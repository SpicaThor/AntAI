//
//  NSString+AI.m
//  Ant
//
//  Created by Ariel Tkachenko on 1/11/13.
//  Copyright (c) 2013 Thor. All rights reserved.
//

#import "NSString+AI.h"

#define kCommentChar    @"#"

@implementation NSString (AI)

-(NSString*)stringStrippedFromComments{
    NSRange range = [self rangeOfString:kCommentChar];
    if(range.location == NSNotFound){
        return self;
    }else{
        return [self substringFromIndex:range.location];
    }
}

@end
