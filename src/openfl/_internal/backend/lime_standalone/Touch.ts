namespace openfl._internal.backend.lime_standalone;

#if openfl_html5
class Touch
{
	public static onCancel = new LimeEvent < Touch -> Void > ();
	public static onEnd = new LimeEvent < Touch -> Void > ();
	public static onMove = new LimeEvent < Touch -> Void > ();
	public static onStart = new LimeEvent < Touch -> Void > ();

	public device: number;
	public dx: number;
	public dy: number;
	public id: number;
	public pressure: number;
	public x: number;
	public y: number;

	public new(x: number, y: number, id: number, dx: number, dy: number, pressure: number, device: number)
	{
		this.x = x;
		this.y = y;
		this.id = id;
		this.dx = dx;
		this.dy = dy;
		this.pressure = pressure;
		this.device = device;
	}
}
#end
