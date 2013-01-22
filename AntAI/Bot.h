//
//  Bot.h
//  AntAI
//
//  Created by Ariel Tkachenko on 1/22/13.
//  Copyright (c) 2013 Thor. All rights reserved.
//

#import "AbstractSystemInputReader.h"

@class Ants;

@interface Bot : AbstractSystemInputReader

@property(nonatomic,strong, readonly)Ants* ants;

@end
