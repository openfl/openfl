package openfl.net;

import openfl.events.EventDispatcher;
import openfl.events._EventDispatcher;
import openfl.events.NetStatusEvent;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:noCompletion
class _NetConnection extends _EventDispatcher
{
	public static inline var CONNECT_SUCCESS:String = "NetConnection.Connect.Success";

	public function new()
	{
		super();
	}

	public function connect(command:String, p1 = null, p2 = null, p3 = null, p4 = null, p5 = null):Void
	{
		if (command != null)
		{
			throw "Error: Can only connect in \"HTTP streaming\" mode";
		}

		this.dispatchEvent(new NetStatusEvent(NetStatusEvent.NET_STATUS, false, true, {code: _NetConnection.CONNECT_SUCCESS}));
	}
}
