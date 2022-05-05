package openfl.net;

import haxe.Constraints.Function;

#if !flash
/**
	The Responder class provides an object that is used in
	`NetConnection.call()` to handle return values from the server related to
	the success or failure of specific operations. When working with
	`NetConnection.call()`, you may encounter a network operation fault specific
	to the current operation or a fault related to the current connection
	status. Operation errors target the Responder object instead of the
	NetConnection object for easier error handling.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class Responder
{
	// the result and status functions are not exposed publicly by the flash
	// target, so they need @:privateAccess for any other target
	@:noCompletion private var __result:Function;
	@:noCompletion private var __status:Function;

	/**
		Creates a new Responder object. You pass a Responder object to
		`NetConnection.call()` to handle return values from the server. You may
		pass `null` for either or both parameters.
	**/
	public function new(result:Function, status:Function = null)
	{
		__result = result;
		__status = status;
	}
}
#else
typedef Responder = flash.net.Responder;
#end
