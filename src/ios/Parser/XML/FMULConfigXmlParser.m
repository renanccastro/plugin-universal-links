//
//  FMULConfigXmlParser.m
//
//  Created by Nikolay Demyankov on 15.09.15.
//

#import "FMULConfigXmlParser.h"
#import "NSBundle+FMUniversalLinks.h"
#import "FMULPath.h"
#import "FMULXmlTags.h"

@interface FMULConfigXmlParser() <NSXMLParserDelegate> {
	NSMutableArray<FMULHost*>* _hostsList;
	BOOL _isInsideMainTag;
	BOOL _didParseMainBlock;
	BOOL _isInsideHostBlock;
	FMULHost* _processedHost;
}

@end

@implementation FMULConfigXmlParser

#pragma mark Public API

+ (NSArray<FMULHost*>*)parse {
	FMULConfigXmlParser* parser = [[FMULConfigXmlParser alloc] init];

	return [parser parseConfig];
}

- (NSArray<FMULHost*>*)parseConfig {
	NSURL* cordovaConfigURL = [NSURL fileURLWithPath:[NSBundle pathToCordovaConfigXml]];
	NSXMLParser* configParser = [[NSXMLParser alloc] initWithContentsOfURL:cordovaConfigURL];
	if (configParser == nil) {
		NSLog(@"Failed to initialize XML parser.");
		return nil;
	}

	_hostsList = [[NSMutableArray alloc] init];
	[configParser setDelegate:self];
	[configParser parse];

	return _hostsList;
}

#pragma mark NSXMLParserDelegate implementation

- (void)parser:(NSXMLParser*)parser didStartElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qName attributes:(NSDictionary<NSString*, NSString*>*)attributeDict {
	if (_didParseMainBlock) {
		return;
	}

	if ([elementName isEqualToString:kFMULMainXmlTag]) {
		_isInsideMainTag = YES;
		return;
	}
	if (!_isInsideMainTag) {
		return;
	}

	if ([elementName isEqualToString:kFMULHostXmlTag]) {
		[self processHostTag:attributeDict];
	} else if ([elementName isEqualToString:kFMULPathXmlTag]) {
		[self processPathTag:attributeDict];
	}
}

- (void)parser:(NSXMLParser*)parser didEndElement:(NSString*)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qName {
	if (_didParseMainBlock || !_isInsideMainTag) {
		return;
	}

	if ([elementName isEqualToString:kFMULHostXmlTag]) {
		_isInsideHostBlock = NO;
		[_hostsList addObject:_processedHost];
	}
}

#pragma mark XML Processing

/**
 *  Parse host tag.
 *
 *  @param attributes host tag attributes
 */
- (void)processHostTag:(NSDictionary<NSString*, NSString*>*)attributes {
	_processedHost = [[FMULHost alloc] initWithHostName:attributes[kFMULHostNameXmlAttribute]
												scheme:attributes[kFMULHostSchemeXmlAttribute]
													event:attributes[kFMULHostEventXmlAttribute]];
	_isInsideHostBlock = YES;
}

/**
 *  Parse path tag.
 *
 *  @param attributes path tag attributes
 */
- (void)processPathTag:(NSDictionary<NSString*, NSString*>*)attributes {
	NSString* urlPath = attributes[kFMULPathUrlXmlAttribute];
	NSString* event = attributes[kFMULPathEventXmlAttribute];

	// ignore '*' paths; we don't need them here
	if ([urlPath isEqualToString:@"*"] || [urlPath isEqualToString:@".*"]) {
		// but if path has event name - set it to host
		if (event) {
			_processedHost.event = event;
		}

		return;
	}

	// if event name is empty - use one from the host
	if (event == nil) {
		event = _processedHost.event;
	}

	// create path entry
	FMULPath* path = [[FMULPath alloc] initWithUrlPath:urlPath andEvent:event];
	[_processedHost addPath:path];
}

@end
