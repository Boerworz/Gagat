#import "StyleableViewController.h"

@interface StyleableViewController ()

@property (nonatomic) BOOL useDarkMode;
@property (nonatomic) UILabel *label;

@end

@implementation StyleableViewController

- (void)loadView {
	self.label = [[UILabel alloc] init];
	self.label.text = @"Gagat";
	self.label.textAlignment = NSTextAlignmentCenter;
	self.view = self.label;

	self.title = @"Gagat";
}

- (void)viewDidLoad {
	[super viewDidLoad];

	[self applyStyle];
}

- (void)styleTransitionWillBegin {
	// Do any work you might need to do once the transition has completed.
}

- (void)styleTransitionDidEnd {
	// Do any work you might need to do once the transition has completed.
}

- (void)toggleActiveStyle {
	self.useDarkMode = !self.useDarkMode;
}

- (void)setUseDarkMode:(BOOL)useDarkMode {
	_useDarkMode = useDarkMode;
	[self applyStyle];
}

- (void)applyStyle {
	self.view.backgroundColor = self.useDarkMode ? [UIColor colorWithWhite:0.15f alpha:1] : UIColor.whiteColor;
	self.label.textColor = self.useDarkMode ? UIColor.lightTextColor : UIColor.darkTextColor;
}

@end
