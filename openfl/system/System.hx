/*
 
 This class provides code completion and inline documentation, but it does 
 not contain runtime support. It should be overridden by a compatible
 implementation in an OpenFL backend, depending upon the target platform.
 
*/

package openfl.system;
#if display


/**
 * The System class contains properties related to local settings and
 * operations. Among these are settings for camers and microphones, operations
 * with shared objects and the use of the Clipboard.
 *
 * <p>Additional properties and methods are in other classes within the
 * openfl.system package: the Capabilities class, the IME class, and the
 * Security class.</p>
 *
 * <p>This class contains only static methods and properties. You cannot
 * create new instances of the System class.</p>
 */
extern class System {
	static var deviceID(default, null):String;
	
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
	static var totalMemory(default, null):UInt;
	
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
	static function exit(code : UInt) : Void;

	/**
	 * Forces the garbage collection process.
	 *
	 * <p><i>For the Flash Player debugger version and AIR applications only.</i>
	 * In an AIR application, the <code>System.gc()</code> method is only enabled
	 * in content running in the AIR Debug Launcher(ADL) or, in an installed
	 * applcation, in content in the application security sandbox.</p>
	 * 
	 */
	static function gc() : Void;
}


#end
