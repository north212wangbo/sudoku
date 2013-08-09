//
//  SudokuBoardVIew.m
//  Sudoku
//
//  Created by Bo Wang on 2/17/13.
//  Copyright (c) 2013 Bo Wang. All rights reserved.
//

#import "SudokuBoardView.h"

@interface SudokuBoardView()


@property (strong, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;

@end

@implementation SudokuBoardView

- (id)initWithFrame:(CGRect)frame
{//initialize the game board, set tap gesture recognizer, initialize game model
    self = [super initWithFrame:frame];
    if (self) {
        _selectedRow = _selectedCol = -1;
        self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        self.tapGestureRecognizer.numberOfTapsRequired = 1;
        [self addGestureRecognizer:self.tapGestureRecognizer];
    }
    self.game = [[SudokuGame alloc] init];
    self.pencilModeOn = NO;
    return self;
}


- (CGRect)boardSquare {
    //basic parameters
    const CGRect myBounds = self.bounds;
    const CGFloat size = (myBounds.size.width < myBounds.size.height) ? myBounds.size.width : myBounds.size.height;
    const CGPoint myCenter = CGPointMake(myBounds.size.width/2, myBounds.size.height/2);
    const CGPoint origin = CGPointMake(myCenter.x - size/2, myCenter.y - size/2);
    return CGRectMake(origin.x, origin.y, size, size);
}

- (void)drawRect:(CGRect)rect
{   //major drawing method
    CGContextRef context = UIGraphicsGetCurrentContext();
    const CGRect myBounds = self.bounds;
    const CGFloat size = (myBounds.size.width < myBounds.size.height) ? myBounds.size.width : myBounds.size.height;
    
    const CGPoint myCenter = CGPointMake(myBounds.size.width/2, myBounds.size.height/2);
    const CGPoint origin = CGPointMake(myCenter.x - size/2, myCenter.y - size/2);
    const CGFloat squareSize = size/3;
    
    //draw the tapped square
    if (self.selectedRow >= 0 && self.selectedCol >= 0) {
        [[UIColor colorWithWhite:0.0 alpha:0.6] setFill];
        CGContextFillRect(context, CGRectMake(origin.x + self.selectedCol*squareSize/3 ,
                                              origin.y + self.selectedRow*squareSize/3 ,
                                              squareSize/3, squareSize/3));
        
    }
    
    //draw numbers ever put on the board, different color for original, user added, conflicting or pencil
    for (int row = 0; row < 9; row++) {
        for (int col = 0; col < 9; col++) {
            int currNumber = [self.game numberAtRow:row Column:col];
            if ([self.game numberAtRow:row Column:col] < 10 && [self.game numberAtRow:row Column:col] > 0) {
                [[UIColor blueColor] setFill];
                if ([self.game isConflictingEntryAtRow:row Column:col]) {
                    [[UIColor redColor] setFill];
                }
                if (![self.game isChangeableAtRow:row Column:col]){
                    [[UIColor blackColor] setFill];
                }
                [self drawFixedNumber:currNumber Row:row Column:col];
            }
            if ([self.game anyPencilsSetAtRow:row Column:col]) {
                NSLog(@"has pencil");
                for (int p = 1; p < 10; p++) {
                    if ([self.game isSetPencil:p AtRow:row Column:col])
                        [self drawPencilNumber:p Row:row Column:col];
                }
            }
        }
    }

    //draw the grid
    [[UIColor blackColor] setStroke];
    CGContextSetLineWidth(context, 5);
    for (int row = 0; row < 3; row++) {
        for(int col = 0; col < 3; col++) {
            CGContextStrokeRect(context, CGRectMake(origin.x + squareSize*col, origin.y + squareSize*row, squareSize, squareSize));
            CGContextSetLineWidth(context, 2);
            [self drawSmallSquareAtRow:row Column:col Context:context Origin:origin SquareSize:squareSize];
            CGContextSetLineWidth(context, 5);
        }
    }

}

- (void)drawSmallSquareAtRow: (int)row Column: (int)col Context: (CGContextRef) context Origin: (CGPoint) origin SquareSize:(CGFloat) squareSize
{//draw small grid
    for (int i = 0; i < 3; i++){
        for (int j = 0; j < 3; j++){
            CGContextStrokeRect(context, CGRectMake(origin.x + col*squareSize + squareSize/3*i, origin.y + row*squareSize+ squareSize/3*j, squareSize/3, squareSize/3));
        }
    }
}


- (void)drawFixedNumber:(int)number Row:(int)row Column:(int)col
{   //draw a specific number on a grid
    CGRect board = [self boardSquare];
    const CGFloat gridSize = board.size.width/3;
    const CGFloat d = gridSize/3;
    const CGPoint gridOrigin = CGPointMake(0, 0);
    UIFont *font = [UIFont boldSystemFontOfSize:30];
    const NSString *text = [NSString stringWithFormat:@"%d", number];
    const CGSize textSize = [text sizeWithFont:font];
    const CGFloat x = gridOrigin.x + col*d + 0.5*(d - textSize.width);
    const CGFloat y = gridOrigin.y + row*d + 0.5*(d - textSize.height);
    const CGRect textRect = CGRectMake(x, y, textSize.width, textSize.height);
    [text drawInRect: textRect withFont:font];
}

- (void)drawPencilNumber:(int)number Row:(int)row Column:(int)col
{
    //draw a pencil number
    CGRect board = [self boardSquare];
    const CGFloat gridSize = board.size.width/3;
    const CGFloat d = gridSize/3;
    const CGFloat s = d/3;
    const CGPoint gridOrigin = CGPointMake(0, 0);
    UIFont *font = [UIFont boldSystemFontOfSize:10];
    const NSString *text = [NSString stringWithFormat:@"%d", number];
    const CGSize textSize = [text sizeWithFont:font];
    const CGFloat x = gridOrigin.x + col*d + (number-1) %3 *s + 0.5*(s- textSize.width);
    const CGFloat y = gridOrigin.y + row*d + (number-1) /3 *s + 0.5*(s- textSize.height);
    const CGRect textRect = CGRectMake(x, y, textSize.width, textSize.height);
    [text drawInRect:textRect withFont:font];
}

- (IBAction)handleTap:(UIGestureRecognizer *)sender {
    //handle tap
    const CGPoint tapPoint = [sender locationInView:sender.view];
    const CGRect boardSquare = [self boardSquare];
    const CGFloat squareSize = boardSquare.size.width/9;
    const int row = (tapPoint.y - boardSquare.origin.y)/squareSize;
    const int col = (tapPoint.x - boardSquare.origin.x)/squareSize;
    if (0 <= row < 9 && 0 <= col < 9) {
        self.selectedCol = col;
        self.selectedRow = row;
    }
}

-(void)setSelectedCol:(NSInteger)selectedCol {
    //update display if col did change
    if (_selectedCol != selectedCol) {
        _selectedCol = selectedCol;
        [self setNeedsDisplay];
    }
}

-(void)setSelectedRow:(NSInteger)selectedRow {
    //update display if row did change
    if (_selectedRow != selectedRow) {
        _selectedRow = selectedRow;
        [self setNeedsDisplay];
    }
}


@end
