//
//  EnemyFactory.swift
//  Shot
//
//  Created by yoshimura on 2014/12/04.
//  Copyright (c) 2014年 yoshimura. All rights reserved.
//

import SpriteKit

class EnemyFactory {
    
    class func EnemyMap() -> [[Int]] {
        return  [
            [20], [19], [18], [17], [16], [15], [14], [13], [12], [3], [11], [1,4,10], [1,2],[3,4,5],[6,7],[8,9,10]
        ]
    }
    
    class func initEnemy(scene:SKScene, stage:Int) {
        
        if (arc4random_uniform(8) == 0) {
            EnemyFactory.initNoDestroyEnemySprite(scene)
        }
        
        if arc4random_uniform(10) != 0 {
            return;
        }
        
        let _map = EnemyMap()
        
        let _mapSub = _map[(stage - 1) % _map.count]
        let _mapNo = arc4random_uniform(UInt32(_mapSub.count))
        let _no = _mapSub[Int(_mapNo)]
        
        switch(_no) {
        case 1:
            EnemyFactory.initEnemySprite(scene)
        case 2:
            EnemyFactory.initEnemySprite2(scene)
        case 3:
            EnemyFactory.initEnemySprite3(scene)
        case 4:
            EnemyFactory.initEnemySprite4(scene)
        case 5:
            EnemyFactory.initEnemySprite5(scene)
        case 6:
            EnemyFactory.initEnemySprite6(scene)
        case 7:
            EnemyFactory.initEnemySprite7(scene)
        case 8:
            EnemyFactory.initEnemySprite8(scene)
        case 9:
            EnemyFactory.initEnemySprite9(scene)
        case 10:
            EnemyFactory.initEnemySprite10(scene)
        case 11:
            EnemyFactory.initEnemySprite11(scene)
        case 12:
            EnemyFactory.initEnemySprite12(scene)
        case 13:
            EnemyFactory.initEnemySprite13(scene)
        case 14:
            EnemyFactory.initEnemySprite14(scene)
        case 15:
            EnemyFactory.initEnemySprite15(scene)
        case 16:
            EnemyFactory.initEnemySprite16(scene)
        case 17:
            EnemyFactory.initEnemySprite17(scene)
        case 18:
            EnemyFactory.initEnemySprite18(scene)
        case 19:
            EnemyFactory.initEnemySprite19(scene)
        case 20:
            EnemyFactory.initEnemySprite20(scene)
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
        _path.addLineToPoint(CGPointMake(40,0))
        _path.addLineToPoint(CGPointMake(40,40))
        _path.addLineToPoint(CGPointMake(0,40))
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
        
        let _moveDown = SKAction.moveToY(-100, duration: 2)
        _sprite.runAction(
            SKAction.sequence([_moveDown, SKAction.removeFromParent()])
        )
        
        
        scene.addChild(_sprite)
    }
    
    // 楕円
    class func initEnemySprite2(scene:SKScene) {
        
        let _frame = scene.frame
        
        let _sprite = SKShapeNode(ellipseOfSize: CGSizeMake(CGRectGetMaxY(_frame) / 2, 100))
        _sprite.userData = [:]
        _sprite.userData!["hp"] = 20
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
    
    // カーブ２つ
    class func initEnemySprite3(scene:SKScene) {
        
        let _frame = scene.frame
        
        let _path = UIBezierPath()
        _path.moveToPoint(CGPointMake(0, 0))
        _path.addQuadCurveToPoint(CGPointMake(0, 40), controlPoint: CGPointMake(40, 20))
        _path.moveToPoint(CGPointMake(0, 0))
        _path.addQuadCurveToPoint(CGPointMake(0, 40), controlPoint: CGPointMake(-40, 20))
        
        
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
                SKAction.moveToY(CGRectGetMidY(_frame) / 2, duration: 2),
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
        _path.addLineToPoint(CGPointMake(40,0))
        _path.addLineToPoint(CGPointMake(0,40))
        _path.addLineToPoint(CGPointMake(40,40))
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
        
        var _move:SKAction? = nil
        var _circle = CGPathCreateMutable()!
        
