//
//  TitleScene.swift
//  Shot
//
//  Created by yoshimura on 2014/10/29.
//  Copyright (c) 2014年 yoshimura. All rights reserved.
//

import SpriteKit
import AVFoundation

class TitleScene: SKScene {

    var _contentCreated = false;
    var sound:AVAudioPlayer? = nil
    
    override func didMoveToView(view: SKView) {
        if (!_contentCreated) {
            createSceneContents();
            _contentCreated = true;
        }
    }
    
    func createSceneContents() {

        backgroundColor = UIColor.blackColor()
        
        let a = [Int]()
        
        let titleLabel = SKLabelNode(fontNamed: "Mosamosa")
//        titleLabel.text = "たからもり"
//        titleLabel.position=CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidX(self.frame))
//        addChild(titleLabel)
        
        for i in 0..<4 {
            let startButton = SKButtonNode(fontNamed: titleLabel.fontName)
            startButton.text = "はじめる"
            startButton.position = CGPointMake(CGRectGetMidX(self.frame), 100 + CGFloat(60*i) )
            startButton.fontSize = 20
//            startButton.hidden = true
            startButton.name = String(format:"start%d", i)
            addChild(startButton)
        }
        
        
//        let wait = SKAction.waitForDuration(1)
//        let moveUp = SKAction.moveByX(0, y: 50, duration: 0.5)
//        let sequence = SKAction.sequence([wait,moveUp])
//        titleLabel.runAction(sequence, completion: {
//            startButton.hidden = false
//            }
//        )
        
    }

    func soundPlay(name:String, ofType:String = "m4a"){
        // 止める
        if (sound != nil){
            sound!.stop()
            sound = nil
        }
        let bgmPath = NSBundle.mainBundle().pathForResource(name, ofType: ofType)!
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
//        let startButton = childNodeWithName("start") as SKButtonNode
//        startButton.setHighlight(false)
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        
        let touch:AnyObject = touches.anyObject()!
        let _nodeAtPoint = nodeAtPoint(touch.locationInNode(self))
//        if (_nodeAtPoint.name=="start"){
//            let startButton = _nodeAtPoint as SKButtonNode
//            if (startButton.highlighted) {
//                let playScene = SKPlayScene(size: self.size)
//                let transition = SKTransition.pushWithDirection(SKTransitionDirection.Left, duration: 1)
//                self.view?.presentScene(playScene, transition: transition)
//            }
//        }
        if (_nodeAtPoint.name == "start0"){
                soundPlay("0",ofType:"m4a")
        }else
        if (_nodeAtPoint.name == "start1"){
                soundPlay("1",ofType:"m4a")
        }else
        if (_nodeAtPoint.name == "start2"){
                soundPlay("2",ofType:"m4a")
        }else
        if (_nodeAtPoint.name == "start3"){
                soundPlay("3",ofType:"m4a")
        }
        
        
        
        self.touchesCancelled(touches, withEvent: event)
    }
    
    
}
