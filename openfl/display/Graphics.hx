package openfl.display; #if !flash #if !lime_legacy


import openfl._internal.renderer.opengl.utils.FilterTexture;
import openfl.errors.ArgumentError;
import openfl._internal.renderer.opengl.utils.GraphicsRenderer;
import openfl._internal.renderer.opengl.utils.DrawPath;
import openfl.display.GraphicsPathCommand;
import openfl.display.Tilesheet;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.Vector;

#if js
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
#end


/**
 * The Graphics class contains a set of methods that you can use to create a
 * vector shape. Display objects that support drawing include Sprite and Shape
 * objects. Each of these classes includes a <code>graphics</code> property
 * that is a Graphics object. The following are among those helper functions
 * provided for ease of use: <code>drawRect()</code>,
 * <code>drawRoundRect()</code>, <code>drawCircle()</code>, and
 * <code>drawEllipse()</code>.
 *
 * <p>You cannot create a Graphics object directly from ActionScript code. If
 * you call <code>new Graphics()</code>, an exception is thrown.</p>
 *
 * <p>The Graphics class is final; it cannot be subclassed.</p>
 */
class Graphics {
	
	
	public static inline var TILE_SCALE = 0x0001;
	public static inline var TILE_ROTATION = 0x0002;
	public static inline var TILE_RGB = 0x0004;
	public static inline var TILE_ALPHA = 0x0008;
	public static inline var TILE_TRANS_2x2 = 0x0010;
	public static inline var TILE_RECT = 0x0020;
	public static inline var TILE_ORIGIN = 0x0040;
	public static inline var TILE_BLEND_NORMAL = 0x00000000;
	public static inline var TILE_BLEND_ADD = 0x00010000;
	
	@:noCompletion private var __bounds:Rectangle;
	@:noCompletion private var __commands:Array<DrawCommand> = [];
	@:noCompletion private var __dirty:Bool = true;
	@:noCompletion private var __glStack:Array<GLStack> = [];
	@:noCompletion private var __drawPaths:Array<DrawPath>;
	@:noCompletion private var __halfStrokeWidth:Float;
	@:noCompletion private var __positionX:Float;
	@:noCompletion private var __positionY:Float;
	@:noCompletion private var __transformDirty:Bool;
	@:noCompletion private var __visible:Bool = true;
	@:noCompletion private var __cachedTexture:FilterTexture;
	
