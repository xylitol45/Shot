//
//  SKHeroNode.swift
//  Shot
//
//  Created by yoshimura on 2014/10/25.
//  Copyright (c) 2014年 yoshimura. All rights reserved.
//

import SpriteKit

class SKHeroNode: SKSpriteNode {
    
    let TIP_SIZE:CGFloat = 96
    
    enum SKHeroState:UInt8 {
        case SKHeroStateStop = 0, SKHeroStateWalk, SKHeroStateAttack
    }
    
    var state:SKHeroState = SKHeroState.SKHeroStateStop
    
    class func hero()->SKNode {
        let hero = SKHeroNode(texture:nil, color:nil, size:CGSizeMake( 96, 96))
        return hero
    }
    
    override init(texture: SKTexture!, color: UIColor!, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        self.stop()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func stop(){
        self.animate("clotharmor", withRow: 3, cols: 2, time: 0.6, completion: nil)
        self.state = SKHeroState.SKHeroStateStop
    }
    
    func walk() {
        self.animate("clotharmor", withRow: 4, cols: 4, time: 0.2, completion: nil)
        self.state = SKHeroState.SKHeroStateWalk
    }
    
    func attack() {
        self.animate("clotharmor", withRow: 5, cols: 5, time: 0.05, completion: {
            self.state = SKHeroState.SKHeroStateStop
        })
        self.sword()
        
        self.state = SKHeroState.SKHeroStateAttack
    }
    
    func sword() {
        let _textures = self.textures("sword1", row: 5, cols: 5)
        
        let swordSprite = SKSpriteNode(texture: _textures.first)
        addChild(swordSprite)
        
        let animate = SKAction.animateWithTextures(_textures, timePerFrame: 0.05)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([animate, remove])
        swordSprite.runAction(sequence)
    }
    
    func animate(name:String, withRow row:Int,  cols:Int,  time t:NSTimeInterval, completion block:(() -> Void)?) {
        let _textures = self.textures(name, row: row, cols: cols)
        let animate = SKAction.animateWithTextures(_textures, timePerFrame:t)
        if (block == nil) {
            let forever = SKAction.repeatActionForever(animate)
            self.runAction(forever)
        } else {
            self.runAction(animate, completion: block!)
        }
    }
    
    func textures(name:String, row:Int, cols:Int)->[SKTexture] {
        let texture = SKTexture(imageNamed: name)
        
        var _textures:[SKTexture] = []
        for var col=0;col < cols;col++ {
            let x = CGFloat(col) * TIP_SIZE / texture.size().width
            let y = CGFloat(row) * TIP_SIZE / texture.size().height
            let w = TIP_SIZE / texture.size().width
            let h = TIP_SIZE / texture.size().height
            
            let t = SKTexture(rect: CGRectMake(x, y, w, h), inTexture: texture)
            _textures.append(t)
        }
        
        return _textures
    }
}
