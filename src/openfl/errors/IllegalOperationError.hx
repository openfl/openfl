package openfl.errors;

#if !flash
/**
	The IllegalOperationError exception is thrown when a method is not
	implemented or the implementation doesn't cover the current usage.

	Examples of illegal operation error exceptions include:

	* A base class, such as DisplayObjectContainer, provides more
	functionality than a Stage can support(such as masks)
	* Certain accessibility methods are called when the player is compiled
	without accessibility support
	* The mms.cfg setting prohibits a FileReference action
	* ActionScript tries to run a `FileReference.browse()` call
	when a browse dialog box is already open
	* ActionScript tries to use an unsupported protocol for a FileReference
	object(such as FTP)
	* Authoring-only features are invoked from a run-time
	player
	* An attempt is made to set the name of a Timeline-placed
	object
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class IllegalOperationError extends Error
{
	/**
		Creates a new IllegalOperationError object.

		@param message A string associated with the error object.
	**/
	public function new(message:String = "")
	{
		super(message, 0);

		name = "IllegalOperationError";
	}
}
#else
typedef IllegalOperationError = flash.errors.IllegalOperationError;
#end
