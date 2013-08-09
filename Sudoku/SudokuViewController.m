//
//  SudokuViewController.m
//  Sudoku
//
//  Created by Bo Wang on 2/17/13.
//  Copyright (c) 2013 Bo Wang. All rights reserved.
//

#import "SudokuViewController.h"
#import "SudokuBoardView.h"
#import "buttonView.h"
#import "SudokuGame.h"

@interface SudokuViewController () {
    NSArray *simpleGames;
    NSArray *hardGames;
}

@end

@implementation SudokuViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    //initialize view, add game board view, button view and read games from input
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) {
        CGRect frame = CGRectMake(0, 0, 320, 320);
        self.sudokuBoard = [[SudokuBoardView alloc] initWithFrame:frame];
        self.sudokuBoard.backgroundColor = [UIColor whiteColor];
        
        CGRect buttonFrame = CGRectMake(0, 320, 320, 140);
        self.sudokuButton = [[buttonView alloc] initWithFrame:buttonFrame];
        self.sudokuButton.backgroundColor = [UIColor whiteColor];
        
        
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"simple" ofType:@"plist"];
        simpleGames = [[NSArray alloc] initWithContentsOfFile:path];
        NSString *hpath = [[NSBundle mainBundle] pathForResource:@"hard" ofType:@"plist"];
        hardGames = [[NSArray alloc] initWithContentsOfFile:hpath];
        [self.sudokuBoard.game freshGame:[self randomSimpleGame]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.sudokuBoard];
    [self.view addSubview:self.sudokuButton];
    [self.sudokuButton addSubview:self.buttonsView];
    [self.sudokuButton addSubview:self.buttonsView2];
    [self.sudokuButton addSubview:self.buttonsView3];
    [self.sudokuButton addSubview:self.buttonsView4];
    [self.sudokuButton addSubview:self.buttonsView5];
    [self.sudokuButton addSubview:self.buttonsView6];
    [self.sudokuButton addSubview:self.buttonsView7];
    [self.sudokuButton addSubview:self.buttonsView8];
    [self.sudokuButton addSubview:self.buttonsView9];
    [self.sudokuButton addSubview:self.buttonsView10];
    [self.sudokuButton addSubview:self.buttonsView11];
    [self.sudokuButton addSubview:self.buttonsView12];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


-(void)viewWillLayoutSubviews {
    //update if user rotates the device
    const CGRect viewBounds = self.view.bounds;
    const bool isPortrait = viewBounds.size.height >= viewBounds.size.width;
    if (isPortrait) {
        const float boardSize = viewBounds.size.width;
        const float buttonsHeight = viewBounds.size.height - boardSize;
        self.sudokuBoard.frame = CGRectMake(0, 0, boardSize, boardSize);
        self.sudokuButton.frame = CGRectMake(0, boardSize, boardSize, buttonsHeight);
    } else {
        const float boardSize = viewBounds.size.height;
        const float buttonsWidth = viewBounds.size.width - boardSize;
        self.sudokuBoard.frame = CGRectMake(0, 0, boardSize, boardSize);
        self.sudokuButton.frame = CGRectMake(boardSize, 0, buttonsWidth, boardSize);

    }
}

- (IBAction)buttonPressed: (UIButton *)sender{
    //action detecter
    int tag = [sender tag];

    if (tag == 11) [self eraserPressed];
    else if (tag == 12) [self menuPressed];
    else [self numberPressed:tag];

}


- (void)numberPressed:(int)tag {
    self.sudokuBoard.tag = tag;
    int row = self.sudokuBoard.selectedRow;
    int col = self.sudokuBoard.selectedCol;
    if (row >= 0 && col >= 0) {
        if (self.sudokuBoard.pencilModeOn == NO) {
            [self.sudokuBoard.game setNumber:tag AtRow:row Column:col];
            [self.sudokuBoard setNeedsDisplay];
        } else {
            [self.sudokuBoard.game setPencil:tag AtRow:row Column:col];
            [self.sudokuBoard setNeedsDisplay];
        }
    }
}

- (void)eraserPressed {
    int row = self.sudokuBoard.selectedRow;
    int col = self.sudokuBoard.selectedCol;
    if(col >= 0 && row >= 0){
        if (self.sudokuBoard.pencilModeOn == NO) {
            [self.sudokuBoard.game setNumber:0 AtRow:row Column:col];
            [self.sudokuBoard setNeedsDisplay];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Deleting all penciled in numbers!" message:@"Are you sure?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
            [alert show];

        }
    }
}

- (IBAction)pencilPressed:(UIButton *)sender {
    int row = self.sudokuBoard.selectedRow;
    int col = self.sudokuBoard.selectedCol;
    if (sender.selected == NO) {
        sender.selected = YES;
    }
    else {
        sender.selected = NO;
    }
    if (self.sudokuBoard.pencilModeOn) {
        self.sudokuBoard.pencilModeOn = NO;
        [self.sudokuBoard.game setNumber:0 AtRow:row Column:col];
        [self.sudokuBoard setNeedsDisplay];
        if ([self.sudokuBoard.game didWin]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You Win!" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            alert.tag = 1;
            [alert show];
        }
    } else {
        self.sudokuBoard.pencilModeOn = YES;
        [self.sudokuBoard.game setNumber:10 AtRow:row Column:col];
        [self.sudokuBoard setNeedsDisplay];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    int row = self.sudokuBoard.selectedRow;
    int col = self.sudokuBoard.selectedCol;
    if (buttonIndex == 1) {
        [self.sudokuBoard.game clearAllPencilsAtRow:row Column:col];
        [self.sudokuBoard setNeedsDisplay];
    } else {
        NSLog(@"Canceled!");
    }
}

- (void)menuPressed {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Main Menu" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"New Easy Game", @"New Hard Game", @"Clearing Conflicting Cells", @"Clear All Cells", nil];
    [sheet showFromBarButtonItem:self animated:YES];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"index = %d", buttonIndex);
    if (buttonIndex == 0) {
        [self.sudokuBoard.game freshGame:[self randomSimpleGame]];
        [self.sudokuBoard setNeedsDisplay];
    } else if (buttonIndex == 1) {
        [self.sudokuBoard.game freshGame:[self randomHardGame]];
        [self.sudokuBoard setNeedsDisplay];
    } else if (buttonIndex == 2) {
        [self.sudokuBoard.game clearAllConflictingCells];
        [self.sudokuBoard setNeedsDisplay];
    } else if (buttonIndex == 3) {
        [self.sudokuBoard.game clearAllCells];
        [self.sudokuBoard setNeedsDisplay];
    }
}


-(NSString*)randomSimpleGame {
    const int n = [simpleGames count];
    const int i = arc4random() % n;
    return [simpleGames objectAtIndex:i];
}

-(NSString*)randomHardGame {
    const int n = [hardGames count];
    const int i = arc4random() % n;
    return [hardGames objectAtIndex:i];
}
@end
