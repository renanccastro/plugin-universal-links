#!/usr/bin/env node

/*
Hook executed before the 'prepare' stage. Only for iOS project.
It will check if project name has changed. If so - it will change the name of the .entitlements file to remove that file duplicates.
If file name has no changed - hook will do nothing.
*/

const path            = require( "path" );
const fs              = require( "fs" );
const ConfigXmlHelper = require( "./lib/configXmlHelper.js" );

module.exports = context => {
	run( context );
};

/**
 * Run the hook logic.
 *
 * @param {Object} context - cordova context object
 */
function run( context ) {
	const projectRoot        = context.opts.projectRoot;
	const iosProjectFilePath = path.join( projectRoot, "platforms", "ios" );
	const configXmlHelper    = new ConfigXmlHelper( context );
	const newProjectName     = configXmlHelper.getProjectName();

	const oldProjectName = getOldProjectName( iosProjectFilePath );

	// if name has not changed - do nothing
	if( oldProjectName.length && oldProjectName === newProjectName ) {
		return;
	}

	// eslint-disable-next-line no-console
	console.log( "Project name has changed. Renaming .entitlements file." );

	// if it does - rename it
	const oldEntitlementsFilePath = path.join( iosProjectFilePath, oldProjectName, "Resources", `${oldProjectName}.entitlements` );
	const newEntitlementsFilePath = path.join( iosProjectFilePath, oldProjectName, "Resources", `${newProjectName}.entitlements` );

	try {
		fs.renameSync( oldEntitlementsFilePath, newEntitlementsFilePath );
	} catch( err ) {
		/* eslint-disable no-console */
		console.warn( "Failed to rename .entitlements file." );
		console.warn( err );
	/* eslint-enable no-console */
	}
}

// region Private API

/**
 * Get old name of the project.
 * Name is detected by the name of the .xcodeproj file.
 *
 * @param {String} projectDir absolute path to ios project directory
 * @return {String} old project name
 */
function getOldProjectName( projectDir ) {
	let files = [];
	try {
		files = fs.readdirSync( projectDir );
	} catch( err ) {
		return "";
	}

	let projectFile = "";
	files.forEach( fileName => {
		if( path.extname( fileName ) === ".xcodeproj" ) {
			projectFile = path.basename( fileName, ".xcodeproj" );
		}
	} );

	return projectFile;
}

// endregion
