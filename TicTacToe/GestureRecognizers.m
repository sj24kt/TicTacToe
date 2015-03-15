//
//  GestureRecognizers.m
//  TicTacToe
//
//  Created by Sherrie Jones on 3/15/15.
//  Copyright (c) 2015 Sherrie Jones. All rights reserved.
//

#import "GestureRecognizers.h"

@implementation GestureRecognizers

#pragma mark - UIGestureRecognizers

// figure out if I touched a specific label
- (UILabel *)findLabelUsingPoint:(CGPoint)point {

    // loop through all grid labels in array
    for (UILabel *labelName in self.labels) {

        // check if point is inside label frame and return label position
        if (CGRectContainsPoint(labelName.frame, point)) {
            return labelName;
        }
    }
    // otherwise, no label was found
    return nil;
}

// find the specific label that was tapped
- (IBAction)onLabelTapped:(UITapGestureRecognizer *)gestureRecognizer {
    // get tap location in view
    CGPoint point = [gestureRecognizer locationInView:self.view];

    // check if label on the view was tapped - calls method
    UILabel *labelName = [self findLabelUsingPoint:point];
    labelName.center = point;

    // if label is empty update turn
    if (labelName != nil && [labelName.text isEqualToString:@""]) {
        [self updateTurn:labelName];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // finds label touched
    CGPoint locationPoint = [[touches anyObject] locationInView:self.view];

    // finds an empty label the whichPlayer can move, else label is taken already
    if (CGRectContainsPoint(self.whichPlayerLabel.frame, locationPoint)) {
        self.canMoveWhichPlayer = YES;
        //        [self startCountdown];
    } else {
        self.canMoveWhichPlayer = NO;
    }
}

// onDrag whichPlayerLabel learns its point x,y location
- (IBAction)onDrag:(UIPanGestureRecognizer *)drag {

    CGPoint point = [drag locationInView:self.view];

    // check if the PlayerLabel's moves into a label's frame
    if (self.canMoveWhichPlayer) {
        self.whichPlayerLabel.center = point;

        // check if drag stopped inside another label and dropped current Player
        if (drag.state == UIGestureRecognizerStateEnded) {
            UILabel *label = [self findLabelUsingPoint:point];

            if (label != nil && [label.text isEqualToString:@""]) {
                self.canMoveWhichPlayer = NO;
                [self updateTurn:label];
            }
        }
    }

    // if movement ended then move back to originalCenter
    if (drag.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:1.0f animations:^{
            self.whichPlayerLabel.center = self.originalCenter;
        } completion:^(BOOL finished) {
            if (finished) {
                self.whichPlayerLabel.backgroundColor = self.originalBackgroundColor;
            }
        }];
    }
}

@end
