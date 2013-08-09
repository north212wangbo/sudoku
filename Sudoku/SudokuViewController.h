//
//  SudokuViewController.h
//  Sudoku
//
//  Created by Bo Wang on 2/17/13.
//  Copyright (c) 2013 Bo Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SudokuBoardView.h"
#import "buttonView.h"


@interface SudokuViewController : UIViewController

@property SudokuBoardView *sudokuBoard;
@property buttonView *sudokuButton;
@property (weak, nonatomic) IBOutlet UIButton *buttonsView;
@property (weak, nonatomic) IBOutlet UIButton *buttonsView2;
@property (weak, nonatomic) IBOutlet UIButton *buttonsView3;
@property (weak, nonatomic) IBOutlet UIButton *buttonsView4;
@property (weak, nonatomic) IBOutlet UIButton *buttonsView5;
@property (weak, nonatomic) IBOutlet UIButton *buttonsView6;
@property (weak, nonatomic) IBOutlet UIButton *buttonsView7;
@property (weak, nonatomic) IBOutlet UIButton *buttonsView8;
@property (weak, nonatomic) IBOutlet UIButton *buttonsView9;
@property (weak, nonatomic) IBOutlet UIButton *buttonsView10;
@property (weak, nonatomic) IBOutlet UIButton *buttonsView11;
@property (weak, nonatomic) IBOutlet UIButton *buttonsView12;


- (IBAction)buttonPressed:(UIButton *)sender;
- (IBAction)pencilPressed:(UIButton *)sender;

@end
