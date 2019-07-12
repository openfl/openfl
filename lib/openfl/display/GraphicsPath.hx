package openfl.display;

#if (display || !flash)
import openfl.Vector;

@:jsRequire("openfl/display/GraphicsPath", "default")

/**
 * A collection of drawing commands and the coordinate parameters for those
 * commands.
 *
 *  Use a GraphicsPath object with the
 * `Graphics.drawGraphicsData()` method. Drawing a GraphicsPath
 * object is the equivalent of calling the `Graphics.drawPath()`
 * method.
 *
 * The GraphicsPath class also has its own set of methods
 * (`curveTo()`, `lineTo()`, `moveTo()`
 * `wideLineTo()` and `wideMoveTo()`) similar to those
 * in the Graphics class for making adjustments to the
 * `GraphicsPath.commands` and `GraphicsPath.data`
 * vector arrays.
 */
@:final extern class GraphicsPath implements IGraphicsData implements IGraphicsPath
{
	/**
	 * The Vector of drawing commands as integers representing the path. Each
	 * command can be one of the values defined by the GraphicsPathCommand class.
	 */
	public var commands:Vector<Int>;

	/**
	 * The Vector of Numbers containing the parameters used with the drawing
	 * commands.
	 */
	public var data:Vector<Float>;

	/**
	 * Specifies the winding rule using a value defined in the
	 * GraphicsPathWinding class.
	 */
	public var winding:GraphicsPathWinding; /* note: currently ignored */

	/**
	 * Creates a new GraphicsPath object.
	 *
	 * @param winding Specifies the winding rule using a value defined in the
	 *                GraphicsPathWinding class.
	 */
	public function new(commands:Vector<Int> = null, data:Vector<Float> = null, ?winding:GraphicsPathWinding);

	public function cubicCurveTo(controlX1:Float, controlY1:Float, controlX2:Float, controlY2:Float, anchorX:Float, anchorY:Float):Void;

	/**
	 * Adds a new "curveTo" command to the `commands` vector and new
	 * coordinates to the `data` vector.
	 *
	 * @param controlX A number that specifies the horizontal position of the
	 *                 control point relative to the registration point of the
	 *                 parent display object.
	 * @param controlY A number that specifies the vertical position of the
	 *                 control point relative to the registration point of the
	 *                 parent display object.
	 * @param anchorX  A number that specifies the horizontal position of the
	 *                 next anchor point relative to the registration point of
	 *                 the parent display object.
	 * @param anchorY  A number that specifies the vertical position of the next
	 *                 anchor point relative to the registration point of the
	 *                 parent display object.
	 */
	public function curveTo(controlX:Float, controlY:Float, anchorX:Float, anchorY:Float):Void;

	/**
	 * Adds a new "lineTo" command to the `commands` vector and new
	 * coordinates to the `data` vector.
	 *
	 * @param x The x coordinate of the destination point for the line.
	 * @param y The y coordinate of the destination point for the line.
	 */
	public function lineTo(x:Float, y:Float):Void;

	/**
	 * Adds a new "moveTo" command to the `commands` vector and new
	 * coordinates to the `data` vector.
	 *
	 * @param x The x coordinate of the destination point.
	 * @param y The y coordinate of the destination point.
	 */
	public function moveTo(x:Float, y:Float):Void;

	/**
	 * Adds a new "wideLineTo" command to the `commands` vector and
	 * new coordinates to the `data` vector.
	 *
	 * @param x The x-coordinate of the destination point for the line.
	 * @param y The y-coordinate of the destination point for the line.
	 */
	public function wideLineTo(x:Float, y:Float):Void;

	/**
	 * Adds a new "wideMoveTo" command to the `commands` vector and
	 * new coordinates to the `data` vector.
	 *
	 * @param x The x-coordinate of the destination point.
	 * @param y The y-coordinate of the destination point.
	 */
	public function wideMoveTo(x:Float, y:Float):Void;
}
#else
typedef GraphicsPath = flash.display.GraphicsPath;
#end
