//
//  Ants.m
//  AntAI
//
//  Created by Ariel Tkachenko on 1/20/13.
//  Copyright (c) 2013 Thor. All rights reserved.
//

#import "Ants.h"
#import "Tile.h"
#import "Order.h"

static NSInteger MAX_MAP_SIZE = 256 * 2;

@interface Ants(){
    
}

@property(nonatomic, assign)int             loadTime;
@property(nonatomic, assign)int             turnTime;
@property(nonatomic, assign)int             rows;
@property(nonatomic, assign)int             cols;
@property(nonatomic, assign)int             turns;
@property(nonatomic, assign)int             viewRadius;
@property(nonatomic, assign)int             attackRadius;
@property(nonatomic, assign)int             spawnRadius;
@property(nonatomic, strong)NSMutableSet*   visionOffsets;
@property(nonatomic, strong)NSArray*        map;
@property(nonatomic, strong)NSMutableSet*   myAnts;
@property(nonatomic, strong)NSMutableSet*   enemyAnts;
@property(nonatomic, strong)NSMutableSet*   myHills;
@property(nonatomic, strong)NSMutableSet*   enemyHills;
@property(nonatomic, strong)NSMutableSet*   foodTiles;
@property(nonatomic, strong)NSMutableSet*   orders;
@property(nonatomic, strong)NSMutableSet*   employed;

@end

@implementation Ants

+(NSInteger)MAX_MAP_SIZE{
    return MAX_MAP_SIZE;
}

-(id)initWithLoadTime:(int)loadTime turnTime:(int)turnTime rows:(int)rows cols:(int)cols turns:(int)turns viewRadius:(int)viewRadius attackRadius:(int)attackRadius spawnRadius:(int)spawnRadius{
    self = [super init];
    if(self){
        self.loadTime = loadTime;
        self.turnTime = turnTime;
        self.rows = rows;
        self.cols = cols;
        self.turns = turns;
        self.viewRadius = viewRadius;
        self.attackRadius = attackRadius;
        self.spawnRadius = spawnRadius;
        
        NSMutableArray* map = [NSMutableArray arrayWithCapacity:self.rows];
        for(int i = 0; i < self.rows; i++){
            NSMutableArray* row = [NSMutableArray arrayWithCapacity:self.cols];
            [map addObject:row];
            for(int j = 0; j < self.cols; j++){
                Tile* tile = [[Tile alloc]initWithRow:i col:j];
                [row addObject:tile];
            }
        }
        self.map = map;
        
        NSMutableSet* visionOffsets = [NSMutableSet set];// new HashSet<Tile>();
        int mx = (int)sqrt(self.viewRadius);
        for (int row = -mx; row <= mx; ++row) {
            for (int col = -mx; col <= mx; ++col) {
                int d = row * row + col * col;
                if (d <= viewRadius) {
                    Tile* tile = [[Tile alloc]initWithRow:row col:col];
                    [visionOffsets addObject:tile];
                }
            }
        }
        self.visionOffsets = visionOffsets;
        
        self.myAnts = [NSMutableSet set];
        self.enemyAnts = [NSMutableSet set];
        self.myHills = [NSMutableSet set];
        self.enemyHills = [NSMutableSet set];
        self.foodTiles = [NSMutableSet set];
        self.orders = [NSMutableSet set];
        self.employed = [NSMutableSet set];
    }
    return self;
}

-(int)turnRemainingTime {
    NSDate* now = [NSDate date];
    return self.turnTime - (int)([now timeIntervalSince1970] - self.turnStartTime);
}

-(Tile*)getTileForRow:(int)row col:(int)col{
    NSArray* rowData = [self.map objectAtIndex:row];
    return [rowData objectAtIndex:col];
}

-(Tile*)getTileForTile:(Tile*)tile direction:(Aim*)direction{
    int row = (tile.row + direction.rowDelta) % self.rows;
    if (row < 0) {
        row += self.rows;
    }
    int col = (tile.col + direction.colDelta) % self.cols;
    if (col < 0) {
        col += self.cols;
    }
    return [self getTileForRow:row col:col];
}


