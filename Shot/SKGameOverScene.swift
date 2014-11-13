//
//  File.swift
//  Shot
//
//  Created by yoshimura on 2014/10/25.
//  Copyright (c) 2014年 yoshimura. All rights reserved.
//

import SpriteKit

class SKGameOverScene:SKScene {
    
    var _contentCreated = false
    
    override func didMoveToView(view: SKView) {
        if (!_contentCreated) {
            createSceneContents();
            _contentCreated = true;
        }
    }

    func createSceneContents() {
        
        let titleLabel = SKLabelNode(fontNamed:"Mosamosa")
        titleLabel.text = "ゲームオーバー"
        titleLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        self.addChild(titleLabel)
        
//        self.performSelector(Selector("goTitle"), withObject:nil, afterDelay:5)
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: Selector("goTitle"), userInfo: nil, repeats: false)

        
    }
    
    func goTitle() {
        let titleScene = SKTitleScene(size:self.size)
        let transition = SKTransition.pushWithDirection(SKTransitionDirection.Left, duration:1)
        self.view?.presentScene(titleScene, transition:transition)
    }
    

    
}
