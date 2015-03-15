//
//  RootViewController.m
//  TicTacToe
//
//  Created by Sherrie Jones on 3/12/15.
//  Copyright (c) 2015 Sherrie Jones. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController () <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *labelOne;
@property (weak, nonatomic) IBOutlet UILabel *labelTwo;
@property (weak, nonatomic) IBOutlet UILabel *labelThree;
@property (weak, nonatomic) IBOutlet UILabel *labelFour;
@property (weak, nonatomic) IBOutlet UILabel *labelFive;
@property (weak, nonatomic) IBOutlet UILabel *labelSix;
@property (weak, nonatomic) IBOutlet UILabel *labelSeven;
@property (weak, nonatomic) IBOutlet UILabel *labelEight;
@property (weak, nonatomic) IBOutlet UILabel *labelNine;
@property (weak, nonatomic) IBOutlet UILabel *whichPlayerLabel;

@property NSArray *labels;

@property UIColor *originalBackgroundColor;
@property CGPoint originalCenter;

@property BOOL playersTurn;
@property BOOL gameStart;
@property BOOL canMoveWhichPlayer;
@property BOOL onePlayerMode;

@property int countdown;
@property (weak, nonatomic) IBOutlet UILabel *countDownLabel;


@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // change navBar text & background color & init
    self.navigationController.navigationBar.barTintColor = [UIColor lightGrayColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blueColor]};

    // create labels array
    self.labels = [[NSArray alloc] initWithObjects:self.labelOne, self.labelTwo, self.labelThree, self.labelFour, self.labelFive, self.labelSix, self.labelSeven, self.labelEight, self.labelNine, nil ];

    // find original center point location for whichPlayerLabel
    self.originalCenter = self.whichPlayerLabel.center;

    // set and call startNewGame and format tiles
    self.gameStart = YES;
    [self startNewGame];
}

// Helper method to start and initialize tiles in a new game
-(void)startNewGame {
    // set labels background color to gray
    self.originalBackgroundColor = [UIColor colorWithRed:230.0f/255.0f
                                                   green:230.0f/255.0f
                                                    blue:230.0f/255.0f
                                                   alpha:1.0f];

    // set all nine tiles to empty with blank labels & backgroundColor to gray
    for (UILabel *labelName in self.labels) {
        labelName.text = @"";
        labelName.backgroundColor = self.originalBackgroundColor;
    }

    // set up X player to start first at every new game
    self.playersTurn = YES;
    self.whichPlayerLabel.hidden = NO;
    self.whichPlayerLabel.text = @"X";
    [self.whichPlayerLabel setTextColor:[UIColor blueColor]];
    self.whichPlayerLabel.backgroundColor = self.originalBackgroundColor;

    // remove the labels
    for (UILabel *label in self.labels) {
        label.text = @"";
        label.backgroundColor = self.originalBackgroundColor;
    }

    // can't move until touched
    self.canMoveWhichPlayer = NO;
}

// check if point is inside which tile label
-(UILabel *) findLabelUsingPoint:(CGPoint)point {

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

// if a label is tapped, find which label it is
- (IBAction)onLabelTapped:(UITapGestureRecognizer *)sender {
    // get tap location in view
    CGPoint point = [sender locationInView:self.view];

    // check if label was tapped - calls method
    UILabel *labelName = [self findLabelUsingPoint:point];

    if (labelName != nil && [labelName.text isEqualToString:@""]) {
        [self updateTurn:labelName];
    }
}

// updateTurn helper updates the whichPlayerLabel & the labelNumber
- (void) updateTurn:(UILabel *)label {
    self.canMoveWhichPlayer = NO;
    if (self.playersTurn) {
        // only update label if user didn't forfeit turn
        if (label != nil) {
            label.text = @"X";
            [label setTextColor:[UIColor blueColor]];
        }
        // switch turns -whichPlayerLabel becomes red "O"
        self.whichPlayerLabel.text = @"O";
        [self.whichPlayerLabel setTextColor:[UIColor redColor]];

        // check if someone wins
        [self checkWins];
    } else {
        if (label != nil) {
            label.text = @"O";
            [label setTextColor:[UIColor redColor]];
        }

        // switch turns -whichPlayerLabel becomes blue "X"
        self.whichPlayerLabel.text = @"X";
        [self.whichPlayerLabel setTextColor:[UIColor blueColor]];

        // check if someone wins
        [self checkWins];
    }
}

// checksWins helper if X or O won game
- (BOOL) checkWins {
    NSString *whoWins = [self whoWon];

    if (whoWins != nil) {
        // hide whichPlayerLabel
        self.whichPlayerLabel.hidden = YES;

        // display X or O WINS! and game over message
        NSString *message = [NSString stringWithFormat:@"%@ WINS!!!", whoWins];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Over" message:message delegate:self cancelButtonTitle:@"Play Again" otherButtonTitles:nil];
        [alert show];
        return YES;
    } else {
        // switch WPL turns
        self.playersTurn = !self.playersTurn;

        // animation
        [self animateTurn];
        return NO;
    }
}

// helper that animates next turn
- (void) animateTurn {
    // move whichPlayerLabel turn offscreen
    CGPoint offSet = self.view.center;
    offSet.y = offSet.y + 800;

    if (self.playersTurn) {
        offSet.x = offSet.x - 300;
    } else{
        offSet.x = offSet.x + 300;
    }

    self.whichPlayerLabel.center = offSet;

    [UIView animateWithDuration:0.5f animations:^{
        self.whichPlayerLabel.center = self.originalCenter;
    } completion:^(BOOL finished) {

    }];
}

// start a new game after alert view returns
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    self.gameStart = YES;
    [self startNewGame];
}

