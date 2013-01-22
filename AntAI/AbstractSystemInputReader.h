//
//  AbstractSystemInputReader.h
//  Ant
//
//  Created by Ariel Tkachenko on 1/11/13.
//  Copyright (c) 2013 Thor. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AbstractSystemInputReader : NSObject

-(void)processLine:(NSString*)line;

@end
