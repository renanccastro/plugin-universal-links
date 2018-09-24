//
//  AppDelegate+CDVUniversalLinks.m
//
//  Created by Nikolay Demyankov on 15.09.15.
//

#import "AppDelegate+CDVUniversalLinks.h"
#import "CDVUniversalLinks.h"

/**
 *  Plugin name in config.xml
 */
static NSString *const PLUGIN_NAME = @"UniversalLinks";

@implementation AppDelegate (CDVUniversalLinks)

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray *))restorationHandler {
    // ignore activities that are not for Universal Links
    if (![userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb] || userActivity.webpageURL == nil) {
        return NO;
    }

    // get instance of the plugin and let it handle the userActivity object
    CDVUniversalLinks *plugin = [self.viewController getCommandInstance:PLUGIN_NAME];
    if (plugin == nil) {
        return NO;
    }

    return [plugin handleUserActivity:userActivity];
}

@end
