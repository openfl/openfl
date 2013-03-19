package flash.errors;
#if (flash || display)


/**
 * The IllegalOperationError exception is thrown when a method is not
 * implemented or the implementation doesn't cover the current usage.
 *
 * <p>Examples of illegal operation error exceptions include:</p>
 *
 * <ul>
 *   <li>A base class, such as DisplayObjectContainer, provides more
 * functionality than a Stage can support(such as masks)</li>
 *   <li>Certain accessibility methods are called when the player is compiled
 * without accessibility support</li>
 *   <li>The mms.cfg setting prohibits a FileReference action</li>
 *   <li>ActionScript tries to run a <code>FileReference.browse()</code> call
 * when a browse dialog box is already open</li>
 *   <li>ActionScript tries to use an unsupported protocol for a FileReference
 * object(such as FTP)</li>
 * <li product="flash">Authoring-only features are invoked from a run-time
 * player</li>
 * <li product="flash">An attempt is made to set the name of a Timeline-placed
 * object</li>
 * </ul>
 */
extern class IllegalOperationError extends Error {

	/**
	 * Creates a new IllegalOperationError object.
	 * 
	 * @param message A string associated with the error object.
	 */
	function new(?message : String, id : Int = 0) : Void;
}


#end
