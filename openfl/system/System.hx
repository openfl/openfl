package openfl.system; #if !flash #if !lime_legacy


/**
 * The System class contains properties related to local settings and
 * operations. Among these are settings for camers and microphones, operations
 * with shared objects and the use of the Clipboard.
 *
 * <p>Additional properties and methods are in other classes within the
 * flash.system package: the Capabilities class, the IME class, and the
 * Security class.</p>
 *
 * <p>This class contains only static methods and properties. You cannot
 * create new instances of the System class.</p>
 */
class System {
	
	
	/**
	 * The amount of memory(in bytes) currently in use that has been directly
	 * allocated by Flash Player or AIR.
	 *
	 * <p>This property does not return <i>all</i> memory used by an Adobe AIR
	 * application or by the application(such as a browser) containing Flash
	 * Player content. The browser or operating system may consume other memory.
	 * The <code>System.privateMemory</code> property reflects <i>all</i> memory
	 * used by an application.</p>
	 *
	 * <p>If the amount of memory allocated is greater than the maximum value for
	 * a uint object(<code>uint.MAX_VALUE</code>, or 4,294,967,295), then this
	 * property is set to 0. The <code>System.totalMemoryNumber</code> property
	 * allows larger values.</p>
	 */
	public static var totalMemory (get, null):Int;
	
	/**
	 * A Boolean value that determines which code page to use to interpret
	 * external text files. When the property is set to <code>false</code>,
	 * external text files are interpretted as Unicode.(These files must be
	 * encoded as Unicode when you save them.) When the property is set to
	 * <code>true</code>, external text files are interpretted using the
	 * traditional code page of the operating system running the application. The
	 * default value of <code>useCodePage</code> is <code>false</code>.
	 *
	 * <p>Text that you load as an external file(using
	 * <code>Loader.load()</code>, the URLLoader class or URLStream) must have
	 * been saved as Unicode in order for the application to recognize it as
	 * Unicode. To encode external files as Unicode, save the files in an
	 * application that supports Unicode, such as Notepad on Windows.</p>
	 *
	 * <p>If you load external text files that are not Unicode-encoded, set
	 * <code>useCodePage</code> to <code>true</code>. Add the following as the
	 * first line of code of the file that is loading the data(for Flash
	 * Professional, add it to the first frame):</p>
	 * <pre xml:space="preserve"><code>System.useCodePage = true;</code></pre>
	 *
	 * <p>When this code is present, the application interprets external text
	 * using the traditional code page of the operating system. For example, this
	 * is generally CP1252 for an English Windows operating system and Shift-JIS
	 * for a Japanese operating system.</p>
	 *
	 * <p>If you set <code>useCodePage</code> to <code>true</code>, Flash Player
	 * 6 and later treat text as Flash Player 5 does.(Flash Player 5 treated all
	 * text as if it were in the traditional code page of the operating system
	 * running the player.)</p>
	 *
	 * <p>If you set <code>useCodePage</code> to <code>true</code>, remember that
	 * the traditional code page of the operating system running the application
	 * must include the characters used in your external text file in order to
	 * display your text. For example, if you load an external text file that
	 * contains Chinese characters, those characters cannot display on a system
	 * that uses the CP1252 code page because that code page does not include
	 * Chinese characters.</p>
	 *
	 * <p>To ensure that users on all platforms can view external text files used
	 * in your application, you should encode all external text files as Unicode
	 * and leave <code>useCodePage</code> set to <code>false</code>. This way,
	 * the application(Flash Player 6 and later, or AIR) interprets the text as
	 * Unicode.</p>
	 */
	public static var useCodePage:Bool = false;
	public static var vmVersion (get, null):String;
	
	
	/**
	 * Closes Flash Player.
	 *
	 * <p><i>For the standalone Flash Player debugger version only.</i></p>
	 *
	 * <p>AIR applications should call the <code>NativeApplication.exit()</code>
	 * method to exit the application.</p>
	 * 
	 * @param code A value to pass to the operating system. Typically, if the
	 *             process exits normally, the value is 0.
	 */
	public static function exit (code:Int):Void {
		
		throw "System.exit is currently not supported for HTML5";
		
	}
	
	
	/**
	 * Forces the garbage collection process.
	 *
	 * <p><i>For the Flash Player debugger version and AIR applications only.</i>
	 * In an AIR application, the <code>System.gc()</code> method is only enabled
	 * in content running in the AIR Debug Launcher(ADL) or, in an installed
	 * applcation, in content in the application security sandbox.</p>
	 * 
	 */
	public static function gc ():Void {
		
		
		
	}
	
	
	/**
	 * Pauses Flash Player or the AIR Debug Launcher(ADL). After calling this
	 * method, nothing in the application continues except the delivery of Socket
	 * events.
	 *
	 * <p><i>For the Flash Player debugger version or the AIR Debug Launcher
	 * (ADL) only.</i></p>
	 * 
	 */
	public static function pause ():Void {
		
		throw "System.pause is currently not supported for HTML5";
		
	}
	
	
	/**
	 * Resumes the application after calling <code>System.pause()</code>.
	 *
	 * <p><i>For the Flash Player debugger version or the AIR Debug Launcher
	 * (ADL) only.</i></p>
	 * 
	 */
	public static function resume ():Void {
		
		throw "System.resume is currently not supported for HTML5";
		
	}
	
	
	/**
	 * Replaces the contents of the Clipboard with a specified text string. This
	 * method works from any security context when called as a result of a user
	 * event(such as a keyboard or input device event handler).
	 *
	 * <p>This method is provided for SWF content running in Flash Player 9. It
	 * allows only adding String content to the Clipboard.</p>
	 *
	 * <p>Flash Player 10 content and content in the application security sandbox
	 * in an AIR application can call the <code>Clipboard.setData()</code>
	 * method.</p>
	 * 
	 * @param string A plain-text string of characters to put on the system
	 *               Clipboard, replacing its current contents(if any).
	 */
	public static function setClipboard (string:String):Void {
		
		throw "System.setClipboard is currently not supported for HTML5";
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	@:noCompletion private static function get_totalMemory ():Int {
		
		return 0;
		
	}
	
	
	@:noCompletion private static function get_vmVersion ():String {
		
		return "1.0.0";
		
	}
	
	
}


#else
typedef System = openfl._v2.system.System;
#end
#else
typedef System = flash.system.System;
#end