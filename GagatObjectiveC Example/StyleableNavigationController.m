#import "StyleableNavigationController.h"

@interface StyleableNavigationController ()

@property (nonatomic) BOOL useDarkMode;

@end

@implementation StyleableNavigationController

- (void)styleTransitionWillBegin {
	// Do any work you might need to do once the transition has completed.
	UIViewController *topViewController = self.topViewController;
	if ([topViewController conformsToProtocol:@protocol(GGTStyleable)]) {
		[(id<GGTStyleable>)topViewController styleTransitionWillBegin];
	}
}

- (void)styleTransitionDidEnd {
	// Do any work you might need to do once the transition has completed.
	UIViewController *topViewController = self.topViewController;
	if ([topViewController conformsToProtocol:@protocol(GGTStyleable)]) {
		[(id<GGTStyleable>)topViewController styleTransitionDidEnd];
	}
}

- (void)toggleActiveStyle {
	self.useDarkMode = !self.useDarkMode;

	// It's up to us to get any child view controllers to
	// toggle their active style. In this example application we've made
	// the child view controller also conform to `GGTStyleable`, but
	// this is not required by Gagat.
	UIViewController *topViewController = self.topViewController;
	if ([topViewController conformsToProtocol:@protocol(GGTStyleable)]) {
		[(id<GGTStyleable>)topViewController toggleActiveStyle];
	}
}

- (void)setUseDarkMode:(BOOL)useDarkMode {
	_useDarkMode = useDarkMode;

	self.navigationBar.barStyle = useDarkMode ? UIBarStyleBlack : UIBarStyleDefault;
}

@end
