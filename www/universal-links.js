"use strict";

const exec = require( "cordova/exec" );

// Reference name for the plugin
const PLUGIN_NAME = "UniversalLinks";

// Default event name that is used by the plugin
const DEFAULT_EVENT_NAME = "didLaunchAppFromLink";

// Plugin methods on the native side that can be called from JavaScript
const pluginNativeMethod = {
	SUBSCRIBE : "jsSubscribeForEvent",
	UNSUBSCRIBE : "jsUnsubscribeFromEvent"
};

const universalLinks = {
	/**
	 * Subscribe to event.
	 * If plugin already captured that event - callback will be called immidietly.
	 *
	 * @param {String} eventName - name of the event you are subscribing on; if null - default plugin event is used
	 * @param {Function} callback - callback that is called when event is captured
	 */
	subscribe : ( eventName, callback ) => {
		if( !callback ) {
			// eslint-disable-next-line no-console
			console.warn( "Universal Links: can't subscribe to event without a callback" );
			return;
		}

		if( !eventName ) {
			eventName = DEFAULT_EVENT_NAME;
		}

		const innerCallback = msg => {
			callback( msg.data );
		};

		exec( innerCallback, null, PLUGIN_NAME, pluginNativeMethod.SUBSCRIBE, [ eventName ] );
	},

	/**
	 * Unsubscribe from the event.
	 *
	 * @param {String} eventName - from what event we are unsubscribing
	 */
	unsubscribe : eventName => {
		if( !eventName ) {
			eventName = DEFAULT_EVENT_NAME;
		}

		exec( null, null, PLUGIN_NAME, pluginNativeMethod.UNSUBSCRIBE, [ eventName ] );
	}
};

module.exports = universalLinks;
