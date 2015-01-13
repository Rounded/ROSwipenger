//
//  ROSlidingPageController.m
//  Pods
//
//  Created by Heather Snepenger on 11/7/14.
//
//


#import "ROSwipenger.h"

#define TITLE_TAG_OFFSET 304
#define VC_TAG_OFFSET 832

#define SCROLL_CONTAINER_WIDTH 0

@interface ROSwipenger () <UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *titleScrollView;
@property (strong, nonatomic) UIView *titleContainer;
@property (strong, nonatomic) UIScrollView *pagingScrollView;
@property (strong, nonatomic) UIView *pagingContainer;

@property (strong, nonatomic) UIView *scrollIndicator;
@property (strong, nonatomic) UIView *scrollIndicatorContainer;
@property (strong, nonatomic) NSLayoutConstraint *leftOffsetConstraint;
@property (strong, nonatomic) NSLayoutConstraint *heightConstraint;
@property (strong, nonatomic) NSLayoutConstraint *widthConstraint;

@property (strong, nonatomic) NSLayoutConstraint *titleBackgroundHeightConstraint;

@property (assign, nonatomic) NSInteger currentPage;
@property (assign, nonatomic) CGFloat lastContentOffset;
@property (assign, nonatomic) CGFloat startingPageCenter;
@property (assign, nonatomic) BOOL buttonScrolling;


// defaults
@property (assign, nonatomic) NSInteger minTitleWidth;
@property (assign, nonatomic) CGFloat disabledTitleAlpha;
@property (assign, nonatomic) NSInteger childViewControllerWidth;

@property (assign, nonatomic) BOOL viewJustLoaded;

@end

@implementation ROSwipenger

- (id) initWithTitles:(NSArray *)titles andViewControllers:(NSArray *)viewControllers
{
    self = [super init];
    if (self) {
        self.scrollIndicatorAutoFitTitleWidth = YES;
        self.titles = titles;
        self.childViewControllers = viewControllers;
        
        self.currentPage = 0;
        
        // Make sure there are the same count of titles to view controllers
        assert(self.titles.count == self.childViewControllers.count);
    }
    return self;
}

