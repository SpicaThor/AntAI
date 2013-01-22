//
//  Ants.h
//  AntAI
//
//  Created by Ariel Tkachenko on 1/20/13.
//  Copyright (c) 2013 Thor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tile.h"
#import "Aim.h"

@interface Ants : NSObject

@property(nonatomic, assign, readonly)int       loadTime;
@property(nonatomic, assign, readonly)int       turnTime;
@property(nonatomic, assign, readonly)int       rows;
@property(nonatomic, assign, readonly)int       cols;
@property(nonatomic, assign, readonly)int       turns;
@property(nonatomic, assign, readonly)int       viewRadius;
@property(nonatomic, assign, readonly)int       attackRadius;
@property(nonatomic, assign, readonly)int       spawnRadius;
@property(nonatomic, strong, readonly)NSMutableSet*    visionOffsets;
@property(nonatomic, assign)long      turnStartTime;
@property(nonatomic, assign, readonly)int       turnRemainingTime;
@property(nonatomic, strong, readonly)NSArray*  map;
@property(nonatomic, strong, readonly)NSMutableSet*    myAnts;
@property(nonatomic, strong, readonly)NSMutableSet*    enemyAnts;
@property(nonatomic, strong, readonly)NSMutableSet*    myHills;
@property(nonatomic, strong, readonly)NSMutableSet*    enemyHills;
@property(nonatomic, strong, readonly)NSMutableSet*    foodTiles;
@property(nonatomic, strong, readonly)NSMutableSet*    orders;
@property(nonatomic, strong, readonly)NSMutableSet*    employed;

+(NSInteger)MAX_MAP_SIZE;

-(id)initWithLoadTime:(int)loadTime turnTime:(int)turnTime rows:(int)rows cols:(int)cols turns:(int)turns viewRadius:(int)viewRadius attackRadius:(int)attackRadius spawnRadius:(int)spawnRadius;

-(Tile*)getTileForTile:(Tile*)tile direction:(Aim*)direction;
-(Tile*)getTileForTile:(Tile*)tile andOffsetTile:(Tile*)offset;
-(int)getDistanceBetweenTile:(Tile*)t1 andTile:(Tile*)t2;
-(NSArray*)getDirectionsBetweenTile:(Tile*)t1 andTile:(Tile*)t2;
-(void)clearMyAnts;
-(void)clearEnemyAnts;
-(void)clearFood;
-(void)clearMyHills;
-(void)clearEnemyHills;
-(void)clearDeadAnts;
-(void)clearVision;
-(void)setVision;
-(void)updateTile:(Tile*)tile withIlk:(Ilk)ilk;
-(void)updateHillsForTile:(Tile*)tile ownerId:(int)ownerId;
-(void)issueOrderForTile:(Tile*)myAnt direction:(Aim*)direction;

@end
