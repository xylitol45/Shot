//
//  SecondScene.swift
//  Shot
//
//  Created by yoshimura on 2014/10/24.
//  Copyright (c) 2014年 yoshimura. All rights reserved.
//

import SpriteKit

class SecondScene: SKScene {

    /*
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var prevScene:SKScene;
    */
    
    var prevScene:SKScene?
    
    var _contentCreated = false;
    
    override func didMoveToView(view: SKView) {
        if (!_contentCreated) {
            createSceneContents();
            _contentCreated = true;
        }
    }
    
    func createSceneContents() {
        self.backgroundColor=SKColor.lightGrayColor()
    }
    
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let door = SKTransition.doorwayWithDuration(2)
    
        self.view?.presentScene(prevScene, transition: door)
        
        // self.view?.presentScene(prevScene, transition: door)
    }
}