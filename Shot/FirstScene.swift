//
//  FirstScene.swift
//  Shot
//
//  Created by yoshimura on 2014/10/24.
//  Copyright (c) 2014年 yoshimura. All rights reserved.
//

import SpriteKit

class FirstScene: SKScene, SKPhysicsContactDelegate {
    
    private func skRandf()->CGFloat {
        let r = CGFloat(rand()) / CGFloat(RAND_MAX)
        return r
    }
    
    private  func skRand(low:CGFloat,high:CGFloat)->CGFloat {
        return skRandf() * (high - low) + low;
    }
    
    #if false
    func newBall()->SKNode {
        let ball = SKShapeNode()
        var path = CGPathCreateMutable()

        let r = skRand(3,high:30)
        
        CGPathAddArc(path, nil, 0, 0, r, 0, CGFloat(M_PI*2), true)
        
        ball.path = path
        ball.fillColor = SKColor(red: skRand(0, high: 1), green: skRand(0, high: 1), blue: skRand(0, high: 1), alpha: skRand(0.7, high: 1));
        ball.strokeColor = SKColor.clearColor()
        ball.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height-r)
        
        ball.physicsBody = SKPhysicsBody(circleOfRadius: r)
        
        
        return ball
    }
    #endif
    
    let swordCategory:UInt32 = 0x1 << 0
    let ballCategory:UInt32 = 0x1 << 1
    let worldCategory:UInt32 = 0x1 << 2
    
    
    func newBall()->SKNode {
        
        let ball = SKShapeNode()
        let path = CGPathCreateMutable()
        let r = skRand(3, high: 30)
        
        CGPathAddArc(path, nil, 0, 0, r, 0, CGFloat(M_PI*2), true)
        
        ball.path = path
        ball.fillColor = SKColor(red: skRand(0, high: 1), green: skRand(0, high: 1), blue: skRand(0, high: 1), alpha: skRand(0, high: 1))
        ball.strokeColor = SKColor.clearColor()
        ball.position = CGPointMake(skRand(0, high: self.frame.size.width), skRand(0, high: self.frame.size.height))
        ball.physicsBody = SKPhysicsBody(circleOfRadius: r)
        ball.physicsBody?.categoryBitMask = ballCategory
        
        return ball;
    }
    
    func newSword()->SKNode {
        
        let sword = SKSpriteNode(imageNamed: "sword")
        sword.xScale = 0.5
        sword.yScale = 0.5
        sword.zRotation = -45 * CGFloat(M_PI) / 180
        
        sword.physicsBody =
            SKPhysicsBody(rectangleOfSize: CGRectApplyAffineTransform(sword.frame, CGAffineTransformMakeScale(0.70,0.7)).size)
        sword.physicsBody?.affectedByGravity = false
        sword.physicsBody?.velocity = CGVectorMake(0, 100)
        sword.physicsBody?.categoryBitMask = swordCategory
        sword.physicsBody?.collisionBitMask = ballCategory
        sword.physicsBody?.contactTestBitMask = ballCategory | worldCategory
        sword.physicsBody?.usesPreciseCollisionDetection = true
        
        
        return sword;
    }
    
    func createSceneContent(){
        let firePath = NSBundle.mainBundle().pathForResource("fire", ofType: "sks")!
        let fire = NSKeyedUnarchiver.unarchiveObjectWithFile(firePath)! as SKEmitterNode
        
        fire.position=CGPointMake(30, 30)
        fire.xScale = 0.5
        fire.yScale = 0.5
        addChild(fire)
        
        physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        physicsWorld.gravity = CGVectorMake(0, self.physicsWorld.gravity.dy * -1)
        physicsWorld.contactDelegate=self
        physicsBody?.categoryBitMask=worldCategory
        
        
        
        for var i=0;i<30;i++ {
            addChild(newBall())
        }
        
    }

    #if false
    func createSceneContent(){
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame);
    }
    #endif
    
    var _contentCreated = false;
    
    override func didMoveToView(view: SKView) {
        if (!_contentCreated) {
            createSceneContent();
            _contentCreated = true;
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        let touch: AnyObject = touches.anyObject()!
        let location = touch.locationInNode(self)
        let sword = newSword()
        sword.position=location
        addChild(sword)
        
        
        #if false
            if (touches.count == 1) {
            let touch:AnyObject = touches.anyObject()!
            let location = touch.locationInNode(self)
            let ball = self.newBall()
            ball.position=location
            addChild(ball)
            
        } else
        if (touches.count == 2){
            self.physicsWorld.gravity=CGVectorMake(0, self.physicsWorld.gravity.dy * -1)
        }
        #endif
        
    }
    
    #if false
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        if (touches.count == 1) {
            
            childNodeWithName("white1")?.yScale *= 0.9;
            
            enumerateChildNodesWithName("whites",usingBlock:{
                node,stop in
                node.zRotation += CGFloat(-5 * M_PI / 180);
            });
            
            
        } else
        if (touches.count == 2) {
            
            let second = SecondScene(size:self.size)
            second.prevScene=self
            let push = SKTransition.pushWithDirection(SKTransitionDirection.Left, duration: 2)
            view?.presentScene(second, transition: push)
        
            
            
            /*
            let second = SecondScene(
            
            let push = SKTransition.pushWithDirection(SKTransitionDirection.Left, duration: 2)
            // second.prevScene=self;
            view?.presentScene(second, transition: push)
            */
            
        }
    }
    #endif
    
    #if false
    func createSceneContent() {
        
        let red = SKSpriteNode(color: SKColor.redColor(), size: CGSizeMake(50, 50));
        red.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        addChild(red);
        
        let green = SKSpriteNode(color:SKColor.greenColor(), size:CGSizeMake(50, 50));
        green.position=CGPointMake(CGRectGetMidX(self.frame)+10, CGRectGetMidY(self.frame)+10);
        addChild(green);
        
        let blue = SKSpriteNode(color: SKColor.blueColor(), size: CGSizeMake(50, 50));
        blue.position=CGPointMake(CGRectGetMidX(self.frame)-10,CGRectGetMidY(self.frame)-10);
        addChild(blue);
        
        let magenta = SKSpriteNode(color: SKColor.magentaColor(), size: CGSizeMake(50, 50));
        magenta.position=CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+100);
        magenta.zPosition=1;
        addChild(magenta);
        
        let yellow = SKSpriteNode(color: SKColor.yellowColor(), size: CGSizeMake(50, 50));
        yellow.position=CGPointMake(CGRectGetMidX(self.frame)+10, CGRectGetMidY(self.frame)+100-10);
        yellow.zPosition=2;
        addChild(yellow);
        
        let cyan = SKSpriteNode(color: SKColor.cyanColor(), size: CGSizeMake(50, 50));
        cyan.position=CGPointMake(CGRectGetMidX(self.frame)-10, CGRectGetMidY(self.frame)+100-20);
        addChild(cyan);
        
        
        let white = SKSpriteNode(color: SKColor.whiteColor(), size: CGSizeMake(50, 50));
        white.position = CGPointMake(65, 70);
        white.name="white1";
        addChild(white);
        
        for var i=2;i<5;i++ {
            let white = SKSpriteNode(color: SKColor.whiteColor(), size: CGSizeMake(50, 50));
            white.position=CGPointMake(CGFloat(65*i), 70);
            white.name="whites";
            addChild(white);
        }
        
    }
    #endif
    
    // MARK: SKPhysicsContactDelegate
    func didBeginContact(contact: SKPhysicsContact) {
        var firstBody:SKPhysicsBody? = nil
        var secondBody:SKPhysicsBody? = nil
        
        if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if ((firstBody!.categoryBitMask & swordCategory) != 0){
            if ((secondBody!.categoryBitMask & ballCategory) != 0){
                let sparkPath = NSBundle.mainBundle().pathForResource("spark", ofType: "sks")
                let spark = NSKeyedUnarchiver.unarchiveObjectWithFile(sparkPath!) as SKEmitterNode
                spark.position = secondBody!.node!.position
                spark.xScale = 0.2
                spark.yScale = 0.3
                addChild(spark)
                
                let fadeOut = SKAction.fadeOutWithDuration(0.3)
                let remove = SKAction.removeFromParent()
                let sequence = SKAction.sequence([fadeOut,remove])
                spark.runAction(sequence)
                
                firstBody!.node!.removeFromParent()
                secondBody!.node!.removeFromParent()
            } else if ((secondBody!.categoryBitMask & worldCategory) != 0) {
                NSLog("contact with world")
                firstBody!.node!.removeFromParent()
            }
        }
        
        
    }
    
}