-(Tile*)getTileForTile:(Tile*)tile andOffsetTile:(Tile*)offset{
    int row = (tile.row + offset.row) % self.rows;
    if (row < 0) {
        row += self.rows;
    }
    int col = (tile.col + offset.col) % self.cols;
    if (col < 0) {
        col += self.cols;
    }
    return [self getTileForRow:row col:col];
}

-(int)getDistanceBetweenTile:(Tile*)t1 andTile:(Tile*)t2{
    int rowDelta = abs(t1.row - t2.row);
    int colDelta = abs(t1.col - t2.col);
    rowDelta = MIN(rowDelta, self.rows - rowDelta);
    colDelta = MIN(colDelta, self.cols - colDelta);
    return rowDelta * rowDelta + colDelta * colDelta;
}

-(NSArray*)getDirectionsBetweenTile:(Tile*)t1 andTile:(Tile*)t2{
    NSMutableArray* directions = [NSMutableArray array];
    if (t1.row < t2.row) {
        if (t2.row - t1.row >= self.rows / 2) {
            [directions addObject:[Aim north]];
        } else {
            [directions addObject:[Aim south]];
        }
    } else if (t1.row > t2.row) {
        if (t1.row - t2.row >= self.rows / 2) {
            [directions addObject:[Aim south]];
        } else {
            [directions addObject:[Aim north]];
        }
    }
    if (t1.col < t2.col) {
        if (t2.col - t1.col >= self.cols / 2) {
            [directions addObject:[Aim west]];
        } else {
            [directions addObject:[Aim east]];
        }
    } else if (t1.col > t2.col) {
        if (t1.col - t2.col >= self.cols / 2) {
            [directions addObject:[Aim east]];
        } else {
            [directions addObject:[Aim west]];
        }
    }
    return directions;
}

-(void)clearMyAnts{
    for (Tile* myAnt in self.myAnts) {
        myAnt.ilk = LAND;
    }
    [self.myAnts removeAllObjects];
}

-(void)clearEnemyAnts{
    for (Tile* enemyAnt in self.enemyAnts) {
        enemyAnt.ilk = LAND;
    }
    [self.enemyAnts removeAllObjects];
}

-(void)clearFood{
    for (Tile* food in self.foodTiles) {
        food.ilk = LAND;
    }
    [self.foodTiles removeAllObjects];
}

-(void)clearMyHills{
    [self.myHills removeAllObjects];
}

-(void)clearEnemyHills{
    [self.enemyHills removeAllObjects];
}

-(void)clearDeadAnts{
        //currently we do not have list of dead ants, so iterate over all map
    for (int row = 0; row < self.rows; row++){
        for (int col = 0; col < self.cols; col++){
            Tile* tile = [self getTileForRow:row col:col];
            if((tile.ilk == MY_DEAD) || (tile.ilk == ENEMY_DEAD)){
                tile.ilk = LAND;
            }
        }
    }
}

-(void)clearVision{
    for (int row = 0; row < self.rows; ++row) {
        for (int col = 0; col < self.cols; ++col) {
            Tile* tile = [self getTileForRow:row col:col];
            tile.visible = NO;
        }
    }
}

-(void)setVision{
    for (Tile* antLoc in self.myAnts) {
        for (Tile* locOffset in self.visionOffsets) {
            Tile* newLoc = [self getTileForTile:antLoc andOffsetTile:locOffset];
            newLoc.visible = YES;
        }
    }
}

-(void)updateTile:(Tile*)tile withIlk:(Ilk)ilk{
    Tile* mapTile = [self getTileForRow:tile.row col:tile.col];
    mapTile.ilk = ilk;
    switch (ilk) {
        case FOOD:
            [self.foodTiles addObject:mapTile];
            break;
        case MY_ANT:
            [self.myAnts addObject:mapTile];
            break;
        case ENEMY_ANT:
            [self.enemyAnts addObject:mapTile];
            break;
        default:
            break;
    }
}

-(void)updateHillsForTile:(Tile*)tile ownerId:(int)ownerId{
    if (ownerId > 0)
        [self.enemyHills addObject:tile];
    else
        [self.myHills addObject:tile];
}

-(void)issueOrderForTile:(Tile*)myAnt direction:(Aim*)direction{
    LogEnter();
    Order* order = [[Order alloc]initWithTile:myAnt andAim:direction];
    [self.orders addObject:order];
    [order issue];
}

@end
