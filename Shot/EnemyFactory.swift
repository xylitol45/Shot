//
//  EnemyFactory.swift
//  Shot
//
//  Created by yoshimura on 2014/12/04.
//  Copyright (c) 2014年 yoshimura. All rights reserved.
//

import SpriteKit

class EnemyFactory {
    
    class func initEnemy(scene:SKScene) {

        if (arc4random_uniform(4) == 0) {
            EnemyFactory.initNoDestroyEnemySprite(scene)
        }
        
        if arc4random_uniform(20) == 0 {
            EnemyFactory.initEnemySprite(scene)
            return;
        }
        
        if (arc4random_uniform(20) == 0) {
            EnemyFactory.initEnemySprite2(scene)
            return;
        }
        
        if (arc4random_uniform(20) == 0) {
            EnemyFactory.initEnemySprite3(scene)
            return;
        }
        
        if (arc4random_uniform(20) == 0) {
            EnemyFactory.initEnemySprite4(scene)
            return;
        }

    }

    class func initNoDestroyEnemySprite(scene:SKScene) {
        
        let _frame = scene.frame
        
        let _player = scene.childNodeWithName("player")
        if _player == nil {
            return
        }
        
        let _sprite = SKShapeNode(ellipseInRect: CGRectMake(0, 0, 10, 10))
        _sprite.userData = [:]
        _sprite.userData!["hp"] = PlayScene.noDestoroyHp()
        _sprite.userData!["ap"] = 12
        _sprite.fillColor = SKColor.whiteColor()
        _sprite.strokeColor = SKColor.blackColor()
        _sprite.name = "enemy"
        _sprite.zPosition = 50
        
        scene.addChild(_sprite)
        
        let _playerX = _player!.position.x
        
        let _r = arc4random_uniform(4)
        
        let _y = CGFloat(arc4random_uniform(UInt32(CGRectGetMaxY(_frame) / 4)))
        
        switch _r {
        case 1,2:
            _sprite.position =
                CGPointMake(CGFloat(arc4random_uniform(UInt32(CGRectGetMaxX(_frame)))), CGRectGetMaxY(_frame)+40)
        case 3:
            _sprite.position =
                CGPointMake(-40, CGRectGetMaxY(_frame) - _y  )
        default:
            _sprite.position =
                CGPointMake(CGRectGetMaxX(_frame)+40, CGRectGetMaxY(_frame) - _y  )
        }
        
        let _moveTo = SKAction.moveTo(CGPointMake(_playerX, -40), duration: 2)
        
        _sprite.runAction(SKAction.sequence([_moveTo,SKAction.removeFromParent()]))
        
    }
    
    class func initEnemySprite3(scene:SKScene) {
        
        let _frame = scene.frame
        
        
        let _path = UIBezierPath()
        _path.moveToPoint(CGPointMake(0, 0))
        _path.addLineToPoint(CGPointMake(50,0))
        _path.addLineToPoint(CGPointMake(0,50))
        _path.addLineToPoint(CGPointMake(50,50))
        _path.closePath()
        
        let _sprite = SKShapeNode(path: _path.CGPath)
        _sprite.userData = [:]
        _sprite.userData!["hp"] = 4
        _sprite.userData!["ap"] = 450
        _sprite.fillColor = SKColor.whiteColor()
        _sprite.strokeColor = SKColor.blackColor()
        _sprite.name = "enemy"
        _sprite.zPosition = 100
        
        _sprite.position = CGPointMake(CGFloat(arc4random_uniform(UInt32(CGRectGetMaxX(_frame))-100)), CGRectGetMaxY(_frame)+10)
        
        _sprite.runAction(
            SKAction.sequence([
                SKAction.moveToY(CGRectGetMidY(_frame) / 2, duration: 3),
                SKAction.moveTo(
                    arc4random_uniform(2) == 0 ? CGPointMake(-100, CGRectGetMidY(_frame)) : CGPointMake(CGRectGetMaxX(_frame)+100, CGRectGetMidY(_frame)), duration:  1),
                SKAction.removeFromParent()]))
        
