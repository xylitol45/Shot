//
//  MainScene.swift
//  Shot
//
//  Created by yoshimura on 2014/11/10.
//  Copyright (c) 2014年 yoshimura. All rights reserved.
//


// import Foundation ... SpriteKit内で呼ばれているので省略可
import SpriteKit
import AVFoundation

class PlayScene: SKScene {
    
    // MARK:変数
    #if false
    enum SpriteName:String {
        case Player = "player"
        case Enemy = "enemy"
        case Star = "star"
        case Missile = "missile"
    }
    #endif
    
    let NoDestroyHp = 999999
    
    var _contentCreated = false;
    
    override func didMoveToView(view: SKView) {
        if (!_contentCreated) {
            createSceneContent();
            _contentCreated = true;
        }
    }
    
    var playerMoving = false
    
    var preLocation:CGPoint? = nil
    
    var spark:SKEmitterNode? = nil
    
    // MARK: クラスメソッド
    // 0.0-1.0
    class func randomCGFloat() -> CGFloat {
        return CGFloat(arc4random()) /  CGFloat(UInt32.max)
    }
    
    
    // MARK: touch
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        if (touches.count == 1) {
            let _touch:AnyObject = touches.anyObject()!
            let _location = _touch.locationInNode(self)
            
            let _player = self.childNodeWithName("player")
            
            if CGRectContainsPoint(_player!.frame, _location) {
                    preLocation = _location
            }
            
            preLocation = _location
        }
        
    }
    
    override  func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        if (preLocation != nil) {
            
            let _touch:AnyObject = touches.anyObject()!
            let _location = _touch.locationInNode(self)
            
            let _player = self.childNodeWithName("player")!
            
            _player.position.x += _location.x - preLocation!.x
            
            if _player.position.x < 0 {
                _player.position.x = 0
            } else
            if _player.position.x > (CGRectGetMaxX(self.frame) - _player.frame.width){
                _player.position.x = CGRectGetMaxX(self.frame) - _player.frame.width
            }
            
            _player.position.y += _location.y - preLocation!.y
            
            if _player.position.y < 0 {
                _player.position.y = 0
            } else
            if _player.position.y > (CGRectGetMaxY(self.frame) - _player.frame.height){
                    _player.position.y = CGRectGetMaxY(self.frame) - _player.frame.height
            }
            
            preLocation = _location
            
        }
        
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        preLocation = nil
    }
    