        if _sprite.position.x > CGRectGetMidX(_frame) {
            CGPathMoveToPoint(_circle, nil, 0, 0)
            CGPathAddArc(_circle, nil, -100, 0, 100, 0, CGFloat(M_PI_2), true);
            _move = SKAction.moveTo(CGPointMake(CGRectGetMaxX(_frame), -40), duration: 1)
        } else {
            
            CGPathMoveToPoint(_circle, nil, 0, 0)
            CGPathAddArc(_circle, nil, 100, 0, 100, CGFloat(M_PI), CGFloat(M_PI_2), false);
            _move = SKAction.moveTo(CGPointMake(0, -40), duration: 1)
        }
        
        _sprite.runAction(
            SKAction.sequence([
                SKAction.moveToY(CGRectGetMaxY(_frame) / 2, duration: 1),
                SKAction.followPath(_circle, asOffset: true, orientToPath: false, duration: 0.5),
                _move!,
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
                        [SKAction.scaleTo(10.0, duration:1),
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
    
    // 長方形
    class func initEnemySprite9(scene:SKScene) {
        
        let _frame = scene.frame
        
        let _path = UIBezierPath()
        _path.moveToPoint(CGPointMake(0, 0))
        _path.addLineToPoint(CGPointMake(100,0))
        _path.addLineToPoint(CGPointMake(100,20))
        _path.addLineToPoint(CGPointMake(0,20))
        _path.closePath()
        
        let _sprite = SKShapeNode(path: _path.CGPath)
        _sprite.userData = [:]
        _sprite.userData!["hp"] = 8
        _sprite.userData!["ap"] = 25
        _sprite.userData!["score"] = 200
        _sprite.fillColor = SKColor.whiteColor()
        _sprite.strokeColor = SKColor.blackColor()
        _sprite.name = "enemy"
        _sprite.zPosition = 100
        
        _sprite.position =
            CGPointMake(CGFloat(arc4random_uniform(UInt32(CGRectGetMaxX(_frame))-100)), CGRectGetMaxY(_frame)+10)
        
        let _moveDown = SKAction.moveToY(CGFloat(CGRectGetMaxY(_frame)) / 4, duration: 5)
        _sprite.runAction(
            SKAction.sequence([
                SKAction.moveToY(10, duration: 5),
                SKAction.repeatActionForever(
                    SKAction.sequence([
                        SKAction.waitForDuration(1),
                        SKAction.runBlock({
                            EnemyFactory.initNoDestroyEnemySprite2(scene, position: _sprite.frame.origin)
                        })
                        ])
                )
                ])
        )
        
        scene.addChild(_sprite)
    }
    
    // まる３つ
    class func initEnemySprite10(scene:SKScene) {
        
        let _frame = scene.frame
        
        //
        let _spriteCircle = SKShapeNode(circleOfRadius: 20)
        _spriteCircle.fillColor = SKColor.whiteColor()
        _spriteCircle.strokeColor = SKColor.blackColor()
        let _spriteCircle2 = _spriteCircle.copy() as SKShapeNode
        let _spriteCircle3 = _spriteCircle.copy() as SKShapeNode
        
        let _sprite = SKSpriteNode()
        _spriteCircle.position = CGPointMake(0, 0)
        _sprite.addChild(_spriteCircle)
        _spriteCircle2.position = CGPointMake(40, 0)
        _sprite.addChild(_spriteCircle2)
        _spriteCircle3.position = CGPointMake(80, 0)
        _sprite.addChild(_spriteCircle3)
        
        _sprite.userData = [:]
        _sprite.userData!["hp"] = 6
        _sprite.userData!["ap"] = 25
        _sprite.userData!["score"] = 100
        _sprite.name = "enemy"
        _sprite.zPosition = 100
        
        _sprite.position =
            CGPointMake(CGFloat(arc4random_uniform(UInt32(CGRectGetMaxX(_frame))-100)), CGRectGetMaxY(_frame)+10)
        
        
        var x1:CGFloat = 0
        var x2:CGFloat = CGRectGetMaxX(_frame) - 80
        if arc4random_uniform(2) == 0 {
            x1 = x2
            x2 = 0
        }
        
        _sprite.runAction(
            SKAction.group([
                SKAction.sequence([
                    SKAction.moveToY(-20, duration: 2),
                    SKAction.removeFromParent()
                    ]),
                SKAction.repeatActionForever(
                    SKAction.sequence([
                        SKAction.moveToX(x1, duration: 0.5),
                        SKAction.moveToX(x2, duration: 0.5)
                        ])
                )
                ])
        );
        scene.addChild(_sprite)
    }
    
    
    // 5こ
    class func initEnemySprite11(scene:SKScene) {
        
        let _frame = scene.frame
        
        let _path = UIBezierPath()
        _path.moveToPoint(CGPointMake(0, 40))
        _path.addLineToPoint(CGPointMake(20, 0))
        _path.addLineToPoint(CGPointMake(40, 40))
        _path.addLineToPoint(CGPointMake(20, 20))
        _path.closePath()
        
        //
        let _sprite = SKShapeNode(path: _path.CGPath)
        _sprite.fillColor = SKColor.whiteColor()
        _sprite.strokeColor = SKColor.blackColor()
        _sprite.userData = [:]
        _sprite.userData!["hp"] = 2
        _sprite.userData!["ap"] = 25
        _sprite.userData!["score"] = 100
        _sprite.name = "enemy"
        _sprite.zPosition = 100
        
        let _move = SKAction.sequence([
            SKAction.moveByX(0, y: CGRectGetMaxY(_frame) * -2, duration:3),
            SKAction.removeFromParent()
            ]);
        
        var _x =
        CGFloat(arc4random_uniform(UInt32(CGRectGetMaxX(_frame))-100))
        
        let _ymap:[CGFloat] = [0, -40, -80, -40, 0]
        let _baseY = CGRectGetMaxY(_frame) + 40 * 3
        
        for _y in _ymap {
            let _spriteCopy = _sprite.copy() as SKShapeNode
            _spriteCopy.position = CGPointMake(_x, _baseY + _y)
            _x += 40
            _spriteCopy.runAction(_move)
            scene.addChild(_spriteCopy)
        }
        
    }
    
    // ジグザグ
    // 四角
    class func initEnemySprite12(scene:SKScene) {
        
        let _frame = scene.frame
        
        let _path = UIBezierPath()
        _path.moveToPoint(CGPointMake(0, 0))
        _path.addLineToPoint(CGPointMake(40,0))
        _path.addLineToPoint(CGPointMake(40,40))
        _path.addLineToPoint(CGPointMake(0,40))
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
        
        var _xx:CGFloat = 1
        if _sprite.position.x > CGRectGetMaxX(_frame) {
            _xx = -1
        }
        
        var _yy = CGFloat(CGRectGetMaxY(_frame)) / 8
        
        var _actions:[SKAction] = []
        
        for _ in 0..<10 {
            _actions.append(SKAction.moveByX(0, y: -1 * _yy, duration: 0.5))
            _actions.append(SKAction.moveByX(_xx * 200, y: 0, duration: 0.5))
            _xx *= -1
        }
        
        _sprite.runAction(SKAction.sequence([
            SKAction.sequence(_actions),
            SKAction.removeFromParent()
            ]))
        
        
        scene.addChild(_sprite)
    }
    
    // 急に方向転換
    class func initEnemySprite13(scene:SKScene) {
        
        let _frame = scene.frame
        
        let _path = UIBezierPath()
        _path.moveToPoint(CGPointMake(0, 0))
        _path.addLineToPoint(CGPointMake(40,0))
        _path.addLineToPoint(CGPointMake(40,40))
        _path.addLineToPoint(CGPointMake(0,40))
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
        
        
        let _yy = arc4random_uniform(4) + 1
        let _height = CGRectGetMaxY(_frame) * -1
        
        let _actions:[SKAction] = [
            SKAction.moveByX(0, y: -1 * CGFloat(_yy) * 100, duration: Double(_yy) * 0.5),
            SKAction.waitForDuration(0.5),
            SKAction.runBlock({
                if let _player = scene.childNodeWithName("player") {
                    let _xx:CGFloat = (_player.position.x > _sprite.position.x) ? 200 : -200
                    
                    _sprite.runAction(
                        SKAction.sequence([
                            SKAction.moveByX(_xx, y: _height, duration: 0.8),
                            SKAction.removeFromParent()
                            ])
                    )
                } else {
                    _sprite.runAction(
                        SKAction.sequence([
                            SKAction.moveByX(0, y: _height, duration: 0.8),
                            SKAction.removeFromParent()
                            ])
                    )
                }
            })
        ];
        
        _sprite.runAction(
            SKAction.sequence(_actions)
        )
        scene.addChild(_sprite)
    }
    
    // 追ってくる
    class func initEnemySprite14(scene:SKScene) {
        
        let _frame = scene.frame
        
        let _path = UIBezierPath()
        _path.moveToPoint(CGPointMake(0, 0))
        _path.addLineToPoint(CGPointMake(40,0))
        _path.addLineToPoint(CGPointMake(40,40))
        _path.addLineToPoint(CGPointMake(0,40))
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
        
        let _height = CGRectGetMaxY(_frame) * -1
        
        var _move:(()->Void)!
        _move = {
            if _sprite.frame.origin.x < -100 || _sprite.frame.origin.x > CGRectGetMaxX(_frame)+100
                ||  _sprite.frame.origin.y < -100 || _sprite.frame.origin.y > CGRectGetMaxY(_frame)+100 {
                    _sprite.removeFromParent()
                    return
            }
            if let _player = scene.childNodeWithName("player") {
                let _xx:CGFloat = (_player.position.x > _sprite.position.x) ? 200 : -200
                let _yy:CGFloat = (_player.position.y > _sprite.position.y) ? 200 : -200
                _sprite.runAction(
                    SKAction.sequence([
                        SKAction.waitForDuration(0.5),
                        SKAction.moveByX(_xx, y: _yy, duration: 0.8),
                        SKAction.runBlock({_move()})
                        ])
                )
            } else {
            }
        }
        
        _sprite.runAction(
            SKAction.runBlock({_move()})
        )
        scene.addChild(_sprite)
    }
    
    // BOM
    class func initEnemySprite15(scene:SKScene) {
        
        let _frame = scene.frame
        
        let _path = UIBezierPath()
        _path.addArcWithCenter(CGPointMake(0, 0), radius: 50, startAngle: 0, endAngle: CGFloat(M_PI) * 2, clockwise: true)
        _path.moveToPoint(CGPointMake(0, 50))
        _path.addLineToPoint(CGPointMake(0, -50))
        
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
            CGPointMake(CGFloat(arc4random_uniform(UInt32(CGRectGetMaxX(_frame))-100)), CGRectGetMaxY(_frame)+50)
        
        let _yy:CGFloat = CGFloat(arc4random_uniform(UInt32(CGRectGetMidY(_frame))) + 200)
        let _scaleTo = SKAction.scaleBy(20, duration: 1.0)
        _scaleTo.timingMode = .EaseIn
        _sprite.runAction(
            SKAction.sequence([
                SKAction.moveByX(0, y: _yy * -1, duration: Double(_yy) * 0.005),
                SKAction.waitForDuration(0.8),
                _scaleTo
                ])
        )
        
        scene.addChild(_sprite)
    }
    
    // BOM
    class func initEnemySprite16(scene:SKScene) {
        
        let _frame = scene.frame
        
        let _path = UIBezierPath()
        _path.moveToPoint(CGPointMake(0, 0))
        _path.addLineToPoint(CGPointMake(30, 0))
        _path.addLineToPoint(CGPointMake(30, 30))
        _path.addLineToPoint(CGPointMake(0, 30))
        _path.closePath()
        _path.moveToPoint(CGPointMake(10, 0))
        _path.addLineToPoint(CGPointMake(10,30))
        _path.moveToPoint(CGPointMake(20, 0))
        _path.addLineToPoint(CGPointMake(20,30))
        
        
        let _sprite = SKShapeNode(path: _path.CGPath)
        _sprite.userData = [:]
        _sprite.userData!["hp"] = 4
        _sprite.userData!["ap"] = 25
        _sprite.userData!["score"] = 100
        _sprite.fillColor = SKColor.whiteColor()
        _sprite.strokeColor = SKColor.blackColor()
        _sprite.name = "enemy"
        _sprite.zPosition = 100
        
        let _movePath = UIBezierPath()
        _movePath.moveToPoint(CGPointMake(0, 0))
        _movePath.addQuadCurveToPoint(CGPointMake(200, 0), controlPoint: CGPointMake(100, CGRectGetMaxY(_frame) * -2))
        let _action = SKAction.followPath(_movePath.CGPath, asOffset: true, orientToPath: false, duration: 2.0)
        
        let _x = CGFloat(arc4random_uniform(UInt32(CGRectGetMaxX(_frame) - 110)))
        
        var _actions:SKAction!
        if (_x < CGRectGetMidX(_frame)) {
            _actions = SKAction.sequence([
                    _action,
                    SKAction.removeFromParent()
                ])
        } else {
            _actions = SKAction.sequence([
                _action.reversedAction(),
                SKAction.removeFromParent()
                ])
            
        }
        
        for i in 0..<3 {
            
            let _spriteSub = _sprite.copy() as SKNode
            
            _spriteSub.position =
                CGPointMake(_x + CGFloat(i*40), CGRectGetMaxY(_frame)+50)
        
            _spriteSub.runAction(_actions)
            scene.addChild(_spriteSub)
        }
    }


    // 四散
    class func initEnemySprite17(scene:SKScene) {
        
        let _frame = scene.frame
        
        let _path = UIBezierPath()
        _path.moveToPoint(CGPointMake(0, 0))
        _path.addLineToPoint(CGPointMake(40,0))
        _path.addLineToPoint(CGPointMake(40,40))
        _path.addLineToPoint(CGPointMake(0,40))
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
        
        let _x = CGFloat(arc4random_uniform(UInt32(CGRectGetMaxX(_frame))-100))
        let _y = CGRectGetMaxY(_frame) + 50
        let _yy = CGFloat(arc4random_uniform(UInt32(CGRectGetMaxY(_frame))))
        let _w = CGRectGetMaxX(_frame)
        let _duration = Double(1.0 * (_yy / CGRectGetMaxY(_frame)))
        
        // 左下
        let _sprite1 = _sprite.copy() as SKNode
        _sprite1.position = CGPointMake(_x, _y)
        _sprite1.runAction(SKAction.sequence([
                SKAction.moveByX(0, y: -1 * _yy, duration: _duration),
                SKAction.waitForDuration(0.5),
                SKAction.moveByX(-1 * _w, y: -1 * _w, duration: 0.5),
                SKAction.removeFromParent()
            ]))
        scene.addChild(_sprite1)
        
        // 右下
        let _sprite2 = _sprite.copy() as SKNode
        _sprite2.position = CGPointMake(_x + 50, _y)
        _sprite2.runAction(SKAction.sequence([
            SKAction.moveByX(0, y: -1 * _yy, duration: _duration),
            SKAction.waitForDuration(0.5),
            SKAction.moveByX(_w, y: -1 * _w, duration: 0.5),
            SKAction.removeFromParent()
            ]))
        scene.addChild(_sprite2)

        // 左上
        let _sprite3 = _sprite.copy() as SKNode
        _sprite3.position = CGPointMake(_x , _y - 50)
        _sprite3.runAction(SKAction.sequence([
            SKAction.moveByX(0, y: -1 * _yy, duration: _duration),
            SKAction.waitForDuration(0.5),
            SKAction.moveByX(_w * -1, y: _w, duration: 0.5),
            SKAction.removeFromParent()
            ]))
        scene.addChild(_sprite3)
        
        // 右上
        let _sprite4 = _sprite.copy() as SKNode
        _sprite4.position = CGPointMake(_x + 50 , _y - 50)
        _sprite4.runAction(SKAction.sequence([
            SKAction.moveByX(0, y: _yy * -1, duration: _duration),
            SKAction.waitForDuration(0.5),
            SKAction.moveByX(_w , y: _w, duration: 0.5),
            SKAction.removeFromParent()
            ]))
        scene.addChild(_sprite4)

    }
    
    // ランダムに縦横
    class func initEnemySprite18(scene:SKScene) {
        
        let _frame = scene.frame
        
        let _path = UIBezierPath()
        _path.moveToPoint(CGPointMake(0, 0))
        _path.addLineToPoint(CGPointMake(40,0))
        _path.addLineToPoint(CGPointMake(40,40))
        _path.addLineToPoint(CGPointMake(0,40))
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
        
        var _move:(()->Void)!
        _move = {
            if _sprite.frame.origin.x < -100 || _sprite.frame.origin.x > CGRectGetMaxX(_frame)+100
                ||  _sprite.frame.origin.y < -100 || _sprite.frame.origin.y > CGRectGetMaxY(_frame)+100 {
                    _sprite.removeFromParent()
                    return
            }
            
            var _xx:CGFloat = 0
            var _yy:CGFloat = 0
            if arc4random_uniform(2) == 0 {
                _xx  = (arc4random_uniform(2)==0) ? 200 : -200
            } else {
                _yy  = (arc4random_uniform(2)==0) ? 200 : -200
            }
            
            _sprite.runAction(
                SKAction.sequence([
                    SKAction.waitForDuration(0.5),
                    SKAction.moveByX(_xx, y: _yy, duration: 0.4),
                    SKAction.runBlock({_move()})
                    ])
            )
        }
        
        _sprite.runAction(
            SKAction.sequence([
                SKAction.moveByX(0, y: -400, duration: 0.2),
                SKAction.runBlock({_move()})
                ])
        )
        scene.addChild(_sprite)
    }

    // 横から出てくる
    class func initEnemySprite19(scene:SKScene) {
        
        let _frame = scene.frame
        
        let _sprite = SKShapeNode(ellipseOfSize: CGSizeMake(80,40))
        _sprite.userData = [:]
        _sprite.userData!["hp"] = 2
        _sprite.userData!["ap"] = 25
        _sprite.userData!["score"] = 100
        _sprite.fillColor = SKColor.whiteColor()
        _sprite.strokeColor = SKColor.blackColor()
        _sprite.name = "enemy"
        _sprite.zPosition = 100
        
        let _x = (arc4random_uniform(2)==0) ? -80 : CGRectGetMaxX(_frame) + 80
        let _y = CGFloat(arc4random_uniform(UInt32(CGRectGetMaxX(_frame))))
        
        _sprite.position = CGPointMake(_x, _y)
        
        
        if _x > 0 {
            _sprite.runAction(SKAction.sequence([
                SKAction.moveByX(CGRectGetMaxX(_frame) * -1.5, y:0, duration: 2.0),
                SKAction.removeFromParent()
                ])
            )
        } else {
            _sprite.runAction(SKAction.sequence([
                SKAction.moveByX(CGRectGetMaxX(_frame) * 1.5, y:0, duration: 2.0),
                SKAction.removeFromParent()
                ])
            )
        }
        
        scene.addChild(_sprite)
    }
    
    // 上からたくさん
    class func initEnemySprite20(scene:SKScene) {
        
        let _frame = scene.frame
        let _w = CGRectGetMaxX(_frame) / 10
        
        let _path = UIBezierPath()
        _path.moveToPoint(CGPointMake(0, 0))
        _path.addLineToPoint(CGPointMake(_w,0))
        _path.addLineToPoint(CGPointMake(_w,40))
        _path.addLineToPoint(CGPointMake(0,40))
        _path.closePath()
        
        let _sprite = SKShapeNode(path: _path.CGPath)
        _sprite.userData = [:]
        _sprite.userData!["hp"] = 1
        _sprite.userData!["ap"] = 25
        _sprite.userData!["score"] = 100
        _sprite.fillColor = SKColor.whiteColor()
        _sprite.strokeColor = SKColor.blackColor()
        _sprite.name = "enemy"
        _sprite.zPosition = 100
        
        let _yy = CGFloat(arc4random_uniform(UInt32(CGRectGetMaxX(_frame)) - 100))
        let _duration = Double(1.0 * _yy / CGRectGetMaxY(_frame))
        
        for i in 0..<10 {
            let _spriteSub = _sprite.copy() as SKNode
            _spriteSub.position = CGPointMake(CGFloat(i) * _w, CGRectGetMaxY(_frame)-40)
            _spriteSub.runAction(SKAction.sequence([
                    SKAction.moveByX(0, y: _yy * -1, duration: _duration),
                    SKAction.waitForDuration(Double(arc4random_uniform(10)+1) * 0.25),
                    SKAction.moveByX(0, y: CGRectGetMaxY(_frame) * -1.5, duration: 2),
                    SKAction.removeFromParent()
                ]))
            scene.addChild(_spriteSub)
        }
    }

    
}