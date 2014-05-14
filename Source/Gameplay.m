//
//  Gameplay.m
//  VikingSurvival
//
//  Created by sethai on 12.05.2014.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gameplay.h"
#import "constants.h"

@implementation Gameplay {
    CCSprite *_hero;
    CCNode *_cloud1;
    CCNode *_cloud2;
    CCNode *_cloud3;
    CCNode *_cloud4;
    CCNode *_cloud5;
    CCNode *_btnUp;
    CCNode *_btnDown;
    CCNode *_btnLeft;
    CCNode *_btnRight;
    CCNode *_axe;
    CCNode *_ground;
    CCLabelTTF *_scoreLabel;
    NSArray *_cloudsSlow;
    NSArray *_cloudsFast;
    NSArray *_allClouds;
    CCPhysicsNode *_physicsNode;
    CCNode *_clouds;
    NSInteger _screenWidth;
    NSInteger gamePoints;
    BOOL isThrowing;
    BOOL isJumping;
    OALSimpleAudio *audio;
    
}

-(id)init{
    if(self = [super init]){
        self.userInteractionEnabled = TRUE;
        audio = [OALSimpleAudio sharedInstance];
        [audio preloadEffect:@"hatchet.mp3"];
        gamePoints = 0;
        isThrowing = FALSE;
        isJumping = FALSE;
    }
    return self;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)_hero ground:(CCNode *)_ground{
    CCLOG(@"landing");
    isJumping = FALSE;
    return TRUE;
}
-(void)didLoadFromCCB{
    _cloudsSlow =@[_cloud1, _cloud2];
    _cloudsFast =@[_cloud3, _cloud4, _cloud5];
    _allClouds = @[_cloud1, _cloud2,_cloud3, _cloud4, _cloud5];
    _screenWidth = _cloud1.contentSize.width;
    _physicsNode.collisionDelegate = self;
    [_hero.physicsBody setCollisionType:@"hero"];
    [_ground.physicsBody setCollisionType:@"ground"];
}

-(void)update:(CCTime)delta{
    if(_axe.position.x>_screenWidth){
        isThrowing = FALSE;
        [_axe removeFromParentAndCleanup:TRUE];
        _axe = nil;
    }
    for(CCNode *cloud in _cloudsSlow){
        cloud.position = ccp(cloud.position.x-(delta*scrollSpeedSlow), cloud.position.y);
    }
    for(CCNode *cloud in _cloudsFast){
        cloud.position = ccp(cloud.position.x-(delta*scrollSpeedFast), cloud.position.y);
    }
    for(CCNode *cloud in _allClouds){
        CGPoint cloudWorldPosition = [_clouds convertToWorldSpace:cloud.position];
        CGPoint cloudScreenPosition = [self convertToNodeSpace:cloudWorldPosition];
        if(cloudScreenPosition.x <= (-1*cloud.contentSize.width)){
            cloud.position = ccp(cloud.position.x+cloud.contentSize.width+_screenWidth, cloud.position.y);
        }
    }
}

-(void) touchBegan: (UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchLocation = [touch locationInNode: self];
    if (CGRectContainsPoint([_btnUp boundingBox], touchLocation)){
        [self jump];
    }
    if (CGRectContainsPoint([_btnRight boundingBox], touchLocation)){
        [self launchAxe];
    }
    if (CGRectContainsPoint([_btnLeft boundingBox], touchLocation)){
        CCLOG(@"tarcza");
    }
    if (CGRectContainsPoint([_btnDown boundingBox], touchLocation)){
        CCLOG(@"unik");
    }
}

-(void) jump{
    isJumping = TRUE;
    [_hero.physicsBody applyImpulse:ccp(0,1600.f)];
}
-(void) launchAxe{
    if(!isThrowing && !isJumping){
        gamePoints++;
        _scoreLabel.string = [NSString stringWithFormat:@"%ld", (long)gamePoints];
        isThrowing = TRUE;
        _axe = [CCBReader load:@"axe"];
        _axe.position = ccpAdd(_hero.position, ccp(10,5));
        [_physicsNode addChild:_axe];
        CGPoint launchDirection = ccp(8,5);
        CGPoint force=ccpMult(launchDirection, 1500);
        _axe.physicsBody.allowsRotation = TRUE;
        [audio playEffect:@"hatchet.mp3"];
        [_axe.physicsBody applyForce:force];
        [_axe.physicsBody applyAngularImpulse:-3000.f];
    }
}
@end
