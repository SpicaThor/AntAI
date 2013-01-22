//
//  main.m
//  AntAI
//
//  Created by Ariel Tkachenko on 1/19/13.
//  Copyright (c) 2013 Thor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyBot.h"

int main(int argc, const char * argv[])
{
    
    @autoreleasepool {
        NSString* line = @"";
        MyBot* bot = [MyBot new];
        
        char character[2]; //for two byte characters
        int nChars;
        while ((nChars = scanf("%1c", character)) >= 0) {
            NSString* text = [NSString stringWithCString:character encoding:NSASCIIStringEncoding];
            NSRange returnRange = [text rangeOfString:@"\n"];
            NSRange returnRange1 = [text rangeOfString:@"\r"];
            if((returnRange.location != NSNotFound)||(returnRange1.location != NSNotFound)){
                [bot processLine:line];
                line = @"";
            }else{
                line = [line stringByAppendingString:text];
            }
        }
    }
    return 0;
}

