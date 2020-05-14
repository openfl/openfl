package openfl.display;

#if !flash
import openfl._internal.renderer.GraphicsDataType;
import openfl.Vector;

/**
	A collection of drawing commands and the coordinate parameters for those
	commands.

	Use a GraphicsPath object with the
	`Graphics.drawGraphicsData()` method. Drawing a GraphicsPath
	object is the equivalent of calling the `Graphics.drawPath()`
	method.

	The GraphicsPath class also has its own set of methods
	(`curveTo()`, `lineTo()`, `moveTo()`
	`wideLineTo()` and `wideMoveTo()`) similar to those
	in the Graphics class for making adjustments to the
	`GraphicsPath.commands` and `GraphicsPath.data`
	vector arrays.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:final class GraphicsPath implements IGraphicsData implements IGraphicsPath
{
	/**
		The Vector of drawing commands as integers representing the path. Each
		command can be one of the values defined by the GraphicsPathCommand class.
	**/
	public var commands(get, set):Vector<Int>;

	/**
		The Vector of Numbers containing the parameters used with the drawing
		commands.
	**/
	public var data(get, set):Vector<Float>;

	/**
		Specifies the winding rule using a value defined in the
		GraphicsPathWinding class.
	**/
	public var winding(get, set):GraphicsPathWinding;

	@:allow(openfl) @:noCompletion private var _:Any;

	/**
		Creates a new GraphicsPath object.

		@param winding Specifies the winding rule using a value defined in the
					   GraphicsPathWinding class.
	**/
	public function new(commands:Vector<Int> = null, data:Vector<Float> = null, winding:GraphicsPathWinding = GraphicsPathWinding.EVEN_ODD)
	{
		_ = new _GraphicsPath(this, commands, data, winding);
	}

	/**
		Adds a new "cubicCurveTo" command to the commands vector and new coordinates to
		the data vector.

		@param	controlX1	A number that specifies the horizontal position of the first
		control point relative to the registration point of the parent display object.
		@param	controlY1	A number that specifies the vertical position of the first
		control point relative to the registration point of the parent display object.
		@param	controlX2	A number that specifies the horizontal position of the second
		control point relative to the registration point of the parent display object.
		@param	controlY2	A number that specifies the vertical position of the second
		control point relative to the registration point of the parent display object.
		@param	anchorX	A number that specifies the horizontal position of the next anchor
		point relative to the registration point of the parent display object.
		@param	anchorY	A number that specifies the vertical position of the next anchor
		point relative to the registration point of the parent display object.
	**/
	public function cubicCurveTo(controlX1:Float, controlY1:Float, controlX2:Float, controlY2:Float, anchorX:Float, anchorY:Float):Void
	{
		(_ : _GraphicsPath).cubicCurveTo(controlX1, controlY1, controlX2, controlY2, anchorX, anchorY);
	}

	/**
		Adds a new "curveTo" command to the `commands` vector and new
		coordinates to the `data` vector.

		@param controlX A number that specifies the horizontal position of the
						control point relative to the registration point of the
						parent display object.
		@param controlY A number that specifies the vertical position of the
						control point relative to the registration point of the
						parent display object.
		@param anchorX  A number that specifies the horizontal position of the
						next anchor point relative to the registration point of
						the parent display object.
		@param anchorY  A number that specifies the vertical position of the next
						anchor point relative to the registration point of the
						parent display object.
	**/
	public function curveTo(controlX:Float, controlY:Float, anchorX:Float, anchorY:Float):Void
	{
		(_ : _GraphicsPath).curveTo(controlX, controlY, anchorX, anchorY);
	}

	/**
		Adds a new "lineTo" command to the `commands` vector and new
		coordinates to the `data` vector.

		@param x The x coordinate of the destination point for the line.
		@param y The y coordinate of the destination point for the line.
	**/
	public function lineTo(x:Float, y:Float):Void
	{
		(_ : _GraphicsPath).lineTo(x, y);
	}

	/**
		Adds a new "moveTo" command to the `commands` vector and new
		coordinates to the `data` vector.

		@param x The x coordinate of the destination point.
		@param y The y coordinate of the destination point.
	**/
	public function moveTo(x:Float, y:Float):Void
	{
		(_ : _GraphicsPath).moveTo(x, y);
	}

	/**
		Adds a new "wideLineTo" command to the `commands` vector and
		new coordinates to the `data` vector.

		@param x The x-coordinate of the destination point for the line.
		@param y The y-coordinate of the destination point for the line.
	**/
	public function wideLineTo(x:Float, y:Float):Void
	{
		(_ : _GraphicsPath).wideLineTo(x, y);
	}

	/**
		Adds a new "wideMoveTo" command to the `commands` vector and
		new coordinates to the `data` vector.

		@param x The x-coordinate of the destination point.
		@param y The y-coordinate of the destination point.
	**/
	public function wideMoveTo(x:Float, y:Float):Void
	{
		(_ : _GraphicsPath).wideMoveTo(x, y);
	}

	// Get & Set Methods

	@:noCompletion private function get_commands():Vector<Int>
	{
		return (_ : _GraphicsPath).commands;
	}

	@:noCompletion private function set_commands(value:Vector<Int>):Vector<Int>
	{
		return (_ : _GraphicsPath).commands = value;
	}

	@:noCompletion private function get_data():Vector<Float>
	{
		return (_ : _GraphicsPath).data;
	}

	@:noCompletion private function set_data(value:Vector<Float>):Vector<Float>
	{
		return (_ : _GraphicsPath).data = value;
	}

	@:noCompletion private function get_winding():GraphicsPathWinding
	{
		return (_ : _GraphicsPath).winding;
	}

	@:noCompletion private function set_winding(value:GraphicsPathWinding):GraphicsPathWinding
	{
		return (_ : _GraphicsPath).winding = value;
	}
}
#else
typedef GraphicsPath = flash.display.GraphicsPath;
#end
