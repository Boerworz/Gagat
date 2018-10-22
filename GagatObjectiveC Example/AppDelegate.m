#import "AppDelegate.h"
#import "StyleableNavigationController.h"
#import "StyleableViewController.h"
@import GagatObjectiveC.Swift;

@interface AppDelegate ()

@property (nonatomic) GGTTransitionHandle *transitionHandle;

@end

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	self.window = [[UIWindow alloc] init];

	StyleableNavigationController *navigationController = [[StyleableNavigationController alloc] initWithRootViewController:[[StyleableViewController alloc] init]];
	self.window.rootViewController = navigationController;

	// Configure Gagat for the applications only window using a jelly factor that is
	// slightly larger than the default factor of 1.0. We'll use the root view controller
	// as the styleable object, but you can use any object that conforms to `GGTStyleable`.
	//
	// Note: Make sure you keep a reference to the value returned from `configureForWindow:withStyleableObject:usingConfiguration:`.
	// If this object is deallocated then the Gagat transition will no longer work.
	GGTConfiguration *configuration = [[GGTConfiguration alloc] initWithJellyFactor:1.5];
	self.transitionHandle = [GGTManager configureForWindow:self.window withStyleableObject:navigationController usingConfiguration:configuration];

	[self.window makeKeyAndVisible];

	return YES;
}

@end