// whoWon helper that determines who won
- (NSString*)whoWon {
    // check first row
    if (![self.labelOne.text isEqualToString:@""] && [self.labelOne.text isEqualToString:self.labelTwo.text] &&
        [self.labelTwo.text isEqualToString:self.labelThree.text]) {
        return self.labelOne.text;
    }
    // check second row
    if (![self.labelFour.text isEqualToString:@""] && [self.labelFour.text isEqualToString:self.labelFive.text] &&
        [self.labelFive.text isEqualToString:self.labelSix.text]) {
        return self.labelFour.text;
    }
    // check third row
    if (![self.labelSeven.text isEqualToString:@""] && [self.labelSeven.text isEqualToString:self.labelEight.text] &&
        [self.labelEight.text isEqualToString:self.labelNine.text]) {
        return self.labelSeven.text;
    }
    // check first column
    if (![self.labelOne.text isEqualToString:@""] && [self.labelOne.text isEqualToString:self.labelFour.text] &&
        [self.labelFour.text isEqualToString:self.labelSeven.text]) {
        return self.labelOne.text;
    }
    // check 2nd column
    if (![self.labelTwo.text isEqualToString:@""] && [self.labelTwo.text isEqualToString:self.labelFive.text] &&
        [self.labelFive.text isEqualToString:self.labelEight.text]) {
        return self.labelTwo.text;
    }
    // check 3rd column
    if (![self.labelThree.text isEqualToString:@""] && [self.labelThree.text isEqualToString:self.labelSix.text] &&
        [self.labelSix.text isEqualToString:self.labelNine.text]) {
        return self.labelThree.text;
    }
    // check downward diagonal
    if (![self.labelOne.text isEqualToString:@""] && [self.labelOne.text isEqualToString:self.labelFive.text] &&
        [self.labelFive.text isEqualToString:self.labelNine.text]) {
        return self.labelOne.text;
    }
    // check upward diagonal
    if (![self.labelSeven.text isEqualToString:@""] && [self.labelSeven.text isEqualToString:self.labelFive.text] &&
        [self.labelFive.text isEqualToString:self.labelThree.text]) {
        return self.labelSeven.text;
    }

    // check if board is full
    bool isFull = true;
    for (UILabel *label in self.labels) {
        if ([label.text isEqualToString:@""]) {
            isFull = false;
        }
    }
    if (isFull) {
        return @"NO ONE";
    }
    // if reached this point no one has won yet
    return nil;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint locationPoint = [[touches anyObject] locationInView:self.view];
    if (CGRectContainsPoint(self.whichPlayerLabel.frame, locationPoint)) {
        self.canMoveWhichPlayer = YES;
    } else {
        self.canMoveWhichPlayer = NO;
    }
}

// onDrag whichPlayerLabel learns its point x,y location
- (IBAction)onDrag:(UIPanGestureRecognizer *)sender {
    CGPoint point = [sender locationInView: self.view];

    // check if the whichPlayerLabel's moves into a label's frame
    if (self.canMoveWhichPlayer) {
        self.whichPlayerLabel.center = point;

        // check if stopped dragging inside another tile label and dropped whichPlayerLabel
        if (sender.state == UIGestureRecognizerStateEnded) {
            UILabel *label = [self findLabelUsingPoint:point];
            if (label != nil && [label.text isEqualToString:@""]) {
                self.canMoveWhichPlayer = NO;
                [self updateTurn:label];
            }
        }
    }

    // if movement ended then move back to originalCenter
    if (sender.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:1.0f animations:^{
            self.whichPlayerLabel.center = self.originalCenter;
        } completion:^(BOOL finished) {
            if (finished) {
                self.whichPlayerLabel.backgroundColor = [UIColor lightGrayColor];
            }
        }];
    }
}


@end
























