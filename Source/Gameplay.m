//
//  Gameplay.m
//  VikingSurvival
//
//  Created by sethai on 12.05.2014.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gameplay.h"

@implementation Gameplay {
    CCSprite *_hero;
    int direction;
}
-(void)didLoadFromCCB{
    direction = 0;
}

-(void)btnUp{
    CCLOG(@"skok");
    [_hero.physicsBody applyImpulse:ccp(0,1600.f)];
}
-(void)btnDown{
    CCLOG(@"unik");
}
-(void)btnRight{
    CCLOG(@"rzut");
}
-(void)btnLeft{
    CCLOG(@"tarcza");
}
@end
