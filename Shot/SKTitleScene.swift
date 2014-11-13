//
//  SKTitleScene.swift
//  Shot
//
//  Created by yoshimura on 2014/10/25.
//  Copyright (c) 2014年 yoshimura. All rights reserved.
//
import SpriteKit
import AVFoundation

class SKTitleScene: SKScene {
    var _contentCreated = false;
    var sound:AVAudioPlayer? = nil
    
    override func didMoveToView(view: SKView) {
        if (!_contentCreated) {
            createSceneContents();
            _contentCreated = true;
        }
    }
    
    func createSceneContents() {
        
        let titleLabel = SKLabelNode(fontNamed: "Mosamosa")
        titleLabel.text = "たからもり"
        titleLabel.position=CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidX(self.frame))
        addChild(titleLabel)
        
        let startButton = SKButtonNode(fontNamed: titleLabel.fontName)
        startButton.text = "はじめる"
        startButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidX(self.frame)-30)
        startButton.fontSize = 20
        startButton.hidden = true
        startButton.name = "start"
        addChild(startButton)
        
        let wait = SKAction.waitForDuration(1)
        let moveUp = SKAction.moveByX(0, y: 50, duration: 0.5)
        let sequence = SKAction.sequence([wait,moveUp])
        titleLabel.runAction(sequence, completion: {
                startButton.hidden = false
            }
        )
    
        let bgmPath = NSBundle.mainBundle().pathForResource("s", ofType: "m4a")!
        let bgmUrl = NSURL.fileURLWithPath(bgmPath)
        sound = AVAudioPlayer(contentsOfURL: bgmUrl, error: nil)
        sound!.numberOfLoops = -1
        sound!.play()
    
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let touch:AnyObject = touches.anyObject()!
        let _nodeAtPoint = nodeAtPoint(touch.locationInNode(self))
        if (_nodeAtPoint.name == "start") {
            let startButton = _nodeAtPoint as SKButtonNode
            startButton.setHighlight(true)
        }
    }
    
    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
        let startButton = childNodeWithName("start") as SKButtonNode
        startButton.setHighlight(false)
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        
        let touch:AnyObject = touches.anyObject()!
        let _nodeAtPoint = nodeAtPoint(touch.locationInNode(self))
        if (_nodeAtPoint.name=="start"){
            let startButton = _nodeAtPoint as SKButtonNode
            if (startButton.highlighted) {
                let playScene = SKPlayScene(size: self.size)
                let transition = SKTransition.pushWithDirection(SKTransitionDirection.Left, duration: 1)
                self.view?.presentScene(playScene, transition: transition)
            }
        }
        
        self.touchesCancelled(touches, withEvent: event)
    }


}

