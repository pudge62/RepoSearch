//
//  AppDelegate.m
//  RepoSearch
//
//

#import "AppDelegate.h"
#import "ViewController.h"

@implementation AppDelegate {
    UIWindow *_mainWindow;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _mainWindow = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    _mainWindow.rootViewController = [ViewController new];
    [_mainWindow makeKeyAndVisible];
    return YES;
}

@end
