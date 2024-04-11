package flash.display;

#if flash
@:final extern class GraphicsStroke implements IGraphicsData implements IGraphicsStroke
{
	#if (haxe_ver < 4.3)
	public var caps:CapsStyle;
	public var joints:JointStyle;
	public var scaleMode:LineScaleMode;
	#else
	@:flash.property var caps(get, set):CapsStyle;
	@:flash.property var joints(get, set):JointStyle;
	@:flash.property var scaleMode(get, set):LineScaleMode;
	#end

	public var fill:IGraphicsFill;
	public var miterLimit:Float;
	public var pixelHinting:Bool;
	public var thickness:Float;

	public function new(thickness:Float = 0 /*NaN*/, pixelHinting:Bool = false, ?scaleMode:LineScaleMode, ?caps:CapsStyle, ?joints:JointStyle,
		miterLimit:Float = 3, fill:IGraphicsFill = null);

	#if (haxe_ver >= 4.3)
	private function get_caps():CapsStyle;
	private function get_joints():JointStyle;
	private function get_scaleMode():LineScaleMode;
	private function set_caps(value:CapsStyle):CapsStyle;
	private function set_joints(value:JointStyle):JointStyle;
	private function set_scaleMode(value:LineScaleMode):LineScaleMode;
	#end
}
#else
typedef GraphicsStroke = openfl.display.GraphicsStroke;
#end
