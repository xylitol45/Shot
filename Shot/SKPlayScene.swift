//
//  SKPlayScene.swift
//  Shot
//
//  Created by yoshimura on 2014/10/25.
//  Copyright (c) 2014年 yoshimura. All rights reserved.
//

import SpriteKit

class SKPlayScene: SKScene, SKPhysicsContactDelegate {
    
    private func skRandf()->CGFloat {
        let r = CGFloat(rand()) / CGFloat(RAND_MAX)
        return r
    }
    
    private  func skRand(low:CGFloat,high:CGFloat)->CGFloat {
        return skRandf() * (high - low) + low;
    }
    
    let HERO_NAME="hero"
    let ENEMY_NAME = "enemy"
    let TIME_NAME = "time"
    let SCORE_NAME = "score"
    
    let TITLE_SIZE:CGFloat = 96
    let HERO_SPEED:CGFloat = 1.5
    let ENEMY_SPEED:CGFloat = 100
    let TIP_SIZE:CGFloat = 96
    
    let heroCategory:UInt32 = 0x1 << 0
    let enemyCategory:UInt32 = 0x1 << 1
    let boxCategory:UInt32 = 0x1 << 2
    let worldCategory:UInt32 = 0x1 << 3
    
    var _contentCreated:Bool = false
    var _lastUpdateTimeInterval:NSTimeInterval = 0.0
    var _timeSinceStart:NSTimeInterval = 0.0
    var _timeSinceLastSecond:NSTimeInterval = 0.0
    var _enemies:Int = 0
    var _boxes:Int = 0
    var _score:Int = 0
    
    
    override func didMoveToView(view: SKView) {
        if (!_contentCreated) {
            createSceneContents();
            _contentCreated = true;
        }
    }

    func createSceneContents() {
        _lastUpdateTimeInterval = 0
        _timeSinceStart = 0
        _timeSinceLastSecond = 0
        _enemies = 0
        _score = 0
        
        self.addBackground()
        self.addHero()
        self.addBoxes()
        self.addLables()
        
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        self.physicsWorld.contactDelegate = self
        self.physicsBody?.categoryBitMask = worldCategory
        
    
    }

    func addBackground() {
        
        let wood = SKTexture(imageNamed: "wood")
        var rows = Int(self.frame.size.height / TITLE_SIZE)
        var cols = Int(self.frame.size.width / TITLE_SIZE)
        for var row=0;row<=rows;row++ {
            var y = CGFloat(row) * TITLE_SIZE
            for var col=0;col<=cols;col++ {
                var x = CGFloat(col) * TITLE_SIZE
                let bgSprite = SKSpriteNode(texture: wood)
                bgSprite.anchorPoint = CGPointMake(0,0)
                bgSprite.position=CGPointMake(x,y)
                bgSprite.xScale = TITLE_SIZE / wood.size().width
                bgSprite.yScale = TITLE_SIZE / wood.size().height
                addChild(bgSprite)
            }
        }
    }
    
