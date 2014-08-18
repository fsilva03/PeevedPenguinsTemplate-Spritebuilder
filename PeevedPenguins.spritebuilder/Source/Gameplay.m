//
//  Gameplay.m
//  PeevedPenguins
//
//  Created by Federico Silva on 8/14/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gameplay.h"

@implementation Gameplay {
    CCPhysicsNode *_physicsNode;
    CCNode *_catapultArm;
    CCNode *_levelNode;
    CCNode *_contentNode;
    CCNode *_pullbackNode;
    CCNode *_mouseJointNode;
    CCPhysicsJoint *_mouseJoint;
    CCNode *_currentPenguin;
    CCPhysicsJoint *_penguinCatapultJoint;
}


// called when the CCB file loads completely
-(void)didLoadFromCCB {
    // tells screen to accept touches from Client
    self.userInteractionEnabled = YES;
    
    //mechanism that loads the levels
    CCScene *level = [CCBReader loadAsScene:@"Levels/Level1"];
    [_levelNode addChild:level];
    
    // to visualize the physics bodies & joints
    _physicsNode.debugDraw = TRUE;
    
    _pullbackNode.physicsBody.collisionMask = @[];
    

}

// called everytime there is a touch
-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [touch locationInNode:_contentNode];
    
    // start catapult dragging when a touch on the catapult is sensed
    if (CGRectContainsPoint([_catapultArm boundingBox], touchLocation)){
        
        // move catapult to touch location
        _mouseJointNode.position = touchLocation;
        
        // creates the joint
        _mouseJoint = [CCPhysicsJoint connectedSpringJointWithBodyA:_mouseJointNode.physicsBody bodyB:_catapultArm.physicsBody anchorA:ccp(0, 0) anchorB:ccp(34, 138) restLength:0.f stiffness:3000.f damping:150.f];
        
        //load penguin
        _currentPenguin = [CCBReader load:@"Penguin"];
        CGPoint penguinPosition = [_catapultArm convertToWorldSpace:ccp(34, 138)];
        _currentPenguin.position = [_physicsNode convertToNodeSpace:penguinPosition];
        [_physicsNode addChild:_currentPenguin];
        _currentPenguin.physicsBody.allowsRotation = false;
        _penguinCatapultJoint = [CCPhysicsJoint connectedPivotJointWithBodyA:_currentPenguin.physicsBody bodyB:_catapultArm.physicsBody anchorA:_currentPenguin.anchorPointInPoints];
        
    }
}

// these two methods cover the catapult moving
-(void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    //whenever the touch moves, update the position of the mouseJointNode
    CGPoint touchLocation = [ touch locationInNode:_contentNode];
    _mouseJointNode.position = touchLocation;
    
}


-(void) touchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    [self releaseCatapult];
}
-(void) touchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {
    //this applies to when the touch comes off the screen (cancelled)
    [self releaseCatapult];
}
-(void)releaseCatapult {
    if(_mouseJoint != nil) {
        //releases catapult and it snaps backs
        [_mouseJoint invalidate];
        _mouseJoint = nil;
    }
    
    [_penguinCatapultJoint invalidate];
    _penguinCatapultJoint = nil;
    
    _currentPenguin.physicsBody.allowsRotation = TRUE;
    CCActionFollow *follow = [CCActionFollow actionWithTarget:_currentPenguin worldBoundary:self.boundingBox];
    [_contentNode runAction:follow];
}


-(void)launchPenguin {
    
    //loads penguin
    CCNode* penguin = [CCBReader load:@"Penguin"];
    
    //positions the penguin at catapult bowl
    penguin.position = ccpAdd(_catapultArm.position, ccp(16, 50));
    
    // add the penguin to the physics node
    [_physicsNode addChild:penguin];
    
    // create & apply force to launch the penguin
    CGPoint launchDirection = ccp(1, 0);
    CGPoint force = ccpMult(launchDirection, 8000);
    [penguin.physicsBody applyForce:force];
    
    // camera that follows the penguin node
    self.position = ccp(0, 0);
    CCActionFollow *follow = [CCActionFollow actionWithTarget:penguin worldBoundary:self.boundingBox];
    [_contentNode runAction:follow];
    
}

-(void)retry {
    // to reload level after clicking "Retry" button on gameplay
    [[CCDirector sharedDirector] replaceScene: [CCBReader loadAsScene:@"Gameplay"]];
}










@end
