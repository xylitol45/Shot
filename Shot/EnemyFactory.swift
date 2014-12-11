//
//  EnemyFactory.swift
//  Shot
//
//  Created by yoshimura on 2014/12/04.
//  Copyright (c) 2014年 yoshimura. All rights reserved.
//

import SpriteKit

class EnemyFactory {
    
    class func initEnemy(scene:SKScene, stage:Int) {

        if (arc4random_uniform(4) == 0) {
            EnemyFactory.initNoDestroyEnemySprite(scene)
        }
        
        if arc4random_uniform(10) != 0 {
            return;
        }
        
        let _no = arc4random_uniform(8)

        
        switch(_no) {
        case 0:
            EnemyFactory.initEnemySprite(scene)
        case 1:
            EnemyFactory.initEnemySprite2(scene)
        case 2:
            EnemyFactory.initEnemySprite3(scene)
        case 3:
            EnemyFactory.initEnemySprite4(scene)
        case 4:
            EnemyFactory.initEnemySprite5(scene)
        case 5:
            EnemyFactory.initEnemySprite6(scene)
        case 6:
            EnemyFactory.initEnemySprite7(scene)
        case 7:
            EnemyFactory.initEnemySprite8(scene)
        default:break;
        }
        
    }

    // MARK: 敵弾
    class func initNoDestroyEnemySprite(scene:SKScene) {
        
        let _frame = scene.frame
        
        let _player = scene.childNodeWithName("player")
        if _player == nil {
            return
        }
        
        let _sprite = SKShapeNode(ellipseInRect: CGRectMake(0, 0, 8, 8))
        _sprite.userData = [:]
        _sprite.userData!["hp"] = PlayScene.noDestoroyHp()
        _sprite.userData!["ap"] = 10
        _sprite.userData!["score"] = 0
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
    
    // 散弾２
    class func initNoDestroyEnemySprite2(scene:SKScene, position:CGPoint) {
        
        let _frame = scene.frame
        
        let _player = scene.childNodeWithName("player")
        if _player == nil {
            return
        }
        let _playerFrame = _player!.frame
        
        let _xx = _playerFrame.origin.x - position.x
        let _yy = _playerFrame.origin.y - position.y
        
        var dx:CGFloat = 0, dy:CGFloat = 0
        
        var _move:SKAction? = nil
        
        if (_xx == 0 || _yy == 0) {
            return
        }
        
        if (_xx == 0) {
            _move = SKAction.moveByX(0, y: _yy > 0 ? 100 : -100, duration: 0.5)
        } else if (_yy == 0) {
            _move = SKAction.moveByX( _xx > 0 ? 100 : -100, y:0, duration: 0.5)
        } else if abs(_xx) > abs(_yy) {
            _move = SKAction.moveByX( _xx > 0 ? 100 : -100, y:_yy / abs(_xx) * 100, duration: 0.5)
        } else {
            _move = SKAction.moveByX( _xx / abs(_yy) * 100, y: _yy > 0 ? 100 : -100, duration: 0.5)
        }
        
        
        let _sprite = SKShapeNode(ellipseInRect: CGRectMake(0, 0, 8, 8))
        _sprite.userData = [:]
        _sprite.userData!["hp"] = PlayScene.noDestoroyHp()
        _sprite.userData!["ap"] = 10
        _sprite.userData!["score"] = 0
        _sprite.fillColor = SKColor.whiteColor()
        _sprite.strokeColor = SKColor.blackColor()
        _sprite.name = "enemy"
        _sprite.zPosition = 50
        _sprite.position = position
        
        _sprite.runAction(SKAction.repeatActionForever(SKAction.sequence([
            _move!,
            SKAction.runBlock({
                
                
                if _sprite.frame.origin.x < 0 || _sprite.frame.origin.x > CGRectGetMaxX(_frame)
                    ||  _sprite.frame.origin.y < 0 || _sprite.frame.origin.y > CGRectGetMaxY(_frame){
                        _sprite.removeFromParent()
                }
            })
        ])))
        
        scene.addChild(_sprite)
        
    }

    // 四角
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
        _sprite.userData!["ap"] = 25
        _sprite.userData!["score"] = 100
        _sprite.fillColor = SKColor.whiteColor()
        _sprite.strokeColor = SKColor.blackColor()
        _sprite.name = "enemy"
        _sprite.zPosition = 100
        
