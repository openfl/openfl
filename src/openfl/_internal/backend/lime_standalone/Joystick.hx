package openfl._internal.backend.lime_standalone;

#if openfl_html5
class Joystick
{
	public static var devices = new Map<Int, Joystick>();
	public static var onConnect = new LimeEvent<Joystick->Void>();

	public var connected(default, null):Bool;
	public var guid(get, never):String;
	public var id(default, null):Int;
	public var name(get, never):String;
	public var numAxes(get, never):Int;
	public var numButtons(get, never):Int;
	public var numHats(get, never):Int;
	public var numTrackballs(get, never):Int;
	public var onAxisMove = new LimeEvent<Int->Float->Void>();
	public var onButtonDown = new LimeEvent<Int->Void>();
	public var onButtonUp = new LimeEvent<Int->Void>();
	public var onDisconnect = new LimeEvent<Void->Void>();
	public var onHatMove = new LimeEvent<Int->JoystickHatPosition->Void>();
	public var onTrackballMove = new LimeEvent<Int->Float->Float->Void>();

	public function new(id:Int)
	{
		this.id = id;
		connected = true;
	}

	@:noCompletion private static function __connect(id:Int):Void
	{
		if (!devices.exists(id))
		{
			var joystick = new Joystick(id);
			devices.set(id, joystick);
			onConnect.dispatch(joystick);
		}
	}

	@:noCompletion private static function __disconnect(id:Int):Void
	{
		var joystick = devices.get(id);
		if (joystick != null) joystick.connected = false;
		devices.remove(id);
		if (joystick != null) joystick.onDisconnect.dispatch();
	}

	@:noCompletion private static function __getDeviceData():Array<Dynamic>
	{
		return
			(untyped navigator.getGamepads) ? untyped navigator.getGamepads() : (untyped navigator.webkitGetGamepads) ? untyped navigator.webkitGetGamepads() : null;
	}

	// Get & Set Methods
	@:noCompletion private inline function get_guid():String
	{
		var devices = __getDeviceData();
		return devices[this.id].id;
	}

	@:noCompletion private inline function get_name():String
	{
		var devices = __getDeviceData();
		return devices[this.id].id;
	}

	@:noCompletion private inline function get_numAxes():Int
	{
		var devices = __getDeviceData();
		return devices[this.id].axes.length;
	}

	@:noCompletion private inline function get_numButtons():Int
	{
		var devices = __getDeviceData();
		return devices[this.id].buttons.length;
	}

	@:noCompletion private inline function get_numHats():Int
	{
		return 0;
	}

	@:noCompletion private inline function get_numTrackballs():Int
	{
		return 0;
	}
}
#end
