//
//  FMULXmlTags.m
//
//  Created by Nikolay Demyankov on 15.09.15.
//

#import "FMULXmlTags.h"

@implementation FMULXmlTags

NSString* const kFMULMainXmlTag = @"universal-links";

NSString* const kFMULHostXmlTag = @"host";
NSString* const kFMULHostSchemeXmlAttribute = @"scheme";
NSString* const kFMULHostNameXmlAttribute = @"name";
NSString* const kFMULHostEventXmlAttribute = @"event";

NSString* const kFMULPathXmlTag = @"path";
NSString* const kFMULPathUrlXmlAttribute = @"url";
NSString* const kFMULPathEventXmlAttribute = @"event";

@end
