//
//  ViewController.m
//  RPNCalculator
//
//  Created by Liang Shi on 2012-09-06.
//  Copyright (c) 2012 Liang Shi. All rights reserved.
//

#import "ViewController.h"
static int BUTTON_SIZE = 80;
int MAX_NUMBER = 9;

@implementation ViewController

@synthesize inputNumbers, numberBuffer;
@synthesize numberpadView, operatorsView, resultView, resultLabel;

#pragma mark - IBAction methods

- (IBAction)enterNumber:(UIButton *)sender{
    //reset background color
    [resultLabel setBackgroundColor:[UIColor colorWithRed:102.0/255.0 green:204.0/255.0 blue:255.0/255.0 alpha:1]];
    
    UIButton *buttonClicked = (UIButton *)sender;
    //enter button clicked
    if ([buttonClicked.titleLabel.text isEqualToString:@"Enter"]) { 
        if ([numberBuffer length] > 0) {
            numberBuffer = [NSString stringWithFormat:@"%g", [numberBuffer doubleValue]];
            
            //add this number to stack
            [inputNumbers addObject:numberBuffer];
            numberBuffer = @"";
        }
    }
    
    //number button clicked
    else if([numberBuffer length] < MAX_NUMBER){ //set number's max length
        if ([buttonClicked.titleLabel.text isEqualToString:@"."]) {
            if ([numberBuffer length] == 0) {
                numberBuffer = @"0"; //add 0 before dot
            }
            if ([numberBuffer rangeOfString:@"."].location != NSNotFound) {
                return; //can't add more than one dot
            }
        }
        //add to number buffer
        numberBuffer = [NSString stringWithFormat:@"%@%@", numberBuffer, buttonClicked.titleLabel.text];
    }
    
    //show number buffer content
    if ([numberBuffer length] > 0) {
        resultLabel.text = numberBuffer;
    }
    else{
        resultLabel.text = @"0.0";
    }
    
    //show current number stack
    [self printInputNumbers];
}


- (IBAction)enterOperator:(UIButton *)sender{
    UIButton *buttonClicked = (UIButton *)sender;
    double result = 0.0; //initial computing result
    int count = [inputNumbers count];
    BOOL isValid = YES;
    //reset background color
    [resultLabel setBackgroundColor:[UIColor colorWithRed:102.0/255.0 green:204.0/255.0 blue:255.0/255.0 alpha:1]];
    if ([buttonClicked.titleLabel.text isEqualToString:CLEAR]) {
        resultLabel.text = @"0.0";
    }
    else if ([buttonClicked.titleLabel.text isEqualToString:PI]) {
        [inputNumbers insertObject:[NSString stringWithFormat:@"%g",M_PI] atIndex:[inputNumbers count]];
        resultLabel.text = [inputNumbers objectAtIndex:[inputNumbers count]-1];
    }
    else if(count > 0){
        if (![resultLabel.text isEqualToString:@"0.0"] && [numberBuffer length] > 0) {
            //add buffer number to the stack
            [inputNumbers insertObject:resultLabel.text atIndex:[inputNumbers count]];
            count++;
        }
        if ([buttonClicked.titleLabel.text isEqualToString:ADD] && count > 1) { //for x+y
            result = [[inputNumbers objectAtIndex:count-2] doubleValue] + [[inputNumbers objectAtIndex:count-1] doubleValue];
            //pop the last element
            [inputNumbers removeObjectAtIndex:count-1]; 
        }
        else if ([buttonClicked.titleLabel.text isEqualToString:MINUS] && count > 1) { //for x-y
            result = [[inputNumbers objectAtIndex:count-2] doubleValue] - [[inputNumbers objectAtIndex:count-1] doubleValue];
            [inputNumbers removeObjectAtIndex:count-1];
        }
        else if ([buttonClicked.titleLabel.text isEqualToString:MULTIPLY] && count > 1) { //for x*y
            result = [[inputNumbers objectAtIndex:count-2] doubleValue] * [[inputNumbers objectAtIndex:count-1] doubleValue];
            [inputNumbers removeObjectAtIndex:count-1];
        }
        else if ([buttonClicked.titleLabel.text isEqualToString:DIVIDE] && count > 1) { //for x/y
            result = [[inputNumbers objectAtIndex:count-2] doubleValue] / [[inputNumbers objectAtIndex:count-1] doubleValue];
            [inputNumbers removeObjectAtIndex:count-1];
        }
        else if ([buttonClicked.titleLabel.text isEqualToString:SQUARE]) { //for x^2
            result = [[inputNumbers objectAtIndex:count-1] doubleValue] * [[inputNumbers objectAtIndex:count-1] doubleValue];
        }
        else if ([buttonClicked.titleLabel.text isEqualToString:SQUAREROOT]) { //for sqrt(x)
            result = sqrt([[inputNumbers objectAtIndex:count-1] doubleValue]);
        }
        else if ([buttonClicked.titleLabel.text isEqualToString:INVERT]) { // for 1/x
            result = 1/[[inputNumbers objectAtIndex:count-1] doubleValue];
        }
        else if ([buttonClicked.titleLabel.text isEqualToString:SIN]) { // for sin(x)
            result = sin([[inputNumbers objectAtIndex:count-1] doubleValue]);
        }
        else if ([buttonClicked.titleLabel.text isEqualToString:COS]) { //for cos(x)
            result = cos([[inputNumbers objectAtIndex:count-1] doubleValue]);
        }
        else if ([buttonClicked.titleLabel.text isEqualToString:TAN]) { //for tan(x)
            result = tan([[inputNumbers objectAtIndex:count-1] doubleValue]);
        }
        else
            isValid = NO;
        if (isValid) {
            //push the new one into number stack
            NSString *resultString = [NSString stringWithFormat:@"%g", result];
            [inputNumbers replaceObjectAtIndex:[inputNumbers count]-1 withObject:resultString];
            resultLabel.text = resultString;
        }
        else{
            resultLabel.text = @"Error";
            [resultLabel setBackgroundColor:[UIColor redColor]];
        }
    }
    else{
        resultLabel.text = @"Error";
        [resultLabel setBackgroundColor:[UIColor redColor]];
    }
    
    //clear number buffer
    numberBuffer = @"";
    
    
    //show current number stack
    [self printInputNumbers];
}

