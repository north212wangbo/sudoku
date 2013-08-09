//
//  SudokuBoardVIew.h
//  Sudoku
//
//  Created by Bo Wang on 2/17/13.
//  Copyright (c) 2013 Bo Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SudokuGame.h"

@interface SudokuBoardView : UIView

@property (assign, nonatomic) NSInteger selectedRow; //0..8
@property (assign, nonatomic) NSInteger selectedCol;
@property (assign, nonatomic) NSInteger tag;
@property (assign, nonatomic) BOOL pencilModeOn;
@property (strong, nonatomic) SudokuGame *game;

- (IBAction)handleTap:(UIGestureRecognizer*)sender;

@end
