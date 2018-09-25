//
//  FMULPath.m
//
//  Created by Nikolay Demyankov on 15.09.15.
//

#import "FMULPath.h"

@implementation FMULPath

- (instancetype)initWithUrlPath:(NSString*)urlPath andEvent:(NSString*)event {
	self = [super init];
	if (self) {
		_url = [urlPath stringByReplacingOccurrencesOfString:@"*" withString:@".*"].lowercaseString;
		_event = event;
	}

	return self;
}

@end
