//
//  MyBot.m
//  AntAI
//
//  Created by Ariel Tkachenko on 1/22/13.
//  Copyright (c) 2013 Thor. All rights reserved.
//

#import "MyBot.h"
#import "Tile.h"
#import "Ants.h"
#import "Aim.h"

@implementation MyBot

-(void)doTurn{
    LogEnter();
    Ants* ants = self.ants;
    Log(@"self.ants = %@",self.ants);
    Log(@"ants.myAnts = %@",self.ants.myAnts);
    
#ifdef DEBUG1
    Log(@"printing map");
    for(NSArray* row in self.ants.map){
        NSString* rowString = @"";
        for(Tile* tile in row){
            rowString = [rowString stringByAppendingFormat:@" %d",tile.ilk];
        }
        Log(@"%@",rowString);
    }
#endif
    
    
    for (Tile* myAnt in ants.myAnts) {
        Log(@"myAnt (row, col) = %@ (%d,%d)",myAnt,myAnt.row,myAnt.col);
        for (Aim* direction in [Aim randomPossibleAims]) {
            Log(@"direction = %@",direction.symbol);
            Tile* tile = [ants getTileForTile:myAnt direction:direction];
            Log(@"target tile (row, col, ilk) = %@ (%d, %d, %d)",tile,tile.row,tile.col,tile.ilk);
            if(tile.isPassable){
                Log(@"target tile passable");
                [ants issueOrderForTile:myAnt direction:direction];
                break;
            }
        }
    }
}

@end