        _sprite.position =
            CGPointMake(CGFloat(arc4random_uniform(UInt32(CGRectGetMaxX(_frame))-100)), CGRectGetMaxY(_frame)+10)
        
        let _moveDown = SKAction.moveToY(-100, duration: 4)
        _sprite.runAction(
            SKAction.sequence([_moveDown, SKAction.removeFromParent()])
            )
            
        
        scene.addChild(_sprite)
    }
    
    // 楕円
    class func initEnemySprite2(scene:SKScene) {
        
        let _frame = scene.frame
        
        let _sprite = SKShapeNode(ellipseOfSize: CGSizeMake(CGRectGetMaxY(_frame) / 2, 50))
        _sprite.userData = [:]
        _sprite.userData!["hp"] = 40
        _sprite.userData!["ap"] = 50
        _sprite.userData!["score"] = 1000
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
    
    // 三角２つ
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
        _sprite.userData!["ap"] = 25
        _sprite.userData!["score"] = 100
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
    
    // 三角２つ
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
        _sprite.userData!["ap"] = 25
        _sprite.userData!["score"] = 100
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
    
    // ズーム
    class func initEnemySprite5(scene:SKScene) {
        
        let _frame = scene.frame
        
        let _path = UIBezierPath()
        _path.moveToPoint(CGPointMake(-10, -10))
        _path.addLineToPoint(CGPointMake(10,-10))
        _path.addLineToPoint(CGPointMake(10,10))
        _path.addLineToPoint(CGPointMake(-10,10))
        _path.closePath()
        
        let _sprite = SKShapeNode(path: _path.CGPath)
        _sprite.userData = [:]
        _sprite.userData!["hp"] = 4
        _sprite.userData!["ap"] = 25
        _sprite.userData!["score"] = 100
        _sprite.fillColor = SKColor.whiteColor()
        _sprite.strokeColor = SKColor.blackColor()
        _sprite.name = "enemy"
        _sprite.zPosition = 100
        
        _sprite.position =
            CGPointMake(CGFloat(arc4random_uniform(UInt32(CGRectGetMaxX(_frame))-100)), CGRectGetMaxY(_frame)+10)
        
        let _moveDown = SKAction.moveToY(-100, duration: 5)
        _sprite.runAction(
            SKAction.group([
                SKAction.repeatActionForever(
                    SKAction.sequence(
                        [SKAction.scaleTo(5.0, duration:1),
                            
                            SKAction.runBlock({
                                EnemyFactory.initNoDestroyEnemySprite2(scene, position: _sprite.frame.origin)
                            }),
                            
                            
                            SKAction.scaleTo(1.0, duration: 1)])
                ),
                SKAction.sequence([_moveDown, SKAction.removeFromParent()])
                ])
        )
        
        scene.addChild(_sprite)
    }
    
    // 菱形
    class func initEnemySprite6(scene:SKScene) {
        
        let _frame = scene.frame
        
        let _path = UIBezierPath()
        _path.moveToPoint(CGPointMake(0, 0))
        _path.addLineToPoint(CGPointMake(20,20))
        _path.addLineToPoint(CGPointMake(0,40))
        _path.addLineToPoint(CGPointMake(-20,20))
        _path.closePath()
        
        let _sprite = SKShapeNode(path: _path.CGPath)
        _sprite.userData = [:]
        _sprite.userData!["hp"] = 4
        _sprite.userData!["ap"] = 25
        _sprite.userData!["score"] = 100
        _sprite.fillColor = SKColor.whiteColor()
        _sprite.strokeColor = SKColor.blackColor()
        _sprite.name = "enemy"
        _sprite.zPosition = 100
        
        _sprite.position =
            CGPointMake(CGFloat(arc4random_uniform(UInt32(CGRectGetMaxX(_frame))-100)), CGRectGetMaxY(_frame)+40)
        
        let _flg = arc4random_uniform(2) == 1 ? true : false
        