	#if js
	@:noCompletion private var __canvas:CanvasElement;
	@:noCompletion private var __context:CanvasRenderingContext2D;
	#end
	
	
	public function new () {
		
		__commands = new Array ();
		__halfStrokeWidth = 0;
		__positionX = 0;
		__positionY = 0;
		
	}
	
	
	/**
	 * Fills a drawing area with a bitmap image. The bitmap can be repeated or
	 * tiled to fill the area. The fill remains in effect until you call the
	 * <code>beginFill()</code>, <code>beginBitmapFill()</code>,
	 * <code>beginGradientFill()</code>, or <code>beginShaderFill()</code>
	 * method. Calling the <code>clear()</code> method clears the fill.
	 *
	 * <p>The application renders the fill whenever three or more points are
	 * drawn, or when the <code>endFill()</code> method is called. </p>
	 * 
	 * @param bitmap A transparent or opaque bitmap image that contains the bits
	 *               to be displayed.
	 * @param matrix A matrix object(of the openfl.geom.Matrix class), which you
	 *               can use to define transformations on the bitmap. For
	 *               example, you can use the following matrix to rotate a bitmap
	 *               by 45 degrees(pi/4 radians):
	 * @param repeat If <code>true</code>, the bitmap image repeats in a tiled
	 *               pattern. If <code>false</code>, the bitmap image does not
	 *               repeat, and the edges of the bitmap are used for any fill
	 *               area that extends beyond the bitmap.
	 *
	 *               <p>For example, consider the following bitmap(a 20 x
	 *               20-pixel checkerboard pattern):</p>
	 *
	 *               <p>When <code>repeat</code> is set to <code>true</code>(as
	 *               in the following example), the bitmap fill repeats the
	 *               bitmap:</p>
	 *
	 *               <p>When <code>repeat</code> is set to <code>false</code>,
	 *               the bitmap fill uses the edge pixels for the fill area
	 *               outside the bitmap:</p>
	 * @param smooth If <code>false</code>, upscaled bitmap images are rendered
	 *               by using a nearest-neighbor algorithm and look pixelated. If
	 *               <code>true</code>, upscaled bitmap images are rendered by
	 *               using a bilinear algorithm. Rendering by using the nearest
	 *               neighbor algorithm is faster.
	 */
	public function beginBitmapFill (bitmap:BitmapData, matrix:Matrix = null, repeat:Bool = true, smooth:Bool = false) {
		
		__commands.push (BeginBitmapFill (bitmap, matrix != null ? matrix.clone () : null, repeat, smooth));
		
		__visible = true;
		
	}
	
	
	/**
	 * Specifies a simple one-color fill that subsequent calls to other Graphics
	 * methods(such as <code>lineTo()</code> or <code>drawCircle()</code>) use
	 * when drawing. The fill remains in effect until you call the
	 * <code>beginFill()</code>, <code>beginBitmapFill()</code>,
	 * <code>beginGradientFill()</code>, or <code>beginShaderFill()</code>
	 * method. Calling the <code>clear()</code> method clears the fill.
	 *
	 * <p>The application renders the fill whenever three or more points are
	 * drawn, or when the <code>endFill()</code> method is called.</p>
	 * 
	 * @param color The color of the fill(0xRRGGBB).
	 * @param alpha The alpha value of the fill(0.0 to 1.0).
	 */
	public function beginFill (color:Int = 0, alpha:Float = 1):Void {
		
		__commands.push (BeginFill (color & 0xFFFFFF, alpha));
		
		if (alpha > 0) __visible = true;
		
	}
	
	
	/**
	 * Specifies a gradient fill used by subsequent calls to other Graphics
	 * methods(such as <code>lineTo()</code> or <code>drawCircle()</code>) for
	 * the object. The fill remains in effect until you call the
	 * <code>beginFill()</code>, <code>beginBitmapFill()</code>,
	 * <code>beginGradientFill()</code>, or <code>beginShaderFill()</code>
	 * method. Calling the <code>clear()</code> method clears the fill.
	 *
	 * <p>The application renders the fill whenever three or more points are
	 * drawn, or when the <code>endFill()</code> method is called. </p>
	 * 
	 * @param type                A value from the GradientType class that
	 *                            specifies which gradient type to use:
	 *                            <code>GradientType.LINEAR</code> or
	 *                            <code>GradientType.RADIAL</code>.
	 * @param matrix              A transformation matrix as defined by the
	 *                            openfl.geom.Matrix class. The openfl.geom.Matrix
	 *                            class includes a
	 *                            <code>createGradientBox()</code> method, which
	 *                            lets you conveniently set up the matrix for use
	 *                            with the <code>beginGradientFill()</code>
	 *                            method.
	 * @param spreadMethod        A value from the SpreadMethod class that
	 *                            specifies which spread method to use, either:
	 *                            <code>SpreadMethod.PAD</code>,
	 *                            <code>SpreadMethod.REFLECT</code>, or
	 *                            <code>SpreadMethod.REPEAT</code>.
	 *
	 *                            <p>For example, consider a simple linear
	 *                            gradient between two colors:</p>
	 *
	 *                            <p>This example uses
	 *                            <code>SpreadMethod.PAD</code> for the spread
	 *                            method, and the gradient fill looks like the
	 *                            following:</p>
	 *
	 *                            <p>If you use <code>SpreadMethod.REFLECT</code>
	 *                            for the spread method, the gradient fill looks
	 *                            like the following:</p>
	 *
	 *                            <p>If you use <code>SpreadMethod.REPEAT</code>
	 *                            for the spread method, the gradient fill looks
	 *                            like the following:</p>
	 * @param interpolationMethod A value from the InterpolationMethod class that
	 *                            specifies which value to use:
	 *                            <code>InterpolationMethod.LINEAR_RGB</code> or
	 *                            <code>InterpolationMethod.RGB</code>
	 *
	 *                            <p>For example, consider a simple linear
	 *                            gradient between two colors(with the
	 *                            <code>spreadMethod</code> parameter set to
	 *                            <code>SpreadMethod.REFLECT</code>). The
	 *                            different interpolation methods affect the
	 *                            appearance as follows: </p>
	 * @param focalPointRatio     A number that controls the location of the
	 *                            focal point of the gradient. 0 means that the
	 *                            focal point is in the center. 1 means that the
	 *                            focal point is at one border of the gradient
	 *                            circle. -1 means that the focal point is at the
	 *                            other border of the gradient circle. A value
	 *                            less than -1 or greater than 1 is rounded to -1
	 *                            or 1. For example, the following example shows
	 *                            a <code>focalPointRatio</code> set to 0.75:
	 * @throws ArgumentError If the <code>type</code> parameter is not valid.
	 */
	public function beginGradientFill (type:GradientType, colors:Array<Dynamic>, alphas:Array<Dynamic>, ratios:Array<Dynamic>, matrix:Matrix = null, spreadMethod:Null<SpreadMethod> = null, interpolationMethod:Null<InterpolationMethod> = null, focalPointRatio:Null<Float> = null):Void {
		
		openfl.Lib.notImplemented ("Graphics.beginGradientFill");
		
	}
	
	
	/**
	 * Clears the graphics that were drawn to this Graphics object, and resets
	 * fill and line style settings.
	 * 
	 */
	public function clear ():Void {
		
		__commands = new Array ();
		__halfStrokeWidth = 0;
		
		if (__bounds != null) {
			
			__dirty = true;
			__transformDirty = true;
			__bounds = null;
			
		}
		
		__visible = false;
		
	}
	
	
	public function copyFrom (sourceGraphics:Graphics):Void {
		
		__bounds = sourceGraphics.__bounds.clone ();
		__commands = sourceGraphics.__commands.copy ();
		__dirty = true;
		__halfStrokeWidth = sourceGraphics.__halfStrokeWidth;
		__positionX = sourceGraphics.__positionX;
		__positionY = sourceGraphics.__positionY;
		__transformDirty = true;
		__visible = sourceGraphics.__visible;
		
	}
	
	
	public function cubicCurveTo (controlX1:Float, controlY1:Float, controlX2:Float, controlY2:Float, anchorX:Float, anchorY:Float):Void {
		
		__inflateBounds (__positionX - __halfStrokeWidth, __positionY - __halfStrokeWidth);
		__inflateBounds (__positionX + __halfStrokeWidth, __positionY + __halfStrokeWidth);
		
		// TODO: Is this the right calculation for bounds?
		
		__inflateBounds (controlX1, controlY1);
		__inflateBounds (controlX2, controlY2);
		
		__positionX = anchorX;
		__positionY = anchorY;
		
		__inflateBounds (__positionX - __halfStrokeWidth, __positionY - __halfStrokeWidth);
		__inflateBounds (__positionX + __halfStrokeWidth, __positionY + __halfStrokeWidth);
		
		__commands.push (CubicCurveTo (controlX1, controlY1, controlX2, controlY2, anchorX, anchorY));
		
		__dirty = true;
		
	}
	
	
	/**
	 * Draws a curve using the current line style from the current drawing
	 * position to(anchorX, anchorY) and using the control point that
	 * (<code>controlX</code>, <code>controlY</code>) specifies. The current
	 * drawing position is then set to(<code>anchorX</code>,
	 * <code>anchorY</code>). If the movie clip in which you are drawing contains
	 * content created with the Flash drawing tools, calls to the
	 * <code>curveTo()</code> method are drawn underneath this content. If you
	 * call the <code>curveTo()</code> method before any calls to the
	 * <code>moveTo()</code> method, the default of the current drawing position
	 * is(0, 0). If any of the parameters are missing, this method fails and the
	 * current drawing position is not changed.
	 *
	 * <p>The curve drawn is a quadratic Bezier curve. Quadratic Bezier curves
	 * consist of two anchor points and one control point. The curve interpolates
	 * the two anchor points and curves toward the control point. </p>
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
	public function curveTo (controlX:Float, controlY:Float, anchorX:Float, anchorY:Float) {
		
		__inflateBounds (__positionX - __halfStrokeWidth, __positionY - __halfStrokeWidth);
		__inflateBounds (__positionX + __halfStrokeWidth, __positionY + __halfStrokeWidth);
		
		// TODO: Be a little less lenient in canvas size?
		
		__inflateBounds (controlX, controlY);
		
		__positionX = anchorX;
		__positionY = anchorY;
		
		__inflateBounds (__positionX - __halfStrokeWidth, __positionY - __halfStrokeWidth);
		__inflateBounds (__positionX + __halfStrokeWidth, __positionY + __halfStrokeWidth);
		
		__commands.push (CurveTo (controlX, controlY, anchorX, anchorY));
		
		__dirty = true;
		
	}
	
	
	/**
	 * Draws a circle. Set the line style, fill, or both before you call the
	 * <code>drawCircle()</code> method, by calling the <code>linestyle()</code>,
	 * <code>lineGradientStyle()</code>, <code>beginFill()</code>,
	 * <code>beginGradientFill()</code>, or <code>beginBitmapFill()</code>
	 * method.
	 * 
	 * @param x      The <i>x</i> location of the center of the circle relative
	 *               to the registration point of the parent display object(in
	 *               pixels).
	 * @param y      The <i>y</i> location of the center of the circle relative
	 *               to the registration point of the parent display object(in
	 *               pixels).
	 * @param radius The radius of the circle(in pixels).
	 */
	public function drawCircle (x:Float, y:Float, radius:Float):Void {
		
		if (radius <= 0) return;
		
		__inflateBounds (x - radius - __halfStrokeWidth, y - radius - __halfStrokeWidth);
		__inflateBounds (x + radius + __halfStrokeWidth, y + radius + __halfStrokeWidth);
		
		__commands.push (DrawCircle (x, y, radius));
		
		__dirty = true;
		
	}
	
	
	/**
	 * Draws an ellipse. Set the line style, fill, or both before you call the
	 * <code>drawEllipse()</code> method, by calling the
	 * <code>linestyle()</code>, <code>lineGradientStyle()</code>,
	 * <code>beginFill()</code>, <code>beginGradientFill()</code>, or
	 * <code>beginBitmapFill()</code> method.
	 * 
	 * @param x      The <i>x</i> location of the top-left of the bounding-box of
	 *               the ellipse relative to the registration point of the parent
	 *               display object(in pixels).
	 * @param y      The <i>y</i> location of the top left of the bounding-box of
	 *               the ellipse relative to the registration point of the parent
	 *               display object(in pixels).
	 * @param width  The width of the ellipse(in pixels).
	 * @param height The height of the ellipse(in pixels).
	 */
	public function drawEllipse (x:Float, y:Float, width:Float, height:Float):Void {
		
		if (width <= 0 || height <= 0) return;
		
		__inflateBounds (x - __halfStrokeWidth, y - __halfStrokeWidth);
		__inflateBounds (x + width + __halfStrokeWidth, y + height + __halfStrokeWidth);
		
		__commands.push (DrawEllipse (x, y, width, height));
		
		__dirty = true;
		
	}
	
	
	/**
	 * Submits a series of IGraphicsData instances for drawing. This method
	 * accepts a Vector containing objects including paths, fills, and strokes
	 * that implement the IGraphicsData interface. A Vector of IGraphicsData
	 * instances can refer to a part of a shape, or a complex fully defined set
	 * of data for rendering a complete shape.
	 *
	 * <p> Graphics paths can contain other graphics paths. If the
	 * <code>graphicsData</code> Vector includes a path, that path and all its
	 * sub-paths are rendered during this operation. </p>
	 * 
	 */
	public function drawGraphicsData (graphicsData:Vector<IGraphicsData>):Void {
		
		openfl.Lib.notImplemented ("Graphics.drawGraphicsData");
		
	}
	
	
	/**
	 * Submits a series of commands for drawing. The <code>drawPath()</code>
	 * method uses vector arrays to consolidate individual <code>moveTo()</code>,
	 * <code>lineTo()</code>, and <code>curveTo()</code> drawing commands into a
	 * single call. The <code>drawPath()</code> method parameters combine drawing
	 * commands with x- and y-coordinate value pairs and a drawing direction. The
	 * drawing commands are values from the GraphicsPathCommand class. The x- and
	 * y-coordinate value pairs are Numbers in an array where each pair defines a
	 * coordinate location. The drawing direction is a value from the
	 * GraphicsPathWinding class.
	 *
	 * <p> Generally, drawings render faster with <code>drawPath()</code> than
	 * with a series of individual <code>lineTo()</code> and
	 * <code>curveTo()</code> methods. </p>
	 *
	 * <p> The <code>drawPath()</code> method uses a uses a floating computation
	 * so rotation and scaling of shapes is more accurate and gives better
	 * results. However, curves submitted using the <code>drawPath()</code>
	 * method can have small sub-pixel alignment errors when used in conjunction
	 * with the <code>lineTo()</code> and <code>curveTo()</code> methods. </p>
	 *
	 * <p> The <code>drawPath()</code> method also uses slightly different rules
	 * for filling and drawing lines. They are: </p>
	 *
	 * <ul>
	 *   <li>When a fill is applied to rendering a path:
	 * <ul>
	 *   <li>A sub-path of less than 3 points is not rendered.(But note that the
	 * stroke rendering will still occur, consistent with the rules for strokes
	 * below.)</li>
	 *   <li>A sub-path that isn't closed(the end point is not equal to the
	 * begin point) is implicitly closed.</li>
	 * </ul>
	 * </li>
	 *   <li>When a stroke is applied to rendering a path:
	 * <ul>
	 *   <li>The sub-paths can be composed of any number of points.</li>
	 *   <li>The sub-path is never implicitly closed.</li>
	 * </ul>
	 * </li>
	 * </ul>
	 * 
	 * @param winding Specifies the winding rule using a value defined in the
	 *                GraphicsPathWinding class.
	 */
	public function drawPath (commands:Vector<Int>, data:Vector<Float>, winding:GraphicsPathWinding = null):Void {
		
		var dataIndex = 0;
		
		for (command in commands) {
			
			switch (command) {
				
				case GraphicsPathCommand.MOVE_TO:
					
					moveTo (data[dataIndex], data[dataIndex + 1]);	
					dataIndex += 2;
					
				case GraphicsPathCommand.LINE_TO:
					
					lineTo (data[dataIndex], data[dataIndex + 1]);
					dataIndex += 2;
					
				case GraphicsPathCommand.CURVE_TO:
					
					curveTo (data[dataIndex], data[dataIndex + 1], data[dataIndex + 2], data[dataIndex + 3]);
					dataIndex += 4;
					
				case GraphicsPathCommand.CUBIC_CURVE_TO:
					
					cubicCurveTo (data[dataIndex], data[dataIndex + 1], data[dataIndex + 2], data[dataIndex + 3], data[dataIndex + 4], data[dataIndex + 5]);
					dataIndex += 6;
				
				default:
				
			}
			
		}
		
	}
	
	
	/**
	 * Draws a rectangle. Set the line style, fill, or both before you call the
	 * <code>drawRect()</code> method, by calling the <code>linestyle()</code>,
	 * <code>lineGradientStyle()</code>, <code>beginFill()</code>,
	 * <code>beginGradientFill()</code>, or <code>beginBitmapFill()</code>
	 * method.
	 * 
	 * @param x      A number indicating the horizontal position relative to the
	 *               registration point of the parent display object(in pixels).
	 * @param y      A number indicating the vertical position relative to the
	 *               registration point of the parent display object(in pixels).
	 * @param width  The width of the rectangle(in pixels).
	 * @param height The height of the rectangle(in pixels).
	 * @throws ArgumentError If the <code>width</code> or <code>height</code>
	 *                       parameters are not a number
	 *                      (<code>Number.NaN</code>).
	 */
	public function drawRect (x:Float, y:Float, width:Float, height:Float):Void {
		
		if (width <= 0 || height <= 0) return;
		
		__inflateBounds (x - __halfStrokeWidth, y - __halfStrokeWidth);
		__inflateBounds (x + width + __halfStrokeWidth, y + height + __halfStrokeWidth);
		
		__commands.push (DrawRect (x, y, width, height));
		
		__dirty = true;
		
	}
	
	
	/**
	 * Draws a rounded rectangle. Set the line style, fill, or both before you
	 * call the <code>drawRoundRect()</code> method, by calling the
	 * <code>linestyle()</code>, <code>lineGradientStyle()</code>,
	 * <code>beginFill()</code>, <code>beginGradientFill()</code>, or
	 * <code>beginBitmapFill()</code> method.
	 * 
	 * @param x             A number indicating the horizontal position relative
	 *                      to the registration point of the parent display
	 *                      object(in pixels).
	 * @param y             A number indicating the vertical position relative to
	 *                      the registration point of the parent display object
	 *                     (in pixels).
	 * @param width         The width of the round rectangle(in pixels).
	 * @param height        The height of the round rectangle(in pixels).
	 * @param ellipseWidth  The width of the ellipse used to draw the rounded
	 *                      corners(in pixels).
	 * @param ellipseHeight The height of the ellipse used to draw the rounded
	 *                      corners(in pixels). Optional; if no value is
	 *                      specified, the default value matches that provided
	 *                      for the <code>ellipseWidth</code> parameter.
	 * @throws ArgumentError If the <code>width</code>, <code>height</code>,
	 *                       <code>ellipseWidth</code> or
	 *                       <code>ellipseHeight</code> parameters are not a
	 *                       number(<code>Number.NaN</code>).
	 */
	public function drawRoundRect (x:Float, y:Float, width:Float, height:Float, rx:Float, ry:Float = -1):Void {
		
		if (width <= 0 || height <= 0) return;
		
		__inflateBounds (x - __halfStrokeWidth, y - __halfStrokeWidth);
		__inflateBounds (x + width + __halfStrokeWidth, y + height + __halfStrokeWidth);
		
		__commands.push (DrawRoundRect (x, y, width, height, rx, ry));
		
		__dirty = true;
		
	}
	
	
	public function drawRoundRectComplex (x:Float, y:Float, width:Float, height:Float, topLeftRadius:Float, topRightRadius:Float, bottomLeftRadius:Float, bottomRightRadius:Float):Void {
		
		openfl.Lib.notImplemented ("Graphics.drawRoundRectComplex");
		
	}
	
	
	public function drawTiles (sheet:Tilesheet, tileData:Array<Float>, smooth:Bool = false, flags:Int = 0, count:Int = -1):Void {
		
		// Checking each tile for extents did not include rotation or scale, and could overflow the maximum canvas
		// size of some mobile browsers. Always use the full stage size for drawTiles instead?
		
		__inflateBounds (0, 0);
		__inflateBounds (Lib.current.stage.stageWidth, Lib.current.stage.stageHeight);
		
		__commands.push (DrawTiles (sheet, tileData, smooth, flags, count));
		
		__dirty = true;
		__visible = true;
		
	}
	
	
	/**
	 * Renders a set of triangles, typically to distort bitmaps and give them a
	 * three-dimensional appearance. The <code>drawTriangles()</code> method maps
	 * either the current fill, or a bitmap fill, to the triangle faces using a
	 * set of(u,v) coordinates.
	 *
	 * <p> Any type of fill can be used, but if the fill has a transform matrix
	 * that transform matrix is ignored. </p>
	 *
	 * <p> A <code>uvtData</code> parameter improves texture mapping when a
	 * bitmap fill is used. </p>
	 * 
	 * @param culling Specifies whether to render triangles that face in a
	 *                specified direction. This parameter prevents the rendering
	 *                of triangles that cannot be seen in the current view. This
	 *                parameter can be set to any value defined by the
	 *                TriangleCulling class.
	 */
	public function drawTriangles (vertices:Vector<Float>, ?indices:Vector<Int> = null, ?uvtData:Vector<Float> = null, ?culling:TriangleCulling = null, ?colors:Vector<Int>, blendMode:Int = 0):Void {
		
		var vlen = Std.int(vertices.length / 2);
		
		if (culling == null) {
			culling = NONE;
		}
		
		if (indices == null) {
			if (vlen % 3 != 0) {
				throw new ArgumentError("Not enough vertices to close a triangle.");
			}
			indices = new Vector<Int>();
			
			for (i in 0...vlen) {
				indices.push(i);
			}
		}
		
		__inflateBounds (0, 0);
		
		var tmpx = Math.NEGATIVE_INFINITY;
		var tmpy = Math.NEGATIVE_INFINITY;
		var maxX = Math.NEGATIVE_INFINITY;
		var maxY = Math.NEGATIVE_INFINITY;		
		
		for (i in 0...vlen) {
			tmpx = vertices[i * 2];
			tmpy = vertices[i * 2 + 1];
			if (maxX < tmpx) maxX = tmpx;
			if (maxY < tmpy) maxY = tmpy;
		}
		
		__inflateBounds (maxX, maxY);
		__commands.push (DrawTriangles(vertices, indices, uvtData, culling, colors, blendMode));
		__dirty = true;
		__visible = true;
		
	}
	
	
	/**
	 * Applies a fill to the lines and curves that were added since the last call
	 * to the <code>beginFill()</code>, <code>beginGradientFill()</code>, or
	 * <code>beginBitmapFill()</code> method. Flash uses the fill that was
	 * specified in the previous call to the <code>beginFill()</code>,
	 * <code>beginGradientFill()</code>, or <code>beginBitmapFill()</code>
	 * method. If the current drawing position does not equal the previous
	 * position specified in a <code>moveTo()</code> method and a fill is
	 * defined, the path is closed with a line and then filled.
	 * 
	 */
	public function endFill ():Void {
		
		__commands.push (EndFill);
		
	}
	
	
	/**
	 * Specifies a bitmap to use for the line stroke when drawing lines.
	 *
	 * <p>The bitmap line style is used for subsequent calls to Graphics methods
	 * such as the <code>lineTo()</code> method or the <code>drawCircle()</code>
	 * method. The line style remains in effect until you call the
	 * <code>lineStyle()</code> or <code>lineGradientStyle()</code> methods, or
	 * the <code>lineBitmapStyle()</code> method again with different parameters.
	 * </p>
	 *
	 * <p>You can call the <code>lineBitmapStyle()</code> method in the middle of
	 * drawing a path to specify different styles for different line segments
	 * within a path. </p>
	 *
	 * <p>Call the <code>lineStyle()</code> method before you call the
	 * <code>lineBitmapStyle()</code> method to enable a stroke, or else the
	 * value of the line style is <code>undefined</code>.</p>
	 *
	 * <p>Calls to the <code>clear()</code> method set the line style back to
	 * <code>undefined</code>. </p>
	 * 
	 * @param bitmap The bitmap to use for the line stroke.
	 * @param matrix An optional transformation matrix as defined by the
	 *               openfl.geom.Matrix class. The matrix can be used to scale or
	 *               otherwise manipulate the bitmap before applying it to the
	 *               line style.
	 * @param repeat Whether to repeat the bitmap in a tiled fashion.
	 * @param smooth Whether smoothing should be applied to the bitmap.
	 */
	public function lineBitmapStyle (bitmap:BitmapData, matrix:Matrix = null, repeat:Bool = true, smooth:Bool = false):Void {
		
		openfl.Lib.notImplemented ("Graphics.lineBitmapStyle");
		
	}
	
	
	/**
	 * Specifies a gradient to use for the stroke when drawing lines.
	 *
	 * <p>The gradient line style is used for subsequent calls to Graphics
	 * methods such as the <code>lineTo()</code> methods or the
	 * <code>drawCircle()</code> method. The line style remains in effect until
	 * you call the <code>lineStyle()</code> or <code>lineBitmapStyle()</code>
	 * methods, or the <code>lineGradientStyle()</code> method again with
	 * different parameters. </p>
	 *
	 * <p>You can call the <code>lineGradientStyle()</code> method in the middle
	 * of drawing a path to specify different styles for different line segments
	 * within a path. </p>
	 *
	 * <p>Call the <code>lineStyle()</code> method before you call the
	 * <code>lineGradientStyle()</code> method to enable a stroke, or else the
	 * value of the line style is <code>undefined</code>.</p>
	 *
	 * <p>Calls to the <code>clear()</code> method set the line style back to
	 * <code>undefined</code>. </p>
	 * 
	 * @param type                A value from the GradientType class that
	 *                            specifies which gradient type to use, either
	 *                            GradientType.LINEAR or GradientType.RADIAL.
	 * @param matrix              A transformation matrix as defined by the
	 *                            openfl.geom.Matrix class. The openfl.geom.Matrix
	 *                            class includes a
	 *                            <code>createGradientBox()</code> method, which
	 *                            lets you conveniently set up the matrix for use
	 *                            with the <code>lineGradientStyle()</code>
	 *                            method.
	 * @param spreadMethod        A value from the SpreadMethod class that
	 *                            specifies which spread method to use:
	 * @param interpolationMethod A value from the InterpolationMethod class that
	 *                            specifies which value to use. For example,
	 *                            consider a simple linear gradient between two
	 *                            colors(with the <code>spreadMethod</code>
	 *                            parameter set to
	 *                            <code>SpreadMethod.REFLECT</code>). The
	 *                            different interpolation methods affect the
	 *                            appearance as follows:
	 * @param focalPointRatio     A number that controls the location of the
	 *                            focal point of the gradient. The value 0 means
	 *                            the focal point is in the center. The value 1
	 *                            means the focal point is at one border of the
	 *                            gradient circle. The value -1 means that the
	 *                            focal point is at the other border of the
	 *                            gradient circle. Values less than -1 or greater
	 *                            than 1 are rounded to -1 or 1. The following
	 *                            image shows a gradient with a
	 *                            <code>focalPointRatio</code> of -0.75:
	 */
	public function lineGradientStyle (type:GradientType, colors:Array<Dynamic>, alphas:Array<Dynamic>, ratios:Array<Dynamic>, matrix:Matrix = null, spreadMethod:SpreadMethod = null, interpolationMethod:InterpolationMethod = null, focalPointRatio:Null<Float> = null):Void {
		
		openfl.Lib.notImplemented ("Graphics.lineGradientStyle");
		
	}
	
	
	/**
	 * Specifies a line style used for subsequent calls to Graphics methods such
	 * as the <code>lineTo()</code> method or the <code>drawCircle()</code>
	 * method. The line style remains in effect until you call the
	 * <code>lineGradientStyle()</code> method, the
	 * <code>lineBitmapStyle()</code> method, or the <code>lineStyle()</code>
	 * method with different parameters.
	 *
	 * <p>You can call the <code>lineStyle()</code> method in the middle of
	 * drawing a path to specify different styles for different line segments
	 * within the path.</p>
	 *
	 * <p><b>Note: </b>Calls to the <code>clear()</code> method set the line
	 * style back to <code>undefined</code>.</p>
	 *
	 * <p><b>Note: </b>Flash Lite 4 supports only the first three parameters
	 * (<code>thickness</code>, <code>color</code>, and <code>alpha</code>).</p>
	 * 
	 * @param thickness    An integer that indicates the thickness of the line in
	 *                     points; valid values are 0-255. If a number is not
	 *                     specified, or if the parameter is undefined, a line is
	 *                     not drawn. If a value of less than 0 is passed, the
	 *                     default is 0. The value 0 indicates hairline
	 *                     thickness; the maximum thickness is 255. If a value
	 *                     greater than 255 is passed, the default is 255.
	 * @param color        A hexadecimal color value of the line; for example,
	 *                     red is 0xFF0000, blue is 0x0000FF, and so on. If a
	 *                     value is not indicated, the default is 0x000000
	 *                    (black). Optional.
	 * @param alpha        A number that indicates the alpha value of the color
	 *                     of the line; valid values are 0 to 1. If a value is
	 *                     not indicated, the default is 1(solid). If the value
	 *                     is less than 0, the default is 0. If the value is
	 *                     greater than 1, the default is 1.
	 * @param pixelHinting(Not supported in Flash Lite 4) A Boolean value that
	 *                     specifies whether to hint strokes to full pixels. This
	 *                     affects both the position of anchors of a curve and
	 *                     the line stroke size itself. With
	 *                     <code>pixelHinting</code> set to <code>true</code>,
	 *                     line widths are adjusted to full pixel widths. With
	 *                     <code>pixelHinting</code> set to <code>false</code>,
	 *                     disjoints can appear for curves and straight lines.
	 *                     For example, the following illustrations show how
	 *                     Flash Player or Adobe AIR renders two rounded
	 *                     rectangles that are identical, except that the
	 *                     <code>pixelHinting</code> parameter used in the
	 *                     <code>lineStyle()</code> method is set differently
	 *                    (the images are scaled by 200%, to emphasize the
	 *                     difference):
	 *
	 *                     <p>If a value is not supplied, the line does not use
	 *                     pixel hinting.</p>
	 * @param scaleMode   (Not supported in Flash Lite 4) A value from the
	 *                     LineScaleMode class that specifies which scale mode to
	 *                     use:
	 *                     <ul>
	 *                       <li> <code>LineScaleMode.NORMAL</code> - Always
	 *                     scale the line thickness when the object is scaled
	 *                    (the default). </li>
	 *                       <li> <code>LineScaleMode.NONE</code> - Never scale
	 *                     the line thickness. </li>
	 *                       <li> <code>LineScaleMode.VERTICAL</code> - Do not
	 *                     scale the line thickness if the object is scaled
	 *                     vertically <i>only</i>. For example, consider the
	 *                     following circles, drawn with a one-pixel line, and
	 *                     each with the <code>scaleMode</code> parameter set to
	 *                     <code>LineScaleMode.VERTICAL</code>. The circle on the
	 *                     left is scaled vertically only, and the circle on the
	 *                     right is scaled both vertically and horizontally:
	 *                     </li>
	 *                       <li> <code>LineScaleMode.HORIZONTAL</code> - Do not
	 *                     scale the line thickness if the object is scaled
	 *                     horizontally <i>only</i>. For example, consider the
	 *                     following circles, drawn with a one-pixel line, and
	 *                     each with the <code>scaleMode</code> parameter set to
	 *                     <code>LineScaleMode.HORIZONTAL</code>. The circle on
	 *                     the left is scaled horizontally only, and the circle
	 *                     on the right is scaled both vertically and
	 *                     horizontally:   </li>
	 *                     </ul>
	 * @param caps        (Not supported in Flash Lite 4) A value from the
	 *                     CapsStyle class that specifies the type of caps at the
	 *                     end of lines. Valid values are:
	 *                     <code>CapsStyle.NONE</code>,
	 *                     <code>CapsStyle.ROUND</code>, and
	 *                     <code>CapsStyle.SQUARE</code>. If a value is not
	 *                     indicated, Flash uses round caps.
	 *
	 *                     <p>For example, the following illustrations show the
	 *                     different <code>capsStyle</code> settings. For each
	 *                     setting, the illustration shows a blue line with a
	 *                     thickness of 30(for which the <code>capsStyle</code>
	 *                     applies), and a superimposed black line with a
	 *                     thickness of 1(for which no <code>capsStyle</code>
	 *                     applies): </p>
	 * @param joints      (Not supported in Flash Lite 4) A value from the
	 *                     JointStyle class that specifies the type of joint
	 *                     appearance used at angles. Valid values are:
	 *                     <code>JointStyle.BEVEL</code>,
	 *                     <code>JointStyle.MITER</code>, and
	 *                     <code>JointStyle.ROUND</code>. If a value is not
	 *                     indicated, Flash uses round joints.
	 *
	 *                     <p>For example, the following illustrations show the
	 *                     different <code>joints</code> settings. For each
	 *                     setting, the illustration shows an angled blue line
	 *                     with a thickness of 30(for which the
	 *                     <code>jointStyle</code> applies), and a superimposed
	 *                     angled black line with a thickness of 1(for which no
	 *                     <code>jointStyle</code> applies): </p>
	 *
	 *                     <p><b>Note:</b> For <code>joints</code> set to
	 *                     <code>JointStyle.MITER</code>, you can use the
	 *                     <code>miterLimit</code> parameter to limit the length
	 *                     of the miter.</p>
	 * @param miterLimit  (Not supported in Flash Lite 4) A number that
	 *                     indicates the limit at which a miter is cut off. Valid
	 *                     values range from 1 to 255(and values outside that
	 *                     range are rounded to 1 or 255). This value is only
	 *                     used if the <code>jointStyle</code> is set to
	 *                     <code>"miter"</code>. The <code>miterLimit</code>
	 *                     value represents the length that a miter can extend
	 *                     beyond the point at which the lines meet to form a
	 *                     joint. The value expresses a factor of the line
	 *                     <code>thickness</code>. For example, with a
	 *                     <code>miterLimit</code> factor of 2.5 and a
	 *                     <code>thickness</code> of 10 pixels, the miter is cut
	 *                     off at 25 pixels.
	 *
	 *                     <p>For example, consider the following angled lines,
	 *                     each drawn with a <code>thickness</code> of 20, but
	 *                     with <code>miterLimit</code> set to 1, 2, and 4.
	 *                     Superimposed are black reference lines showing the
	 *                     meeting points of the joints:</p>
	 *
	 *                     <p>Notice that a given <code>miterLimit</code> value
	 *                     has a specific maximum angle for which the miter is
	 *                     cut off. The following table lists some examples:</p>
	 */
	public function lineStyle (thickness:Null<Float> = null, color:Null<Int> = null, alpha:Null<Float> = null, pixelHinting:Null<Bool> = null, scaleMode:LineScaleMode = null, caps:CapsStyle = null, joints:JointStyle = null, miterLimit:Null<Float> = null):Void {
		
		__halfStrokeWidth = (thickness != null) ? thickness / 2 : 0;
		__commands.push (LineStyle (thickness, color, alpha, pixelHinting, scaleMode, caps, joints, miterLimit));
		
		if (thickness != null) __visible = true;
		
	}
	
	
	/**
	 * Draws a line using the current line style from the current drawing
	 * position to(<code>x</code>, <code>y</code>); the current drawing position
	 * is then set to(<code>x</code>, <code>y</code>). If the display object in
	 * which you are drawing contains content that was created with the Flash
	 * drawing tools, calls to the <code>lineTo()</code> method are drawn
	 * underneath the content. If you call <code>lineTo()</code> before any calls
	 * to the <code>moveTo()</code> method, the default position for the current
	 * drawing is(<i>0, 0</i>). If any of the parameters are missing, this
	 * method fails and the current drawing position is not changed.
	 * 
	 * @param x A number that indicates the horizontal position relative to the
	 *          registration point of the parent display object(in pixels).
	 * @param y A number that indicates the vertical position relative to the
	 *          registration point of the parent display object(in pixels).
	 */
	public function lineTo (x:Float, y:Float):Void {
		
		// TODO: Should we consider the origin instead, instead of inflating in all directions?
		
		__inflateBounds (__positionX - __halfStrokeWidth, __positionY - __halfStrokeWidth);
		__inflateBounds (__positionX + __halfStrokeWidth, __positionY + __halfStrokeWidth);
		
		__positionX = x;
		__positionY = y;
		
		__inflateBounds (__positionX - __halfStrokeWidth, __positionY - __halfStrokeWidth);
		__inflateBounds (__positionX + __halfStrokeWidth, __positionY + __halfStrokeWidth);
		
		__commands.push (LineTo (x, y));
		
		__dirty = true;
		
	}
	
	
	/**
	 * Moves the current drawing position to(<code>x</code>, <code>y</code>). If
	 * any of the parameters are missing, this method fails and the current
	 * drawing position is not changed.
	 * 
	 * @param x A number that indicates the horizontal position relative to the
	 *          registration point of the parent display object(in pixels).
	 * @param y A number that indicates the vertical position relative to the
	 *          registration point of the parent display object(in pixels).
	 */
	public function moveTo (x:Float, y:Float):Void {
		
		__positionX = x;
		__positionY = y;
		
		__commands.push (MoveTo (x, y));
		
	}
	
	
	@:noCompletion private function __getBounds (rect:Rectangle, matrix:Matrix):Void {
		
		if (__bounds == null) return;
		
		var bounds = __bounds.clone ().transform (matrix);
		rect.__expand (bounds.x, bounds.y, bounds.width, bounds.height);
		
	}
	
	
	@:noCompletion private function __hitTest (x:Float, y:Float, shapeFlag:Bool, matrix:Matrix):Bool {
		
		//TODO: Shape flag
		
		if (__bounds == null) return false;
		
		var bounds = __bounds.clone ().transform (matrix);
		return (x > bounds.x && y > bounds.y && x <= bounds.right && y <= bounds.bottom);
		
	}
	
	
	@:noCompletion private function __inflateBounds (x:Float, y:Float):Void {
		
		if (__bounds == null) {
			
			__bounds = new Rectangle (x, y, 0, 0);
			__transformDirty = true;
			return;
			
		}
		
		if (x < __bounds.x) {
			
			__bounds.width += __bounds.x - x;
			__bounds.x = x;
			__transformDirty = true;
			
		}
		
		if (y < __bounds.y) {
			
			__bounds.height += __bounds.y - y;
			__bounds.y = y;
			__transformDirty = true;
			
		}
		
		if (x > __bounds.x + __bounds.width) {
			
			__bounds.width = x - __bounds.x;
			
		}
		
		if (y > __bounds.y + __bounds.height) {
			
			__bounds.height = y - __bounds.y;
			
		}
		
	}
	
	
}


