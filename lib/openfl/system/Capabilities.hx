package openfl.system; #if (display || !flash)


@:jsRequire("openfl/system/Capabilities", "default")

/**
 * The Capabilities class provides properties that describe the system and
 * runtime that are hosting the application. For example, a mobile phone's
 * screen might be 100 square pixels, black and white, whereas a PC screen
 * might be 1000 square pixels, color. By using the Capabilities class to
 * determine what capabilities the client has, you can provide appropriate
 * content to as many users as possible. When you know the device's
 * capabilities, you can tell the server to send the appropriate SWF files or
 * tell the SWF file to alter its presentation.
 *
 * However, some capabilities of Adobe AIR are not listed as properties in
 * the Capabilities class. They are properties of other classes:
 * 
 *
 * There is also a `WD` server string that specifies whether
 * windowless mode is disabled. Windowless mode can be disabled in Flash
 * Player due to incompatibility with the web browser or to a user setting in
 * the mms.cfg file. There is no corresponding Capabilities property.
 *
 * All properties of the Capabilities class are read-only.
 */
@:final extern class Capabilities {
	
	
	/**
	 * Specifies whether access to the user's camera and microphone has been
	 * administratively prohibited(`true`) or allowed
	 * (`false`). The server string is `AVD`.
	 *
	 * For content in Adobe AIR™, this property applies only to content in
	 * security sandboxes other than the application security sandbox. Content in
	 * the application security sandbox can always access the user's camera and
	 * microphone.
	 */
	public static var avHardwareDisable (default, null):Bool;
	
	/**
	 * Specifies the current CPU architecture. The `cpuArchitecture`
	 * property can return the following strings: "`PowerPC`",
	 * "`x86`", "`SPARC`", and "`ARM`". The
	 * server string is `ARCH`.
	 */
	public static var cpuArchitecture (default, null):String;
	
	/**
	 * Specifies whether the system supports(`true`) or does not
	 * support(`false`) communication with accessibility aids. The
	 * server string is `ACC`.
	 */
	public static var hasAccessibility (default, null):Bool;
	
	/**
	 * Specifies whether the system has audio capabilities. This property is
	 * always `true`. The server string is `A`.
	 */
	public static var hasAudio (default, null):Bool;
	
	/**
	 * Specifies whether the system can(`true`) or cannot
	 * (`false`) encode an audio stream, such as that coming from a
	 * microphone. The server string is `AE`.
	 */
	public static var hasAudioEncoder (default, null):Bool;
	
	/**
	 * Specifies whether the system supports(`true`) or does not
	 * support(`false`) embedded video. The server string is
	 * `EV`.
	 */
	public static var hasEmbeddedVideo (default, null):Bool;
	
	/**
	 * Specifies whether the system does(`true`) or does not
	 * (`false`) have an input method editor(IME) installed. The
	 * server string is `IME`.
	 */
	public static var hasIME (default, null):Bool;
	
	/**
	 * Specifies whether the system does(`true`) or does not
	 * (`false`) have an MP3 decoder. The server string is
	 * `MP3`.
	 */
	public static var hasMP3 (default, null):Bool;
	
	/**
	 * Specifies whether the system does(`true`) or does not
	 * (`false`) support printing. The server string is
	 * `PR`.
	 */
	public static var hasPrinting (default, null):Bool;
	
	/**
	 * Specifies whether the system does(`true`) or does not
	 * (`false`) support the development of screen broadcast
	 * applications to be run through Flash Media Server. The server string is
	 * `SB`.
	 */
	public static var hasScreenBroadcast (default, null):Bool;
	
	/**
	 * Specifies whether the system does(`true`) or does not
	 * (`false`) support the playback of screen broadcast applications
	 * that are being run through Flash Media Server. The server string is
	 * `SP`.
	 */
	public static var hasScreenPlayback (default, null):Bool;
	
	/**
	 * Specifies whether the system can(`true`) or cannot
	 * (`false`) play streaming audio. The server string is
	 * `SA`.
	 */
	public static var hasStreamingAudio (default, null):Bool;
	
	/**
	 * Specifies whether the system can(`true`) or cannot
	 * (`false`) play streaming video. The server string is
	 * `SV`.
	 */
	public static var hasStreamingVideo (default, null):Bool;
	
	/**
	 * Specifies whether the system supports native SSL sockets through
	 * NetConnection(`true`) or does not(`false`). The
	 * server string is `TLS`.
	 */
	public static var hasTLS (default, null):Bool;
	
	/**
	 * Specifies whether the system can(`true`) or cannot
	 * (`false`) encode a video stream, such as that coming from a web
	 * camera. The server string is `VE`.
	 */
	public static var hasVideoEncoder (default, null):Bool;
	
	/**
	 * Specifies whether the system is a special debugging version
	 * (`true`) or an officially released version
	 * (`false`). The server string is `DEB`. This property
	 * is set to `true` when running in the debug version of Flash
	 * Player or the AIR Debug Launcher(ADL).
	 */
	public static var isDebugger (default, null):Bool;
	
	/**
	 * Specifies whether the Flash runtime is embedded in a PDF file that is open
	 * in Acrobat 9.0 or higher(`true`) or not(`false`).
	 */
	public static var isEmbeddedInAcrobat (default, null):Bool;
	
	/**
	 * Specifies the language code of the system on which the content is running.
	 * The language is specified as a lowercase two-letter language code from ISO
	 * 639-1. For Chinese, an additional uppercase two-letter country code from
	 * ISO 3166 distinguishes between Simplified and Traditional Chinese. The
	 * languages codes are based on the English names of the language: for
	 * example, `hu` specifies Hungarian.
	 *
	 * On English systems, this property returns only the language code
	 * (`en`), not the country code. On Microsoft Windows systems,
	 * this property returns the user interface(UI) language, which refers to
	 * the language used for all menus, dialog boxes, error messages, and help
	 * files. The following table lists the possible values: 
	 *
	 * _Note:_ The value of `Capabilities.language` property
	 * is limited to the possible values on this list. Because of this
	 * limitation, Adobe AIR applications should use the first element in the
	 * `Capabilities.languages` array to determine the primary user
	 * interface language for the system. 
	 *
	 * The server string is `L`.
	 */
	public static var language (default, never):String;
	
	/**
	 * Specifies whether read access to the user's hard disk has been
	 * administratively prohibited(`true`) or allowed
	 * (`false`). For content in Adobe AIR, this property applies only
	 * to content in security sandboxes other than the application security
	 * sandbox.(Content in the application security sandbox can always read from
	 * the file system.) If this property is `true`, Flash Player
	 * cannot read files(including the first file that Flash Player launches
	 * with) from the user's hard disk. If this property is `true`,
	 * AIR content outside of the application security sandbox cannot read files
	 * from the user's hard disk. For example, attempts to read a file on the
	 * user's hard disk using load methods will fail if this property is set to
	 * `true`.
	 *
	 * Reading runtime shared libraries is also blocked if this property is
	 * set to `true`, but reading local shared objects is allowed
	 * without regard to the value of this property.
	 *
	 * The server string is `LFD`.
	 */
	public static var localFileReadDisable (default, null):Bool;
	
	/**
	 * Specifies the manufacturer of the running version of Flash Player or the
	 * AIR runtime, in the format `"Adobe`
	 * `_OSName_"`. The value for `_OSName_`
	 * could be `"Windows"`, `"Macintosh"`,
	 * `"Linux"`, or another operating system name. The server string
	 * is `M`.
	 *
	 * Do _not_ use `Capabilities.manufacturer` to determine a
	 * capability based on the operating system if a more specific capability
	 * property exists. Basing a capability on the operating system is a bad
	 * idea, since it can lead to problems if an application does not consider
	 * all potential target operating systems. Instead, use the property
	 * corresponding to the capability for which you are testing. For more
	 * information, see the Capabilities class description.
	 */
	public static var manufacturer (default, null):String;
	
	/**
	 * Retrieves the highest H.264 Level IDC that the client hardware supports.
	 * Media run at this level are guaranteed to run; however, media run at the
	 * highest level might not run with the highest quality. This property is
	 * useful for servers trying to target a client's capabilities. Using this
	 * property, a server can determine the level of video to send to the client.
	 *
	 *
	 * The server string is `ML`.
	 */
	public static var maxLevelIDC (default, null):Int;
	
	/**
	 * Specifies the current operating system. The `os` property can
	 * return the following strings:
	 *
	 * The server string is `OS`.
	 *
	 * Do _not_ use `Capabilities.os` to determine a
	 * capability based on the operating system if a more specific capability
	 * property exists. Basing a capability on the operating system is a bad
	 * idea, since it can lead to problems if an application does not consider
	 * all potential target operating systems. Instead, use the property
	 * corresponding to the capability for which you are testing. For more
	 * information, see the Capabilities class description.
	 */
	public static var os (default, never):String;
	
	/**
	 * Specifies the pixel aspect ratio of the screen. The server string is
	 * `AR`.
	 */
	public static var pixelAspectRatio (default, never):Float;
	
	/**
	 * Specifies the type of runtime environment. This property can have one of
	 * the following values:
	 * 
	 *  * `"ActiveX"` for the Flash Player ActiveX control used by
	 * Microsoft Internet Explorer
	 *  * `"Desktop"` for the Adobe AIR runtime(except for SWF
	 * content loaded by an HTML page, which has
	 * `Capabilities.playerType` set to `"PlugIn"`)
	 *  * `"External"` for the external Flash Player<ph
	 * outputclass="flashonly"> or in test mode
	 *  * `"PlugIn"` for the Flash Player browser plug-in(and for
	 * SWF content loaded by an HTML page in an AIR application)
	 *  * `"StandAlone"` for the stand-alone Flash Player
	 * 
	 *
	 * The server string is `PT`.
	 */
	public static var playerType (default, null):String;
	
	/**
	 * Specifies the screen color. This property can have the value
	 * `"color"`, `"gray"`(for grayscale), or
	 * `"bw"`(for black and white). The server string is
	 * `COL`.
	 */
	public static var screenColor (default, null):String;
	
	/**
	 * Specifies the dots-per-inch(dpi) resolution of the screen, in pixels. The
	 * server string is `DP`.
	 */
	public static var screenDPI (default, never):Float;
	
	/**
	 * Specifies the maximum horizontal resolution of the screen. The server
	 * string is `R`(which returns both the width and height of the
	 * screen). This property does not update with a user's screen resolution and
	 * instead only indicates the resolution at the time Flash Player or an Adobe
	 * AIR application started. Also, the value only specifies the primary
	 * screen.
	 */
	public static var screenResolutionX (default, never):Float;
	
	/**
	 * Specifies the maximum vertical resolution of the screen. The server string
	 * is `R`(which returns both the width and height of the screen).
	 * This property does not update with a user's screen resolution and instead
	 * only indicates the resolution at the time Flash Player or an Adobe AIR
	 * application started. Also, the value only specifies the primary screen.
	 */
	public static var screenResolutionY (default, never):Float;
	
	/**
	 * A URL-encoded string that specifies values for each Capabilities property.
	 *
	 *
	 * The following example shows a URL-encoded string:
	 * `A=t&SA=t&SV=t&EV=t&MP3=t&AE=t&VE=t&ACC=f&PR=t&SP=t&
	 * SB=f&DEB=t&V=WIN%208%2C5%2C0%2C208&M=Adobe%20Windows&
	 * R=1600x1200&DP=72&COL=color&AR=1.0&OS=Windows%20XP&
	 * L=en&PT=External&AVD=f&LFD=f&WD=f`
	 */
	public static var serverString (default, null):String;
	
	/**
	 * Specifies whether the system supports running 32-bit processes. The server
	 * string is `PR32`.
	 */
	public static var supports32BitProcesses (default, null):Bool;
	
	/**
	 * Specifies whether the system supports running 64-bit processes. The server
	 * string is `PR64`.
	 */
	public static var supports64BitProcesses (default, null):Bool;
	
	/**
	 * Specifies the type of touchscreen supported, if any. Values are defined in
	 * the flash.system.TouchscreenType class.
	 */
	public static var touchscreenType (default, null):TouchscreenType;
	
	/**
	 * Specifies the Flash Player or Adobe<sup>®</sup> AIR<sup>®</sup> platform
	 * and version information. The format of the version number is: _platform
	 * majorVersion,minorVersion,buildNumber,internalBuildNumber_. Possible
	 * values for _platform_ are `"WIN"`, ` `"MAC"`,
	 * `"LNX"`, and `"AND"`. Here are some examples of
	 * version information: `WIN 9,0,0,0 // Flash
	 * Player 9 for Windows MAC 7,0,25,0 // Flash Player 7 for Macintosh LNX
	 * 9,0,115,0 // Flash Player 9 for Linux AND 10,2,150,0 // Flash Player 10
	 * for Android`
	 *
	 * Do _not_ use `Capabilities.version` to determine a
	 * capability based on the operating system if a more specific capability
	 * property exists. Basing a capability on the operating system is a bad
	 * idea, since it can lead to problems if an application does not consider
	 * all potential target operating systems. Instead, use the property
	 * corresponding to the capability for which you are testing. For more
	 * information, see the Capabilities class description.
	 *
	 * The server string is `V`.
	 */
	public static var version (default, never):String;
	
	
	public static function hasMultiChannelAudio (type:String):Bool;
	
	
}


#else
typedef Capabilities = flash.system.Capabilities;
#end