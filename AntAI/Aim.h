//
//  Aim.h
//  AntAI
//
//  Created by Ariel Tkachenko on 1/20/13.
//  Copyright (c) 2013 Thor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Aim : NSObject

@property(nonatomic,assign,readonly)int     rowDelta;
@property(nonatomic,assign,readonly)int     colDelta;
@property(nonatomic,copy,readonly)NSString*  symbol;

+(Aim*)getRandom;
+(Aim*)fromString:(NSString*)symbol;
+(NSArray*)possibleAims;

+(Aim*)north;
+(Aim*)east;
+(Aim*)south;
+(Aim*)west;

@end
