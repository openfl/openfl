package openfl.desktop;

#if (haxe4 && sys && !flash)
import openfl.Vector;
import openfl.filesystem.File;

/**
	This class provides the basic information used to start a process on the
	host operating system. It is constructed and passed to the `start()` method
	of a NativeProcess object.

	Native process access is only available to AIR applications installed with
	native installers (applications in the extended desktop profile) and Haxe
	"sys" targets.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class NativeProcessStartupInfo
{
	/**
		Constructs an empty NativeProcessStartupInfo object.
	**/
	public function new() {}

	/**
		The command line arguments that will be passed to the process on
		startup.

		Each string in the `arguments` Vector will be passed as a separate
		argument to the executable, regardless of what characters the string
		contains. In other words, there is an exact one-to-one correspondence;
		no re-interpretation occurs. AIR automatically escapes any characters
		in the string that need to be escaped (such as space characters).
	**/
	public var arguments:Vector<String>;

	/**
		The File object that references an executable on the host operating
		system. This should be the full path to the executable including any
		extension required.

		**Note:** On Mac OS, to launch an executable within an application
		bundle, be sure to have the path of the File object include the full
		path the the executable (within the bundle), not just the path to the
		app file.
	**/
	public var executable:File;

	/**
		The File object that references the initial working directory for the
		new native process. If assigned a value where isDirectory is false, an
		ArgumentError is thrown.
	**/
	public var workingDirectory:File;
}
#else
#if air
typedef NativeProcessStartupInfo = flash.desktop.NativeProcessStartupInfo;
#end
#end
