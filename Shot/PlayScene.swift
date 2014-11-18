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
    
    var lastUpdateTime:CFTimeInterval = 0
    var sound:AVAudioPlayer? = nil
    var player:SKShapeNode? = nil
    var score = 0
    var zan = 0
    
    // MARK: クラスメソッド
    // 0.0-1.0
    class func randomCGFloat() -> CGFloat {
        return CGFloat(arc4random()) /  CGFloat(UInt32.max)
    }
    
    
    // MARK: touch
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        let _player = self.childNodeWithName("player")
        
        if _player == nil {
            return
        }
        
        if (touches.count == 1) {
            let _touch:AnyObject = touches.anyObject()!
            let _location = _touch.locationInNode(self)
            
            if CGRectContainsPoint(_player!.frame, _location) {
                preLocation = _location
            }
            
            preLocation = _location
        }
        
    }
    
    override  func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        
        let _player = self.childNodeWithName("player")
        if _player == nil {
            return
        }
        
        if (preLocation != nil) {
            
            let _touch:AnyObject = touches.anyObject()!
            let _location = _touch.locationInNode(self)
            
            _player!.position.x += _location.x - preLocation!.x
            if _player!.position.x < 0 {
                _player!.position.x = 0
            } else if _player!.position.x > (CGRectGetMaxX(self.frame) - _player!.frame.width){
                _player!.position.x = CGRectGetMaxX(self.frame) - _player!.frame.width
            }
            
            _player!.position.y += _location.y - preLocation!.y
            if _player!.position.y < 0 {
                _player!.position.y = 0
            } else if _player!.position.y > (CGRectGetMaxY(self.frame) - _player!.frame.height){
                _player!.position.y = CGRectGetMaxY(self.frame) - _player!.frame.height
            }
            
            preLocation = _location
            
        }
        
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        preLocation = nil
    }
    
    //    var _lastTime:CFTimeInterval = 0
    
    // MARK: 画面更新(update)
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        let _player = childNodeWithName("player")
        
        checkCollision()
        
        // 定期的処理
        if (currentTime - lastUpdateTime) > 0.1 {
            
            
            initStarSprite()
            
            if (arc4random_uniform(4) == 0) {
                initNoDestroyEnemySprite()
            }
            
            if (arc4random() % 10) == 0 {
                initEnemySprite()
                
            }
            
            if (arc4random_uniform(10) == 0) {
                initEnemySprite2()
            }
            
            if _player != nil {
                initMissileSprite(_player!.frame)
            }
            
            lastUpdateTime = currentTime
        }
        
    }
    
    // MARK: 当たり判定
    func checkCollision() {
        let _player = childNodeWithName("player") as SKShapeNode?
        
        if _player == nil {
            return
        }
        
        // 当たり判定
        enumerateChildNodesWithName("enemy") {
            node, stop in
            
            var _flg = false
            var _hp = (node.userData!["hp"] as Int)
            var _ap = (node.userData!["ap"] as Int)
            
            // SKShapeNodeの場合はこちら
            // player
            if CGRectIntersectsRect(node.frame, _player!.frame) {
                //                _player.strokeColor = SKColor.redColor()
                //                let colorAction = SKAction.colorizeWithColor(UIColor.redColor(), colorBlendFactor: 1.0 , duration: 1)
                self.initSparkSprite(CGPointMake(CGRectGetMidX(node.frame), CGRectGetMidY(node.frame)), scale:0.5)
                node.removeFromParent()
                self.zan += _ap
                NSLog("%d %d", self.zan, _ap)
                
                // 終了
                if self.zan >= 1000 {
                    self.initSparkSprite(CGPointMake(CGRectGetMidX(_player!.frame), CGRectGetMidY(_player!.frame)), scale: 1.0)
                    _player!.removeFromParent()
                    self.refreshScore()
                    
                    self.endGame()
                    
                    stop.memory = true
                    return
                }
                
                
                // playerダメージ効果
                let _que = dispatch_queue_create("com.kick55.a.Shot.background", nil)
                dispatch_async( _que, {
                    for i in 0...9 {
                        let _f = 1.0 / CGFloat(10 - i)
                        dispatch_async(dispatch_get_main_queue(), {
                            if let _player = self.childNodeWithName("player") as SKShapeNode? {
                                _player.fillColor = UIColor(red:1.0, green: _f, blue: _f, alpha: 1)
                            }
                            
                        });
                        NSThread.sleepForTimeInterval(0.05)
                    }
                    dispatch_async(dispatch_get_main_queue(), {
                        if let _player = self.childNodeWithName("player") as SKShapeNode? {
                            _player.fillColor = UIColor.whiteColor()
                    
                        }
                    });
                })
                return
            }
            
            if _hp == self.NoDestroyHp {
                return
            }
            
            // ミサイル判定
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
                    node.removeFromParent()
                }
                // stop.memory = true
                return
            }
        }
    }
    
    // MARK: sound
    var soundIndex = -1
    var soundPath = ["0", "1", "2", "3"]
    func changeSound() {
        
        
        if sound != nil {
            if sound!.volume > 0.1 {
                sound!.volume -= 0.1
                NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("changeSound"), userInfo: nil, repeats: false)
                return
            }
            
            sound!.stop()
            sound = nil
        }
        
        soundIndex++
        if soundIndex >= soundPath.count {
            soundIndex = 0
        }
        
        let bgmPath = NSBundle.mainBundle().pathForResource(soundPath[soundIndex], ofType: "m4a")!
        let bgmUrl = NSURL.fileURLWithPath(bgmPath)
        sound = AVAudioPlayer(contentsOfURL: bgmUrl, error: nil)
        sound!.volume = 1
        sound!.numberOfLoops = -1
        sound!.play()
        
        NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: Selector("changeSound"), userInfo: nil, repeats: false)
    
    }
    
    // MARK: 初期化
    func createSceneContent() {
        
        self.backgroundColor = UIColor.whiteColor()
        
        changeSound()
        
        // 自機
        initPlayer()
        
        // CGAffineTransformMakeTranslation(<#tx: CGFloat#>, <#ty: CGFloat#>)
        
        //_path2.bo
        // score
        var _scoreNode = childNodeWithName("score") as SKLabelNode?
        
        if _scoreNode == nil {
            _scoreNode = SKLabelNode(text: "0")
            _scoreNode!.name="score"
            _scoreNode!.position = CGPointMake(100,  CGRectGetMaxY(self.frame)-50)
            _scoreNode!.fontColor=UIColor.blackColor()
            _scoreNode!.verticalAlignmentMode = .Bottom
            _scoreNode!.horizontalAlignmentMode = .Right
            _scoreNode!.zPosition=1000
            addChild(_scoreNode!)
        }
        
        // zan
        var _zanNode = childNodeWithName("zan") as SKLabelNode?
        if _zanNode == nil {
            _zanNode = SKLabelNode(text: "0.0%")
            _zanNode!.name="zan"
            _zanNode!.position = CGPointMake(CGRectGetMaxX(frame)-50,  CGRectGetMaxY(self.frame)-50)
            _zanNode!.fontColor=SKColor.blackColor()
            _zanNode!.verticalAlignmentMode = .Bottom
            _zanNode!.horizontalAlignmentMode = .Right
            _zanNode!.zPosition=1000
            addChild(_zanNode!)
        }
        
        // 表示初期化
        refreshScore()
    }
    
    func endGame() {
        
        let _node = SKLabelNode(text: "GAME OVER")
        _node.position = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame))
        _node.fontColor = SKColor.blackColor()
        _node.zPosition = 1000
        addChild(_node)
        
    }
    
    
    
    
    func refreshScore() {
        let _scoreNode = childNodeWithName("score")! as SKLabelNode
        _scoreNode.text = String(self.score)
        
        let _zanNode = childNodeWithName("zan")! as SKLabelNode
        _zanNode.text = String(format: "%.1f%%", Float(self.zan) * 0.1)
        
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
            _path.addLineToPoint(CGPointMake(0,16))
            
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
    
    func initEnemySprite() {
        
        let _path = UIBezierPath()
        _path.moveToPoint(CGPointMake(0, 0))
        _path.addLineToPoint(CGPointMake(50,0))
        _path.addLineToPoint(CGPointMake(50,50))
        _path.addLineToPoint(CGPointMake(0,50))
        _path.closePath()
        
        let _sprite = SKShapeNode(path: _path.CGPath)
        _sprite.userData = [:]
        _sprite.userData!["hp"] = 5
        _sprite.userData!["ap"] = 450
        _sprite.fillColor = SKColor.whiteColor()
        _sprite.strokeColor = SKColor.blackColor()
        _sprite.name = "enemy"
        _sprite.zPosition = 100
        
        _sprite.position = CGPointMake(CGFloat(arc4random_uniform(UInt32(CGRectGetMaxX(frame))-100)), CGRectGetMaxY(frame)+10)
        
        let _moveDown = SKAction.moveToY(-100, duration: 5)
        _sprite.runAction(SKAction.sequence([_moveDown, SKAction.removeFromParent()]))
        
        addChild(_sprite)
    }
    
    func initEnemySprite2() {
        let _sprite = SKShapeNode(ellipseOfSize: CGSizeMake(100, 50))
        _sprite.userData = [:]
        _sprite.userData!["hp"] = 10
        _sprite.userData!["ap"] = 35
        _sprite.fillColor = SKColor.whiteColor()
        _sprite.strokeColor = SKColor.blackColor()
        _sprite.name = "enemy"
        _sprite.zPosition = 100
        
        let _x = CGFloat(arc4random_uniform(UInt32(CGRectGetMaxX(frame))))
        
        _sprite.position = CGPointMake(_x, CGRectGetMaxY(frame) + 100)
        
        let _action = SKAction.group([
            SKAction.repeatActionForever(SKAction.rotateByAngle(CGFloat(M_PI_2) * -1, duration: 5)),
            SKAction.sequence([
                SKAction.moveTo(CGPointMake(_x, -100), duration: 20),
                SKAction.removeFromParent()])
            ])
        _sprite.runAction(_action)
        addChild(_sprite)
    }
    
    func initNoDestroyEnemySprite() {
        
        let _player = self.childNodeWithName("player")
        if _player == nil {
            return
        }
        
        let _sprite = SKShapeNode(ellipseInRect: CGRectMake(0, 0, 10, 10))
        _sprite.userData = [:]
        _sprite.userData!["hp"] = NoDestroyHp
        _sprite.userData!["ap"] = 10
        _sprite.fillColor = SKColor.whiteColor()
        _sprite.strokeColor = SKColor.blackColor()
        _sprite.name = "enemy"
        _sprite.zPosition = 50
        
        addChild(_sprite)
        
        let _playerX = _player!.position.x
        
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
        
        if (arc4random_uniform(4) != 0) {
            return
        }
        
        
        for _ in 1...10 {
            
            if (arc4random_uniform(10)) == 0 {
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
            
            let _duration = NSTimeInterval( arc4random_uniform(10) + 1)
            let _moveDown = SKAction.moveToY(-10, duration: _duration)
            let _sequence = SKAction.sequence([_moveDown, SKAction.removeFromParent()])
            _node.runAction(_sequence)
            
            addChild(_node)
            
        }
    }
}
