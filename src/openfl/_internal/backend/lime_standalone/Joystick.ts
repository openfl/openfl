namespace openfl._internal.backend.lime_standalone;

#if openfl_html5
class Joystick
{
	public static devices = new Map<Int, Joystick>();
	public static onConnect = new LimeEvent < Joystick -> Void > ();

	public connected(default , null): boolean;
	public guid(get, never): string;
	public id(default , null): number;
	public name(get, never): string;
	public numAxes(get, never): number;
	public numButtons(get, never): number;
	public numHats(get, never): number;
	public numTrackballs(get, never): number;
	public onAxisMove = new LimeEvent < Int -> Float -> Void > ();
	public onButtonDown = new LimeEvent < Int -> Void > ();
	public onButtonUp = new LimeEvent < Int -> Void > ();
	public onDisconnect = new LimeEvent < Void -> Void > ();
	public onHatMove = new LimeEvent < Int -> JoystickHatPosition -> Void > ();
	public onTrackballMove = new LimeEvent < Int -> Float -> Float -> Void > ();

	public constructor(id: number)
	{
		this.id = id;
		connected = true;
	}

	protected static __connect(id: number): void
	{
		if (!devices.exists(id))
		{
			var joystick = new Joystick(id);
			devices.set(id, joystick);
			onConnect.dispatch(joystick);
		}
	}

	protected static __disconnect(id: number): void
	{
		var joystick = devices.get(id);
		if (joystick != null) joystick.connected = false;
		devices.remove(id);
		if (joystick != null) joystick.onDisconnect.dispatch();
	}

	protected static __getDeviceData(): Array<Dynamic>
	{
		return
		(untyped navigator.getGamepads) ?untyped navigator.getGamepads() : (untyped navigator.webkitGetGamepads) ?untyped navigator.webkitGetGamepads() : null;
	}

	// Get & Set Methods
	protected inline get_guid(): string
	{
		var devices = __getDeviceData();
		return devices[this.id].id;
	}

	protected inline get_name(): string
	{
		var devices = __getDeviceData();
		return devices[this.id].id;
	}

	protected inline get_numAxes(): number
	{
		var devices = __getDeviceData();
		return devices[this.id].axes.length;
	}

	protected inline get_numButtons(): number
	{
		var devices = __getDeviceData();
		return devices[this.id].buttons.length;
	}

	protected inline get_numHats(): number
	{
		return 0;
	}

	protected inline get_numTrackballs(): number
	{
		return 0;
	}
}
#end
