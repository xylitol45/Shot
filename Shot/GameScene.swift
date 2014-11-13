//
//  GameScene.swift
//  Shot
//
//  Created by yoshimura on 2014/10/23.
//  Copyright (c) 2014年 yoshimura. All rights reserved.
//

// import Foundation ... SpriteKit内で呼ばれているので省略可
import SpriteKit

class GameScene: SKScene {
    
    var _contentCreated = false;
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
//        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
//        myLabel.text = "Hello, World!";
//        myLabel.fontSize = 32;
//        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
//        
//        self.addChild(myLabel)

        
        if (!_contentCreated) {
            createSceneContent();
            _contentCreated = true;
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        
        if (touches.count == 1) {
            
            childNodeWithName("white1")?.yScale *= 0.9;
            
            enumerateChildNodesWithName("whites",usingBlock:{
                node,stop in
                node.zRotation += CGFloat(-5 * M_PI / 180);
            });
            
            
        }
        
        /* Called when a touch begins */
        
//        for touch: AnyObject in touches {
//            let location = touch.locationInNode(self)
//            
//            let sprite = SKSpriteNode(imageNamed:"Spaceship")
//            
//            sprite.xScale = 0.5
//            sprite.yScale = 0.5
//            sprite.position = location
//            
//            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
//            
//            sprite.runAction(SKAction.repeatActionForever(action))
//            
//            self.addChild(sprite)
//        }
        
//        let touch:AnyObject = touches.anyObject()!;
//        let location = touch.locationInNode(self);
//        let moveToTouch = SKAction.moveTo(location, duration: 1.0);
//        
//        let sword = childNodeWithName("sword")!;
//        
//        sword.runAction(moveToTouch, completion: { () -> Void in
//            NSLog("%@", NSStringFromCGPoint(location));
//        });
        
        
    }
   
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        NSLog("1");
    }
    #if false
    
    override func   didEvaluateActions() {
        NSLog("2");
    }
    
    override func didSimulatePhysics() {
        NSLog("3");
    }
    #endif
    
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
    
}
