//
//  FMUniversalLinks.m
//
//  Created by Nikolay Demyankov on 14.09.15.
//

#import "FMUniversalLinks.h"
#import "FMULConfigXmlParser.h"
#import "FMULPath.h"
#import "FMULHost.h"
#import "CDVPluginResult+FMUniversalLinks.h"
#import "CDVInvokedUrlCommand+FMUniversalLinks.h"
#import "FMULConfigJsonParser.h"

@interface FMUniversalLinks() {
	NSArray* _supportedHosts;
	CDVPluginResult* _storedEvent;
	NSMutableDictionary<NSString*, NSString*>* _subscribers;
}

@end

@implementation FMUniversalLinks

#pragma mark Public API

- (void)pluginInitialize {
	[self localInit];
	// Can be used for testing.
	// Just uncomment, close the app and reopen it. That will simulate application launch from the link.
	// [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onResume:) name:UIApplicationWillEnterForegroundNotification object:nil];
}

//- (void)onResume:(NSNotification *)notification {
//	NSUserActivity *activity = [[NSUserActivity alloc] initWithActivityType:NSUserActivityTypeBrowsingWeb];
//	[activity setWebpageURL:[NSURL URLWithString:@"http://site2.com/news/page?q=1&v=2#myhash"]];
//
//	[self handleUserActivity:activity];
//}

- (void)handleOpenURL:(NSNotification*)notification {
	id url = notification.object;
	if (![url isKindOfClass:[NSURL class]]) {
		return;
	}

	FMULHost* host = [self findHostByURL:url];
	if (host) {
		[self storeEventWithHost:host originalURL:url];
	}
}

- (BOOL)handleUserActivity:(NSUserActivity*)userActivity {
	[self localInit];

	NSURL* launchURL = userActivity.webpageURL;
	FMULHost* host = [self findHostByURL:launchURL];
	if (host == nil) {
		return NO;
	}

	[self storeEventWithHost:host originalURL:launchURL];

	return YES;
}

- (void)onAppTerminate {
	_supportedHosts = nil;
	_subscribers = nil;
	_storedEvent = nil;

	[super onAppTerminate];
}

#pragma mark Private API

- (void)localInit {
	if (_supportedHosts) {
		return;
	}

	_subscribers = [[NSMutableDictionary alloc] init];

	// Get supported hosts from the config.xml or www/ul.json.
	// For now priority goes to json config.
	_supportedHosts = [self getSupportedHostsFromPreferences];
}

- (NSArray<FMULHost*>*)getSupportedHostsFromPreferences {
	NSString* jsonConfigPath = [[NSBundle mainBundle] pathForResource:@"ul" ofType:@"json" inDirectory:@"www"];
	if (jsonConfigPath) {
		return [FMULConfigJsonParser parseConfig:jsonConfigPath];
	}

	return [FMULConfigXmlParser parse];
}

/**
 *  Store event data for future use.
 *  If we are resuming the app - try to consume it.
 *
 *  @param host        host that matches the launch url
 *  @param originalUrl launch url
 */
- (void)storeEventWithHost:(FMULHost*)host originalURL:(NSURL*)originalUrl {
	_storedEvent = [CDVPluginResult resultWithHost:host originalURL:originalUrl];
	[self tryToConsumeEvent];
}

/**
 *  Find host entry that corresponds to launch url.
 *
 *  @param  launchURL url that launched the app
 *  @return host entry; <code>nil</code> if none is found
 */
- (FMULHost *)findHostByURL:(NSURL *)launchURL {
	NSURLComponents* urlComponents = [NSURLComponents componentsWithURL:launchURL resolvingAgainstBaseURL:YES];
	FMULHost* host = nil;
	for (FMULHost* supportedHost in _supportedHosts) {
		NSPredicate* pred = [NSPredicate predicateWithFormat:@"self LIKE[c] %@", supportedHost.name];
		if ([pred evaluateWithObject:urlComponents.host]) {
			host = supportedHost;
			break;
		}
	}

	return host;
}

#pragma mark Methods to send data to JavaScript

/**
 *  Try to send event to the web page.
 *  If there is a subscriber for the event - it will be consumed.
 *  If not - it will stay until someone subscribes to it.
 */
- (void)tryToConsumeEvent {
	if (_subscribers.count == 0 || _storedEvent == nil) {
		return;
	}

	NSString* storedEventName = [_storedEvent eventName];
	for (NSString* eventName in _subscribers) {
		if ([storedEventName isEqualToString:eventName]) {
			NSString* callbackID = _subscribers[eventName];
			[self.commandDelegate sendPluginResult:_storedEvent callbackId:callbackID];
			_storedEvent = nil;
			break;
		}
	}
}

#pragma mark Methods, available from JavaScript side

- (void)jsSubscribeForEvent:(CDVInvokedUrlCommand*)command {
	NSString* eventName = [command eventName];
	if (eventName.length == 0) {
		return;
	}

	_subscribers[eventName] = command.callbackId;
	[self tryToConsumeEvent];
}

- (void)jsUnsubscribeFromEvent:(CDVInvokedUrlCommand*)command {
	NSString* eventName = [command eventName];
	if (eventName.length == 0) {
		return;
	}

	[_subscribers removeObjectForKey:eventName];
}

@end
