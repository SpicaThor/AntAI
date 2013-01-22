//
//  Tile.m
//  AntAI
//
//  Created by Ariel Tkachenko on 1/20/13.
//  Copyright (c) 2013 Thor. All rights reserved.
//

#import "Tile.h"
#import "Ants.h"

@interface Tile ()

@property(nonatomic, assign)int   row;
@property(nonatomic, assign)int   col;

@end

@implementation Tile

-(id)initWithRow:(int)row col:(int)col{
    self = [super init];
    if(self){
        self.row = row;
        self.col = col;
        self.visible = NO;
        self.ilk = LAND;
    }
    return self;
}

-(NSString*)toString{
    return [NSString stringWithFormat:@"%d %d",self.row,self.col];
}

-(BOOL)isEqual:(id)object{
    if([object isKindOfClass:[self class]]){
        Tile* other = (Tile*)object;
        return (self.row == other.row)&&(self.col == other.col);
    }
    return NO;
}

-(NSUInteger)hash{
    return self.row * [Ants MAX_MAP_SIZE] + self.col;
}


-(BOOL)isPassable{
    return self.ilk > WATER;
}

-(BOOL)isUnoccupied{
    return self.ilk == LAND || self.ilk == MY_DEAD || self.ilk == ENEMY_DEAD;
}

@end
