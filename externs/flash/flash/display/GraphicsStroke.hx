package flash.display;

#if flash
@:final extern class GraphicsStroke implements IGraphicsData implements IGraphicsStroke
{
	public var caps:CapsStyle;
	public var fill:IGraphicsFill;
	public var joints:JointStyle;
	public var miterLimit:Float;
	public var pixelHinting:Bool;
	public var scaleMode:LineScaleMode;
	public var thickness:Float;
	public function new(thickness:Float = 0 /*NaN*/, pixelHinting:Bool = false, ?scaleMode:LineScaleMode, ?caps:CapsStyle, ?joints:JointStyle,
		miterLimit:Float = 3, fill:IGraphicsFill = null);
}
#else
typedef GraphicsStroke = openfl.display.GraphicsStroke;
#end
