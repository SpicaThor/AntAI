//
//  Order.m
//  AntAI
//
//  Created by Ariel Tkachenko on 1/20/13.
//  Copyright (c) 2013 Thor. All rights reserved.
//

#import "Order.h"
#import "Tile.h"
#import "Aim.h"

@interface Order ()

@property(nonatomic, strong)Aim* aim;
@property(nonatomic, strong)Tile* tile;

@end

@implementation Order

-(id)init{
    NSAssert(NO, @"Please use designated initialiser");
    return nil;
}

-(id)initWithTile:(Tile*)tile andAim:(Aim*)aim{
    self = [super init];
    if(self){
        self.aim = aim;
        self.tile = tile;
    }
    return self;
}

-(NSString*)toString{
    return [NSString stringWithFormat:@"o %d %d %@",self.tile.row,self.tile.col,self.aim.symbol];
}

-(void)issue{
    Log(@"%@",[self toString]);
    printf("%s\n",[self toString].UTF8String);
    fflush(stdout);
}

@end
