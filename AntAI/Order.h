//
//  Order.h
//  AntAI
//
//  Created by Ariel Tkachenko on 1/20/13.
//  Copyright (c) 2013 Thor. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Aim;
@class Tile;

@interface Order : NSObject

-(id)initWithTile:(Tile*)tile andAim:(Aim*)aim;
-(NSString*)toString;
-(void)issue;

@end
