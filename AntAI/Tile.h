//
//  Tile.h
//  AntAI
//
//  Created by Ariel Tkachenko on 1/20/13.
//  Copyright (c) 2013 Thor. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    WATER,
    FOOD,
    LAND,
    MY_DEAD,
    ENEMY_DEAD,
    MY_ANT,
    ENEMY_ANT
}Ilk;

@interface Tile : NSObject

@property(nonatomic, assign, readonly)int   row;
@property(nonatomic, assign, readonly)int   col;
@property(nonatomic, assign)BOOL  visible;
@property(nonatomic, assign)Ilk   ilk;

-(id)initWithRow:(int)row col:(int)col;

-(NSString*)toString;
-(BOOL)isPassable;
-(BOOL)isUnoccupied;

@end