#pragma mark - helper methods
- (void)initialCalculatorView{
    //clear up view
    for (UIView *subview in [numberpadView subviews]) {
        if ([subview isKindOfClass:[UIButton class]]) {
            [subview removeFromSuperview];
        }
    }
    for (UIView *subview in [operatorsView subviews]) {
        if ([subview isKindOfClass:[UIButton class]]) {
            [subview removeFromSuperview];
        }
    }
    
    [resultLabel setBackgroundColor:[UIColor colorWithRed:102.0/255.0 green:204.0/255.0 blue:255.0/255.0 alpha:1]];
    [self clearAll]; //clean up all the stack and buffer
    
    //set up 4x3 number pad
    int heightOfNumberButton = self.numberpadView.frame.size.height/4;
    int widthOfNumberButton = self.numberpadView.frame.size.width/3;
    //all components in numberpad
    NSArray *numberPadArray = [NSArray arrayWithObjects:@"7" , @"8" , @"9",  @"4" , @"5" , @"6", @"1", @"2" , @"3" , @"0", @".", @"Enter", nil];
    for (int index = 0; index < [numberPadArray count]; index++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:[NSString stringWithFormat:@"%@", [numberPadArray objectAtIndex:index]] forState:UIControlStateNormal];
        if ([button.titleLabel.text isEqualToString:@"Enter"]) {
            [button setBackgroundImage:[UIImage imageNamed:@"orange.png"] forState:UIControlStateNormal];
        }
        else{
            [button setBackgroundImage:[UIImage imageNamed:@"gray.png"] forState:UIControlStateNormal];
        }
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:20.0f]];
        [button setFrame:CGRectMake(index%3*widthOfNumberButton, index/3*heightOfNumberButton, widthOfNumberButton, heightOfNumberButton)];
        
        [button addTarget:self action:@selector(enterNumber:) forControlEvents:UIControlEventTouchUpInside];
        [numberpadView addSubview:button];
    }
    
    //set up operator view
    //pre-defined operators for the calculator
    NSArray *operatorsArray = [NSArray arrayWithObjects:CLEAR, ADD, MINUS, MULTIPLY, DIVIDE, PI, SQUARE, SQUAREROOT, SIN, COS, TAN, INVERT, nil];
    //depending on the view size, decide button layout
    int numberOfColume = floor(operatorsView.frame.size.width/BUTTON_SIZE);
    numberOfColume = numberOfColume == 0 ? 1: numberOfColume;
    int numberOfButtons = ceil([operatorsArray count] / (double)numberOfColume);
    //set up operator buttons
    for (int index = 0; index < [operatorsArray count]; index++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"lightblue.png"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:20.0f]];
        [button setFrame:CGRectMake(floor(index/numberOfButtons)*BUTTON_SIZE, (index%numberOfButtons)*heightOfNumberButton, BUTTON_SIZE, heightOfNumberButton)]; //reuse height of number pad buttons
        [button setTitle:[NSString stringWithFormat:@"%@", [operatorsArray objectAtIndex:index]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(enterOperator:) forControlEvents:UIControlEventTouchUpInside];
        [operatorsView addSubview:button];
    }
    //set scrollview contnet size
    [operatorsView setContentSize:CGSizeMake(operatorsView.frame.size.width, numberOfButtons*heightOfNumberButton)];
}


- (void)printInputNumbers{
    NSString *resultString = @"";
    for(NSString *eachNumber in inputNumbers){
        if ([inputNumbers count] > 1 && [resultString length] > 0) {
            resultString = [NSString stringWithFormat:@"%@;\n%@", eachNumber, resultString];
        }
        else{
            resultString = [NSString stringWithFormat:@"%@", eachNumber];
        }
    }
    resultView.text = resultString;
}


//shake to clear all
- (BOOL)canBecomeFirstResponder{
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    //clear contnet when user shake the device
    [self clearAll];
}

- (void)clearAll{
    inputNumbers = [[NSMutableArray alloc] init];
    resultView.text = @"";
    resultLabel.text = @"0.0";
    numberBuffer = @"";
}


#pragma mark - view controller methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initialCalculatorView];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    [self initialCalculatorView];
    if (interfaceOrientation == UIInterfaceOrientationPortrait) {
        MAX_NUMBER = 9;
    }
    else{
        MAX_NUMBER = 16;
    }
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
