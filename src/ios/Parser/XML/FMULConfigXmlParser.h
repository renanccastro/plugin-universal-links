//
//  FMULConfigXmlParser.h
//
//  Created by Nikolay Demyankov on 15.09.15.
//

#import <Foundation/Foundation.h>
#import "FMULHost.h"

/**
 *  Parser for config.xml. Reads only plugin-specific preferences.
 */
@interface FMULConfigXmlParser : NSObject

/**
 *  Parse config.xml
 *
 *  @return list of hosts, defined in the config file
 */
+ (NSArray<FMULHost*>*)parse;

@end
