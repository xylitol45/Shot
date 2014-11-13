//
//  SKButtonNode.swift
//  Shot
//
//  Created by yoshimura on 2014/10/25.
//  Copyright (c) 2014年 yoshimura. All rights reserved.
//

import SpriteKit

class SKButtonNode: SKLabelNode {

//    
    var highlighted = false
    
    override init() {
        super.init()
    }
    
    override init(fontNamed fontName: String!) {
        super.init(fontNamed: fontName)
        color=SKColor.grayColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder:aDecoder)
//    }
    
    
    
    func setHighlight(highlighted:Bool){
        if (!self.hidden) {
            self.highlighted=highlighted
        }
        self.colorBlendFactor = self.highlighted ? 0.7 : 0
    }

}