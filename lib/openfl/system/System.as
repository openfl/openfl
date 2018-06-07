package openfl.system {
	
	
	/**
	 * @externs
	 * The System class contains properties related to local settings and
	 * operations. Among these are settings for camers and microphones, operations
	 * with shared objects and the use of the Clipboard.
	 *
	 * Additional properties and methods are in other classes within the
	 * flash.system package: the Capabilities class, the IME class, and the
	 * Security class.
	 *
	 * This class contains only static methods and properties. You cannot
	 * create new instances of the System class.
	 */
	final public class System {
		
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10_1) public static var freeMemory (default, null):Float;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) public static var ime (default, null):flash.system.IME;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10_1) public static var privateMemory (default, null):Float;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash11) public static var processCPUUsage (default, null):Float;
		// #end
		
		/**
		 * The amount of memory(in bytes) currently in use that has been directly
		 * allocated by Flash Player or AIR.
		 *
		 * This property does not return _all_ memory used by an Adobe AIR
		 * application or by the application(such as a browser) containing Flash
		 * Player content. The browser or operating system may consume other memory.
		 * The `System.privateMemory` property reflects _all_ memory
		 * used by an application.
		 *
		 * If the amount of memory allocated is greater than the maximum value for
		 * a uint object(`uint.MAX_VALUE`, or 4,294,967,295), then this
		 * property is set to 0. The `System.totalMemoryNumber` property
		 * allows larger values.
		 */
		public static function get totalMemory ():int { return 0; }
		
		protected static function get_totalMemory ():int { return 0; }
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10_1) public static var totalMemoryNumber (default, null):Float;
		// #end
		
		/**
		 * A Boolean value that determines which code page to use to interpret
		 * external text files. When the property is set to `false`,
		 * external text files are interpretted as Unicode.(These files must be
		 * encoded as Unicode when you save them.) When the property is set to
		 * `true`, external text files are interpretted using the
		 * traditional code page of the operating system running the application. The
		 * default value of `useCodePage` is `false`.
		 *
		 * Text that you load as an external file(using
		 * `Loader.load()`, the URLLoader class or URLStream) must have
		 * been saved as Unicode in order for the application to recognize it as
		 * Unicode. To encode external files as Unicode, save the files in an
		 * application that supports Unicode, such as Notepad on Windows.
		 *
		 * If you load external text files that are not Unicode-encoded, set
		 * `useCodePage` to `true`. Add the following as the
		 * first line of code of the file that is loading the data(for Flash
		 * Professional, add it to the first frame):
		 * `System.useCodePage = true;`
		 *
		 * When this code is present, the application interprets external text
		 * using the traditional code page of the operating system. For example, this
		 * is generally CP1252 for an English Windows operating system and Shift-JIS
		 * for a Japanese operating system.
		 *
		 * If you set `useCodePage` to `true`, Flash Player
		 * 6 and later treat text as Flash Player 5 does.(Flash Player 5 treated all
		 * text as if it were in the traditional code page of the operating system
		 * running the player.)
		 *
		 * If you set `useCodePage` to `true`, remember that
		 * the traditional code page of the operating system running the application
		 * must include the characters used in your external text file in order to
		 * display your text. For example, if you load an external text file that
		 * contains Chinese characters, those characters cannot display on a system
		 * that uses the CP1252 code page because that code page does not include
		 * Chinese characters.
		 *
		 * To ensure that users on all platforms can view external text files used
		 * in your application, you should encode all external text files as Unicode
		 * and leave `useCodePage` set to `false`. This way,
		 * the application(Flash Player 6 and later, or AIR) interprets the text as
		 * Unicode.
		 */
		public static var useCodePage:Boolean;
		
		public static function get vmVersion ():String { return null; }
		
		protected static function get_vmVersion ():String { return null; }
		
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10_1) public static function disposeXML (node:flash.xml.XML):void {}
		// #end
		
		
		/**
		 * Closes Flash Player.
		 *
		 * _For the standalone Flash Player debugger version only._
		 *
		 * AIR applications should call the `NativeApplication.exit()`
		 * method to exit the application.
		 * 
		 * @param code A value to pass to the operating system. Typically, if the
		 *             process exits normally, the value is 0.
		 */
		public static function exit (code:uint):void {}
		
		
		/**
		 * Forces the garbage collection process.
		 *
		 * _For the Flash Player debugger version and AIR applications only._
		 * In an AIR application, the `System.gc()` method is only enabled
		 * in content running in the AIR Debug Launcher(ADL) or, in an installed
		 * applcation, in content in the application security sandbox.
		 * 
		 */
		public static function gc ():void {}
		
		
		/**
		 * Pauses Flash Player or the AIR Debug Launcher(ADL). After calling this
		 * method, nothing in the application continues except the delivery of Socket
		 * events.
		 *
		 * _For the Flash Player debugger version or the AIR Debug Launcher
		 * (ADL) only._
		 * 
		 */
		public static function pause ():void {}
		
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash11) public static function pauseForGCIfCollectionImminent (imminence:Float = 0.75):void {}
		// #end
		
		
		/**
		 * Resumes the application after calling `System.pause()`.
		 *
		 * _For the Flash Player debugger version or the AIR Debug Launcher
		 * (ADL) only._
		 * 
		 */
		public static function resume ():void {}
		
		
		/**
		 * Replaces the contents of the Clipboard with a specified text string. This
		 * method works from any security context when called as a result of a user
		 * event(such as a keyboard or input device event handler).
		 *
		 * This method is provided for SWF content running in Flash Player 9. It
		 * allows only adding String content to the Clipboard.
		 *
		 * Flash Player 10 content and content in the application security sandbox
		 * in an AIR application can call the `Clipboard.setData()`
		 * method.
		 * 
		 * @param string A plain-text string of characters to put on the system
		 *               Clipboard, replacing its current contents(if any).
		 */
		public static function setClipboard (string:String):void {}
		
		
	}
	
	
}