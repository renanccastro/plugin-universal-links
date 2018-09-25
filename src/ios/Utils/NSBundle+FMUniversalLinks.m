//
//  NSBundle+FMUniversalLinks.m
//
//  Created by Nikolay Demyankov on 15.09.15.
//

#import "NSBundle+FMUniversalLinks.h"

@implementation NSBundle (FMUniversalLinks)

+ (NSString*)pathToCordovaConfigXml {
	return [[NSBundle mainBundle] pathForResource:@"config" ofType:@"xml"];
}

@end
