//
//  FMULHost.m
//
//  Created by Nikolay Demyankov on 15.09.15.
//

#import "FMULHost.h"

// default event name
static NSString *const DEFAULT_EVENT = @"didLaunchAppFromLink";

// default host scheme
static NSString *const DEFAULT_SCHEME = @"http";

@interface FMULHost() {
	NSMutableArray<FMULPath*>* _paths;
}

@end

@implementation FMULHost

- (instancetype)initWithHostName:(NSString*)name scheme:(NSString*)scheme event:(NSString*)event {
	self = [super init];
	if (self) {
		_event = event ? event : DEFAULT_EVENT;
		_scheme = scheme ? scheme : DEFAULT_SCHEME;
		_name = name.lowercaseString;
		_paths = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)addPath:(FMULPath*)path {
	if (path) {
		[_paths addObject:path];
	}
}

- (void)addAllPaths:(NSArray<FMULPath*>*)paths {
	if (paths) {
		[_paths addObjectsFromArray:paths];
	}
}

- (NSArray<FMULPath*>*)paths {
	return _paths;
}

@end