    func addHero() {
        let hero = SKHeroNode.hero()
        hero.position=CGPointMake(CGRectGetMidX(self.frame), hero.frame.size.height * 1.25)
        hero.name = HERO_NAME
        hero.zPosition=1
        addChild(hero)
        
        hero.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(TIP_SIZE*0.5, TIP_SIZE*0.5))
        hero.physicsBody?.affectedByGravity = false
        hero.physicsBody?.categoryBitMask = heroCategory
        hero.physicsBody?.contactTestBitMask = enemyCategory
        hero.physicsBody?.collisionBitMask = 0
    }
    
    func addEnemy() {
        
        _enemies++
        
        var row = 0
        var cols = 5
        let bat = SKTexture(imageNamed: "bat")
        var textures:[SKTexture]=[]
        
        for var col=0;col < cols;col++ {
            let x = CGFloat(col) * TIP_SIZE / bat.size().width
            let y = CGFloat(row) * TIP_SIZE / bat.size().height
            let w = TIP_SIZE / bat.size().width
            let h = TIP_SIZE / bat.size().height
            let texture = SKTexture(rect: CGRectMake(x, y, w, h), inTexture: bat)
            textures.append(texture)
        }
        
        let enemy = SKSpriteNode(texture: textures.first)
        enemy.position=CGPointMake(skRand(40.0, high: CGRectGetMaxX(self.frame)-40), CGRectGetMaxY(self.frame)-TIP_SIZE)
        enemy.name = ENEMY_NAME
        addChild(enemy)
        
        let animate = SKAction.animateWithTextures(textures, timePerFrame: 0.1)
        let forever = SKAction.repeatActionForever(animate)
        enemy.runAction(forever)
        
        enemy.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(TIP_SIZE * 0.4, TIP_SIZE * 0.4))
        enemy.physicsBody?.affectedByGravity    = false
        enemy.physicsBody?.velocity = CGVectorMake(0, -1 * ENEMY_SPEED - CGFloat(_timeSinceStart) * 3)
        enemy.physicsBody?.categoryBitMask = enemyCategory
        enemy.physicsBody?.contactTestBitMask = boxCategory | worldCategory
        enemy.physicsBody?.collisionBitMask = 0
        enemy.physicsBody?.usesPreciseCollisionDetection = true
        
    }


    func addBoxes() {
        
        let chest = SKTexture(imageNamed: "chest")
        _boxes=6
        
        let y:CGFloat = 30
        
        for var col=0;col < _boxes;col++ {
            let x = CGFloat(col) * chest.size().width + 40;
            let boxSprite = SKSpriteNode(texture: chest)
            boxSprite.position = CGPointMake(x, y)
            addChild(boxSprite)
            
            boxSprite.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(boxSprite.size.width * 0.5, boxSprite.size.height * 0.5))
            boxSprite.physicsBody?.affectedByGravity = false
            boxSprite.physicsBody?.categoryBitMask = boxCategory
            boxSprite.physicsBody?.collisionBitMask = 0
            
        }
    }
    
    func addLables() {
        
        let timeLabel = SKLabelNode(fontNamed: "Mosamosa")
        timeLabel.name=TIME_NAME
        timeLabel.verticalAlignmentMode=SKLabelVerticalAlignmentMode.Top
        timeLabel.horizontalAlignmentMode=SKLabelHorizontalAlignmentMode.Left
        timeLabel.position=CGPointMake(5, CGRectGetMaxY(self.frame)-20)
        timeLabel.fontSize = 14
        addChild(timeLabel)
        
        let scoreLabel = SKLabelNode(fontNamed: "Mosamosa")
        scoreLabel.name=SCORE_NAME
        scoreLabel.verticalAlignmentMode=SKLabelVerticalAlignmentMode.Top
        scoreLabel.horizontalAlignmentMode=SKLabelHorizontalAlignmentMode.Right
        
        scoreLabel.position=CGPointMake(CGRectGetMaxX(self.frame)-scoreLabel.frame.size.width-5,CGRectGetMaxY(self.frame)-20);
        scoreLabel.fontSize=14
        addChild(scoreLabel)
        
        _score = 0
        
    }

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        let touch:AnyObject = touches.anyObject()!
        let location = touch.locationInNode(self)
        
        let _nodeAtPoint = self.nodeAtPoint(location)
        if (_nodeAtPoint.name==HERO_NAME) {
            let hero = _nodeAtPoint as SKHeroNode
            hero.attack()
            for node in self.nodesAtPoint(location) as [SKNode]{
                
                
                
                
                
                if (node.name==nil){
                    continue
                }
                NSLog("node.name %@", node.name!)
                if (node.name==ENEMY_NAME){
                    self.attack(node as SKNode)
                }
            }
        } else {
            let hero = self.childNodeWithName(HERO_NAME) as SKHeroNode
            let x = location.x
            let y = location.y
            let diff = abs(hero.position.x - x)
            let duration = HERO_SPEED * diff / self.frame.size.width
            let move = SKAction.moveToX(x, duration: NSTimeInterval(duration))
            hero.removeAllActions()
            hero.walk()
            hero.runAction(move, completion: {
                hero.stop()
            })
        }
        
    }
    
    func attack(enemy:SKNode){
        
        let sparkPath = NSBundle.mainBundle().pathForResource("spark", ofType: "sks")!
        let spark = NSKeyedUnarchiver.unarchiveObjectWithFile(sparkPath)! as SKEmitterNode
        spark.position = enemy.position
        spark.xScale = 0.2
        spark.yScale = 0.2
        addChild(spark)
        
        let fadeOut = SKAction.fadeOutWithDuration(0.3)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([fadeOut, remove])
        spark.runAction(sequence)
        
        enemy.removeFromParent()
        
        _enemies--
        
        self.score(Int(1 * _timeSinceStart))
    
    }
    
    func miss(box:SKNode) {
        let sparkPath = NSBundle.mainBundle().pathForResource("fire", ofType: "sks")!
        let fire = NSKeyedUnarchiver.unarchiveObjectWithFile(sparkPath)! as SKEmitterNode
        fire.position = box.position
        fire.xScale=0.7
        fire.yScale=0.7
        self.addChild(fire)
        
        let fadeOut = SKAction.fadeOutWithDuration(3)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([fadeOut,remove])
        fire.runAction(sequence)
        
        box.removeFromParent()
        _boxes--
        
        if (_boxes < 1) {
            let goScene = SKGameOverScene(size:self.size)
            let transition = SKTransition.fadeWithDuration(3.0)
            self.view?.presentScene(goScene, transition:transition)
        }
        
    }
    
    func score(n:Int){
        _score += n
        let scoreLabel = self.childNodeWithName(SCORE_NAME) as SKLabelNode
        scoreLabel.text = String(format: "%5d",  _score)
    }
    
    override func update(currentTime: NSTimeInterval) {
        
        if (_lastUpdateTimeInterval > 0) {
            
            let timeSinceLast  = currentTime - _lastUpdateTimeInterval
            _timeSinceStart += timeSinceLast
            _timeSinceLastSecond += timeSinceLast
            
            let timeLabel = self.childNodeWithName(TIME_NAME) as SKLabelNode
            timeLabel.text = String(format: "%07.1f", _timeSinceStart)
            
            if (_timeSinceLastSecond >= 1){
                _timeSinceLastSecond = 0
                
                var timing = 3
                if (_timeSinceStart > 2){
                    timing = 2
                }
                if (_timeSinceStart > 4) {timing = 1}
                
                var max = 1
                if (_timeSinceStart > 1) {max = 2}
                if (_timeSinceStart > 3) {max = 3}
                if (_timeSinceStart > 5) {max = 4}
                
                if (Int(_timeSinceStart) % timing == 0){
                    if (_enemies < max) {
                        self.addEnemy()
                    }
                }
                
            }
            
            
            
        }
        _lastUpdateTimeInterval = currentTime
    }
    
    // MARK: SKPhysicsContactDelegate
    func didBeginContact(contact: SKPhysicsContact) {
        
        var firstBody:SKPhysicsBody
        var secondBody:SKPhysicsBody
        
        if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if ((firstBody.categoryBitMask & heroCategory) != 0) {
            if ((secondBody.categoryBitMask & enemyCategory) != 0) {
                let hero = firstBody.node as SKHeroNode
                if (hero.state == SKHeroNode.SKHeroState.SKHeroStateAttack){
                    self.attack(secondBody.node!)
                }
            }
        } else if ((firstBody.categoryBitMask & enemyCategory) != 0) {
            if ((secondBody.categoryBitMask & worldCategory) != 0) {
                firstBody.node?.removeFromParent()
                _enemies--;
            } else if ((secondBody.categoryBitMask & boxCategory) != 0) {
                firstBody.node?.removeFromParent()
                _enemies--;
                self.miss(secondBody.node!)
                
            }
        }
    }
}

