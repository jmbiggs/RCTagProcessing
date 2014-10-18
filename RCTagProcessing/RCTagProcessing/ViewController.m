//
//  ViewController.m
//  RCTagProcessing
//
//  Created by Radu Ciobanu on 11/10/2014.
//  Copyright (c) 2014 Radu Ciobanu. All rights reserved.
//

#import "ViewController.h"
#import "UIButton+TextAttributeTags.h"
#import "UILabel+TextAttributeTags.h"
#import "RCTagProcessor.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UILabel *label2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *stringWithTags = @"<b>Bold</b><sup>sup</sup><sub>sub</sub><u>Underline</u><strike>strike</strike><i>Italic</i>";
    
    [self.label rc_setTaggedText:stringWithTags];
    [self.button rc_setTaggedTitle:stringWithTags forState:UIControlStateNormal];
    
    //To showcae generating attributed directly
    self.label2.attributedText = [[RCTagProcessor defaultInstance] attributedStringForText:stringWithTags];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
