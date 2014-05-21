/*
 
 This class provides code completion and inline documentation, but it does 
 not contain runtime support. It should be overridden by a compatible
 implementation in an OpenFL backend, depending upon the target platform.
 
*/

package openfl.system;
#if display


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
}


#end