//    var _lastTime:CFTimeInterval = 0
    var lastUpdateTime:CFTimeInterval = 0
    
    // MARK: 画面更新(update)
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        checkCollision()
        
        // 定期的処理
        if (currentTime - lastUpdateTime) > 0.2 {
            
            let _player = childNodeWithName("player")

            initStarSprite()
            
//            for i in 1...10 {
//                
//                if (arc4random() % 4) == 0 {
//                    continue
//                }
//            
//                
//                let _node = SKShapeNode(rect: CGRectMake(0, 0, 3, 3))
//                _node.fillColor=SKColor.blackColor()
//                
//                let _x = CGFloat(arc4random_uniform(UInt32(CGRectGetMaxX(self.frame))))
//                let _y = CGRectGetMaxY(self.frame)+10
//                // let _y = CGFloat(arc4random()) %  CGRectGetMaxY(self.frame)
//                
//                _node.position = CGPointMake(_x, _y)
//                _node.zPosition = 10
//                _node.name = "star"
//                
//                let _duration = NSTimeInterval( ((arc4random() % 10) + 1))
//                let _moveDown = SKAction.moveToY(-10, duration: _duration)
//                let _sequence = SKAction.sequence([_moveDown, SKAction.removeFromParent()])
//                _node.runAction(_sequence)
//
//                addChild(_node)
//            
//            }
            
            if (arc4random_uniform(4) == 0) {
                initNoDestroyEnemySprite()
            }
            
            if (arc4random() % 10) == 0 {
                
                let _node = self.createEnemySprite(5)
                _node.position = CGPointMake(CGFloat(arc4random_uniform(UInt32(CGRectGetMaxX(frame))-100)), CGRectGetMaxY(frame)+10)
                
                
                let _moveDown = SKAction.moveToY(-100, duration: 5)
                _node.runAction(SKAction.sequence([_moveDown, SKAction.removeFromParent()]))
                
                addChild(_node)
                
            }
            
            initMissileSprite(_player!.frame)

//            for i in 0...1 {
//                let _path = UIBezierPath()
//                _path.moveToPoint(CGPointMake(0, 0))
//                _path.addLineToPoint(CGPointMake(0,31))
//                
//                let _missile = SKShapeNode(path: _path.CGPath)
//                _missile.name = "missile"
//                _missile.strokeColor = SKColor.blackColor()
//                _missile.position =
//                    CGPointMake(_player!.position.x + 16 + (CGFloat(i)*32), _player!.position.y+64)
//                
//                addChild(_missile)
//                
//                let _moveUp = SKAction.moveByX(0, y: CGRectGetMaxY(frame), duration: 1)
//    
//                let _sequence = SKAction.sequence([_moveUp, SKAction.removeFromParent()])
//                
//                _missile.runAction(_sequence)
// 
//            }
            
            lastUpdateTime = currentTime
        }
        
    }
    
    // MARK: 当たり判定
    func checkCollision() {
        let _player = childNodeWithName("player")! as SKShapeNode
        
        // 当たり判定
        enumerateChildNodesWithName("enemy") {
            node, stop in
            
            var _flg = false
            var _hp = (node.userData!["hp"] as Int)
            
            // SKShapeNodeの場合はこちら
            // player
            if CGRectIntersectsRect(node.frame, _player.frame) {
                
//                _player.strokeColor = SKColor.redColor()
//                let colorAction = SKAction.colorizeWithColor(UIColor.redColor(), colorBlendFactor: 1.0 , duration: 1)
                
                let _que = dispatch_queue_create("com.kick55.a.Shot.background", nil)
                
                dispatch_async( _que, {
                    
                    for i in 0...9 {
                        
                        let _f = 1.0 / CGFloat(10 - i)
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            let _player = self.childNodeWithName("player")! as SKShapeNode
                            
                            _player.fillColor = UIColor(red:1.0, green: _f, blue: _f, alpha: 1)
                            
                            
                            
                        });

                        NSThread.sleepForTimeInterval(0.05)
                        
                        
                    }
                    

                    dispatch_async(dispatch_get_main_queue(), {
                        let _player = self.childNodeWithName("player")! as SKShapeNode
                        
                        _player.fillColor = UIColor.whiteColor()
                        
                        
                    });

                
                })
//                
//                
//                _player.runAction(SKAction.sequence([
//                    SKAction.runBlock({
////                        let _player = self.childNodeWithName("player")! as SKShapeNode
//                        
//                        for i in 0...9 {
//                            let _f = 1.0 / CGFloat(10 - i)
//                            
//                            _player.fillColor = UIColor(red:1.0, green: _f, blue: _f, alpha: 1)
//                            
//                            // 全部が止まってしまう...
////                            NSThread.sleepForTimeInterval(0.5)
//                            
//                        }
//                        
//                        _player.fillColor = UIColor.whiteColor()
//                    })
//                    ]))
                
                self.initSparkSprite(CGPointMake(CGRectGetMidX(node.frame), CGRectGetMidY(node.frame)), scale:0.5)
                
                node.removeFromParent()
                
                self.zan++;
                
                return
            }
            
            
            if _hp == self.NoDestroyHp {
                return
            }
            
            var _hitFlg = false
            self.enumerateChildNodesWithName("missile") {
                node2, stop2 in
                if CGRectIntersectsRect(node.frame, node2.frame) {
                    
                    
                    
                    
                    node2.removeFromParent()
                    _hitFlg = true
                    stop2.memory = true
                }
            }
            
            if _hitFlg {
                //             var _userData = node.userData!
                _hp--;
                if _hp > 0 {
                    node.userData!["hp"] = _hp
                } else {
                    
                    self.score += 10
                    self.refreshScore()
                    
                    self.initSparkSprite(CGPointMake(CGRectGetMidX(node.frame), CGRectGetMidY(node.frame)))
                    
//                    let _spark = self.spark!.copy() as SKEmitterNode
//                    
//                    
//                    _spark.position = CGPointMake(CGRectGetMidX(node.frame), CGRectGetMidY(node.frame))
//                    _spark.runAction(SKAction.sequence([SKAction.fadeOutWithDuration(1),SKAction.removeFromParent()]))
//                    _spark.zPosition = 50
//                    
//                    self.addChild(_spark)
                    
                    
                    
                    node.removeFromParent()
                }
                
                
                println(_hp)
                
                //                Int(node.userData["hp"])
                
                
                stop.memory = true
                
                return
            }
            
        }

    }
    
    #if false
    
    override func   didEvaluateActions() {
    NSLog("2");
    }
    
    override func didSimulatePhysics() {
    NSLog("3");
    }
    #endif
    
    var sound:AVAudioPlayer? = nil
    var player:SKShapeNode? = nil
    var score = 0
    var zan = 0
    
    // MARK: 初期化
    func createSceneContent() {
        
        self.backgroundColor = UIColor.whiteColor()
        
        let bgmPath = NSBundle.mainBundle().pathForResource("2", ofType: "m4a")!
        let bgmUrl = NSURL.fileURLWithPath(bgmPath)
        sound = AVAudioPlayer(contentsOfURL: bgmUrl, error: nil)
        sound!.numberOfLoops = -1
        sound!.play()
        
        // 自機
        initPlayer()
        
        // CGAffineTransformMakeTranslation(<#tx: CGFloat#>, <#ty: CGFloat#>)
        
        //_path2.bo
        // score
        let _scoreNode = SKLabelNode(text: "0")
        _scoreNode.name="score"
        _scoreNode.position = CGPointMake(100,  CGRectGetMaxY(self.frame)-50)
        _scoreNode.fontColor=UIColor.blackColor()
        _scoreNode.verticalAlignmentMode = .Bottom
        _scoreNode.horizontalAlignmentMode = .Right
        _scoreNode.zPosition=1000
        addChild(_scoreNode)
        
        // zan
        let _zanNode = SKLabelNode(text: "0.0%")
        _zanNode.name="zan"
        _zanNode.position = CGPointMake(CGRectGetMaxX(frame)-50,  CGRectGetMaxY(self.frame)-50)
        _zanNode.fontColor=UIColor.blackColor()
        _zanNode.verticalAlignmentMode = .Bottom
        _zanNode.horizontalAlignmentMode = .Right
        _zanNode.zPosition=1000
        addChild(_zanNode)

        
        
    }
    
    
    
    //    var SIZE:CGFloat{get} = 96;
    
    //    var SIZE:CGFloat{96};
    #if false
    let a=0;
    
    let SIZE:CGFloat=96.0;
    
    var SIZE2:CGFloat {
    get {
    return 96.0;
    }
    };
    
    
    func createSceneContent() {
    
    var row = 1;
    let clotharmor = SKTexture(imageNamed: "clotharmor");
    var textures=[SKTexture]();
    
    for var col=0;col<4;col++ {
    let x = CGFloat(col) * SIZE / clotharmor.size().width;
    let y = CGFloat(row) * SIZE / clotharmor.size().height;
    let w = SIZE / clotharmor.size().width;
    let h = SIZE / clotharmor.size().height;
    
    let texture = SKTexture(rect: CGRectMake(x, y, w, h), inTexture: clotharmor);
    
    textures.append(texture);
    }
    
    let walker = SKSpriteNode(texture: textures.first);
    walker.position=CGPointMake(250, 100);
    addChild(walker);
    
    let walk=SKAction.animateWithTextures(textures, timePerFrame: 0.2);
    let forever=SKAction.repeatActionForever(walk);
    
    walker.runAction(forever);
    //
    //
    //        int row = 1;
    //        SKTexture *clotharmor = [SKTexture textureWithImageNamed:@"clotharmor"];
    //
    //        NSMutableArray *textures = @[].mutableCopy;
    //        for (int col = 0; col < 4; col++) {
    //            CGFloat x = col * SIZE / clotharmor.size.width;
    //            CGFloat y = row * SIZE / clotharmor.size.height;
    //            CGFloat w = SIZE / clotharmor.size.width;
    //            CGFloat h = SIZE / clotharmor.size.height;
    //
    //            SKTexture *texture = [SKTexture textureWithRect:CGRectMake(x, y, w, h) inTexture:clotharmor];
    //            [textures addObject:texture];
    //        }
    //        SKSpriteNode *walker = [SKSpriteNode spriteNodeWithTexture:textures.firstObject];
    //        walker.position = CGPointMake(250.0f, 100.0f);
    //        [self addChild:walker];
    //
    //        SKAction *walk = [SKAction animateWithTextures:textures timePerFrame:0.2f];
    //        SKAction *forever = [SKAction repeatActionForever:walk];
    //        [walker runAction:forever];
    //
    //        self.SIZE = 100;
    
    
    //        let sword = SKSpriteNode(imageNamed: "sword");
    //        sword.position=CGPointMake(30.0, 30.0);
    //        sword.name = "sword";
    //        addChild(sword);
    //
    //        let  sequenceSword = SKSpriteNode(imageNamed: "sword");
    //        sequenceSword.position = CGPointMake(100.0, 400.0);
    //        addChild(sequenceSword);
    //
    //        let moveRight = SKAction.moveByX(100, y:0, duration:1.0);
    //        let moveDown = SKAction.moveByX(0, y:-100, duration:1.0);
    //        let wait = SKAction.waitForDuration(0.5);
    //        let moveLeft = SKAction.moveByX(-100, y: 0, duration: 1);
    //        let moveUp = SKAction.moveByX(0, y: 100, duration: 1);
    //        let remove = SKAction.removeFromParent();
    //        let sequence = SKAction.sequence([moveRight,moveDown,wait,moveLeft,moveUp,remove]);
    //
    //        sequenceSword.runAction(sequence);
    
    //        SKSpriteNode *groupSword = [SKSpriteNode spriteNodeWithImageNamed:@"sword"];
    //        groupSword.position = CGPointMake(150.0f, 200.0f);
    //        [self addChild:groupSword];
    //
    //        SKAction *zoom = [SKAction scaleBy:5.0 duration:3.0f];
    //        SKAction *fadeOut = [SKAction fadeOutWithDuration:3.0f];
    //        SKAction *group = [SKAction group:@[zoom, fadeOut]];
    //
    //        [groupSword runAction:group];
    //
    //        let groupSword = SKSpriteNode(imageNamed: "sword");
    //        groupSword.position=CGPointMake(150, 200);
    //        addChild(groupSword);
    //
    //        let zoom=SKAction.scaleBy(5.0, duration: 3);
    //        let fadeOut=SKAction.fadeOutWithDuration(3);
    //        let group = SKAction.group([zoom,fadeOut]);
    //        groupSword.runAction(group);
    //
    
    }
    #endif
    
    #if false
    
    func createSceneContent() {
    
    let sword = SKSpriteNode(imageNamed: "sword");
    sword.position = CGPointMake(  CGRectGetMidX(self.frame),  CGRectGetMidY(self.frame));
    addChild(sword);
    
    let square = SKSpriteNode(color: UIColor.grayColor(), size: CGSizeMake(30.0, 30.0));
    square.position = CGPointMake(sword.position.x, sword.position.y - 50.0);
    addChild(square);
    
    
    for var i=1;i<=5;i++ {
    
    println(String(format:"index %d",i));
    println(CGRectGetMaxX(self.frame));
    println(CGRectGetMaxY(self.frame));
    
    let colorSword = SKSpriteNode(imageNamed: "sword");
    colorSword.position = CGPointMake(CGFloat(i) * 55.0 , square.position.y - 50.0);
    colorSword.color = SKColor.redColor();
    colorSword.colorBlendFactor =  CGFloat(i) * 2 / 10 ;
    addChild(colorSword);
    }
    
    let resizedSword = SKSpriteNode(imageNamed: "sword");
    //        resizedSword.position = CGPointMake(sword.position.x, sword.position.y + 100.0);
    resizedSword.position = CGPointMake(sword.position.x, sword.position.y + 100.0);
    resizedSword.xScale = 2.0;
    resizedSword.yScale = 2.0;
    addChild(resizedSword);
    
    // 基準点中央（左から2番目）
    let centerSword = SKSpriteNode(imageNamed: "sword");
    centerSword.position = CGPointMake(sword.position.x - 55.0 , resizedSword.position.y + 80.0);
    centerSword.zPosition = 1.0 ;
    addChild(centerSword);
    
    let centerBox = SKSpriteNode(color: UIColor.grayColor(), size: CGSizeMake(50.0, 50.0));
    centerBox.position = centerSword.position;
    addChild(centerBox);
    
    
    // 基準点中央・回転（一番左）
    let centerRotatedSword = SKSpriteNode(imageNamed: "sword");
    centerRotatedSword.position = CGPointMake(centerSword.position.x - 55.0 , centerSword.position.y );
    centerRotatedSword.zRotation = CGFloat(30.0 * M_PI / 180.0);
    centerRotatedSword.zPosition = 1.0 ;
    addChild(centerRotatedSword);
    
    let centerRotedBox = SKSpriteNode(color: UIColor.grayColor(), size: CGSizeMake(50.0, 50.0));
    centerRotedBox.position = centerRotatedSword.position;
    addChild(centerRotedBox);
    
    
    // 基準点右下（右から2番目）
    let bottomSword = SKSpriteNode(imageNamed: "sword");
    bottomSword.position = CGPointMake(sword.position.x+55.0, centerRotatedSword.position.y);
    bottomSword.zPosition=1.0;
    bottomSword.anchorPoint=CGPointMake(1.0,1.0);
    addChild(bottomSword);
    
    let bottomBox = SKSpriteNode(color: UIColor.grayColor(), size: CGSizeMake(50.0, 50.0));
    bottomBox.position=bottomSword.position;
    addChild(bottomBox);
    
    // 基準点右下・回転（一番右）
    let bottomRotatedSword = SKSpriteNode(imageNamed: "sword");
    bottomRotatedSword.position=CGPointMake(bottomSword.position.x+55.0, bottomSword.position.y);
    bottomRotatedSword.zRotation = CGFloat(180.0 * M_PI / 180.0);
    bottomRotatedSword.zPosition = 1.0;
    bottomRotatedSword.anchorPoint = CGPointMake(1.0,1.0);
    addChild(bottomRotatedSword);
    
    let bottomRotatedBox = SKSpriteNode(color: UIColor.grayColor(), size: CGSizeMake(50.0, 50.0));
    bottomRotatedBox.position = bottomRotatedSword.position;
    addChild(bottomRotatedBox);
    }
    #endif
 
    func refreshScore() {
        let _scoreNode = childNodeWithName("score")! as SKLabelNode
        _scoreNode.text = String(self.score)
        
        let _zanNode = childNodeWithName("zan")! as SKLabelNode
        _zanNode.text = String(format: "%.1f%%", Float(self.zan) / 10)
        
        NSLog("zan %d %.1f", zan, Float(self.zan) * 0.1)
        // 逆スラッシュは option + ¥
        println("score \(self.score)")
    
    }
    
    // MARK: sprite
    func initPlayer() {
        
        // 自機
        let _path = UIBezierPath()
        _path.moveToPoint(CGPointMake(0, 0))
        _path.addLineToPoint(CGPointMake(63, 0))
        _path.addLineToPoint(CGPointMake(47,63))
        _path.addLineToPoint(CGPointMake(31,0))
        _path.addLineToPoint(CGPointMake(15,63))
        _path.closePath()
        
        player = SKShapeNode(path: _path.CGPath)
        
        player?.name = "player"
        player?.fillColor = SKColor.whiteColor()
        player?.strokeColor = SKColor.blackColor()
        player?.position = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame))
        player?.zPosition = 100
        
        addChild(player!)
    }
    
    func initMissileSprite(rect:CGRect) {
        
        for i in 0...1 {
            
            
            
            let _path = UIBezierPath()
            _path.moveToPoint(CGPointMake(0, 0))
            _path.addLineToPoint(CGPointMake(0,31))
            
            let _missile = SKShapeNode(path: _path.CGPath)
            _missile.name = "missile"
            _missile.strokeColor = SKColor.blackColor()
            _missile.position =
                CGPointMake(rect.origin.x + 16 + (CGFloat(i)*32), rect.origin.y + 64)
            
            addChild(_missile)
            
            let _moveUp = SKAction.moveByX(0, y: CGRectGetMaxY(frame), duration: 1)
            
            let _sequence = SKAction.sequence([_moveUp, SKAction.removeFromParent()])
            
            _missile.runAction(_sequence)
            
        }
        

        
        
    }
    
    func createEnemySprite(hp:Int)->SKShapeNode {
        
        let _path = UIBezierPath()
        _path.moveToPoint(CGPointMake(0, 0))
        _path.addLineToPoint(CGPointMake(50,0))
        _path.addLineToPoint(CGPointMake(50,50))
        _path.addLineToPoint(CGPointMake(0,50))
        _path.closePath()
        
        let _sprite = SKShapeNode(path: _path.CGPath)
        _sprite.userData = [:]
        _sprite.userData!["hp"] = hp
        _sprite.fillColor = SKColor.whiteColor()
        _sprite.strokeColor = SKColor.blackColor()
        _sprite.name = "enemy"
        _sprite.zPosition = 100
        
        return _sprite
    }
    
    func initNoDestroyEnemySprite() {
        
        let _sprite = SKShapeNode(ellipseInRect: CGRectMake(0, 0, 20, 20))
        _sprite.userData = [:]
        _sprite.userData!["hp"] = NoDestroyHp
        _sprite.fillColor = SKColor.whiteColor()
        _sprite.strokeColor = SKColor.blackColor()
        _sprite.name = "enemy"
        _sprite.zPosition = 50
        
        addChild(_sprite)
        
        let _player = self.childNodeWithName("player")!
        let _playerX = _player.position.x
        
        let _r = arc4random_uniform(4)
        
        let _y = CGRectGetMaxY(frame) / 4
        
        switch _r {
        case 1,2:
            _sprite.position =
                CGPointMake(CGRectGetMaxX(self.frame) * PlayScene.randomCGFloat(), CGRectGetMaxY(frame)+40)
        case 3:
            _sprite.position =
                CGPointMake(-40, CGRectGetMaxY(frame) - _y * PlayScene.randomCGFloat())
        default:
            _sprite.position =
                CGPointMake(CGRectGetMaxX(frame)+40, CGRectGetMaxY(frame) - _y * PlayScene.randomCGFloat())
        }
        
        let _moveTo = SKAction.moveTo(CGPointMake(_playerX, -40), duration: 2)
        
        _sprite.runAction(SKAction.sequence([_moveTo,SKAction.removeFromParent()]))
        
    }

    func initSparkSprite(position:CGPoint, scale:CGFloat = 1.0) {
       
        if (self.spark ==  nil) {
            let _sparkPath = NSBundle.mainBundle().pathForResource("spark", ofType: "sks")!
            self.spark = NSKeyedUnarchiver.unarchiveObjectWithFile(_sparkPath) as SKEmitterNode?
        }

        let _spark = self.spark!.copy() as SKEmitterNode
        
        _spark.yScale = scale
        _spark.xScale = scale
        _spark.position = position
        _spark.runAction(SKAction.sequence([SKAction.fadeOutWithDuration(1),SKAction.removeFromParent()]))
        _spark.zPosition = 1000
        
        self.addChild(_spark)
        
    }
    
    func initStarSprite() {
        
        for i in 1...10 {
            
            if (arc4random() % 4) == 0 {
                continue
            }
            
            
            let _node = SKShapeNode(rect: CGRectMake(0, 0, 3, 3))
            _node.fillColor=SKColor.blackColor()
            
            let _x = CGFloat(arc4random_uniform(UInt32(CGRectGetMaxX(self.frame))))
            let _y = CGRectGetMaxY(self.frame)+10
            // let _y = CGFloat(arc4random()) %  CGRectGetMaxY(self.frame)
            
            _node.position = CGPointMake(_x, _y)
            _node.zPosition = 10
            _node.name = "star"
            
            let _duration = NSTimeInterval( ((arc4random() % 10) + 1))
            let _moveDown = SKAction.moveToY(-10, duration: _duration)
            let _sequence = SKAction.sequence([_moveDown, SKAction.removeFromParent()])
            _node.runAction(_sequence)
            
            addChild(_node)
            
        }
    }
}
