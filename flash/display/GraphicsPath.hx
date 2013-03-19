package flash.display;
#if (flash || display)


/**
 * A collection of drawing commands and the coordinate parameters for those
 * commands.
 *
 * <p> Use a GraphicsPath object with the
 * <code>Graphics.drawGraphicsData()</code> method. Drawing a GraphicsPath
 * object is the equivalent of calling the <code>Graphics.drawPath()</code>
 * method. </p>
 *
 * <p>The GraphicsPath class also has its own set of methods
 * (<code>curveTo()</code>, <code>lineTo()</code>, <code>moveTo()</code>
 * <code>wideLineTo()</code> and <code>wideMoveTo()</code>) similar to those
 * in the Graphics class for making adjustments to the
 * <code>GraphicsPath.commands</code> and <code>GraphicsPath.data</code>
 * vector arrays.</p>
 */
@:final extern class GraphicsPath implements IGraphicsData/*  implements IGraphicsPath*/ {

	/**
	 * The Vector of drawing commands as integers representing the path. Each
	 * command can be one of the values defined by the GraphicsPathCommand class.
	 */
	var commands : flash.Vector<Int>;

	/**
	 * The Vector of Numbers containing the parameters used with the drawing
	 * commands.
	 */
	var data : flash.Vector<Float>;

	/**
	 * Specifies the winding rule using a value defined in the
	 * GraphicsPathWinding class.
	 */
	var winding : GraphicsPathWinding;

	/**
	 * Creates a new GraphicsPath object.
	 * 
	 * @param winding Specifies the winding rule using a value defined in the
	 *                GraphicsPathWinding class.
	 */
	function new(?commands : flash.Vector<Int>, ?data : flash.Vector<Float>, ?winding : GraphicsPathWinding) : Void;
	@:require(flash11) function cubicCurveTo(controlX1 : Float, controlY1 : Float, controlX2 : Float, controlY2 : Float, anchorX : Float, anchorY : Float) : Void;

	/**
	 * Adds a new "curveTo" command to the <code>commands</code> vector and new
	 * coordinates to the <code>data</code> vector.
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
	function curveTo(controlX : Float, controlY : Float, anchorX : Float, anchorY : Float) : Void;

	/**
	 * Adds a new "lineTo" command to the <code>commands</code> vector and new
	 * coordinates to the <code>data</code> vector.
	 * 
	 * @param x The x coordinate of the destination point for the line.
	 * @param y The y coordinate of the destination point for the line.
	 */
	function lineTo(x : Float, y : Float) : Void;

	/**
	 * Adds a new "moveTo" command to the <code>commands</code> vector and new
	 * coordinates to the <code>data</code> vector.
	 * 
	 * @param x The x coordinate of the destination point.
	 * @param y The y coordinate of the destination point.
	 */
	function moveTo(x : Float, y : Float) : Void;

	/**
	 * Adds a new "wideLineTo" command to the <code>commands</code> vector and
	 * new coordinates to the <code>data</code> vector.
	 * 
	 * @param x The x-coordinate of the destination point for the line.
	 * @param y The y-coordinate of the destination point for the line.
	 */
	function wideLineTo(x : Float, y : Float) : Void;

	/**
	 * Adds a new "wideMoveTo" command to the <code>commands</code> vector and
	 * new coordinates to the <code>data</code> vector.
	 * 
	 * @param x The x-coordinate of the destination point.
	 * @param y The y-coordinate of the destination point.
	 */
	function wideMoveTo(x : Float, y : Float) : Void;
}


#end