@:noCompletion @:dox(hide) enum DrawCommand {
	
	BeginBitmapFill (bitmap:BitmapData, matrix:Matrix, repeat:Bool, smooth:Bool);
	BeginFill (color:Int, alpha:Float);
	CubicCurveTo (controlX1:Float, controlY1:Float, controlX2:Float, controlY2:Float, anchorX:Float, anchorY:Float);
	CurveTo (controlX:Float, controlY:Float, anchorX:Float, anchorY:Float);
	DrawCircle (x:Float, y:Float, radius:Float);
	DrawEllipse (x:Float, y:Float, width:Float, height:Float);
	DrawRect (x:Float, y:Float, width:Float, height:Float);
	DrawRoundRect (x:Float, y:Float, width:Float, height:Float, rx:Float, ry:Float);
	DrawTiles (sheet:Tilesheet, tileData:Array<Float>, smooth:Bool, flags:Int, count:Int);
	DrawTriangles (vertices:Vector<Float>, indices:Vector<Int>, uvtData:Vector<Float>, culling:TriangleCulling, colors:Vector<Int>, blendMode:Int);
	EndFill;
	LineStyle (thickness:Null<Float>, color:Null<Int>, alpha:Null<Float>, pixelHinting:Null<Bool>, scaleMode:LineScaleMode, caps:CapsStyle, joints:JointStyle, miterLimit:Null<Float>);
	LineTo (x:Float, y:Float);
	MoveTo (x:Float, y:Float);
	
}


