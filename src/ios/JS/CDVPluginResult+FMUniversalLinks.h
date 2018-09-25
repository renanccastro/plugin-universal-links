//
//  CDVPluginResult+FMUniversalLinks.h
//
//  Created by Nikolay Demyankov on 15.09.15.
//

#import <Cordova/CDVPlugin.h>
#import "FMULHost.h"

/**
 *  Category to simplify plugin result generation.
 */
@interface CDVPluginResult (FMUniversalLinks)

/**
 *  Get CDVPluginResult instance with information about the launch url that is send to JS.
 *
 *  @param host        host that corresponds to launch url
 *  @param originalURL launching url
 *
 *  @return instance of the CDVPluginResult
 */
+ (instancetype)resultWithHost:(FMULHost*)host originalURL:(NSURL*)originalURL;

- (BOOL)isResultForEvent:(NSString*)eventName;

- (NSString *)eventName;

@end
