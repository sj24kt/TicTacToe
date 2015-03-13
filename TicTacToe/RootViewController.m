//
//  RootViewController.m
//  TicTacToe
//
//  Created by Sherrie Jones on 3/12/15.
//  Copyright (c) 2015 Sherrie Jones. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController () <UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *labelOne;
@property (strong, nonatomic) IBOutlet UILabel *labelTwo;
@property (strong, nonatomic) IBOutlet UILabel *labelThree;
@property (strong, nonatomic) IBOutlet UILabel *labelFour;
@property (strong, nonatomic) IBOutlet UILabel *labelFive;
@property (strong, nonatomic) IBOutlet UILabel *labelSix;
@property (strong, nonatomic) IBOutlet UILabel *labelSeven;
@property (strong, nonatomic) IBOutlet UILabel *labelEight;
@property (strong, nonatomic) IBOutlet UILabel *labelNine;
@property (strong, nonatomic) IBOutlet UILabel *whichPlayerLabel;
@property CGPoint originalCenter;
@property NSArray *labels;

@property (strong, nonatomic) NSMutableArray *labelArray;
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self presetLabelValues];
    // find original center point location for whichPlayerLabel
    self.originalCenter = self.whichPlayerLabel.center;

}

- (IBAction)onLabelTapped:(UITapGestureRecognizer *)gestureRecognizer {
    // get tap location in view
    CGPoint point = [gestureRecognizer locationInView:self.view];

    // check if label on the view was tapped - calls method
    UILabel *labelName = [self findLabelUsingPoint:point];

    if (labelName != nil && [labelName.text isEqualToString:@""]) {
        //[self updateTurn:labelName];
    }
}

- (UILabel *)findLabelUsingPoint:(CGPoint)point {

    // loop through all grid labels
    for (UILabel *labelName in self.labels) {
        // check if point is inside tile frame and return tile label position
        if (CGRectContainsPoint(labelName.frame, point)) {
            return labelName;
        }
    }
    // otherwise, no label was found
    return nil;

}


# pragma mark - Helper methods

- (void)presetLabelValues {

    self.labelOne.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.labelOne.layer.backgroundColor = [UIColor whiteColor].CGColor;
    self.labelOne.layer.borderWidth = 2.0;

    self.labelTwo.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.labelTwo.layer.backgroundColor = [UIColor whiteColor].CGColor;
    self.labelTwo.layer.borderWidth = 2.0;

    self.labelThree.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.labelThree.layer.backgroundColor = [UIColor whiteColor].CGColor;
    self.labelThree.layer.borderWidth = 2.0;
    
    self.labelFour.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.labelFour.layer.backgroundColor = [UIColor whiteColor].CGColor;
    self.labelFour.layer.borderWidth = 2.0;
    
    self.labelFive.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.labelFive.layer.backgroundColor = [UIColor whiteColor].CGColor;
    self.labelFive.layer.borderWidth = 2.0;
    
    self.labelSix.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.labelSix.layer.backgroundColor = [UIColor whiteColor].CGColor;
    self.labelSix.layer.borderWidth = 2.0;
    
    self.labelSeven.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.labelSeven.layer.backgroundColor = [UIColor whiteColor].CGColor;
    self.labelSeven.layer.borderWidth = 2.0;
    
    self.labelEight.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.labelEight.layer.backgroundColor = [UIColor whiteColor].CGColor;
    self.labelEight.layer.borderWidth = 2.0;
    
    self.labelNine.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.labelNine.layer.backgroundColor = [UIColor whiteColor].CGColor;
    self.labelNine.layer.borderWidth = 2.0;

    self.whichPlayerLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.whichPlayerLabel.layer.backgroundColor = [UIColor whiteColor].CGColor;
    self.whichPlayerLabel.layer.borderWidth = 2.0;
}



@end
