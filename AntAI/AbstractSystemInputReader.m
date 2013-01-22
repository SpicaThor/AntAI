//
//  AbstractSystemInputReader.m
//  Ant
//
//  Created by Ariel Tkachenko on 1/11/13.
//  Copyright (c) 2013 Thor. All rights reserved.
//

#import "AbstractSystemInputReader.h"
#import "NSString+AI.h"

NSString* const kReady          = @"ready";
NSString* const kGo             = @"go";
NSString* const kCommentChar    = @"#";

static NSArray*  kUpdateSet;
static NSArray*  kSetupSet;

@interface AbstractSystemInputReader ()

@property(nonatomic, strong)NSMutableArray* input;

//-(void)beforeUpdate;
//-(void)afterUpdate;
//-(void)addWater:(CGPoint)place;

@end

@implementation AbstractSystemInputReader

#pragma mark - Globals methods

+(void)initialize{
    kUpdateSet = [[NSArray alloc] initWithObjects:@"W",@"A",@"F",@"D",@"H", nil];
    kSetupSet = [[NSArray alloc] initWithObjects:@"LOADTIME", @"TURNTIME", @"ROWS", @"COLS", @"TURNS", @"VIEWRADIUS2", @"ATTACKRADIUS2", @"SPAWNRADIUS2", nil];
}

-(id)init{
    self = [super init];
    if(self){
        self.input = [NSMutableArray new];
    }
    return self;
}

-(void)processLine:(NSString*)line{
    Log(@"%@",line);
    if([line isEqualToString:kReady]){
        [self parseSetup:self.input];
        [self doTurn];
        [self finishTurn];
        [self.input removeAllObjects];
    }else{
        if([line isEqualToString:kGo]){
            [self parseUpdate:self.input];
            [self doTurn];
            [self finishTurn];
            [self.input removeAllObjects];
        }else{
            if (line.length > 0){
                [self.input addObject:line];
            }
        }
    }
}

-(void)parseSetup:(NSArray*)input{
    NSInteger loadTime = 0;
    NSInteger turnTime = 0;
    NSInteger rows = 0;
    NSInteger cols = 0;
    NSInteger turns = 0;
    NSInteger viewRadius = 0;
    NSInteger attackRadius = 0;
    NSInteger spawnRadius = 0;
    for(NSString* line in input){
        NSString* strippedLine = [[line stringStrippedFromComments] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if(strippedLine.length == 0){
            continue;
        }
        NSScanner* scanner = [NSScanner scannerWithString:strippedLine];
        if([scanner isAtEnd] == NO){
            NSCharacterSet* separators = [NSCharacterSet whitespaceAndNewlineCharacterSet];
            NSString* command;
            BOOL scanned = [scanner scanUpToCharactersFromSet:separators intoString:&command];
            if(scanned){
                NSInteger index = [kSetupSet indexOfObject:[command uppercaseString]];
                if(index == NSNotFound){
                    continue;
                }
                switch (index) {
                    case 0:{ // => LOADTIME
                        [scanner scanInteger:&loadTime];
                        break;
                    }
                    case 1:{ // => TURNTIME
                        [scanner scanInteger:&turnTime];
                        break;
                    }
                    case 2:{ // => ROWS
                        [scanner scanInteger:&rows];
                        break;
                    }
                    case 3:{ // => COLS
                        [scanner scanInteger:&cols];
                        break;
                    }
                    case 4:{ // => TURNS
                        [scanner scanInteger:&turns];
                        break;
                    }
                    case 5:{ // => VIEWRADIUS2
                        [scanner scanInteger:&viewRadius];
                        break;
                    }
                    case 6:{ // => ATTACKRADIUS2
                        [scanner scanInteger:&attackRadius];
                        break;
                    }
                    case 7:{ // => SPAWNRADIUS2
                        [scanner scanInteger:&spawnRadius];
                        break;
                    }
                    default:
                        break;
                }
                
            }
        }
    }
    [self setupLoadTime:loadTime turnTime:turnTime rows:rows cols:cols turns:turns viewRadius:viewRadius attackRadius:attackRadius spawnRadius:spawnRadius];
}

-(void)setupLoadTime:(NSInteger)loadTime turnTime:(NSInteger)turnTime rows:(NSInteger)rows cols:(NSInteger)cols turns:(NSInteger)turns viewRadius:(NSInteger)viewRadius attackRadius:(NSInteger)attackRadius spawnRadius:(NSInteger)spawnRadius{
        //abstract => to implement in subclasses
}

-(void)doTurn{
    //abstract => to implement in subclasses
}

-(void)finishTurn{
//    fprintf(stdout, "%s","go");
    printf("go\n");
    fflush(stdout);
//    NSLog(@"go");
}

-(void)parseUpdate:(NSArray*)input{
    [self beforeUpdate];
    for(NSString* line in input){
        NSString* strippedLine = [[line stringStrippedFromComments] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if(strippedLine.length == 0){
            continue;
        }
        
        NSScanner* scanner = [NSScanner scannerWithString:strippedLine];
        NSCharacterSet* separators = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString* command;
        NSInteger col;
        NSInteger row;
        NSInteger userId;
        
        if([scanner isAtEnd] == NO){
            BOOL scanned = [scanner scanUpToCharactersFromSet:separators intoString:&command];
            if(scanned){
                NSInteger index = [kUpdateSet indexOfObject:[command uppercaseString]];
                if(index == NSNotFound){
                    continue;
                }
                scanned &= [scanner scanInteger:&col];
                scanned &= [scanner scanInteger:&row];
                if(scanned){
                    CGPoint place = CGPointMake(row, col);
                    switch (index) {
                        case 0:{ // W =>
                            [self addWaterTo:place];
                            break;
                        }
                        case 1:{ // A =>
                            scanned &= [scanner scanInteger:&userId];
                            if(scanned){
                                [self addAntTo:place byUser:userId];
                            }
                            break;
                        }
                        case 2:{ // F =>
                            [self addFoodTo:place];
                            break;
                        }
                        case 3:{ // D =>
                            scanned &= [scanner scanInteger:&userId];
                            if(scanned){
                                [self removeAntFrom:place byUser:userId];
                            }
                            break;
                        }
                        case 4:{ // H =>
                            scanned &= [scanner scanInteger:&userId];
                            if(scanned){
                                [self addHillTo:place byUser:userId];
                            }
                            break;
                        }
                        default:
                            break;
                    }
                }
            }
        }
    }
    [self afterUpdate];
}

#pragma mark - Other

-(void)beforeUpdate{
    //abstract => to implement in subclasses
}

-(void)afterUpdate{
    //abstract => to implement in subclasses
}

-(void)addWaterTo:(CGPoint)place{
    //abstract => to implement in subclasses
}

-(void)addAntTo:(CGPoint)place byUser:(NSInteger)userId{
    //abstract => to implement in subclasses
}

-(void)addFoodTo:(CGPoint)place{
    //abstract => to implement in subclasses
}

-(void)removeAntFrom:(CGPoint)place byUser:(NSInteger)userId{
    //abstract => to implement in subclasses
}

-(void)addHillTo:(CGPoint)place byUser:(NSInteger)userId{
    //abstract => to implement in subclasses
}

@end
