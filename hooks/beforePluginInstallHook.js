#!/usr/bin/env node

/**
Hook is executed when plugin is added to the project.
It will check all necessary module dependencies and install the missing ones locally.
*/

const path                        = require( "path" );
const fs                          = require( "fs" );
const spawnSync                   = require( "child_process" ).spawnSync;
const pluginNpmDependencies       = require( "../package.json" ).dependencies;
const INSTALLATION_FLAG_FILE_NAME = ".npmInstalled";

// region mark that we installed npm packages
/**
 * Check if we already executed this hook.
 *
 * @param {Object} context - cordova context
 * @return {Boolean} true if already executed; otherwise - false
 */
function isInstallationAlreadyPerformed( context ) {
	const pathToInstallFlag = path.join( context.opts.projectRoot, "plugins", context.opts.plugin.id, INSTALLATION_FLAG_FILE_NAME );
	try {
		fs.accessSync( pathToInstallFlag, fs.F_OK );
		return true;
	} catch( err ) {
		return false;
	}
}

/**
 * Create empty file - indicator, that we tried to install dependency modules after installation.
 * We have to do that, or this hook is gonna be called on any plugin installation.
 */
function createPluginInstalledFlag( context ) {
	const pathToInstallFlag = path.join( context.opts.projectRoot, "plugins", context.opts.plugin.id, INSTALLATION_FLAG_FILE_NAME );

	fs.closeSync( fs.openSync( pathToInstallFlag, "w" ) );
}
// endregion

module.exports = context => {
	if( isInstallationAlreadyPerformed( context ) ) {
		return;
	}

	/* eslint-disable no-console */
	console.log( "Installing dependency packages: " );
	console.log( JSON.stringify( pluginNpmDependencies, null, 2 ) );
	/* eslint-enable no-console */

	const npm    = ( process.platform === "win32" ? "npm.cmd" : "npm" );
	const result = spawnSync( npm, [ "install", "--production" ], {
		cwd : `./plugins/${context.opts.plugin.id}`
	} );
	if( result.error ) {
		throw result.error;
	}

	createPluginInstalledFlag( context );
};