        scene.addChild(_sprite)
    }
    
    class func initEnemySprite(scene:SKScene) {
        
        let _frame = scene.frame
        
        let _path = UIBezierPath()
        _path.moveToPoint(CGPointMake(0, 0))
        _path.addLineToPoint(CGPointMake(50,0))
        _path.addLineToPoint(CGPointMake(50,50))
        _path.addLineToPoint(CGPointMake(0,50))
        _path.closePath()
        
        let _sprite = SKShapeNode(path: _path.CGPath)
        _sprite.userData = [:]
        _sprite.userData!["hp"] = 4
        _sprite.userData!["ap"] = 450
        _sprite.fillColor = SKColor.whiteColor()
        _sprite.strokeColor = SKColor.blackColor()
        _sprite.name = "enemy"
        _sprite.zPosition = 100
        
        _sprite.position =
            CGPointMake(CGFloat(arc4random_uniform(UInt32(CGRectGetMaxX(_frame))-100)), CGRectGetMaxY(_frame)+10)
        
        let _moveDown = SKAction.moveToY(-100, duration: 5)
        _sprite.runAction(SKAction.sequence([_moveDown, SKAction.removeFromParent()]))
        
        scene.addChild(_sprite)
    }
    
    class func initEnemySprite2(scene:SKScene) {
        
        let _frame = scene.frame
        
        let _sprite = SKShapeNode(ellipseOfSize: CGSizeMake(CGRectGetMaxY(_frame) / 2, 50))
        _sprite.userData = [:]
        _sprite.userData!["hp"] = 10
        _sprite.userData!["ap"] = 35
        _sprite.fillColor = SKColor.whiteColor()
        _sprite.strokeColor = SKColor.blackColor()
        _sprite.name = "enemy"
        _sprite.zPosition = 100
        
        let _x = CGFloat(arc4random_uniform(UInt32(CGRectGetMaxX(_frame))))
        
        _sprite.position = CGPointMake(_x, CGRectGetMaxY(_frame) + 100)
        
        let _action = SKAction.group([
            SKAction.repeatActionForever(SKAction.rotateByAngle(CGFloat(M_PI_2) * -1, duration: 5)),
            SKAction.sequence([
                SKAction.moveTo(CGPointMake(_x, -100), duration: 20),
                SKAction.removeFromParent()])
            ])
        _sprite.runAction(_action)
        scene.addChild(_sprite)
    }
    
    
    class func initEnemySprite4(scene:SKScene) {
        
        let _frame = scene.frame
        
        let _path = UIBezierPath()
        _path.moveToPoint(CGPointMake(0, 0))
        _path.addLineToPoint(CGPointMake(50,0))
        _path.addLineToPoint(CGPointMake(0,50))
        _path.addLineToPoint(CGPointMake(50,50))
        _path.closePath()
        
        let _sprite = SKShapeNode(path: _path.CGPath)
        _sprite.userData = [:]
        _sprite.userData!["hp"] = 4
        _sprite.userData!["ap"] = 450
        _sprite.fillColor = SKColor.whiteColor()
        _sprite.strokeColor = SKColor.blackColor()
        _sprite.name = "enemy"
        _sprite.zPosition = 100
        
        _sprite.position =
            CGPointMake(CGFloat(arc4random_uniform(UInt32(CGRectGetMaxX(_frame))-100)), CGRectGetMaxY(_frame)+10)
        
        var _circle = CGPathCreateMutable()!
        
        CGPathMoveToPoint(_circle, nil, 0, 0)
        CGPathAddArc(_circle, nil, 0, 200, 200, CGFloat(M_PI_2), CGFloat(-M_PI_2), true);
        
        
        
        _sprite.runAction(
            SKAction.sequence([
                SKAction.moveToY(CGRectGetMidY(_frame) / 2, duration: 3),
                SKAction.followPath(_circle, asOffset: true, orientToPath: false, duration: 1),
                SKAction.moveToY(-100, duration:1),
                SKAction.removeFromParent()]))
        
        scene.addChild(_sprite)
    }
    

}