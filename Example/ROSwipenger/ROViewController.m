//
//  ROViewController.m
//  ROSlidingPageController
//
//  Created by Heather Snepenger on 11/07/2014.
//  Copyright (c) 2014 Heather Snepenger. All rights reserved.
//

#import "ROViewController.h"
#import <ROSwipenger/ROSwipenger.h>
#import "ImageViewController.h"

@interface ROViewController ()

@property (strong, nonatomic) UIButton *button;

@end

@implementation ROViewController

- (void)loadView {
    
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    [view setBackgroundColor:[UIColor greenColor]];
    self.view = view;
    
    self.button = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.button setTitle:@"Click Me" forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(showViewController) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.button];
    self.button.frame = CGRectMake(100, 100, 100, 40);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
}

- (void) showViewController {
    
    ImageViewController *dummy1 = [ImageViewController new];
    dummy1.image = [UIImage imageNamed:@"Brian.jpg"];
    
    ImageViewController *dummy2 = [ImageViewController new];
    dummy2.image = [UIImage imageNamed:@"Rob.jpg"];
    
    ImageViewController *dummy3 = [ImageViewController new];
    dummy3.image = [UIImage imageNamed:@"Heather.jpg"];
    
    ImageViewController *dummy4 = [ImageViewController new];
    dummy4.image = [UIImage imageNamed:@"Steve.jpg"];
    
    ImageViewController *dummy5 = [ImageViewController new];
    dummy5.image = [UIImage imageNamed:@"Kyle.jpg"];
    
    ImageViewController *dummy6 = [ImageViewController new];
    dummy6.image = [UIImage imageNamed:@"Ben.jpg"];
    
    ImageViewController *dummy7 = [ImageViewController new];
    dummy7.image = [UIImage imageNamed:@"Jordan.jpg"];
    
    ImageViewController *dummy8 = [ImageViewController new];
    dummy8.image = [UIImage imageNamed:@"Andrew.jpg"];
    
//    ROSwipenger *controller = [[ROSwipenger alloc] initWithTitles:@[@"Brian", @"Rob", @"Heather", @"Steve", @"Kyle", @"Ben", @"Jordan", @"Andrew"] andViewControllers:@[dummy1, dummy2, dummy3, dummy4, dummy5, dummy6, dummy7, dummy8]];
    
    NSDictionary *attributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                                 NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0],
                                 NSKernAttributeName: @2};
    
    ROSwipenger *controller = [[ROSwipenger alloc] initWithAttributedTitles:@[[[NSAttributedString alloc] initWithString:@"Brian" attributes:attributes], [[NSAttributedString alloc] initWithString:@"Rob" attributes:attributes], [[NSAttributedString alloc] initWithString:@"Heather123123" attributes:attributes]] andViewControllers:@[dummy1, dummy2, dummy3]];
    [controller setScrollIndicatorColor:[UIColor blackColor]];
    [controller setScrollIndicatorAutoFitTitleWidth:YES];
    [controller setTitleFont:[UIFont fontWithName:@"Cochin" size:19]];

    [self presentViewController:controller animated:YES completion:nil];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [controller addTitle:[[NSAttributedString alloc] initWithString:@"Kyle" attributes:attributes] withViewController:dummy5 atIndex:1];
//    });
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(7.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [controller removeTitleAtIndex:0];
//    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
