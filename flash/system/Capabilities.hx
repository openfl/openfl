package flash.system;
#if (flash || display)


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
 * <p>However, some capabilities of Adobe AIR are not listed as properties in
 * the Capabilities class. They are properties of other classes:</p>
 * </p>
 *
 * <p>There is also a <code>WD</code> server string that specifies whether
 * windowless mode is disabled. Windowless mode can be disabled in Flash
 * Player due to incompatibility with the web browser or to a user setting in
 * the mms.cfg file. There is no corresponding Capabilities property.</p>
 *
 * <p>All properties of the Capabilities class are read-only.</p>
 */
extern class Capabilities {
	
	#if !display
	static var _internal(default,null) : Int;

	/**
	 * Specifies whether access to the user's camera and microphone has been
	 * administratively prohibited(<code>true</code>) or allowed
	 * (<code>false</code>). The server string is <code>AVD</code>.
	 *
	 * <p>For content in Adobe AIR™, this property applies only to content in
	 * security sandboxes other than the application security sandbox. Content in
	 * the application security sandbox can always access the user's camera and
	 * microphone.</p>
	 */
	static var avHardwareDisable(default,null) : Bool;

	/**
	 * Specifies the current CPU architecture. The <code>cpuArchitecture</code>
	 * property can return the following strings: "<code>PowerPC</code>",
	 * "<code>x86</code>", "<code>SPARC</code>", and "<code>ARM</code>". The
	 * server string is <code>ARCH</code>.
	 */
	@:require(flash10_1) static var cpuArchitecture(default,null) : String;

	/**
	 * Specifies whether the system supports(<code>true</code>) or does not
	 * support(<code>false</code>) communication with accessibility aids. The
	 * server string is <code>ACC</code>.
	 */
	static var hasAccessibility(default,null) : Bool;

	/**
	 * Specifies whether the system has audio capabilities. This property is
	 * always <code>true</code>. The server string is <code>A</code>.
	 */
	static var hasAudio(default,null) : Bool;

	/**
	 * Specifies whether the system can(<code>true</code>) or cannot
	 * (<code>false</code>) encode an audio stream, such as that coming from a
	 * microphone. The server string is <code>AE</code>.
	 */
	static var hasAudioEncoder(default,null) : Bool;

	/**
	 * Specifies whether the system supports(<code>true</code>) or does not
	 * support(<code>false</code>) embedded video. The server string is
	 * <code>EV</code>.
	 */
	static var hasEmbeddedVideo(default,null) : Bool;

	/**
	 * Specifies whether the system does(<code>true</code>) or does not
	 * (<code>false</code>) have an input method editor(IME) installed. The
	 * server string is <code>IME</code>.
	 */
	static var hasIME(default,null) : Bool;

	/**
	 * Specifies whether the system does(<code>true</code>) or does not
	 * (<code>false</code>) have an MP3 decoder. The server string is
	 * <code>MP3</code>.
	 */
	static var hasMP3(default,null) : Bool;

	/**
	 * Specifies whether the system does(<code>true</code>) or does not
	 * (<code>false</code>) support printing. The server string is
	 * <code>PR</code>.
	 */
	static var hasPrinting(default,null) : Bool;

	/**
	 * Specifies whether the system does(<code>true</code>) or does not
	 * (<code>false</code>) support the development of screen broadcast
	 * applications to be run through Flash Media Server. The server string is
	 * <code>SB</code>.
	 */
	static var hasScreenBroadcast(default,null) : Bool;

	/**
	 * Specifies whether the system does(<code>true</code>) or does not
	 * (<code>false</code>) support the playback of screen broadcast applications
	 * that are being run through Flash Media Server. The server string is
	 * <code>SP</code>.
	 */
	static var hasScreenPlayback(default,null) : Bool;

	/**
	 * Specifies whether the system can(<code>true</code>) or cannot
	 * (<code>false</code>) play streaming audio. The server string is
	 * <code>SA</code>.
	 */
	static var hasStreamingAudio(default,null) : Bool;

	/**
	 * Specifies whether the system can(<code>true</code>) or cannot
	 * (<code>false</code>) play streaming video. The server string is
	 * <code>SV</code>.
	 */
	static var hasStreamingVideo(default,null) : Bool;

	/**
	 * Specifies whether the system supports native SSL sockets through
	 * NetConnection(<code>true</code>) or does not(<code>false</code>). The
	 * server string is <code>TLS</code>.
	 */
	static var hasTLS(default,null) : Bool;

	/**
	 * Specifies whether the system can(<code>true</code>) or cannot
	 * (<code>false</code>) encode a video stream, such as that coming from a web
	 * camera. The server string is <code>VE</code>.
	 */
	static var hasVideoEncoder(default,null) : Bool;

	/**
	 * Specifies whether the system is a special debugging version
	 * (<code>true</code>) or an officially released version
	 * (<code>false</code>). The server string is <code>DEB</code>. This property
	 * is set to <code>true</code> when running in the debug version of Flash
	 * Player or the AIR Debug Launcher(ADL).
	 */
	static var isDebugger(default,null) : Bool;

	/**
	 * Specifies whether the Flash runtime is embedded in a PDF file that is open
	 * in Acrobat 9.0 or higher(<code>true</code>) or not(<code>false</code>).
	 */
	@:require(flash10) static var isEmbeddedInAcrobat(default,null) : Bool;
	#end
	
	/**
	 * Specifies the language code of the system on which the content is running.
	 * The language is specified as a lowercase two-letter language code from ISO
	 * 639-1. For Chinese, an additional uppercase two-letter country code from
	 * ISO 3166 distinguishes between Simplified and Traditional Chinese. The
	 * languages codes are based on the English names of the language: for
	 * example, <code>hu</code> specifies Hungarian.
	 *
	 * <p>On English systems, this property returns only the language code
	 * (<code>en</code>), not the country code. On Microsoft Windows systems,
	 * this property returns the user interface(UI) language, which refers to
	 * the language used for all menus, dialog boxes, error messages, and help
	 * files. The following table lists the possible values: </p>
	 *
	 * <p><i>Note:</i> The value of <code>Capabilities.language</code> property
	 * is limited to the possible values on this list. Because of this
	 * limitation, Adobe AIR applications should use the first element in the
	 * <code>Capabilities.languages</code> array to determine the primary user
	 * interface language for the system. </p>
	 *
	 * <p>The server string is <code>L</code>.</p>
	 */
	static var language(default,null) : String;
	
	#if !display
	/**
	 * Specifies whether read access to the user's hard disk has been
	 * administratively prohibited(<code>true</code>) or allowed
	 * (<code>false</code>). For content in Adobe AIR, this property applies only
	 * to content in security sandboxes other than the application security
	 * sandbox.(Content in the application security sandbox can always read from
	 * the file system.) If this property is <code>true</code>, Flash Player
	 * cannot read files(including the first file that Flash Player launches
	 * with) from the user's hard disk. If this property is <code>true</code>,
	 * AIR content outside of the application security sandbox cannot read files
	 * from the user's hard disk. For example, attempts to read a file on the
	 * user's hard disk using load methods will fail if this property is set to
	 * <code>true</code>.
	 *
	 * <p>Reading runtime shared libraries is also blocked if this property is
	 * set to <code>true</code>, but reading local shared objects is allowed
	 * without regard to the value of this property.</p>
	 *
	 * <p>The server string is <code>LFD</code>.</p>
	 */
	static var localFileReadDisable(default,null) : Bool;

	/**
	 * Specifies the manufacturer of the running version of Flash Player or the
	 * AIR runtime, in the format <code>"Adobe</code>
	 * <code><i>OSName</i>"</code>. The value for <code><i>OSName</i></code>
	 * could be <code>"Windows"</code>, <code>"Macintosh"</code>,
	 * <code>"Linux"</code>, or another operating system name. The server string
	 * is <code>M</code>.
	 *
	 * <p>Do <i>not</i> use <code>Capabilities.manufacturer</code> to determine a
	 * capability based on the operating system if a more specific capability
	 * property exists. Basing a capability on the operating system is a bad
	 * idea, since it can lead to problems if an application does not consider
	 * all potential target operating systems. Instead, use the property
	 * corresponding to the capability for which you are testing. For more
	 * information, see the Capabilities class description.</p>
	 */
	static var manufacturer(default,null) : String;

	/**
	 * Retrieves the highest H.264 Level IDC that the client hardware supports.
	 * Media run at this level are guaranteed to run; however, media run at the
	 * highest level might not run with the highest quality. This property is
	 * useful for servers trying to target a client's capabilities. Using this
	 * property, a server can determine the level of video to send to the client.
	 *
	 *
	 * <p>The server string is <code>ML</code>.</p>
	 */
	@:require(flash10) static var maxLevelIDC(default,null) : String;

	/**
	 * Specifies the current operating system. The <code>os</code> property can
	 * return the following strings:
	 *
	 * <p>The server string is <code>OS</code>.</p>
	 *
	 * <p>Do <i>not</i> use <code>Capabilities.os</code> to determine a
	 * capability based on the operating system if a more specific capability
	 * property exists. Basing a capability on the operating system is a bad
	 * idea, since it can lead to problems if an application does not consider
	 * all potential target operating systems. Instead, use the property
	 * corresponding to the capability for which you are testing. For more
	 * information, see the Capabilities class description.</p>
	 */
	static var os(default,null) : String;
	
	/**
	 * Specifies the pixel aspect ratio of the screen. The server string is
	 * <code>AR</code>.
	 */
	static var pixelAspectRatio(default,null) : Float;

	/**
	 * Specifies the type of runtime environment. This property can have one of
	 * the following values:
	 * <ul>
	 *   <li><code>"ActiveX"</code> for the Flash Player ActiveX control used by
	 * Microsoft Internet Explorer</li>
	 *   <li><code>"Desktop"</code> for the Adobe AIR runtime(except for SWF
	 * content loaded by an HTML page, which has
	 * <code>Capabilities.playerType</code> set to <code>"PlugIn"</code>)</li>
	 *   <li><code>"External"</code> for the external Flash Player<ph
	 * outputclass="flashonly"> or in test mode</li>
	 *   <li><code>"PlugIn"</code> for the Flash Player browser plug-in(and for
	 * SWF content loaded by an HTML page in an AIR application)</li>
	 *   <li><code>"StandAlone"</code> for the stand-alone Flash Player</li>
	 * </ul>
	 *
	 * <p>The server string is <code>PT</code>.</p>
	 */
	static var playerType(default,null) : String;

	/**
	 * Specifies the screen color. This property can have the value
	 * <code>"color"</code>, <code>"gray"</code>(for grayscale), or
	 * <code>"bw"</code>(for black and white). The server string is
	 * <code>COL</code>.
	 */
	static var screenColor(default,null) : String;
	#end
	
	/**
	 * Specifies the dots-per-inch(dpi) resolution of the screen, in pixels. The
	 * server string is <code>DP</code>.
	 */
	static var screenDPI(default,null) : Float;

	/**
	 * Specifies the maximum horizontal resolution of the screen. The server
	 * string is <code>R</code>(which returns both the width and height of the
	 * screen). This property does not update with a user's screen resolution and
	 * instead only indicates the resolution at the time Flash Player or an Adobe
	 * AIR application started. Also, the value only specifies the primary
	 * screen.
	 */
	static var screenResolutionX(default,null) : Float;

	/**
	 * Specifies the maximum vertical resolution of the screen. The server string
	 * is <code>R</code>(which returns both the width and height of the screen).
	 * This property does not update with a user's screen resolution and instead
	 * only indicates the resolution at the time Flash Player or an Adobe AIR
	 * application started. Also, the value only specifies the primary screen.
	 */
	static var screenResolutionY(default,null) : Float;
	
	#if !display
	/**
	 * A URL-encoded string that specifies values for each Capabilities property.
	 *
	 *
	 * <p>The following example shows a URL-encoded string: <pre
	 * xml:space="preserve">A=t&SA=t&SV=t&EV=t&MP3=t&AE=t&VE=t&ACC=f&PR=t&SP=t&
	 * SB=f&DEB=t&V=WIN%208%2C5%2C0%2C208&M=Adobe%20Windows&
	 * R=1600x1200&DP=72&COL=color&AR=1.0&OS=Windows%20XP&
	 * L=en&PT=External&AVD=f&LFD=f&WD=f</pre></p>
	 */
	static var serverString(default,null) : String;

	/**
	 * Specifies whether the system supports running 32-bit processes. The server
	 * string is <code>PR32</code>.
	 */
	@:require(flash10_1) static var supports32BitProcesses(default,null) : Bool;

	/**
	 * Specifies whether the system supports running 64-bit processes. The server
	 * string is <code>PR64</code>.
	 */
	@:require(flash10_1) static var supports64BitProcesses(default,null) : Bool;

	/**
	 * Specifies the type of touchscreen supported, if any. Values are defined in
	 * the flash.system.TouchscreenType class.
	 */
	@:require(flash10_1) static var touchscreenType(default,null) : TouchscreenType;

	/**
	 * Specifies the Flash Player or Adobe<sup>®</sup> AIR<sup>®</sup> platform
	 * and version information. The format of the version number is: <i>platform
	 * majorVersion,minorVersion,buildNumber,internalBuildNumber</i>. Possible
	 * values for <i>platform</i> are <code>"WIN"</code>, ` <code>"MAC"</code>,
	 * <code>"LNX"</code>, and <code>"AND"</code>. Here are some examples of
	 * version information: <pre xml:space="preserve"> WIN 9,0,0,0 // Flash
	 * Player 9 for Windows MAC 7,0,25,0 // Flash Player 7 for Macintosh LNX
	 * 9,0,115,0 // Flash Player 9 for Linux AND 10,2,150,0 // Flash Player 10
	 * for Android </pre>
	 *
	 * <p>Do <i>not</i> use <code>Capabilities.version</code> to determine a
	 * capability based on the operating system if a more specific capability
	 * property exists. Basing a capability on the operating system is a bad
	 * idea, since it can lead to problems if an application does not consider
	 * all potential target operating systems. Instead, use the property
	 * corresponding to the capability for which you are testing. For more
	 * information, see the Capabilities class description.</p>
	 *
	 * <p>The server string is <code>V</code>.</p>
	 */
	static var version(default,null) : String;
	@:require(flash11) static function hasMultiChannelAudio(type : String) : Bool;
	#end
	
}


#end
