//
//  ROSlidingPageController.h
//  Pods
//
//  Created by Heather Snepenger on 11/7/14.
//
//

#import <UIKit/UIKit.h>
#import <PureLayout/PureLayout.h>

@interface ROSwipenger : UIViewController

@property (strong, nonatomic) NSArray *titles;
@property (strong, nonatomic) NSArray *childViewControllers;

// Colors
@property (strong, nonatomic) UIColor *titleBarBackground;
@property (strong, nonatomic) UIColor *titleTextColor;
@property (strong, nonatomic) UIColor *scrollIndicatorColor;

// Font
@property (strong, nonatomic) UIFont *titleFont;

// Dimensions
@property (assign, nonatomic) CGFloat titleBackgroundHeight;
@property (assign, nonatomic) NSInteger titlePadding;
@property (assign, nonatomic) NSInteger scrollIndicatorHeight;
@property (assign, nonatomic) NSInteger defaultScrollIndicatorWidth;

@property (assign, nonatomic) BOOL scrollIndicatorAutoFitTitleWidth;

- (id) initWithTitles:(NSArray *)titles andViewControllers:(NSArray *)viewControllers;

@end
