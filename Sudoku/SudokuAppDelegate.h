//
//  SudokuAppDelegate.h
//  Sudoku
//
//  Created by Bo Wang on 2/17/13.
//  Copyright (c) 2013 Bo Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SudokuViewController;

@interface SudokuAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) SudokuViewController *viewController;

@end
