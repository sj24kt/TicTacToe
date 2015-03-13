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
@property (weak, nonatomic) IBOutlet UILabel *countDownLabel;

@property (strong, nonatomic) NSMutableArray *labelArray;

@property CGPoint originalCenter;
@property UIColor *originalBackgroundColor;
@property NSArray *labels;
@property int countdown;
@property BOOL canMoveWhichPlayer;
@property BOOL gameStart;
@property BOOL playersTurn;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // change navBar text & background color & init
    self.navigationController.navigationBar.barTintColor = [UIColor cyanColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blueColor]};

    [self presetGridLabelValues];

    // create labels array
    self.labels = [[NSArray alloc] initWithObjects:self.labelOne, self.labelTwo, self.labelThree, self.labelFour, self.labelFive, self.labelSix, self.labelSeven, self.labelEight, self.labelNine, nil ];

    // find original center point location for whichPlayerLabel
    self.originalCenter = self.whichPlayerLabel.center;

    self.gameStart = YES;
    [self startNewGame];
}

# pragma mark - taps, touches, drags and locations

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

# pragma mark - Helper methods

-(void)startNewGame {

    // set all nine tiles to empty with blank labels & backgroundColor to gray
    for (UILabel *labelName in self.labels) {
        labelName.text = @"";
        labelName.backgroundColor = self.originalBackgroundColor;
        labelName.layer.borderColor = [UIColor lightGrayColor].CGColor;
        labelName.layer.borderWidth = 2.0;
    }

    // always start a game with Player X
    [self setupPlayerX];

    // can't move until touched
    self.canMoveWhichPlayer = NO;
}

// resets Player X values
- (void)setupPlayerX {
    self.playersTurn = YES;
    self.whichPlayerLabel.hidden = NO;
    self.whichPlayerLabel.text = @"X";
    self.whichPlayerLabel.backgroundColor = self.originalBackgroundColor;
    self.whichPlayerLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.whichPlayerLabel setTextColor:[UIColor blueColor]];
}

// set label's text to X or O depending on current player
- (void) updateTurn:(UILabel *)label {
    self.canMoveWhichPlayer = NO;

    if (self.playersTurn) {
        [self playerXTurn:label];

    } else {
        // only update label if PlayerO didn't forfeit turn
        if (label != nil) {
            label.text = @"O";
            [label setTextColor:[UIColor redColor]];
        }

        // switch turns - PlayerLabel becomes blue "X"
        self.whichPlayerLabel.text = @"X";
        [self.whichPlayerLabel setTextColor:[UIColor blueColor]];

        // check if someone wins
        //[self checkWins];
    }
}

- (void)playerXTurn:(UILabel *)label {

    // only update label if PlayerX didn't forfeit turn
    if (label != nil) {
        label.text = @"X";
        [label setTextColor:[UIColor blueColor]];
    }

    // switch turns - PlayerLabel becomes red "O"
    self.whichPlayerLabel.text = @"O";
    [self.whichPlayerLabel setTextColor:[UIColor redColor]];

    // check if someone wins
    //[self checkWins];

}













- (void)presetGridLabelValues {

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
