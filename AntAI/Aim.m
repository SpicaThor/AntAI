//
//  Aim.m
//  AntAI
//
//  Created by Ariel Tkachenko on 1/20/13.
//  Copyright (c) 2013 Thor. All rights reserved.
//

#import "Aim.h"

static NSDictionary* possibleAims = nil;
static Aim* north = nil;
static Aim* east = nil;
static Aim* south = nil;
static Aim* west = nil;

@interface Aim ()

@property(nonatomic,assign)int     rowDelta;
@property(nonatomic,assign)int     colDelta;
@property(nonatomic,copy)NSString*  symbol;

-(id)initWithRowDelta:(int)rowDelta colDelta:(int)colDelta symbol:(NSString*)symbol;

@end


@implementation Aim

+(void)initialize{
    north = [[self alloc]initWithRowDelta:-1 colDelta:0 symbol:@"n"];
    east =  [[self alloc]initWithRowDelta:0 colDelta:1 symbol:@"e"];
    south = [[self alloc]initWithRowDelta:1 colDelta:0 symbol:@"s"];
    west =  [[self alloc]initWithRowDelta:0 colDelta:-1 symbol:@"w"];
    NSMutableDictionary* data = [NSMutableDictionary dictionaryWithCapacity:4];
    [data setObject:north forKey:@"n"];//North
    [data setObject:east forKey:@"e"];//East
    [data setObject:south forKey:@"s"];//South
    [data setObject:west forKey:@"w"];//West
    possibleAims = data;
}

+(Aim*)north{
    return north;
}

+(Aim*)east{
    return east;
}

+(Aim*)south{
    return south;
}

+(Aim*)west{
    return west;
}

-(id)init{
    NSAssert(NO, @"Please use designated initialiser");
    return nil;
}

-(id)initWithRowDelta:(int)rowDelta colDelta:(int)colDelta symbol:(NSString*)symbol{
    self = [super init];
    if(self){
        self.rowDelta = rowDelta;
        self.colDelta = colDelta;
        self.symbol = symbol;
    }
    return self;
}

+(Aim*)getRandom{
    NSArray* possibleAims = [self possibleAims];
    int index = arc4random_uniform((int)possibleAims.count - 1);
    return [possibleAims objectAtIndex:index];
}

+(Aim*)fromString:(NSString*)symbol{
    return [possibleAims objectForKey:symbol];
}

+(NSArray*)possibleAims{
    return possibleAims.allValues;
}

@end
