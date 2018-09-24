//
//  NSBundle+CDVUniversalLinks.m
//
//  Created by Nikolay Demyankov on 15.09.15.
//

#import "NSBundle+CDVUniversalLinks.h"

@implementation NSBundle (CDVUniversalLinks)

+ (NSString *)pathToCordovaConfigXml {
    return [[NSBundle mainBundle] pathForResource:@"config" ofType:@"xml"];
}

@end