#else
typedef Graphics = openfl._v2.display.Graphics;
#end
#else


import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;

@:access(openfl.display.Tilesheet)

@:forward(beginBitmapFill, beginFill, beginGradientFill, beginShaderFill, clear, copyFrom, cubicCurveTo, curveTo, drawCircle, drawEllipse, drawGraphicsData, drawPath, drawRect, drawRoundRect, drawRoundRectComplex, drawTriangles, endFill, lineBitmapStyle, lineGradientStyle, lineShaderStyle, lineStyle, lineTo, moveTo, recurse)


abstract Graphics(flash.display.Graphics) from flash.display.Graphics to flash.display.Graphics {
	
	
	public function drawTiles (sheet:Tilesheet, tileData:Array<Float>, smooth:Bool = false, flags:Int = 0, count:Int = -1):Void {
		
		var useScale = (flags & Tilesheet.TILE_SCALE) > 0;
		var useRotation = (flags & Tilesheet.TILE_ROTATION) > 0;
		var useRGB = (flags & Tilesheet.TILE_RGB) > 0;
		var useAlpha = (flags & Tilesheet.TILE_ALPHA) > 0;
		var useTransform = (flags & Tilesheet.TILE_TRANS_2x2) > 0;
		var useRect = (flags & Tilesheet.TILE_RECT) > 0;
		var useOrigin = (flags & Tilesheet.TILE_ORIGIN) > 0;
		
		var tile:Rectangle = null;
		var tileUV:Rectangle = null;
		var tilePoint:Point = null;
		
		var numValues = 3;
		var totalCount = count;
		var itemCount;
		if (count < 0) {
			
			totalCount = tileData.length;
			
		}
		
		if (useTransform || useScale || useRotation || useRGB || useAlpha) {
			
			var scaleIndex = 0;
			var rotationIndex = 0;
			var rgbIndex = 0;
			var alphaIndex = 0;
			var transformIndex = 0;
			
			if (useRect) { numValues = useOrigin ? 8 : 6; }
			if (useScale) { scaleIndex = numValues; numValues ++; }
			if (useRotation) { rotationIndex = numValues; numValues ++; }
			if (useTransform) { transformIndex = numValues; numValues += 4; }
			if (useRGB) { rgbIndex = numValues; numValues += 3; }
			if (useAlpha) { alphaIndex = numValues; numValues ++; }
			
			itemCount = Std.int (totalCount / numValues);
			var ids = sheet.adjustIDs (sheet.__ids, itemCount);
			var vertices = sheet.adjustLen (sheet.__vertices, itemCount * 8); 
			var indices = sheet.adjustIndices (sheet.__indices, itemCount * 6); 
			var uvtData = sheet.adjustLen (sheet.__uvs, itemCount * 8); 
			
			var index = 0;
			var offset8 = 0;
			var tileIndex:Int = 0;
			var tileID:Int = 0;
			var cacheID:Int = -1;
			
			while (index < totalCount) {
				
				var x = tileData[index];
				var y = tileData[index + 1];
				var tileID = (!useRect) ? Std.int(tileData[index + 2]) : -1;
				var scale = 1.0;
				var rotation = 0.0;
				var alpha = 1.0;
				
				if (useScale) {
					
					scale = tileData[index + scaleIndex];
					
				}
				
				if (useRotation) {
					
					rotation = tileData[index + rotationIndex];
					
				}
				
				if (useRGB) {
					
					//ignore for now
					
				}
				
				if (useAlpha) {
					
					alpha = tileData[index + alphaIndex];
					
				}
				
				if (!useRect && cacheID != tileID) {
					
					cacheID = tileID;
					tile = sheet.__tileRects[tileID];
					tileUV = sheet.__tileUVs[tileID];
					tilePoint = sheet.__centerPoints[tileID];
					
				} else if (useRect) {
					
					tile = sheet.__rectTile;
					tile.setTo (tileData[index + 2], tileData[index + 3], tileData[index + 4], tileData[index + 5]);
					tileUV = sheet.__rectUV;
					tileUV.setTo (tile.x / sheet.__bitmap.width, tile.y / sheet.__bitmap.height, tile.right / sheet.__bitmap.width, tile.bottom / sheet.__bitmap.height);
					tilePoint = sheet.__point;
					
					if (useOrigin) {
						
						tilePoint.setTo (tileData[index + 6] / tile.width, tileData[index + 7] / tile.height);
						
					} else {
						
						tilePoint.setTo (0, 0);
						
					}
					
				}
				
				if (useTransform) {
					
					var tw = tile.width;
					var th = tile.height;
					var t0 = tileData[index + transformIndex];
					var t1 = tileData[index + transformIndex + 1];
					var t2 = tileData[index + transformIndex + 2];
					var t3 = tileData[index + transformIndex + 3];
					var ox = tilePoint.x * tw;
					var oy = tilePoint.y * th;
					var ox_ = ox * t0 + oy * t2;
					oy = ox * t1 + oy * t3;
					x -= ox_;
					y -= oy;
					vertices[offset8] = x;
					vertices[offset8 + 1] = y;
					vertices[offset8 + 2] = x + tw * t0;
					vertices[offset8 + 3] = y + tw * t1;
					vertices[offset8 + 4] = x + th * t2;
					vertices[offset8 + 5] = y + th * t3;
					vertices[offset8 + 6] = x + tw * t0 + th * t2;
					vertices[offset8 + 7] = y + tw * t1 + th * t3;
					
				} else {
					
					var tileWidth = tile.width * scale;
					var tileHeight = tile.height * scale;
					
					if (rotation != 0) {
						
						var ca = Math.cos (rotation);
						var sa = Math.sin (rotation);
						var tw = tile.width;
						var th = tile.height;
						var t0 = ca;
						var t1 = sa;
						var t2 = -sa;
						var t3 = ca;
						var ox = tilePoint.x * tw;
						var oy = tilePoint.y * th;
						var ox_ = ox * t0 + oy * t2;
						oy = ox * t1 + oy * t3;
						x -= ox_;
						y -= oy;
						vertices[offset8] = x;
						vertices[offset8 + 1] = y;
						vertices[offset8 + 2] = x + tw * t0;
						vertices[offset8 + 3] = y + tw * t1;
						vertices[offset8 + 4] = x + th * t2;
						vertices[offset8 + 5] = y + th * t3;
						vertices[offset8 + 6] = x + tw * t0 + th * t2;
						vertices[offset8 + 7] = y + tw * t1 + th * t3;
						
					} else {
						
						x -= tilePoint.x * tileWidth;
						y -= tilePoint.y * tileHeight;
						vertices[offset8] = vertices[offset8 + 4] = x;
						vertices[offset8 + 1] = vertices[offset8 + 3] = y;
						vertices[offset8 + 2] = vertices[offset8 + 6] = x + tileWidth;
						vertices[offset8 + 5] = vertices[offset8 + 7] = y + tileHeight;
						
					}
					
				}
				
				if (ids[tileIndex] != tileID || useRect) {
					
					ids[tileIndex] = tileID;
					uvtData[offset8] = uvtData[offset8 + 4] = tileUV.left;
					uvtData[offset8 + 1] = uvtData[offset8 + 3] = tileUV.top;
					uvtData[offset8 + 2] = uvtData[offset8 + 6] = tileUV.width;
					uvtData[offset8 + 5] = uvtData[offset8 + 7] = tileUV.height;
					
				}
				
				offset8 += 8;
				index += numValues;
				tileIndex++;
				
			}
			
			this.beginBitmapFill (sheet.__bitmap, null, false, smooth);
			this.drawTriangles (vertices, indices, uvtData);
			
		} else {
			
			var index = 0;
			var matrix = new Matrix ();
			while (index < totalCount) {
				
				var x = tileData[index++];
				var y = tileData[index++];
				var tileID = (!useRect) ? Std.int (tileData[index++]) : -1;
				var ox:Float = 0; 
				var oy:Float = 0;
				
				if (!useRect) {
					
					tile = sheet.__tileRects[tileID];
					tilePoint = sheet.__centerPoints[tileID];
					ox = tilePoint.x * tile.width;
					oy = tilePoint.y * tile.height;
				}
				else {
					tile = sheet.__rectTile;
					tile.setTo(tileData[index++], tileData[index++], tileData[index++], tileData[index++]);
					if (useOrigin)
					{
						ox = tileData[index++];
						oy = tileData[index++];
					}
				}
				
				matrix.tx = x - tile.x - ox;
				matrix.ty = y - tile.y - oy;
				
				this.beginBitmapFill (sheet.__bitmap, matrix, false, smooth);
				this.drawRect (x - ox, y - oy, tile.width, tile.height);
				
			}
			
		}
		
		this.endFill ();
		
	}
	
	
}


#end
