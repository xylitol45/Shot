//
//  GameViewController.swift
//  Shot
//
//  Created by yoshimura on 2014/10/23.
//  Copyright (c) 2014年 yoshimura. All rights reserved.
//

import UIKit
import SpriteKit

#if false
extension SKNode {
    class func unarchiveFromFile(file : NSString) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as GameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}
#endif
    
class GameViewController: UIViewController {

    override func loadView() {
        let applicationFram = UIScreen.mainScreen().applicationFrame
        let skView = SKView(frame: applicationFram)
        self.view=skView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView:SKView = self.view as SKView
        
        skView.showsDrawCount = true
        skView.showsNodeCount = true
        skView.showsFPS=true
        
        println(self.view.bounds.size)
        
        // このサイズはiPhone6
        let scene = GameScene(size:CGSizeMake(375, 667))
        scene.scaleMode = .AspectFit
        
//        let scene = PlayScene(size: self.view.bounds.size)
        
        skView.presentScene(scene)
        
        #if false
        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            // Configure the view.
            let skView = self.view as SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            scene.size = skView.frame.size;
            
            skView.presentScene(scene)
        }
        #endif
        
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
