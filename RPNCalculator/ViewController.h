//
//  ViewController.h
//  RPNCalculator
//
//  Created by Liang Shi on 2012-09-06.
//  Copyright (c) 2012 Liang Shi. All rights reserved.
//

#import <UIKit/UIKit.h>


//define operators
static NSString *ADD = @"+";
static NSString *MINUS = @"-";
static NSString *DIVIDE = @"\u00F7";
static NSString *MULTIPLY = @"*";//@"\u00D7";
static NSString *SQUARE = @"x\u00B2";
static NSString *SQUAREROOT = @"\u221Ax";
static NSString *INVERT = @"1/x";
static NSString *SIN = @"Sin";
static NSString *COS = @"Cos";
static NSString *TAN = @"Tan";
static NSString *CLEAR = @"c";
static NSString *PI = @"\u03C0";

@interface ViewController : UIViewController<UITextViewDelegate, UITextFieldDelegate>{
    
    NSMutableArray *inputNumbers;
    
    UIView *numberpadView;
    UIScrollView *operatorsView;
    UILabel *resultLabel;
    UITextView *resultView;
    
    NSString *numberBuffer;
}

@property (nonatomic, strong) NSMutableArray *inputNumbers;
@property (nonatomic, strong) IBOutlet UIView *numberpadView;
@property (nonatomic, strong) IBOutlet UIScrollView *operatorsView;
@property (nonatomic, strong) IBOutlet UILabel *resultLabel;
@property (nonatomic, strong) IBOutlet UITextView *resultView;
@property (nonatomic, strong) NSString *numberBuffer;
@end
