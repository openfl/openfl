package openfl.desktop;

#if (!flash && sys)
import openfl.errors.IllegalOperationError;
import openfl.filesystem.File;

/**
	The Updater class is used to update the currently running application with a
	different version. To use it, instantiate an Updater object and then call
	its `update()` method.

	You can test for support at run time using the `Updater.isSupported`
	property.

	_OpenFL target support:_ Not supported, except when targeting AIR.

	_Adobe AIR profile support:_ The Updater class is only supported in the
	desktop profile. It is not supported for extended desktop applications
	(applications installed with a native installer), and it is not supported on
	the AIR mobile profile or AIR for TV profiles.

	Extended desktop application (applications installed with a native
	installer) can download a new version of the native installer and launch it
	using the `File.openWithDefaultApplication()` method.
**/
class Updater
{
	/**
		The isSupported property is set to `true` if the Updater class is
		available on the current platform, otherwise it is set to `false`.
	**/
	public static var isSupported(get, never):Bool;

	private static function get_isSupported():Bool
	{
		return false;
	}

	/**
		The constructor function for the Updater class. Note that the `update()`
		method is not a static member of the class. You must instantiate an
		Updater object and call the `update()` method on it.
	**/
	public function new() {}

	/**
		Updates the currently running application with the version of the
		application contained in the specified AIR file. The application in the
		AIR file must have the same application identifier (appID) as the
		currently running application.

		Calling this method causes the current application to exit (as if the
		`NativeApplication.exit()` method had been called). This is necessary
		because Adobe AIR cannot fully update an application while the
		application is running. Upon successfully installing the new version of
		the application, the application launches. If the runtime cannot
		successfully install the new version (for example, if its application ID
		does not match the existing version), the AIR installer presents an
		error message to the user, and then the old version relaunches.

		The update process relaunches the application whether or not the update
		is successful. Updates can fail for a variety of reasons, including some
		that the application cannot control (such as the user having
		insufficient privileges to install the application). Applications should
		take care to detect failures and avoid reattempting the same failed
		update repeatedly. The resulting infinite loop would effectively disable
		the application. One way to check for a successful update is to write
		the current version number to a file before starting the update, and
		then compare that to the version number when the application is
		relaunched.

		When testing an application using the AIR Debug Launcher (ADL)
		application, calling the `update()` method results in an
		IllegalOperationError exception.

		On Mac OS, to install an updated version of an application, the user
		needs to have adequate system privileges to install to the application
		directory. On Windows or Linux, the user needs to have adminstrative
		privileges.

		If the updated version of the application requires an updated version of
		the runtime, the new runtime version is installed. To update the
		runtime, a user needs to have administrative privileges for the
		computer.

		Note: Specifying the version parameter is required for security reasons.
		By requiring the application to verify the version number in the AIR
		file, the application will not inadvertantly install an older version,
		which might contain a security vulnerability that has been fixed.
	**/
	public function update(airFile:File, version:String):Void
	{
		throw new IllegalOperationError("Not supported");
	}
}
#else
#if air
typedef Updater = flash.desktop.Updater;
#end
#end
