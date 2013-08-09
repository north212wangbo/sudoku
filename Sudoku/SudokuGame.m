//
//  SudokuGame.m
//  Sudoku
//
//  Created by Bo Wang on 2/18/13.
//  Copyright (c) 2013 Bo Wang. All rights reserved.
//

#import "SudokuGame.h"

@implementation SudokuGame {    
    struct cell {
        int value;
        BOOL isInitial;
        BOOL pencil[9];
    };
    
    struct cell gameBoard[9][9];
    NSArray *simpleGames;
}

-(id)init {
    self = [super init];
    if (self) {
        for (int r = 0; r < 9; r++) {
            for (int c = 0; c < 9; c++) {
                gameBoard[r][c].value = 0;
                for (int n = 0; n < 10; n++){
                    gameBoard[r][c].pencil[n] = NO;
                    gameBoard[r][c].isInitial = NO;
                }
            }
        }
    }
    return self;
}

- (void) freshGame:(NSString *)boardString {
    for (int r = 0; r < 9; r++) {
        for (int c = 0; c < 9; c++) {
            gameBoard[r][c].value = 0;
            for (int n = 0; n < 10; n++){
                gameBoard[r][c].pencil[n] = NO;
                gameBoard[r][c].isInitial = NO;
            }
        }
    }
    
    for (int i = 0,r = 0; r < 9; r++) {
        for (int c = 0; c < 9; c++) {
            char ch = [boardString characterAtIndex:i];
            if ( ch != '.') {
                gameBoard[r][c].value = (int)ch - 48;
                gameBoard[r][c].isInitial = YES;
            }
            i++;
        }
    }
}

- (int)numberAtRow:(int)r Column:(int)c {
    return gameBoard[r][c].value;
}

- (void)setNumber:(int)n AtRow:(int)r Column:(int)c {
    if (gameBoard[r][c].isInitial == NO) {
        gameBoard[r][c].value = n;
    }
}

- (BOOL)anyPencilsSetAtRow:(int)r Column:(int)c {
    if (gameBoard[r][c].value == 10) return YES;
    else return NO;
}

- (void)setPencil:(int)n AtRow:(int)r Column:(int)c {
    if (gameBoard[r][c].isInitial == NO) {
        gameBoard[r][c].value = 10;
        if (gameBoard[r][c].pencil[n] == NO){
            gameBoard[r][c].pencil[n] = YES;
        } else {
            gameBoard[r][c].pencil[n] = NO;
        }
    }
}

- (BOOL)isSetPencil:(int)n AtRow:(int)r Column:(int)c {
    return gameBoard[r][c].pencil[n];
}

- (void)clearAllPencilsAtRow:(int)r Column:(int)c {
    for (int n = 1; n < 10; n++) {
        gameBoard[r][c].pencil[n] = NO;
    }
}

- (BOOL)isChangeableAtRow: (int)r Column:(int)c {
    return (!gameBoard[r][c].isInitial);
}

-(BOOL)isConflictingEntryAtRow:(int)r Column:(int)c {
    for (int row = 0; row < 9; row++) {
        if (gameBoard[row][c].value == gameBoard[r][c].value && row != r)
            return YES;
    }
    for (int col = 0; col < 9; col++) {
        if (gameBoard[r][col].value == gameBoard[r][c].value && col != c)
            return YES;

    }
    for (int row = r/3*3; row < r/3*3+3; row++) {
        for (int col = c/3*3; col < c/3*3+3; col++) {
            if (gameBoard[row][col].value == gameBoard[r][c].value && row != r)
                return YES;
        }
    }
    return NO;
}

-(BOOL)didWin {
    for (int r = 0; r <9; r++) {
        for (int c = 0; c < 9; c++) {
            if (gameBoard[r][c].value < 0 || gameBoard[r][c].value > 10 || [self isConflictingEntryAtRow:r Column:c])
                return NO;
        }
    }
    return YES;
}

-(void)clearAllConflictingCells {
    for (int r = 0; r <9; r++) {
        for (int c = 0; c < 9; c++) {
            if ([self isConflictingEntryAtRow:r Column:c])
                [self setNumber:0 AtRow:r Column:c];
        }
    }
}

-(void)clearAllCells {
    for (int r = 0; r <9; r++) {
        for (int c = 0; c < 9; c++) {
            if ([self isChangeableAtRow:r Column:c])
                [self setNumber:0 AtRow:r Column:c];
        }
    }
}
@end
