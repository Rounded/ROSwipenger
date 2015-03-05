# ROSwipenger

[![CI Status](http://img.shields.io/travis/Heather Snepenger/ROSwipenger.svg?style=flat)](https://travis-ci.org/Heather Snepenger/ROSwipenger)
[![Version](https://img.shields.io/cocoapods/v/ROSwipenger.svg?style=flat)](http://cocoadocs.org/docsets/ROSwipenger)
[![License](https://img.shields.io/cocoapods/l/ROSwipenger.svg?style=flat)](http://cocoadocs.org/docsets/ROSwipenger)
[![Platform](https://img.shields.io/cocoapods/p/ROSwipenger.svg?style=flat)](http://cocoadocs.org/docsets/ROSwipenger)

[![IMAGE ALT TEXT HERE](http://img.youtube.com/vi/YOUTUBE_VIDEO_ID_HERE/0.jpg)](http://www.youtube.com/watch?v=btf7v6Glbg8)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

ROSwipenger is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "ROSwipenger"


1. Create the `ROSwipenger` view controller:

    	ImageViewController *dummy1 = [ImageViewController new];
    	dummy1.image = [UIImage imageNamed:@"Brian.jpg"];
    
    	ImageViewController *dummy2 = [ImageViewController new];
    	dummy2.image = [UIImage imageNamed:@"Rob.jpg"];
    
    	ImageViewController *dummy3 = [ImageViewController new];
    	dummy3.image = [UIImage imageNamed:@"Heather.jpg"];
    
    	ROSwipenger *controller = [[ROSwipenger alloc] initWithTitles:@[@"Brian", @"Rob", @"Heather"] andViewControllers:@[dummy1, dummy2, dummy3]];

    	
    	
    	
2. Present the view controller:

		[self presentViewController:controller animated:YES completion:nil];
		
3. Customize the controller:

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




## Author

Heather Snepenger, hs@roundedco.com

## License

ROSwipenger is available under the MIT license. See the LICENSE file for more info.

