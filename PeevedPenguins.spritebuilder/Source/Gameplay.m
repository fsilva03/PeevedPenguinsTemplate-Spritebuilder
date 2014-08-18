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
    

}

// called everytime there is a touch
-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    [self launchPenguin];
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