- (id) initWithAttributedTitles:(NSArray *)attributedTitles andViewControllers:(NSArray *)viewControllers
{
    self = [super init];
    if (self) {
        self.scrollIndicatorAutoFitTitleWidth = YES;
        self.titles = attributedTitles;
        self.childViewControllers = viewControllers;
        
        self.currentPage = 0;
        
        // Make sure there are the same count of titles to view controllers
        assert(self.titles.count == self.childViewControllers.count);
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    [self setDefaultValues];
    [self setupViews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewJustLoaded = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // After the view is displayed, show the scroll indicator
    if (self.titles.count > 0 && self.viewJustLoaded) {
        UIButton *firstButton = (UIButton *)[self.titleContainer viewWithTag:0 + TITLE_TAG_OFFSET];
        [self moveIndicatorUnderneathButton:firstButton];
        self.scrollIndicatorContainer.hidden = NO;
    }

    self.viewJustLoaded = NO;
}

- (void)setDefaultValues {
    if (!self.titlePadding)
        self.titlePadding = 50;
    
    if (!self.minTitleWidth)
        self.minTitleWidth = 80;
    
    if (!self.defaultScrollIndicatorWidth)
        self.defaultScrollIndicatorWidth = 80;
    
    if (!self.scrollIndicatorColor)
        self.scrollIndicatorColor = [UIColor grayColor];

    if (!self.scrollIndicatorHeight)
        self.scrollIndicatorHeight = 4;
    
    if (!self.childViewControllerWidth)
        self.childViewControllerWidth = 320;
    
    if (!self.titleBarBackground)
        self.titleBarBackground = [UIColor darkGrayColor];
    
    if (!self.titleTextColor)
        self.titleTextColor = [UIColor whiteColor];
    
    if (!self.titleBackgroundHeight)
        self.titleBackgroundHeight = 60.0f;
    
    self.disabledTitleAlpha = 0.5f;
}

- (void)setupViews {
    
    self.currentPage = 0;
    self.startingPageCenter = self.childViewControllerWidth / 2;
    
    [self.view addSubview:self.titleScrollView];
    
    self.titleScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.titleScrollView addSubview:self.titleContainer];
    [self.titleScrollView addSubview:self.scrollIndicatorContainer];
    [self.scrollIndicatorContainer addSubview:self.scrollIndicator]; // the scrollIndicatorContainer has a constant width
    
    [self.view addSubview:self.pagingScrollView];
    [self.pagingScrollView addSubview:self.pagingContainer];
    
    
    [self addTitles];

    [self loadViewControllerAtIndex:0];
    [self loadViewControllerAtIndex:1];
    
    [self updateConstraints];
    [self.view setNeedsUpdateConstraints];
    
}

- (void)updateConstraints {
    
    [self.titleScrollView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
    self.titleBackgroundHeightConstraint = [self.titleScrollView autoSetDimension:ALDimensionHeight toSize:self.titleBackgroundHeight];
    [self.titleContainer autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    [self.titleContainer autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.titleScrollView];
    
    // Set the scrollIndicator constraints
    [self updateScrollIndicatorHeight];
    [self.scrollIndicatorContainer autoSetDimension:ALDimensionWidth toSize:SCROLL_CONTAINER_WIDTH];
    self.heightConstraint = [self.scrollIndicatorContainer autoSetDimension:ALDimensionHeight toSize:self.scrollIndicatorHeight];
    [self.scrollIndicatorContainer autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    self.leftOffsetConstraint = [self.scrollIndicatorContainer autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.titleContainer withOffset:self.titlePadding];


    [self.scrollIndicator autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    [self.scrollIndicator autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [self.scrollIndicator autoAlignAxisToSuperviewAxis:ALAxisVertical];
    self.widthConstraint = [self.scrollIndicator autoSetDimension:ALDimensionWidth toSize:self.minTitleWidth/2];
    
    
    [self.pagingScrollView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    [self.pagingScrollView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.titleScrollView withOffset:0];
    
    [self.pagingContainer autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.pagingScrollView];
    [self.pagingContainer autoSetDimension:ALDimensionWidth toSize:self.childViewControllerWidth * self.titles.count];
    [self.pagingContainer autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    
    [super updateViewConstraints];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addTitles {
    
    for (int i = 0; i < self.titles.count; i++) {
        NSObject *titleObject = self.titles[i];
        UIButton *button;
        if ([titleObject isKindOfClass:[NSString class]]) {
            button = [self newButtonWithTitle:(NSString *)titleObject];
        } else if ([titleObject isKindOfClass:[NSAttributedString class]]) {
            button = [self newButtonWithAttributedString:(NSAttributedString *)titleObject];
        }

        button.alpha = self.disabledTitleAlpha;
        button.tag = i + TITLE_TAG_OFFSET;
        button.translatesAutoresizingMaskIntoConstraints = NO;
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 7, 0, 7);
        [button addTarget:self action:@selector(moveIndicatorUnderneathButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.titleContainer addSubview:button];
        
        if (i == 0) {
            [button autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:self.titlePadding / 2];
            [button autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        } else {
            [button autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:[self.view viewWithTag:i + TITLE_TAG_OFFSET - 1] withOffset:self.titlePadding / 2];
            [button autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
            if (i == self.titles.count - 1) {
                [button autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.titleContainer withOffset:-self.titlePadding / 2];
            }
        }
    }
    
}

- (UIButton *)newButtonWithTitle:(NSString *)title {
    UIButton *button = [UIButton newAutoLayoutView];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:self.titleTextColor forState:UIControlStateNormal];
    if (self.titleFont) {
        [button.titleLabel setFont:self.titleFont];
    }
    return button;
}

- (UIButton *)newButtonWithAttributedString:(NSAttributedString *)title {
    UIButton *button = [UIButton newAutoLayoutView];
    [button setAttributedTitle:title forState:UIControlStateNormal];
    return button;
}


- (void) loadViewControllerAtIndex:(NSInteger)index {
    
    if (index > self.childViewControllers.count - 1)
        return;
    
    
    UIViewController *childViewController = self.childViewControllers[index];
    if (!childViewController.view.superview) {
        
        [childViewController.view setTag:(index + VC_TAG_OFFSET)];
        
        [self addChildViewController:childViewController];
        [self.pagingContainer addSubview:childViewController.view];
        [childViewController didMoveToParentViewController:self];
        
        [childViewController.view autoSetDimension:ALDimensionWidth toSize:self.childViewControllerWidth];
        [childViewController.view autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.pagingContainer];
        
        [childViewController.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, index * self.childViewControllerWidth, 0, 0) excludingEdge:ALEdgeRight];
    }
}


- (void) moveIndicatorUnderneathButton:(UIButton *)button {
    [self fadeOutOldButton:[self.titleContainer viewWithTag:self.currentPage + TITLE_TAG_OFFSET]];
    self.currentPage = button.tag - TITLE_TAG_OFFSET;
    [self fadeInNewButton:button];
    
    if (self.scrollIndicatorAutoFitTitleWidth) {
        self.widthConstraint.constant = button.frame.size.width;
    }
    self.buttonScrolling = YES;
    self.leftOffsetConstraint.constant = button.center.x;
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self.view layoutIfNeeded];
                     } completion:^(BOOL finished) {
                         self.buttonScrolling = NO;
                     }];
    
    [self.pagingScrollView setContentOffset:CGPointMake(self.currentPage * self.childViewControllerWidth, self.pagingScrollView.contentOffset.y) animated:YES];
    
    
    // If the title is on the left hand side of the screen move the title bar over
    if ((button.frame.origin.x - self.titleScrollView.contentOffset.x) < self.titlePadding && self.currentPage > 0) {
        [self.titleScrollView setContentOffset:CGPointMake(self.titleScrollView.contentOffset.x - [self.titleContainer viewWithTag:self.currentPage + TITLE_TAG_OFFSET - 1].frame.size.width - self.titlePadding / 2, self.titleScrollView.contentOffset.y) animated:YES];
    }
    
    // If the title is on the right hand side of the screen, move the title bar over to the right
    if (((button.frame.origin.x + button.frame.size.width) - self.titleScrollView.contentOffset.x) > (self.childViewControllerWidth - self.titlePadding) && self.currentPage < self.titles.count - 1) {
        [self.titleScrollView setContentOffset:CGPointMake(self.titleScrollView.contentOffset.x + [self.titleContainer viewWithTag:self.currentPage + TITLE_TAG_OFFSET + 1].frame.size.width + self.titlePadding / 2, self.titleScrollView.contentOffset.y) animated:YES];
    }
    [self loadViewControllerAtIndex:self.currentPage - 1];
    [self loadViewControllerAtIndex:self.currentPage];
    [self loadViewControllerAtIndex:self.currentPage + 1];
}

- (void)updateScrollIndicatorHeight {
    self.heightConstraint.constant = self.scrollIndicatorHeight;
    
    // Round the corners of the bar
    self.scrollIndicator.layer.cornerRadius = self.scrollIndicatorHeight / 2;
}

#pragma mark - ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.pagingScrollView && !self.buttonScrolling) {

        if (self.pagingScrollView.contentOffset.x < 0 || (self.titles.count - 1) * self.childViewControllerWidth < self.pagingScrollView.contentOffset.x) {
            return;
        }

        CGFloat titleDistance;
        // get the distance based on direction of swipe
        if (self.lastContentOffset > self.pagingScrollView.contentOffset.x) {
            titleDistance = abs([self.titleContainer viewWithTag:(self.currentPage + TITLE_TAG_OFFSET)- 1].center.x - [self.titleContainer viewWithTag:(self.currentPage + TITLE_TAG_OFFSET)].center.x);
            
        } else {
            titleDistance = abs([self.titleContainer viewWithTag:(self.currentPage + TITLE_TAG_OFFSET)].center.x - [self.titleContainer viewWithTag:(self.currentPage + TITLE_TAG_OFFSET + 1)].center.x);
        }
        
        self.lastContentOffset = self.pagingScrollView.contentOffset.x;
        
        float b = titleDistance / self.childViewControllerWidth;
        float a = [self.titleContainer viewWithTag:(self.currentPage + TITLE_TAG_OFFSET)].center.x - b * (self.currentPage * self.childViewControllerWidth);
        
        self.leftOffsetConstraint.constant = (titleDistance / self.childViewControllerWidth) * self.pagingScrollView.contentOffset.x + a;
        
        [self.view layoutIfNeeded];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    int page = self.pagingScrollView.contentOffset.x / self.childViewControllerWidth;
    self.startingPageCenter = [self.pagingScrollView viewWithTag:(page + VC_TAG_OFFSET)].center.x;
    UIButton *currentButton = (UIButton *)[self.titleContainer viewWithTag:(page + TITLE_TAG_OFFSET)];
    
    [self moveIndicatorUnderneathButton:currentButton];
}

- (CGFloat) computeIndicatorOffset:(CGFloat)scrollViewOffset {
    return scrollViewOffset * (self.titlePadding + self.minTitleWidth) / self.childViewControllerWidth;
}

- (CGFloat) distanceBetweenTitles:(UIButton *)title1 andTitle2:(UIButton *)title2 {
    return abs(title2.center.x - title1.center.x);
}

- (void) fadeOutOldButton:(UIView *)button {
    [UIView animateWithDuration:0.3
                     animations:^{
                         button.alpha = self.disabledTitleAlpha;
                     }];
    
}

- (void) fadeInNewButton:(UIView *)button {
    [UIView animateWithDuration:0.3
                     animations:^{
                         button.alpha = 1.0;
                     }];
}

#pragma mark - Getters
- (UIScrollView *)titleScrollView {
    if (!_titleScrollView) {
        _titleScrollView = [UIScrollView newAutoLayoutView];
        _titleScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _titleScrollView;
}

- (UIScrollView *)pagingScrollView {
    if (!_pagingScrollView) {
        _pagingScrollView = [UIScrollView newAutoLayoutView];
        _pagingScrollView.pagingEnabled = YES;
        _pagingScrollView.delegate = self;
    }
    return _pagingScrollView;
}

- (UIView *)titleContainer {
    if (!_titleContainer) {
        _titleContainer = [UIView newAutoLayoutView];
    }
    return _titleContainer;
}

- (UIView *)scrollIndicator {
    if (!_scrollIndicator) {
        _scrollIndicator = [UIView newAutoLayoutView];
        _scrollIndicator.backgroundColor = self.scrollIndicatorColor;
    }
    return _scrollIndicator;
}

- (UIView *)scrollIndicatorContainer {
    if (!_scrollIndicatorContainer) {
        _scrollIndicatorContainer = [UIView newAutoLayoutView];
        _scrollIndicatorContainer.backgroundColor = [UIColor clearColor];
        _scrollIndicatorContainer.hidden = YES;
    }
    return _scrollIndicatorContainer;
}

- (UIView *)pagingContainer {
    if (!_pagingContainer) {
        _pagingContainer = [UIView newAutoLayoutView];
        _pagingContainer.backgroundColor = [UIColor clearColor];
    }
    return _pagingContainer;
}

#pragma mark - Setters
- (void)setScrollIndicatorAutoFitTitleWidth:(BOOL)scrollIndicatorAutoFitTitleWidth {
    _scrollIndicatorAutoFitTitleWidth = scrollIndicatorAutoFitTitleWidth;
    self.widthConstraint.constant = self.defaultScrollIndicatorWidth;
}

- (void)setScrollIndicatorColor:(UIColor *)scrollIndicatorColor {
    _scrollIndicatorColor = scrollIndicatorColor;
    self.scrollIndicator.backgroundColor = scrollIndicatorColor;
}

- (void)setScrollIndicatorHeight:(NSInteger)scrollIndicatorHeight {
    _scrollIndicatorHeight = scrollIndicatorHeight;
    [self updateScrollIndicatorHeight];
}

- (void)setTitleBarBackground:(UIColor *)titleBarBackground {
    _titleBarBackground = titleBarBackground;
    self.titleScrollView.backgroundColor = self.titleBarBackground;
}

- (void)setTitleTextColor:(UIColor *)titleTextColor {
    _titleTextColor = titleTextColor;
    for (int i = 0; i < self.titles.count; i++) {
        UIButton *button = (UIButton *)[self.titleContainer viewWithTag:(i + TITLE_TAG_OFFSET)];
        if (button) {
            [button setTitleColor:self.titleTextColor forState:UIControlStateNormal];
        }
    }
}

- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    for (int i = 0; i < self.titles.count; i++) {
        UIButton *button = (UIButton *)[self.titleContainer viewWithTag:(i + TITLE_TAG_OFFSET)];
        if (button) {
            [button.titleLabel setFont:self.titleFont];
        }
    }
}

- (void)setTitleBackgroundHeight:(CGFloat)titleBackgroundHeight {
    _titleBackgroundHeight = titleBackgroundHeight;
    self.titleBackgroundHeightConstraint.constant = titleBackgroundHeight;
}

@end
