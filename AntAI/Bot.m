//
//  Bot.m
//  AntAI
//
//  Created by Ariel Tkachenko on 1/22/13.
//  Copyright (c) 2013 Thor. All rights reserved.
//

#import "Bot.h"
#import "Ants.h"

@interface Bot()

@property(nonatomic,strong)Ants* ants;

@end


@implementation Bot

-(void)setupLoadTime:(NSInteger)loadTime turnTime:(NSInteger)turnTime rows:(NSInteger)rows cols:(NSInteger)cols turns:(NSInteger)turns viewRadius:(NSInteger)viewRadius attackRadius:(NSInteger)attackRadius spawnRadius:(NSInteger)spawnRadius{
    self.ants = [[Ants alloc]initWithLoadTime:loadTime turnTime:turnTime rows:rows cols:cols turns:turns viewRadius:viewRadius attackRadius:attackRadius spawnRadius:spawnRadius];
}


-(void)beforeUpdate{
    Ants* ants = self.ants;
    NSDate* now = [NSDate date];
    
    ants.turnStartTime = [now timeIntervalSince1970];
    [ants clearMyAnts];
    [ants clearEnemyAnts];
    [ants clearMyHills];
    [ants clearEnemyHills];
    [ants clearFood];
    [ants clearDeadAnts];
    [ants.orders removeAllObjects];
    [ants clearVision];
}

-(void)afterUpdate{
    [self.ants setVision];
}

-(void)addWaterTo:(CGPoint)place{
    LogEnter();
    Tile* tile = [[Tile alloc] initWithRow:place.y col:place.x];
    [self.ants updateTile:tile withIlk:WATER];
}

-(void)addAntTo:(CGPoint)place byUser:(int)userId{
    LogEnter();
    Tile* tile = [[Tile alloc] initWithRow:place.y col:place.x];
    [self.ants updateTile:tile withIlk:userId>0?ENEMY_ANT:MY_ANT];
}

-(void)addFoodTo:(CGPoint)place{
    LogEnter();
    Tile* tile = [[Tile alloc] initWithRow:place.y col:place.x];
    [self.ants updateTile:tile withIlk:FOOD];
}

-(void)removeAntFrom:(CGPoint)place byUser:(int)userId{
    LogEnter();
    Tile* tile = [[Tile alloc] initWithRow:place.y col:place.x];
    [self.ants updateTile:tile withIlk:userId>0?ENEMY_DEAD:MY_DEAD];
}

-(void)addHillTo:(CGPoint)place byUser:(int)userId{
    LogEnter();
    Tile* tile = [[Tile alloc] initWithRow:place.y col:place.x];
    [self.ants updateHillsForTile:tile ownerId:userId];
}

@end
