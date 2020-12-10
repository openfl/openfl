package openfl.system;

#if !flash
import haxe.macro.Compiler;
import openfl.utils._internal.Lib;
#if lime
import lime.system.Locale;
import lime.system.System;
#end
#if linux
import sys.io.Process;
#end

/**
	The Capabilities class provides properties that describe the system and
	runtime that are hosting the application. For example, a mobile phone's
	screen might be 100 square pixels, black and white, whereas a PC screen
	might be 1000 square pixels, color. By using the Capabilities class to
	determine what capabilities the client has, you can provide appropriate
	content to as many users as possible. When you know the device's
	capabilities, you can tell the server to send the appropriate SWF files or
	tell the SWF file to alter its presentation.
	However, some capabilities of Adobe AIR are not listed as properties in
	the Capabilities class. They are properties of other classes:

	| Property | Description |
	| --- | --- |
	| `NativeApplication.supportsDockIcon` | Whether the operating system supports application doc icons. |
	| `NativeApplication.supportsMenu` | Whether the operating system supports a global application menu bar. |
	| `NativeApplication.supportsSystemTrayIcon` | Whether the operating system supports system tray icons. |
	| `NativeWindow.supportsMenu` | Whether the operating system supports window menus. |
	| `NativeWindow.supportsTransparency` | Whether the operating system supports transparent windows. |

	Do _not_ use `Capabilities.os` or `Capabilities.manufacturer` to determine
	a capability based on the operating system. Basing a capability on the
	operating system is a bad idea, since it can lead to problems if an
	application does not consider all potential target operating systems.
	Instead, use the property corresponding to the capability for which you
	are testing.

	You can send capabilities information, which is stored in the
	`Capabilities.serverString` property as a URL-encoded string, using the
	`GET` or `POST` HTTP method. The following example shows a server string
	for a computer that has MP3 support and 1600 x 1200 pixel resolution and
	that is running Windows XP with an input method editor (IME) installed:
	<pre
	xml:space="preserve">A=t&SA=t&SV=t&EV=t&MP3=t&AE=t&VE=t&ACC=f&PR=t&SP=t&
	SB=f&DEB=t&V=WIN%209%2C0%2C0%2C0&M=Adobe%20Windows&
	R=1600x1200&DP=72&COL=color&AR=1.0&OS=Windows%20XP&
	L=en&PT=External&AVD=f&LFD=f&WD=f&IME=t</pre>
	The following table lists the properties of the Capabilities class and
	corresponding server strings: <adobetable><tgroup
	<row><entry align="left">Capabilities class
	property</entry><entry align="left">Server
	string |
		|`avHardwareDisable` | `AVD` |
		|`hasAccessibility` | `ACC` |
		|`hasAudio` | `A` |
		|`hasAudioEncoder` | `AE` |
		|`hasEmbeddedVideo` | `EV` |
		|`hasIME` | `IME` |
		|`hasMP3` | `MP3` |
		|`hasPrinting` | `PR` |
		|`hasScreenBroadcast` | `SB` |
		|`hasScreenPlayback` | `SP` |
		|`hasStreamingAudio` | `SA` |
		|`hasStreamingVideo` | `SV` |
		|`hasTLS` | `TLS` |
		|`hasVideoEncoder` | `VE` |
		|`isDebugger` | `DEB` |
		|`language` | `L` |
		|`localFileReadDisable` | `LFD` |
		|`manufacturer` | `M` |
		|`maxLevelIDC` | `ML` |
		|`os` | `OS` |
		|`pixelAspectRatio` | `AR` |
		|`playerType` | `PT` |
		|`screenColor` | `COL` |
		|`screenDPI` | `DP` |
		|`screenResolutionX` | `R` |
		|`screenResolutionY` | `R` |
		|`version` | `V` |


	There is also a `WD` server string that specifies whether windowless mode
	is disabled. Windowless mode can be disabled in Flash Player due to
	incompatibility with the web browser or to a user setting in the mms.cfg
	file. There is no corresponding Capabilities property.

	All properties of the Capabilities class are read-only.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:final class Capabilities
{
	/**
		Specifies whether access to the user's camera and microphone has been
		administratively prohibited(`true`) or allowed
		(`false`). The server string is `AVD`.

		For content in Adobe AIR™, this property applies only to content in
		security sandboxes other than the application security sandbox. Content in
		the application security sandbox can always access the user's camera and
		microphone.
	**/
	public static var avHardwareDisable(default, null) = true;

	/**
		Specifies the current CPU architecture. The `cpuArchitecture`
		property can return the following strings: "`PowerPC`",
		"`x86`", "`SPARC`", and "`ARM`". The
		server string is `ARCH`.
	**/
	public static var cpuArchitecture(get, never):String;

	/**
		Specifies whether the system supports(`true`) or does not
		support(`false`) communication with accessibility aids. The
		server string is `ACC`.
	**/
	public static var hasAccessibility(default, null) = false;

	/**
		Specifies whether the system has audio capabilities. This property is
		always `true`. The server string is `A`.
	**/
	public static var hasAudio(default, null) = true;

	/**
		Specifies whether the system can(`true`) or cannot
		(`false`) encode an audio stream, such as that coming from a
		microphone. The server string is `AE`.
	**/
	public static var hasAudioEncoder(default, null) = false;

	/**
		Specifies whether the system supports(`true`) or does not
		support(`false`) embedded video. The server string is
		`EV`.
	**/
	public static var hasEmbeddedVideo(default, null) = false;

	/**
		Specifies whether the system does(`true`) or does not
		(`false`) have an input method editor(IME) installed. The
		server string is `IME`.
	**/
	public static var hasIME(default, null) = false;

	/**
		Specifies whether the system does(`true`) or does not
		(`false`) have an MP3 decoder. The server string is
		`MP3`.
	**/
	public static var hasMP3(default, null) = false;

	/**
		Specifies whether the system does(`true`) or does not
		(`false`) support printing. The server string is
		`PR`.
	**/
	public static var hasPrinting(default, null) = #if html5 true #else false #end;

	/**
		Specifies whether the system does(`true`) or does not
		(`false`) support the development of screen broadcast
		applications to be run through Flash Media Server. The server string is
		`SB`.
	**/
	public static var hasScreenBroadcast(default, null) = false;

	/**
		Specifies whether the system does(`true`) or does not
		(`false`) support the playback of screen broadcast applications
		that are being run through Flash Media Server. The server string is
		`SP`.
	**/
	public static var hasScreenPlayback(default, null) = false;

	/**
		Specifies whether the system can(`true`) or cannot
		(`false`) play streaming audio. The server string is
		`SA`.
	**/
	public static var hasStreamingAudio(default, null) = false;

	/**
		Specifies whether the system can(`true`) or cannot
		(`false`) play streaming video. The server string is
		`SV`.
	**/
	public static var hasStreamingVideo(default, null) = false;

	/**
		Specifies whether the system supports native SSL sockets through
		NetConnection(`true`) or does not(`false`). The
		server string is `TLS`.
	**/
	public static var hasTLS(default, null) = true;

	/**
		Specifies whether the system can(`true`) or cannot
		(`false`) encode a video stream, such as that coming from a web
		camera. The server string is `VE`.
	**/
	public static var hasVideoEncoder(default, null) = #if html5 true #else false #end;

	/**
		Specifies whether the system is a special debugging version
		(`true`) or an officially released version
		(`false`). The server string is `DEB`. This property
		is set to `true` when running in the debug version of Flash
		Player or the AIR Debug Launcher(ADL).
	**/
	public static var isDebugger(default, null) = #if debug true #else false #end;

	/**
		Specifies whether the Flash runtime is embedded in a PDF file that is open
		in Acrobat 9.0 or higher(`true`) or not(`false`).
	**/
	public static var isEmbeddedInAcrobat(default, null) = false;

	/**
		Specifies the language code of the system on which the content is
		running. The language is specified as a lowercase two-letter language
		code from ISO 639-1. For Chinese, an additional uppercase two-letter
		country code from ISO 3166 distinguishes between Simplified and
		Traditional Chinese. The languages codes are based on the English
		names of the language: for example, `hu` specifies Hungarian.
		On English systems, this property returns only the language code
		(`en`), not the country code. On Microsoft Windows systems, this
		property returns the user interface (UI) language, which refers to the
		language used for all menus, dialog boxes, error messages, and help
		files. The following table lists the possible values:

		| Language | Value |
		| --- | --- |
		| Czech | `cs` |
		| Danish | `da` |
		| Dutch | `nl` |
		| English | `en` |
		| Finnish | `fi` |
		| French | `fr` |
		| German | `de` |
		| Hungarian | `hu` |
		| Italian | `it` |
		| Japanese | `ja` |
		| Korean | `ko` |
		| Norwegian | `no` |
		| Other/unknown | `xu` |
		| Polish | `pl` |
		| Portuguese | `pt` |
		| Russian | `ru` |
		| Simplified Chinese | `zh-CN` |
		| Spanish | `es` |
		| Swedish | `sv` |
		| Traditional Chinese | `zh-TW` |
		| Turkish | `tr` |

		_Note:_ The value of `Capabilities.language` property is limited to
		the possible values on this list. Because of this limitation, Adobe
		AIR applications should use the first element in the
		`Capabilities.languages` array to determine the primary user interface
		language for the system.

		The server string is `L`.
	**/
	public static var language(get, never):String;

	/**
		Specifies whether read access to the user's hard disk has been
		administratively prohibited(`true`) or allowed
		(`false`). For content in Adobe AIR, this property applies only
		to content in security sandboxes other than the application security
		sandbox.(Content in the application security sandbox can always read from
		the file system.) If this property is `true`, Flash Player
		cannot read files(including the first file that Flash Player launches
		with) from the user's hard disk. If this property is `true`,
		AIR content outside of the application security sandbox cannot read files
		from the user's hard disk. For example, attempts to read a file on the
		user's hard disk using load methods will fail if this property is set to
		`true`.

		Reading runtime shared libraries is also blocked if this property is
		set to `true`, but reading local shared objects is allowed
		without regard to the value of this property.

		The server string is `LFD`.
	**/
	public static var localFileReadDisable(default, null) = #if web true #else false #end;

	/**
		Specifies the manufacturer of the running version of Flash Player or the
		AIR runtime, in the format `"Adobe`
		`_OSName_"`. The value for `_OSName_`
		could be `"Windows"`, `"Macintosh"`,
		`"Linux"`, or another operating system name. The server string
		is `M`.

		Do _not_ use `Capabilities.manufacturer` to determine a
		capability based on the operating system if a more specific capability
		property exists. Basing a capability on the operating system is a bad
		idea, since it can lead to problems if an application does not consider
		all potential target operating systems. Instead, use the property
		corresponding to the capability for which you are testing. For more
		information, see the Capabilities class description.
	**/
	public static var manufacturer(get, never):String;

	/**
		Retrieves the highest H.264 Level IDC that the client hardware supports.
		Media run at this level are guaranteed to run; however, media run at the
		highest level might not run with the highest quality. This property is
		useful for servers trying to target a client's capabilities. Using this
		property, a server can determine the level of video to send to the client.


		The server string is `ML`.
	**/
	public static var maxLevelIDC(default, null) = 0;

	/**
		Specifies the current operating system. The `os` property can return
		the following strings:

		|Operating system | Value |
		| --- | --- |
		| Windows 7 | `"Windows 7"` |
		| Windows Vista | `"Windows Vista"` |
		| Windows Server 2008 R2 | `"Windows Server 2008 R2"` |
		| Windows Server 2008 | `"Windows Server 2008"` |
		| Windows Home Server | `"Windows Home Server"` |
		| Windows Server 2003 R2 | `"Windows Server 2003 R2"` |
		| Windows Server 2003 | `"Windows Server 2003"` |
		| Windows XP 64 | `"Windows Server XP 64"` |
		| Windows XP | `"Windows XP"` |
		| Windows 98 | `"Windows 98"` |
		| Windows 95 | `"Windows 95"` |
		| Windows NT | `"Windows NT"` |
		| Windows 2000 | `"Windows 2000"` |
		| Windows ME | `"Windows ME"` |
		| Windows CE | `"Windows CE"` |
		| Windows SmartPhone | `"Windows SmartPhone"` |
		| Windows PocketPC | `"Windows PocketPC"` |
		| Windows CEPC | `"Windows CEPC"` |
		| Windows Mobile | `"Windows Mobile"` |
		| Mac OS | `"Mac OS X.Y.Z"` (where X.Y.Z is the version number, for example: `"Mac OS 10.5.2"`) |
		| Linux | `"Linux"` (Flash Player attaches the Linux version, such as `"Linux 2.6.15-1.2054_FC5smp"` |
		| iPhone OS 4.1 | `"iPhone3,1"` |

		The server string is `OS`.

		Do _not_ use `Capabilities.os` to determine a capability based on the
		operating system if a more specific capability property exists. Basing
		a capability on the operating system is a bad idea, since it can lead
		to problems if an application does not consider all potential target
		operating systems. Instead, use the property corresponding to the
		capability for which you are testing. For more information, see the
		Capabilities class description.
	**/
	public static var os(get, never):String;

	/**
		Specifies the pixel aspect ratio of the screen. The server string is
		`AR`.
	**/
	public static var pixelAspectRatio(get, never):Float;

	/**
		Specifies the type of runtime environment. This property can have one of
		the following values:

		* `"ActiveX"` for the Flash Player ActiveX control used by
		Microsoft Internet Explorer
		* `"Desktop"` for the Adobe AIR runtime(except for SWF
		content loaded by an HTML page, which has
		`Capabilities.playerType` set to `"PlugIn"`)
		* `"External"` for the external Flash Player<ph
		outputclass="flashonly"> or in test mode
		* `"PlugIn"` for the Flash Player browser plug-in(and for
		SWF content loaded by an HTML page in an AIR application)
		* `"StandAlone"` for the stand-alone Flash Player

		The server string is `PT`.
	**/
	public static var playerType(default, null) = #if web "PlugIn" #else "StandAlone" #end;

	/**
		Specifies the screen color. This property can have the value
		`"color"`, `"gray"`(for grayscale), or
		`"bw"`(for black and white). The server string is
		`COL`.
	**/
	public static var screenColor(default, null) = "color";

	/**
		Specifies the dots-per-inch(dpi) resolution of the screen, in pixels. The
		server string is `DP`.
	**/
	public static var screenDPI(get, never):Float;

	/**
		Specifies the maximum horizontal resolution of the screen. The server
		string is `R`(which returns both the width and height of the
		screen). This property does not update with a user's screen resolution and
		instead only indicates the resolution at the time Flash Player or an Adobe
		AIR application started. Also, the value only specifies the primary
		screen.
	**/
	public static var screenResolutionX(get, never):Float;

	/**
		Specifies the maximum vertical resolution of the screen. The server string
		is `R`(which returns both the width and height of the screen).
		This property does not update with a user's screen resolution and instead
		only indicates the resolution at the time Flash Player or an Adobe AIR
		application started. Also, the value only specifies the primary screen.
	**/
	public static var screenResolutionY(get, never):Float;

	/**
		A URL-encoded string that specifies values for each Capabilities property.


		The following example shows a URL-encoded string:
		`A=t&SA=t&SV=t&EV=t&MP3=t&AE=t&VE=t&ACC=f&PR=t&SP=t&
		SB=f&DEB=t&V=WIN%208%2C5%2C0%2C208&M=Adobe%20Windows&
		R=1600x1200&DP=72&COL=color&AR=1.0&OS=Windows%20XP&
		L=en&PT=External&AVD=f&LFD=f&WD=f`
	**/
	public static var serverString(default, null) = ""; // TODO

	/**
		Specifies whether the system supports running 32-bit processes. The server
		string is `PR32`.
	**/
	public static var supports32BitProcesses(default, null) = #if sys true #else false #end;

	/**
		Specifies whether the system supports running 64-bit processes. The server
		string is `PR64`.
	**/
	public static var supports64BitProcesses(default, null) = #if desktop true #else false #end; // TODO

	/**
		Specifies the type of touchscreen supported, if any. Values are defined in
		the openfl.system.TouchscreenType class.
	**/
	public static var touchscreenType(default, null) = TouchscreenType.FINGER; // TODO

	/**
		Specifies the Flash Player or Adobe<sup>®</sup> AIR<sup>®</sup> platform
		and version information. The format of the version number is: _platform
		majorVersion,minorVersion,buildNumber,internalBuildNumber_. Possible
		values for _platform_ are `"WIN"`, ` `"MAC"`,
		`"LNX"`, and `"AND"`. Here are some examples of
		version information: `WIN 9,0,0,0 // Flash
		Player 9 for Windows MAC 7,0,25,0 // Flash Player 7 for Macintosh LNX
		9,0,115,0 // Flash Player 9 for Linux AND 10,2,150,0 // Flash Player 10
		for Android`

		Do _not_ use `Capabilities.version` to determine a
		capability based on the operating system if a more specific capability
		property exists. Basing a capability on the operating system is a bad
		idea, since it can lead to problems if an application does not consider
		all potential target operating systems. Instead, use the property
		corresponding to the capability for which you are testing. For more
		information, see the Capabilities class description.

		The server string is `V`.
	**/
	public static var version(get, never):String;

	@:noCompletion private static var __standardDensities:Array<Int> = [120, 160, 240, 320, 480, 640, 800, 960];

	#if openfljs
	@:noCompletion private static function __init__()
	{
		untyped Object.defineProperties(Capabilities, {
			"cpuArchitecture": {
				get: function()
				{
					return Capabilities.get_cpuArchitecture();
				}
			},
			"language": {
				get: function()
				{
					return Capabilities.get_language();
				}
			},
			"manufacturer": {
				get: function()
				{
					return Capabilities.get_manufacturer();
				}
			},
			"os": {
				get: function()
				{
					return Capabilities.get_os();
				}
			},
			"pixelAspectRatio": {
				get: function()
				{
					return Capabilities.get_pixelAspectRatio();
				}
			},
			"screenDPI": {
				get: function()
				{
					return Capabilities.get_screenDPI();
				}
			},
			"screenResolutionX": {
				get: function()
				{
					return Capabilities.get_screenResolutionX();
				}
			},
			"screenResolutionY": {
				get: function()
				{
					return Capabilities.get_screenResolutionY();
				}
			},
			"version": {
				get: function()
				{
					return Capabilities.get_version();
				}
			}
		});
	}
	#end

	/**
		Specifies whether the system supports multichannel audio of a specific type. The
		class flash.media.AudioDecoder enumerates the possible types.

		_AIR profile support:_ Multichannel audio is supported only on AIR for TV devices.
		On all other devices, this method always returns `false`. See AIR Profile Support
		for more information regarding API support across multiple profiles.

		**Note:** When using one of the DTS audio codecs, scenarios exist in which
		`hasMultiChannelAudio()` returns `true` but the DTS audio is not played. For
		example, consider a Blu-ray player with an S/PDIF output, connected to an old
		amplifier. The old amplifier does not support DTS, but S/PDIF has no protocol to
		notify the Blu-ray player. If the Blu-ray player sends the DTS stream to the old
		amplifier, the user hears nothing. Therefore, as a best practice when using DTS,
		provide a user interface so that the user can indicate if no sound is playing.
		Then, your application can revert to a different codec.

		The following table shows the server string for each multichannel audio type:

		| Multichannel audio type | Server string |
		| --- | --- |
		| AudioDecoder.DOLBY_DIGITAL | DD |
		| AudioDecoder.DOLBY_DIGITAL_PLUS | DDP |
		| AudioDecoder.DTS | DTS |
		| AudioDecoder.DTS_EXPRESS | DTE |
		| AudioDecoder.DTS_HD_HIGH_RESOLUTION_AUDIO | DTH |
		| AudioDecoder.DTS_HD_MASTER_AUDIO | DTM |

		@param	type	A String value representing a multichannel audio type. The valid
		values are the constants defined in flash.media.AudioDecoder.
		@returns	The Boolean value `true` if the system supports the multichannel audio
		type passed in the `type` parameter. Otherwise, the return value is `false`.

	**/
	public static function hasMultiChannelAudio(type:String):Bool
	{
		return false;
	}

	// Getters & Setters
	@:noCompletion private static inline function get_cpuArchitecture():String
	{
		// TODO: Check architecture
		#if (mobile && !simulator && !emulator)
		return "ARM";
		#else
		return "x86";
		#end
	}

	@:noCompletion private static function get_language():String
	{
		#if lime
		var language = Locale.currentLocale.language;

		if (language != null)
		{
			language = language.toLowerCase();

			switch (language)
			{
				case "cs", "da", "nl", "en", "fi", "fr", "de", "hu", "it", "ja", "ko", "nb", "pl", "pt", "ru", "es", "sv", "tr":
					return language;

				case "zh":
					var region = Locale.currentLocale.region;

					if (region != null)
					{
						switch (region.toUpperCase())
						{
							case "TW", "HANT":
								return "zh-TW";

							default:
						}
					}

					return "zh-CN";

				default:
					return "xu";
			}
		}
		#end

		return "en";
	}

	@:noCompletion private static inline function get_manufacturer():String
	{
		#if mac
		return "OpenFL Macintosh";
		#elseif linux
		return "OpenFL Linux";
		#elseif lime
		var name = System.platformName;
		return "OpenFL" + (name != null ? " " + name : "");
		#else
		return null;
		#end
	}

	@:noCompletion private static inline function get_os():String
	{
		#if lime
		#if (ios || tvos)
		return System.deviceModel;
		#elseif mac
		return "Mac OS " + System.platformVersion;
		#elseif linux
		var kernelVersion = "";
		try
		{
			var process = new Process("uname", ["-r"]);
			kernelVersion = StringTools.trim(process.stdout.readLine().toString());
			process.close();
		}
		catch (e:Dynamic) {}
		if (kernelVersion != "") return "Linux " + kernelVersion;
		else
			return "Linux";
		#else
		var label = System.platformLabel;
		return label != null ? label : "";
		#end
		#else
		return null;
		#end
	}

	@:noCompletion private static function get_pixelAspectRatio():Float
	{
		return 1;
	}

	@:noCompletion private static function get_screenDPI():Float
	{
		#if lime
		var window = Lib.application != null ? Lib.application.window : null;
		var screenDPI:Float;

		#if (desktop || web)
		screenDPI = 72;

		if (window != null)
		{
			screenDPI *= window.scale;
		}
		#else
		screenDPI = __standardDensities[0];

		if (window != null)
		{
			var display = window.display;

			if (display != null)
			{
				var actual = display.dpi;

				var closestValue = screenDPI;
				var closestDifference = Math.abs(actual - screenDPI);
				var difference:Float;

				for (density in __standardDensities)
				{
					difference = Math.abs(actual - density);

					if (difference < closestDifference)
					{
						closestDifference = difference;
						closestValue = density;
					}
				}

				screenDPI = closestValue;
			}
		}
		#end

		return screenDPI;
		#else
		return 72;
		#end
	}

	@:noCompletion private static function get_screenResolutionX():Float
	{
		#if lime
		var stage = Lib.current.stage;
		var resolutionX = 0;

		if (stage == null) return 0;

		if (stage.window != null)
		{
			var display = stage.window.display;

			if (display != null)
			{
				resolutionX = Math.ceil(display.currentMode.width * stage.window.scale);
			}
		}

		if (resolutionX > 0)
		{
			return resolutionX;
		}

		return stage.stageWidth;
		#else
		return 0;
		#end
	}

	@:noCompletion private static function get_screenResolutionY():Float
	{
		#if lime
		var stage = Lib.current.stage;
		var resolutionY = 0;

		if (stage == null) return 0;

		if (stage.window != null)
		{
			var display = stage.window.display;

			if (display != null)
			{
				resolutionY = Math.ceil(display.currentMode.height * stage.window.scale);
			}
		}

		if (resolutionY > 0)
		{
			return resolutionY;
		}

		return stage.stageHeight;
		#else
		return 0;
		#end
	}

	@:noCompletion private static function get_version():String
	{
		#if windows
		var value = "WIN";
		#elseif mac
		var value = "MAC";
		#elseif linux
		var value = "LNX";
		#elseif ios
		var value = "IOS";
		#elseif tvos
		var value = "TVO";
		#elseif android
		var value = "AND";
		#elseif blackberry
		var value = "QNX";
		#elseif firefox
		var value = "MOZ";
		#elseif html5
		var value = "WEB";
		#else
		var value = "OFL";
		#end

		if (Compiler.getDefine("openfl") != null)
		{
			value += " " + StringTools.replace(Compiler.getDefine("openfl"), ".", ",") + ",0";
		}

		return value;
	}
}
#else
typedef Capabilities = flash.system.Capabilities;
#end