        _sprite.runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.moveTo(
                    CGPointMake(_flg ? 0 : CGRectGetMaxX(_frame),CGFloat(arc4random_uniform(UInt32(CGRectGetMaxY(_frame))))), duration: 1),
                SKAction.moveTo(
                    CGPointMake(CGFloat(arc4random_uniform(UInt32(CGRectGetMaxX(_frame)))), 0), duration: 1),
                
                SKAction.moveTo(
                    CGPointMake(!_flg ? 0 : CGRectGetMaxX(_frame), CGFloat(arc4random_uniform(UInt32(CGRectGetMaxY(_frame))))), duration: 1),
                SKAction.moveTo(
                    CGPointMake(CGFloat(arc4random_uniform(UInt32(CGRectGetMaxX(_frame)))), CGRectGetMaxY(_frame)), duration: 1),
                
                
                ])
            )
        )
        scene.addChild(_sprite)
    }
    
    // ３つ
    class func initEnemySprite7(scene:SKScene) {
        
        let _frame = scene.frame
        let _x = CGFloat(arc4random_uniform(UInt32(CGRectGetMaxX(_frame))-100))
        
        for i in -1...1 {
            
            let _path = UIBezierPath()
            _path.moveToPoint(CGPointMake(0, 0))
            _path.addLineToPoint(CGPointMake(10,0))
            _path.addLineToPoint(CGPointMake(10,40))
            _path.addLineToPoint(CGPointMake(0,40))
            _path.closePath()
            
            let _sprite = SKShapeNode(path: _path.CGPath)
            _sprite.userData = [:]
            _sprite.userData!["hp"] = 2
            _sprite.userData!["ap"] = 25
            _sprite.userData!["score"] = 100
            _sprite.fillColor = SKColor.whiteColor()
            _sprite.strokeColor = SKColor.blackColor()
            _sprite.name = "enemy"
            _sprite.zPosition = 100
            
            _sprite.position =
                CGPointMake(_x + CGFloat(i) * 20, CGRectGetMaxY(_frame)+40)
            
            
            let _moveDown = SKAction.moveToY(20, duration: 2)
            let _moveUp = SKAction.group([
                SKAction.moveToY(CGRectGetMaxY(_frame)+40, duration: 1),
                SKAction.moveByX(CGFloat(i) * 100, y: 0, duration: 1)
            ])
            
            _sprite.runAction(SKAction.sequence([_moveDown, _moveUp,SKAction.removeFromParent()]))
            
            scene.addChild(_sprite)
        }
        
    }

    // 丸
    class func initEnemySprite8(scene:SKScene) {
        
        let _frame = scene.frame
        
        let _path = UIBezierPath()
        _path.moveToPoint(CGPointMake(0, 0))
        _path.addLineToPoint(CGPointMake(50,0))
        _path.addLineToPoint(CGPointMake(0,50))
        _path.addLineToPoint(CGPointMake(50,50))
        _path.closePath()
        
        let _sprite = SKShapeNode(ellipseOfSize:CGSizeMake(40, 40))
        _sprite.userData = [:]
        _sprite.userData!["hp"] = 4
        _sprite.userData!["ap"] = 25
        _sprite.userData!["score"] = 100
        _sprite.fillColor = SKColor.whiteColor()
        _sprite.strokeColor = SKColor.blackColor()
        _sprite.name = "enemy"
        _sprite.zPosition = 100
        
        _sprite.position =
            CGPointMake(CGFloat(arc4random_uniform(UInt32(CGRectGetMaxX(_frame))-100)), CGRectGetMaxY(_frame)+10)
        
        var _movePath:[SKAction] = []
        
        for _ in 0..<10 {
            
            let _x = CGFloat(arc4random_uniform(UInt32(CGRectGetMaxX(_frame))))
            let _y = CGFloat(arc4random_uniform(UInt32(CGRectGetMaxY(_frame))))
            _movePath.append(
                SKAction.moveTo(CGPointMake(_x, _y), duration: 1)
            )
            _movePath.append(
                SKAction.runBlock({
                    EnemyFactory.initNoDestroyEnemySprite2(scene, position: _sprite.frame.origin)
                })

            )
        }
        _movePath.append(SKAction.moveToY(-100, duration: 1))
        _movePath.append(SKAction.removeFromParent())
        
        _sprite.runAction(SKAction.sequence(_movePath))
        
        scene.addChild(_sprite)
    }

}