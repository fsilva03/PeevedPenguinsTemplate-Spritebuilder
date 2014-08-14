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
}


// called when the CCB file loads completely
-(void)didLoadFromCCB {
    // tells screen to accept touches from Client
    self.userInteractionEnabled = YES;

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
    
}








@end
