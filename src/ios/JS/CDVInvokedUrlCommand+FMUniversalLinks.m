//
//  CDVInvokedUrlCommand+FMUniversalLinks.m
//
//  Created by Nikolay Demyankov on 08.12.15.
//

#import "CDVInvokedUrlCommand+FMUniversalLinks.h"

@implementation CDVInvokedUrlCommand (FMUniversalLinks)

- (NSString*)eventName {
	if (self.arguments.count == 0) {
		return nil;
	}

	return self.arguments[0];
}

@end
