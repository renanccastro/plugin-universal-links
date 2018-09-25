//
//  FMULConfigJsonParser.h
//
//  Created by Nikolay Demyankov on 29.01.17.
//

#import <Foundation/Foundation.h>
#import "FMULHost.h"

/**
 *  JSON parser for plugin's preferences.
 */
@interface FMULConfigJsonParser : NSObject

/**
 *  Parse JSON config.
 *
 *  @return list of hosts, defined in the config file
 */
+ (NSArray<FMULHost*>*)parseConfig:(NSString*)pathToJsonConfig;

@end
