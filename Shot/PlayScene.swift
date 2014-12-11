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
    
    enum Mode {
        case Title, Game, EndGame
    }
    
    var mode:Mode = .Title
    
    
    var contentCreated = false;
    
    
    var playerMoving = false
    
    var preLocation:CGPoint? = nil
    
    var spark:SKEmitterNode? = nil
    
    var lastUpdateTime:CFTimeInterval = 0
    var sound:AVAudioPlayer? = nil
    var player:SKNode? = nil
    var score = 0
    var zan = 0
    var phase = 0
    var stage = 1
    var playerCollision = false
    
    var highscores = [NSDictionary]()
    var nextStage = false
    var soundIndex = -1
    var soundPath = ["0", "1", "2", "3"]
    var soundTimer:NSTimer? = nil
    
    
    // MARK: クラスメソッド
    // 0.0-1.0
    class func randomCGFloat() -> CGFloat {
        return CGFloat(arc4random()) /  CGFloat(UInt32.max)
    }
    
    class func noDestoroyHp() -> Int {
        return 999999
    }
    
    // MARK: 開始
    override func didMoveToView(view: SKView) {
        readData()
        startTitle()
    }
    
    // MARK: touch
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        if (touches.count != 1) {
            return
        }
        
        if self.mode == .Title {
            startGame()
            return
        }
        
        if self.mode == .EndGame {
            startTitle()
            return
        }
        
        // 以下、ゲーム中
        let _touch: AnyObject = touches.anyObject()!
        
        let _player = self.childNodeWithName("player")
        if _player == nil {
            return
        }
        
        if _touch.tapCount == 3 {
            changePlayer()
            return
        }
        
        let _location = _touch.locationInNode(self)
        
        if CGRectContainsPoint(_player!.frame, _location) {
            preLocation = _location
        }
        
        preLocation = _location
        
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
            
            if mode == .Game {
                
                phase++
                
                if phase % 500 == 0 {
                    changeSound()
                }
                
                // 次のステージ
                if nextStage {
                    nextStage = false
                    stage++
                    var _y = blockHeight() * 6
                    let _label = SKLabelNode(text: "stage \(stage)")
                    _label.position = CGPointMake(CGRectGetMidX(frame), _y)
                    _label.fontColor = SKColor.blackColor()
                    _label.zPosition = 1000
                    _label.runAction(SKAction.sequence([
                        SKAction.waitForDuration(3.0),SKAction.removeFromParent()
                        ]))
                    addChild(_label)
                    
                    
                    if phase > 500 {
                        self.zan -= 30
                        if self.zan < 0 {
                            self.zan = 0
                        }
                        
                        self.score += 5000
                        
                        _y -= 100
                        let _label = SKLabelNode(text: "30% recovery")
                        _label.position = CGPointMake(CGRectGetMidX(frame), _y)
                        _label.fontColor = SKColor.blackColor()
                        _label.zPosition = 1000
                        _label.runAction(SKAction.sequence([
                            SKAction.waitForDuration(3.0),SKAction.removeFromParent()
                            ]))
                        addChild(_label)
                        
                        refreshScore()
                    }
                }
                
                
                if let _node = childNodeWithName("phase") as SKLabelNode! {
                    _node.text = String(phase)
                }
                
                EnemyFactory.initEnemy(self, stage: stage)
                
                
                initMissileSprite()
                
            }
            
            lastUpdateTime = currentTime
        }
        
    }
    
    // MARK: 当たり判定
    func checkCollision() {
        
        if mode != .Game {
            return
        }
        
        let _player = childNodeWithName("player") as SKNode?
        if _player == nil {
            return
        }
        
        let _playerFrame = _player!.calculateAccumulatedFrame()
        
        // 当たり判定
        enumerateChildNodesWithName("enemy") {
            node, stop in
            
            var _flg = false
            var _hp = (node.userData!["hp"] as Int)
            var _ap = (node.userData!["ap"] as Int)
            var _enemyFrame = node.calculateAccumulatedFrame()
            
            // SKShapeNodeの場合はこちら
            // player
            // if node.intersectsNode(_player!){
            
            if CGRectIntersectsRect(_enemyFrame, _playerFrame) {
                
                println(" player.frame \(_player!.frame)")
                
                //                _player.strokeColor = SKColor.redColor()
                //                let colorAction = SKAction.colorizeWithColor(UIColor.redColor(), colorBlendFactor: 1.0 , duration: 1)
                self.initSparkSprite(CGPointMake(CGRectGetMidX(_enemyFrame), CGRectGetMidY(_enemyFrame)), scale:0.5)
                node.removeFromParent()
                //                NSLog("zan1 %d ap %d", self.zan, _ap)
                
                // 衝突中はダメージ1.5倍
                self.zan += Int(Float(_ap) * Float(self.playerCollision ? 1.5 : 1))
                //
                //NSLog("zan2 %d ap %d", self.zan, _ap)
                
                // 終了
                if self.zan >= 100 {
                    self.initSparkSprite(CGPointMake(CGRectGetMidX(_playerFrame), CGRectGetMidY(_playerFrame)), scale: 1.0)
                    _player!.removeFromParent()
                    self.refreshScore()
                    
                    self.endGame()
                    
                    stop.memory = true
                    return
                }
                
                // playerダメージ効果
                self.playerCollision = true
                let _que = dispatch_queue_create("com.kick55.a.Shot.background", nil)
                dispatch_async( _que, {
                    for i in 0...9 {
                        let _f = 1.0 / CGFloat(10 - i)
                        dispatch_async(dispatch_get_main_queue(), {
                            if let _player:SKNode = self.childNodeWithName("player") as SKNode! {
                                
                                for _node in _player.children as [SKShapeNode] {
                                    _node.fillColor = UIColor(red:1.0, green: _f, blue: _f, alpha: 1)
                                    
                                }
                                
                                //                                _player.fillColor = UIColor(red:1.0, green: _f, blue: _f, alpha: 1)
                            }
                            
                        });
                        NSThread.sleepForTimeInterval(0.08)
                    }
                    dispatch_async(dispatch_get_main_queue(), {
                        if let _player = self.childNodeWithName("player") as SKNode? {
                            //                            _player.fillColor = UIColor.whiteColor()
                            for _node in _player.children as [SKShapeNode] {
                                _node.fillColor = SKColor.whiteColor()
                                
                            }
                            
                        }
                        self.playerCollision = false
                    });
                })
                return
            }
            
            if _hp ==  PlayScene.noDestoroyHp() {
                return
            }
            
            // ミサイル判定
            var _hitFlg = false
            self.enumerateChildNodesWithName("missile") {
                node2, stop2 in
                if CGRectIntersectsRect(_enemyFrame, node2.frame) {
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
                    let _score = node.userData!["score"] as Int
                    self.score += _score
                    self.refreshScore()
                    self.initSparkSprite(CGPointMake(CGRectGetMidX(node.frame), CGRectGetMidY(node.frame)))
                    
                    let _scoreNode = SKLabelNode(text: "\(_score)")
                    _scoreNode.zPosition = 1000
                    _scoreNode.position =
                        CGPointMake(CGRectGetMidX(_enemyFrame), CGRectGetMidY(_enemyFrame))
                    _scoreNode.color = SKColor.whiteColor()
                    _scoreNode.fontSize = 16
                    _scoreNode.runAction(SKAction.sequence([
                        SKAction.waitForDuration(1.0), SKAction.removeFromParent()
                        ]))
                    self.addChild(_scoreNode)
                    
                    
                    node.removeFromParent()
                }
                // stop.memory = true
                return
            }
        }
    }
    
    // MARK: sound
    func changeSound() {
        
        //  タイトルでは流さない
        if mode == .Title {
            soundStop()
            return
        }
        
        // Fadeout
        if sound != nil {
            if sound!.volume > 0.05 {
                sound!.volume -= 0.05
                NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("changeSound"), userInfo: nil, repeats: false)
                return
            }
        }
        
        // 今の曲を止める
        soundStop()
        
        // ゲームオーバでは次曲なし
        if mode == .EndGame {
            return
        }
        
        // 次の曲
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
        
        nextStage = true
    }
    
    func soundStop() {
        if sound != nil {
            if sound!.playing {
                sound!.stop()
            }
            sound = nil
        }
    }
    
    // MARK: 初期化
    func createSceneContent() {
        
        if self.contentCreated {
            return
        }
        contentCreated = true
        
        let _fmt = NSDateFormatter()
        _fmt.dateFormat="yyyy-MM-dd HH:mm:ss"
        _fmt.locale=NSLocale(localeIdentifier: "ja_JP")
        
        NSLog("[%@]", _fmt.stringFromDate(NSDate()))
        
        
        self.backgroundColor = UIColor.whiteColor()
        
        let _defaults = NSUserDefaults.standardUserDefaults()
        if let _array:NSArray = _defaults.arrayForKey("highscores") {
            highscores = _array.mutableCopy() as [NSDictionary]
        }
        
        
        // CGAffineTransformMakeTranslation()
        //_path2.bo
        // score
        var _scoreNode = childNodeWithName("score") as SKLabelNode?
        
        if _scoreNode == nil {
            _scoreNode = SKLabelNode(text: "0")
            _scoreNode!.name="score"
            _scoreNode!.position = CGPointMake(CGRectGetMidX(frame),  CGRectGetMaxY(self.frame)-50)
            _scoreNode!.fontColor=UIColor.blackColor()
            _scoreNode!.verticalAlignmentMode = .Bottom
            _scoreNode!.horizontalAlignmentMode = .Right
            _scoreNode!.zPosition=1000
            addChild(_scoreNode!)
        }
        
        // zan
        var _zanNode = childNodeWithName("zan") as SKLabelNode?
        if _zanNode == nil {
            _zanNode = SKLabelNode(text: "0%")
            _zanNode!.name="zan"
            _zanNode!.position = CGPointMake(CGRectGetMaxX(frame)-50,  CGRectGetMaxY(self.frame)-50)
            _zanNode!.fontColor=SKColor.blackColor()
            _zanNode!.verticalAlignmentMode = .Bottom
            _zanNode!.horizontalAlignmentMode = .Right
            _zanNode!.zPosition=1000
            addChild(_zanNode!)
        }
        
        // phase
        var _phaseNode = childNodeWithName("phase") as SKLabelNode?
        if _phaseNode == nil {
            _phaseNode = SKLabelNode(text: "")
            _phaseNode!.name = "phase"
            _phaseNode!.position = CGPointMake(0,0)
            _phaseNode!.fontColor=SKColor.blackColor()
            _phaseNode!.verticalAlignmentMode = .Bottom
            _phaseNode!.horizontalAlignmentMode = .Left
            _phaseNode!.zPosition=1000
            addChild(_phaseNode!)
        }
        
        // highscores read
        if let _highscores = NSUserDefaults.standardUserDefaults().objectForKey("highscores") as NSArray! {
            self.highscores = Array(_highscores) as [NSDictionary]
        }
    }
    
    // MARK: シーン変更
    func startTitle() {
        
        mode = .Title
        
        if let _node = childNodeWithName("gameover") {
            _node.removeFromParent()
        }
        if let _node = childNodeWithName("push") {
            _node.removeFromParent()
        }
        
        for _row:SKNode in children as [SKNode] {
            if _row.name == "enemy" {
                _row.removeFromParent()
            }
            if _row.name == "star" {
                _row.removeFromParent()
            }
        }
        
        createSceneContent()
        
        var _y = blockHeight() * 6
        
        let _titleNode = SKLabelNode(text:"Shot")
        _titleNode.name = "title"
        _titleNode.position = CGPointMake(CGRectGetMidX(frame), _y)
        _titleNode.fontColor = SKColor.blackColor()
        _titleNode.zPosition = 1000
        addChild(_titleNode)
        
        var _index = 0;
        _y -= 100
        
        let _fmt = NSDateFormatter()
        let _fmtJa = NSDateFormatter()
        _fmtJa.dateFormat = "yyMMdd"
        _fmtJa.locale = NSLocale(localeIdentifier: "ja_JP")
        for _row in self.highscores {
            
            println(_row["date"])
            //            let _dateString = _row["date"] as NSDate!
            
            
            let _str = String(_index+1) + ". "  + String(_row["score"] as Int)
            let _scoreNode = SKLabelNode(text:_str)
            _scoreNode.name = "title"
            _scoreNode.position = CGPointMake(CGRectGetMidX(frame) - 80, _y - CGFloat(_index) * 40)
            _scoreNode.fontColor = SKColor.blackColor()
            _scoreNode.zPosition = 1000
            _scoreNode.horizontalAlignmentMode = .Left
            addChild(_scoreNode)
            _index++
            
        }
        
        zan = 0
        score = 0
        phase = 0
        
        refreshScore()
        
        soundStop()
    }
    
    func startGame() {
        
        mode = .Game
        
        enumerateChildNodesWithName("title") {
            node, stop in
            node.removeFromParent()
        }
        
        
        enumerateChildNodesWithName("enemy") {
            node, stop in
            node.removeFromParent()
        }
        
        initPlayer()
        
        zan = 0
        score = 0
        stage = 0
        playerMode = 0
        nextStage = false
        playerCollision = false
        
        refreshScore()
        
        soundIndex = -1
        if soundTimer != nil {
            if soundTimer!.valid {
                soundTimer!.invalidate()
            }
            soundTimer = nil
        }
        changeSound()
    }
    
    func endGame() {
        
        mode = .EndGame
        
        let _fmt = NSDateFormatter()
        
        //        highscores.append(["date":_fmt.stringFromDate(NSDate()),  "score":score]);
        highscores.append(["date":NSDate(), "score":score]);
        highscores = highscores.sorted {
            (dictOne, dictTwo) -> Bool in
            return dictOne["score"] as Int! > dictTwo["score"] as Int!
        }
        if highscores.count > 5 {
            highscores =  Array(highscores[0..<5]) as [NSDictionary]
        }
        NSUserDefaults.standardUserDefaults().setObject(highscores, forKey: "highscores")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        var _y = blockHeight() * 6
        
        let _node = SKLabelNode(text: "GAME OVER")
        _node.name = "gameover"
        _node.position = CGPointMake(CGRectGetMidX(frame), _y)
        _node.fontColor = SKColor.blackColor()
        _node.zPosition = 1000
        addChild(_node)
        
        changeSound()
        
    }
    
    func refreshScore() {
        let _scoreNode = childNodeWithName("score")! as SKLabelNode
        _scoreNode.text = String(self.score)
        
        let _zanNode = childNodeWithName("zan")! as SKLabelNode
        //        _zanNode.text = String(format: "%.1f%%", Float(self.zan) * 0.1)
        _zanNode.text = "\(self.zan)%"
        //        NSLog("zan %d %.1f", zan, Float(self.zan) * 0.1)
        // 逆スラッシュは option + ¥
        //        println("score \(self.score)")
        
    }
    
    func readData() {
        
        let _path = NSBundle.mainBundle().pathForResource("data", ofType: "json")!
        let _handle = NSFileHandle(forReadingAtPath: _path)!
        let _data:NSData! = _handle.readDataToEndOfFile()
        
        let _json =
        NSJSONSerialization.JSONObjectWithData(_data, options: NSJSONReadingOptions.AllowFragments, error: nil) as NSDictionary!
        
        let _enemy = _json.objectForKey("enemy") as [NSDictionary]!
        
        for _row in _enemy {
            println(_row.objectForKey("ap"))
            println(_row.objectForKey("hp"))
        }
    }
    
    func blockHeight()->CGFloat {
        return CGRectGetMaxY(frame) / 8
    }
    
    // MARK: スプライト
    func initPlayer() {
        
        // 存在していたら削除
        if let _player = childNodeWithName("player") {
            _player.removeFromParent()
        }
        
        // 自機
        let _path = UIBezierPath()
        _path.moveToPoint(CGPointMake(0, 0))
        _path.addLineToPoint(CGPointMake(15, 0))
        _path.addLineToPoint(CGPointMake(7,31))
        
        //        _path.addLineToPoint(CGPointMake(31,0))
        //        _path.addLineToPoint(CGPointMake(15,63))
        _path.closePath()
        
        let _sub = SKShapeNode(path: _path.CGPath)
        _sub.fillColor = SKColor.whiteColor()
        _sub.strokeColor = SKColor.blackColor()
        _sub.position = CGPointMake(0,0)
        
        let _sub2 = _sub.copy() as SKShapeNode
        _sub2.name = "right"
        _sub2.position = CGPointMake(15, 0)
        
        player = SKNode()
        
        player?.addChild(_sub)
        player?.addChild(_sub2)
        player?.name = "player"
        player?.position = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame))
        player?.zPosition = 100
        
        
        //        player?.fillColor = SKColor.whiteColor()
        //        player?.strokeColor = SKColor.blackColor()
        
        addChild(player!)
    }
    
    
    func initMissileSprite() {
        
        if playerMode == 1 {
            return
        }
        
        let _player = childNodeWithName("player")
        if _player == nil {
            return
        }
        
        let _rect = _player!.frame
        
        let _path = UIBezierPath()
        _path.moveToPoint(CGPointMake(0, 0))
        _path.addLineToPoint(CGPointMake(0,7))
        
        let _missile = SKShapeNode(path: _path.CGPath)
        _missile.name = "missile"
        _missile.strokeColor = SKColor.blackColor()
        
        
        let _clone = _missile.copy() as SKShapeNode
        _clone.position =
            CGPointMake(_rect.origin.x + 7, _rect.origin.y + 32)
        _clone.runAction(SKAction.sequence([
            SKAction.moveByX(0, y: CGRectGetMaxY(frame), duration: 1),
            SKAction.removeFromParent()
            ]))
        addChild(_clone)
        
        if playerMode == 0 {
            // 上下
            let _clone2 = _missile.copy() as SKShapeNode
            _clone2.position =
                CGPointMake(_rect.origin.x + 7 + 16, _rect.origin.y + 32)
            _clone2.runAction(SKAction.sequence([
                SKAction.moveByX(0, y: CGRectGetMaxY(frame), duration: 1),
                SKAction.removeFromParent()
                ]))
            addChild(_clone2)
        } else {
            
            let _clone2 = _missile.copy() as SKShapeNode
            _clone2.position =
                CGPointMake(_rect.origin.x + 7, _rect.origin.y - (32+7))
            
            _clone2.runAction(SKAction.sequence([
                SKAction.moveByX(0, y: -CGRectGetMaxY(frame), duration: 1),
                SKAction.removeFromParent()
                ]))
            
            addChild(_clone2)
        }
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
        
        
        if (arc4random_uniform(5) != 0) {
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
    
    // MARK:
    var playerMode = 0
    func changePlayer() {
        
        // 開始直後の誤動作防止
        if phase < 10 {
            return
        }
        
        
        if playerMode == 1 {
            return
        }
        
        let _player = childNodeWithName("player")
        if _player == nil {
            return
        }
        
        let _right = _player!.childNodeWithName("right")
        if _right == nil {
            return
        }
        
        let _nextMode = playerMode == 0 ? 2 : 0
        self.playerMode = 1
        _right!.runAction(SKAction.sequence([
            SKAction.rotateByAngle(CGFloat(-M_PI), duration: 0.2),
            SKAction.runBlock({
                self.playerMode = _nextMode
            })
            ]))
        
    }
}
