package flash.display;

#if flash
import openfl.Vector;

@:final extern class GraphicsPath implements IGraphicsData implements IGraphicsPath
{
	#if (haxe_ver < 4.3)
	public var winding:GraphicsPathWinding;
	#else
	@:flash.property var winding(get, set):GraphicsPathWinding;
	#end

	public var commands:Vector<Int>;
	public var data:Vector<Float>;
	public function new(commands:Vector<Int> = null, data:Vector<Float> = null, ?winding:GraphicsPathWinding);
	@:require(flash11) public function cubicCurveTo(controlX1:Float, controlY1:Float, controlX2:Float, controlY2:Float, anchorX:Float, anchorY:Float):Void;
	public function curveTo(controlX:Float, controlY:Float, anchorX:Float, anchorY:Float):Void;
	public function lineTo(x:Float, y:Float):Void;
	public function moveTo(x:Float, y:Float):Void;
	public function wideLineTo(x:Float, y:Float):Void;
	public function wideMoveTo(x:Float, y:Float):Void;

	#if (haxe_ver >= 4.3)
	private function get_winding():GraphicsPathWinding;
	private function set_winding(value:GraphicsPathWinding):GraphicsPathWinding;
	#end
}
#else
typedef GraphicsPath = openfl.display.GraphicsPath;
#end
