//
//  FMULXmlTags.h
//
//  Created by Nikolay Demyankov on 15.09.15.
//

#import <Foundation/Foundation.h>

/**
 *  XML tags that is used in config.xml to specify plugin preferences.
 */
@interface FMULXmlTags : NSObject

/**
 *  Main tag in which we define plugin related stuff
 */
extern NSString* const kFMULMainXmlTag;

/**
 *  Host main tag
 */
extern NSString* const kFMULHostXmlTag;

/**
 *  Scheme attribute for the host entry
 */
extern NSString* const kFMULHostSchemeXmlAttribute;

/**
 *  Name attribute for the host entry
 */
extern NSString* const kFMULHostNameXmlAttribute;

/**
 *  Event attribute for the host entry
 */
extern NSString* const kFMULHostEventXmlAttribute;

/**
 *  Path main tag
 */
extern NSString* const kFMULPathXmlTag;

/**
 *  Url attribute for the path entry
 */
extern NSString* const kFMULPathUrlXmlAttribute;

/**
 *  Event attribute for the path entry
 */
extern NSString* const kFMULPathEventXmlAttribute;

@end
