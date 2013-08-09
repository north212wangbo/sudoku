//
//  SudokuGame.h
//  Sudoku
//
//  Created by Bo Wang on 2/18/13.
//  Copyright (c) 2013 Bo Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SudokuGame : NSObject

-(id)init;
-(void)freshGame:(NSString*)boardString;
-(int)numberAtRow:(int)r Column:(int)c;
-(void)setNumber:(int)n AtRow:(int)r Column:(int)c;
-(BOOL)isConflictingEntryAtRow:(int)r Column:(int)c;
-(BOOL)anyPencilsSetAtRow:(int)r Column:(int)c;
-(BOOL)isSetPencil:(int)n AtRow:(int)r Column:(int)c;
-(void)setPencil:(int)n AtRow:(int)r Column:(int)c;
-(void)clearAllPencilsAtRow:(int)r Column:(int)c;
-(BOOL)isChangeableAtRow: (int)r Column:(int)c;
-(BOOL)didWin;
-(void)clearAllConflictingCells;
-(void)clearAllCells;
@end
