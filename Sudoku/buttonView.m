//
//  buttonView.m
//  Sudoku
//
//  Created by Bo Wang on 2/17/13.
//  Copyright (c) 2013 Bo Wang. All rights reserved.
//

#import "buttonView.h"


@interface buttonView ()


@end

@implementation buttonView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{   //initialize the view
    static const int buttonTagsPortrait[2][6] = {
        1,2,3,4,5,11,
        6,7,8,9,10,12
    };
    const CGRect myBounds = self.bounds;
    const CGSize buttonSize = CGSizeMake(myBounds.size.width/6, myBounds.size.height/2);
    for (int row = 0; row < 2; row++) {
        for (int col = 0; col < 6; col++) {
            const int tag = buttonTagsPortrait[row][col];
            UIView *button = [self viewWithTag:tag];
            button.frame = CGRectMake(buttonSize.width*col, buttonSize.height*row, buttonSize.width, buttonSize.height);
        }
    }
}

- (void)layoutSubviews {
    //update button view if user rotates the device
    static const int buttonTagsPortrait[2][6] = {
        1,2,3,4,5,11,
        6,7,8,9,10,12
    };
    static const int buttonTagsLandscape[6][2] = {
        1,6,
        2,7,
        3,8,
        4,9,
        5,10,
        11,12
    };
    const CGRect myBounds = self.bounds;
    if (myBounds.size.width > myBounds.size.height) {
        const CGSize buttonSize = CGSizeMake(myBounds.size.width/6, myBounds.size.height/2);
        for (int row = 0; row < 2; row++) {
            for (int col = 0; col < 6; col++) {
                const int tag = buttonTagsPortrait[row][col];
                UIView *button = [self viewWithTag:tag];
                button.frame = CGRectMake(buttonSize.width*col, buttonSize.height*row, buttonSize.width, buttonSize.height);
            }
        }
    } else {
        const CGSize buttonSize = CGSizeMake(myBounds.size.width/2, myBounds.size.height/6);
        for (int row = 0; row < 6; row++) {
            for (int col = 0; col < 2; col++) {
                const int tag = buttonTagsLandscape[row][col];
                UIView *button = [self viewWithTag:tag];
                button.frame = CGRectMake(buttonSize.width*col, buttonSize.height*row, buttonSize.width, buttonSize.height);
            }
        }
    }
}






@end
