namespace openfl._internal.backend.lime_standalone;

#if openfl_html5
@: access(openfl._internal.backend.lime_standalone.Joystick)
class Gamepad
{
	public static devices = new Map<Int, Gamepad>();
	public static onConnect = new LimeEvent < Gamepad -> Void > ();

	public connected(default , null): boolean;
	public guid(get, never): string;
	public id(default , null): number;
	public name(get, never): string;
	public onAxisMove = new LimeEvent < GamepadAxis -> Float -> Void > ();
	public onButtonDown = new LimeEvent < GamepadButton -> Void > ();
	public onButtonUp = new LimeEvent < GamepadButton -> Void > ();
	public onDisconnect = new LimeEvent < Void -> Void > ();

	public constructor(id: number)
	{
		this.id = id;
		connected = true;
	}

	public static addMappings(mappings: Array<string>): void { }

	protected static __connect(id: number): void
	{
		if (!devices.exists(id))
		{
			var gamepad = new Gamepad(id);
			devices.set(id, gamepad);
			onConnect.dispatch(gamepad);
		}
	}

	protected static __disconnect(id: number): void
	{
		var gamepad = devices.get(id);
		if (gamepad != null) gamepad.connected = false;
		devices.remove(id);
		if (gamepad != null) gamepad.onDisconnect.dispatch();
	}

	// Get & Set Methods
	protected inline get_guid(): string
	{
		var devices = Joystick.__getDeviceData();
		return devices[this.id].id;
	}

	protected inline get_name(): string
	{
		var devices = Joystick.__getDeviceData();
		return devices[this.id].id;
	}
}
#end
