package flash.display {


	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	// import flash.Vector;


	/**
	 * @externs
	 * The Graphics class contains a set of methods that you can use to create a
	 * vector shape. Display objects that support drawing include Sprite and Shape
	 * objects. Each of these classes includes a `graphics` property
	 * that is a Graphics object. The following are among those helper functions
	 * provided for ease of use: `drawRect()`,
	 * `drawRoundRect()`, `drawCircle()`, and
	 * `drawEllipse()`.
	 *
	 * You cannot create a Graphics object directly from ActionScript code. If
	 * you call `new Graphics()`, an exception is thrown.
	 *
	 * The Graphics class is final; it cannot be subclassed.
	 */
	final public class Graphics {
		
		
		/**
		 * Fills a drawing area with a bitmap image. The bitmap can be repeated or
		 * tiled to fill the area. The fill remains in effect until you call the
		 * `beginFill()`, `beginBitmapFill()`,
		 * `beginGradientFill()`, or `beginShaderFill()`
		 * method. Calling the `clear()` method clears the fill.
		 *
		 * The application renders the fill whenever three or more points are
		 * drawn, or when the `endFill()` method is called. 
		 * 
		 * @param bitmap A transparent or opaque bitmap image that contains the bits
		 *               to be displayed.
		 * @param matrix A matrix object(of the flash.geom.Matrix class), which you
		 *               can use to define transformations on the bitmap. For
		 *               example, you can use the following matrix to rotate a bitmap
		 *               by 45 degrees(pi/4 radians):
		 * @param repeat If `true`, the bitmap image repeats in a tiled
		 *               pattern. If `false`, the bitmap image does not
		 *               repeat, and the edges of the bitmap are used for any fill
		 *               area that extends beyond the bitmap.
		 *
		 *               For example, consider the following bitmap(a 20 x
		 *               20-pixel checkerboard pattern):
		 *
		 *               When `repeat` is set to `true`(as
		 *               in the following example), the bitmap fill repeats the
		 *               bitmap:
		 *
		 *               When `repeat` is set to `false`,
		 *               the bitmap fill uses the edge pixels for the fill area
		 *               outside the bitmap:
		 * @param smooth If `false`, upscaled bitmap images are rendered
		 *               by using a nearest-neighbor algorithm and look pixelated. If
		 *               `true`, upscaled bitmap images are rendered by
		 *               using a bilinear algorithm. Rendering by using the nearest
		 *               neighbor algorithm is faster.
		 */
		public function beginBitmapFill (bitmap:BitmapData, matrix:Matrix = null, repeat:Boolean = true, smooth:Boolean = false):void {}
		
		
		/**
		 * Specifies a simple one-color fill that subsequent calls to other Graphics
		 * methods(such as `lineTo()` or `drawCircle()`) use
		 * when drawing. The fill remains in effect until you call the
		 * `beginFill()`, `beginBitmapFill()`,
		 * `beginGradientFill()`, or `beginShaderFill()`
		 * method. Calling the `clear()` method clears the fill.
		 *
		 * The application renders the fill whenever three or more points are
		 * drawn, or when the `endFill()` method is called.
		 * 
		 * @param color The color of the fill(0xRRGGBB).
		 * @param alpha The alpha value of the fill(0.0 to 1.0).
		 */
		public function beginFill (color:uint = 0, alpha:Number = 1):void {}
		
		
		/**
		 * Specifies a gradient fill used by subsequent calls to other Graphics
		 * methods(such as `lineTo()` or `drawCircle()`) for
		 * the object. The fill remains in effect until you call the
		 * `beginFill()`, `beginBitmapFill()`,
		 * `beginGradientFill()`, or `beginShaderFill()`
		 * method. Calling the `clear()` method clears the fill.
		 *
		 * The application renders the fill whenever three or more points are
		 * drawn, or when the `endFill()` method is called. 
		 * 
		 * @param type                A value from the GradientType class that
		 *                            specifies which gradient type to use:
		 *                            `GradientType.LINEAR` or
		 *                            `GradientType.RADIAL`.
		 * @param matrix              A transformation matrix as defined by the
		 *                            flash.geom.Matrix class. The flash.geom.Matrix
		 *                            class includes a
		 *                            `createGradientBox()` method, which
		 *                            lets you conveniently set up the matrix for use
		 *                            with the `beginGradientFill()`
		 *                            method.
		 * @param spreadMethod        A value from the SpreadMethod class that
		 *                            specifies which spread method to use, either:
		 *                            `SpreadMethod.PAD`,
		 *                            `SpreadMethod.REFLECT`, or
		 *                            `SpreadMethod.REPEAT`.
		 *
		 *                            For example, consider a simple linear
		 *                            gradient between two colors:
		 *
		 *                            This example uses
		 *                            `SpreadMethod.PAD` for the spread
		 *                            method, and the gradient fill looks like the
		 *                            following:
		 *
		 *                            If you use `SpreadMethod.REFLECT`
		 *                            for the spread method, the gradient fill looks
		 *                            like the following:
		 *
		 *                            If you use `SpreadMethod.REPEAT`
		 *                            for the spread method, the gradient fill looks
		 *                            like the following:
		 * @param interpolationMethod A value from the InterpolationMethod class that
		 *                            specifies which value to use:
		 *                            `InterpolationMethod.LINEAR_RGB` or
		 *                            `InterpolationMethod.RGB`
		 *
		 *                            For example, consider a simple linear
		 *                            gradient between two colors(with the
		 *                            `spreadMethod` parameter set to
		 *                            `SpreadMethod.REFLECT`). The
		 *                            different interpolation methods affect the
		 *                            appearance as follows: 
		 * @param focalPointRatio     A number that controls the location of the
		 *                            focal point of the gradient. 0 means that the
		 *                            focal point is in the center. 1 means that the
		 *                            focal point is at one border of the gradient
		 *                            circle. -1 means that the focal point is at the
		 *                            other border of the gradient circle. A value
		 *                            less than -1 or greater than 1 is rounded to -1
		 *                            or 1. For example, the following example shows
		 *                            a `focalPointRatio` set to 0.75:
		 * @throws ArgumentError If the `type` parameter is not valid.
		 */
		public function beginGradientFill (type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix = null, spreadMethod:String = null, interpolationMethod:String = null, focalPointRatio:Number = 0):void {}
		
		
		public function beginShaderFill (shader:Shader, matrix:Matrix = null):void {}
		
		
		/**
		 * Clears the graphics that were drawn to this Graphics object, and resets
		 * fill and line style settings.
		 * 
		 */
		public function clear ():void {}
		
		
		public function copyFrom (sourceGraphics:Graphics):void {}
		
		
		public function cubicCurveTo (controlX1:Number, controlY1:Number, controlX2:Number, controlY2:Number, anchorX:Number, anchorY:Number):void {}
		
		
		/**
		 * Draws a curve using the current line style from the current drawing
		 * position to(anchorX, anchorY) and using the control point that
		 * (`controlX`, `controlY`) specifies. The current
		 * drawing position is then set to(`anchorX`,
		 * `anchorY`). If the movie clip in which you are drawing contains
		 * content created with the Flash drawing tools, calls to the
		 * `curveTo()` method are drawn underneath this content. If you
		 * call the `curveTo()` method before any calls to the
		 * `moveTo()` method, the default of the current drawing position
		 * is(0, 0). If any of the parameters are missing, this method fails and the
		 * current drawing position is not changed.
		 *
		 * The curve drawn is a quadratic Bezier curve. Quadratic Bezier curves
		 * consist of two anchor points and one control point. The curve interpolates
		 * the two anchor points and curves toward the control point. 
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
		public function curveTo (controlX:Number, controlY:Number, anchorX:Number, anchorY:Number):void {}
		
		
		/**
		 * Draws a circle. Set the line style, fill, or both before you call the
		 * `drawCircle()` method, by calling the `linestyle()`,
		 * `lineGradientStyle()`, `beginFill()`,
		 * `beginGradientFill()`, or `beginBitmapFill()`
		 * method.
		 * 
		 * @param x      The _x_ location of the center of the circle relative
		 *               to the registration point of the parent display object(in
		 *               pixels).
		 * @param y      The _y_ location of the center of the circle relative
		 *               to the registration point of the parent display object(in
		 *               pixels).
		 * @param radius The radius of the circle(in pixels).
		 */
		public function drawCircle (x:Number, y:Number, radius:Number):void {}
		
		
		/**
		 * Draws an ellipse. Set the line style, fill, or both before you call the
		 * `drawEllipse()` method, by calling the
		 * `linestyle()`, `lineGradientStyle()`,
		 * `beginFill()`, `beginGradientFill()`, or
		 * `beginBitmapFill()` method.
		 * 
		 * @param x      The _x_ location of the top-left of the bounding-box of
		 *               the ellipse relative to the registration point of the parent
		 *               display object(in pixels).
		 * @param y      The _y_ location of the top left of the bounding-box of
		 *               the ellipse relative to the registration point of the parent
		 *               display object(in pixels).
		 * @param width  The width of the ellipse(in pixels).
		 * @param height The height of the ellipse(in pixels).
		 */
		public function drawEllipse (x:Number, y:Number, width:Number, height:Number):void {}
		
		
		/**
		 * Submits a series of IGraphicsData instances for drawing. This method
		 * accepts a Vector containing objects including paths, fills, and strokes
		 * that implement the IGraphicsData interface. A Vector of IGraphicsData
		 * instances can refer to a part of a shape, or a complex fully defined set
		 * of data for rendering a complete shape.
		 *
		 *  Graphics paths can contain other graphics paths. If the
		 * `graphicsData` Vector includes a path, that path and all its
		 * sub-paths are rendered during this operation. 
		 * 
		 */
		public function drawGraphicsData (graphicsData:Vector.<IGraphicsData>):void {}
		
		
		/**
		 * Submits a series of commands for drawing. The `drawPath()`
		 * method uses vector arrays to consolidate individual `moveTo()`,
		 * `lineTo()`, and `curveTo()` drawing commands into a
		 * single call. The `drawPath()` method parameters combine drawing
		 * commands with x- and y-coordinate value pairs and a drawing direction. The
		 * drawing commands are values from the GraphicsPathCommand class. The x- and
		 * y-coordinate value pairs are Numbers in an array where each pair defines a
		 * coordinate location. The drawing direction is a value from the
		 * GraphicsPathWinding class.
		 *
		 *  Generally, drawings render faster with `drawPath()` than
		 * with a series of individual `lineTo()` and
		 * `curveTo()` methods. 
		 *
		 *  The `drawPath()` method uses a uses a floating computation
		 * so rotation and scaling of shapes is more accurate and gives better
		 * results. However, curves submitted using the `drawPath()`
		 * method can have small sub-pixel alignment errors when used in conjunction
		 * with the `lineTo()` and `curveTo()` methods. 
		 *
		 *  The `drawPath()` method also uses slightly different rules
		 * for filling and drawing lines. They are: 
		 *
		 * 
		 *  * When a fill is applied to rendering a path:
		 * 
		 *  * A sub-path of less than 3 points is not rendered.(But note that the
		 * stroke rendering will still occur, consistent with the rules for strokes
		 * below.)
		 *  * A sub-path that isn't closed(the end point is not equal to the
		 * begin point) is implicitly closed.
		 * 
		 * 
		 *  * When a stroke is applied to rendering a path:
		 * 
		 *  * The sub-paths can be composed of any number of points.
		 *  * The sub-path is never implicitly closed.
		 * 
		 * 
		 * 
		 * 
		 * @param winding Specifies the winding rule using a value defined in the
		 *                GraphicsPathWinding class.
		 */
		public function drawPath (commands:Vector.<int>, data:Vector.<Number>, winding:String = null):void {}
		
		
		/**
		 * Renders a set of quadrilaterals. This is similar to calling `drawRect`
		 * repeatedly, but each rectangle can use a transform value to rotate, scale
		 * or skew the result.
		 *
		 * Any type of fill can be used, but if the fill has a transform matrix
		 * that transform matrix is ignored.
		 *
		 * The optional `indices` parameter allows the use of either repeated 
		 * rectangle geometry, or allows the use of a subset of a broader rectangle
		 * data `Vector`, such as `tileset.rectData`.
		 *
		 * @param rects A `Vector` containing rectangle coordinates in 
		 *              [ x0, y0, width0, height0, x1, y1 ... ] format.
		 * @param indices A `Vector` containing optional index values to reference
		 *                the data contained in `rects`. Each index is a rectangle
		 *                index in the `Vector`, not an array index. If this parameter
		 *                is ommitted, each index from `rects` will be used in order.
		 * @param transforms A `Vector` containing optional transform data to adjust
		 *                   _x_, _y_, _a_, _b_, _c_ or _d_ value for the resulting
		 *                   quadrilateral. A `transforms` `Vector` that is double
		 *                   size of the draw count (the length of `indices`, or if
		 *                   omitted, the rectangle count in `rects`) will be treated
		 *                   as [ x, y, ... ] pairs. A `transforms` `Vector` that is
		 *                   four times the size of the draw count will be used as 
		 *                   matrix [ a, b, c, d, ... ] values. A `transforms` object
		 *                   which is six times the draw count in size will use full
		 *                   matrix [ a, b, c, d, tx, ty, ... ] values per draw.
		 */
		public function drawQuads (rects:Vector.<Number>, indices:Vector.<int> = null, transforms:Vector.<Number> = null):void {}
		
		
		/**
		 * Draws a rectangle. Set the line style, fill, or both before you call the
		 * `drawRect()` method, by calling the `linestyle()`,
		 * `lineGradientStyle()`, `beginFill()`,
		 * `beginGradientFill()`, or `beginBitmapFill()`
		 * method.
		 * 
		 * @param x      A number indicating the horizontal position relative to the
		 *               registration point of the parent display object(in pixels).
		 * @param y      A number indicating the vertical position relative to the
		 *               registration point of the parent display object(in pixels).
		 * @param width  The width of the rectangle(in pixels).
		 * @param height The height of the rectangle(in pixels).
		 * @throws ArgumentError If the `width` or `height`
		 *                       parameters are not a number
		 *                      (`Number.NaN`).
		 */
		public function drawRect (x:Number, y:Number, width:Number, height:Number):void {}
		
		
		/**
		 * Draws a rounded rectangle. Set the line style, fill, or both before you
		 * call the `drawRoundRect()` method, by calling the
		 * `linestyle()`, `lineGradientStyle()`,
		 * `beginFill()`, `beginGradientFill()`, or
		 * `beginBitmapFill()` method.
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
		 *                      for the `ellipseWidth` parameter.
		 * @throws ArgumentError If the `width`, `height`,
		 *                       `ellipseWidth` or
		 *                       `ellipseHeight` parameters are not a
		 *                       number(`Number.NaN`).
		 */
		public function drawRoundRect (x:Number, y:Number, width:Number, height:Number, ellipseWidth:Number, ellipseHeight:Object = null):void {}
		
		
		public function drawRoundRectComplex (x:Number, y:Number, width:Number, height:Number, topLeftRadius:Number, topRightRadius:Number, bottomLeftRadius:Number, bottomRightRadius:Number):void {}
		
		
		/**
		 * Renders a set of triangles, typically to distort bitmaps and give them a
		 * three-dimensional appearance. The `drawTriangles()` method maps
		 * either the current fill, or a bitmap fill, to the triangle faces using a
		 * set of(u,v) coordinates.
		 *
		 *  Any type of fill can be used, but if the fill has a transform matrix
		 * that transform matrix is ignored. 
		 *
		 *  A `uvtData` parameter improves texture mapping when a
		 * bitmap fill is used. 
		 * 
		 * @param culling Specifies whether to render triangles that face in a
		 *                specified direction. This parameter prevents the rendering
		 *                of triangles that cannot be seen in the current view. This
		 *                parameter can be set to any value defined by the
		 *                TriangleCulling class.
		 */
		public function drawTriangles (vertices:Vector.<Number>, indices:Vector.<int> = null, uvtData:Vector.<Number> = null, culling:String = null):void {}
		
		
		/**
		 * Applies a fill to the lines and curves that were added since the last call
		 * to the `beginFill()`, `beginGradientFill()`, or
		 * `beginBitmapFill()` method. Flash uses the fill that was
		 * specified in the previous call to the `beginFill()`,
		 * `beginGradientFill()`, or `beginBitmapFill()`
		 * method. If the current drawing position does not equal the previous
		 * position specified in a `moveTo()` method and a fill is
		 * defined, the path is closed with a line and then filled.
		 * 
		 */
		public function endFill ():void {}
		
		
		/**
		 * Specifies a bitmap to use for the line stroke when drawing lines.
		 *
		 * The bitmap line style is used for subsequent calls to Graphics methods
		 * such as the `lineTo()` method or the `drawCircle()`
		 * method. The line style remains in effect until you call the
		 * `lineStyle()` or `lineGradientStyle()` methods, or
		 * the `lineBitmapStyle()` method again with different parameters.
		 * 
		 *
		 * You can call the `lineBitmapStyle()` method in the middle of
		 * drawing a path to specify different styles for different line segments
		 * within a path. 
		 *
		 * Call the `lineStyle()` method before you call the
		 * `lineBitmapStyle()` method to enable a stroke, or else the
		 * value of the line style is `undefined`.
		 *
		 * Calls to the `clear()` method set the line style back to
		 * `undefined`. 
		 * 
		 * @param bitmap The bitmap to use for the line stroke.
		 * @param matrix An optional transformation matrix as defined by the
		 *               flash.geom.Matrix class. The matrix can be used to scale or
		 *               otherwise manipulate the bitmap before applying it to the
		 *               line style.
		 * @param repeat Whether to repeat the bitmap in a tiled fashion.
		 * @param smooth Whether smoothing should be applied to the bitmap.
		 */
		public function lineBitmapStyle (bitmap:BitmapData, matrix:Matrix = null, repeat:Boolean = true, smooth:Boolean = false):void {}
		
		
		/**
		 * Specifies a gradient to use for the stroke when drawing lines.
		 *
		 * The gradient line style is used for subsequent calls to Graphics
		 * methods such as the `lineTo()` methods or the
		 * `drawCircle()` method. The line style remains in effect until
		 * you call the `lineStyle()` or `lineBitmapStyle()`
		 * methods, or the `lineGradientStyle()` method again with
		 * different parameters. 
		 *
		 * You can call the `lineGradientStyle()` method in the middle
		 * of drawing a path to specify different styles for different line segments
		 * within a path. 
		 *
		 * Call the `lineStyle()` method before you call the
		 * `lineGradientStyle()` method to enable a stroke, or else the
		 * value of the line style is `undefined`.
		 *
		 * Calls to the `clear()` method set the line style back to
		 * `undefined`. 
		 * 
		 * @param type                A value from the GradientType class that
		 *                            specifies which gradient type to use, either
		 *                            GradientType.LINEAR or GradientType.RADIAL.
		 * @param matrix              A transformation matrix as defined by the
		 *                            flash.geom.Matrix class. The flash.geom.Matrix
		 *                            class includes a
		 *                            `createGradientBox()` method, which
		 *                            lets you conveniently set up the matrix for use
		 *                            with the `lineGradientStyle()`
		 *                            method.
		 * @param spreadMethod        A value from the SpreadMethod class that
		 *                            specifies which spread method to use:
		 * @param interpolationMethod A value from the InterpolationMethod class that
		 *                            specifies which value to use. For example,
		 *                            consider a simple linear gradient between two
		 *                            colors(with the `spreadMethod`
		 *                            parameter set to
		 *                            `SpreadMethod.REFLECT`). The
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
		 *                            `focalPointRatio` of -0.75:
		 */
		public function lineGradientStyle (type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix = null, spreadMethod:String = null, interpolationMethod:String = null, focalPointRatio:Number = 0):void {}
		
		
		/**
		 * Specifies a line style used for subsequent calls to Graphics methods such
		 * as the `lineTo()` method or the `drawCircle()`
		 * method. The line style remains in effect until you call the
		 * `lineGradientStyle()` method, the
		 * `lineBitmapStyle()` method, or the `lineStyle()`
		 * method with different parameters.
		 *
		 * You can call the `lineStyle()` method in the middle of
		 * drawing a path to specify different styles for different line segments
		 * within the path.
		 *
		 * **Note: **Calls to the `clear()` method set the line
		 * style back to `undefined`.
		 *
		 * **Note: **Flash Lite 4 supports only the first three parameters
		 * (`thickness`, `color`, and `alpha`).
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
		 *                     `pixelHinting` set to `true`,
		 *                     line widths are adjusted to full pixel widths. With
		 *                     `pixelHinting` set to `false`,
		 *                     disjoints can appear for curves and straight lines.
		 *                     For example, the following illustrations show how
		 *                     Flash Player or Adobe AIR renders two rounded
		 *                     rectangles that are identical, except that the
		 *                     `pixelHinting` parameter used in the
		 *                     `lineStyle()` method is set differently
		 *                    (the images are scaled by 200%, to emphasize the
		 *                     difference):
		 *
		 *                     If a value is not supplied, the line does not use
		 *                     pixel hinting.
		 * @param scaleMode   (Not supported in Flash Lite 4) A value from the
		 *                     LineScaleMode class that specifies which scale mode to
		 *                     use:
		 *                     
		 *                      *  `LineScaleMode.NORMAL` - Always
		 *                     scale the line thickness when the object is scaled
		 *                    (the default). 
		 *                      *  `LineScaleMode.NONE` - Never scale
		 *                     the line thickness. 
		 *                      *  `LineScaleMode.VERTICAL` - Do not
		 *                     scale the line thickness if the object is scaled
		 *                     vertically _only_. For example, consider the
		 *                     following circles, drawn with a one-pixel line, and
		 *                     each with the `scaleMode` parameter set to
		 *                     `LineScaleMode.VERTICAL`. The circle on the
		 *                     left is scaled vertically only, and the circle on the
		 *                     right is scaled both vertically and horizontally:
		 *                     
		 *                      *  `LineScaleMode.HORIZONTAL` - Do not
		 *                     scale the line thickness if the object is scaled
		 *                     horizontally _only_. For example, consider the
		 *                     following circles, drawn with a one-pixel line, and
		 *                     each with the `scaleMode` parameter set to
		 *                     `LineScaleMode.HORIZONTAL`. The circle on
		 *                     the left is scaled horizontally only, and the circle
		 *                     on the right is scaled both vertically and
		 *                     horizontally:   
		 *                     
		 * @param caps        (Not supported in Flash Lite 4) A value from the
		 *                     CapsStyle class that specifies the type of caps at the
		 *                     end of lines. Valid values are:
		 *                     `CapsStyle.NONE`,
		 *                     `CapsStyle.ROUND`, and
		 *                     `CapsStyle.SQUARE`. If a value is not
		 *                     indicated, Flash uses round caps.
		 *
		 *                     For example, the following illustrations show the
		 *                     different `capsStyle` settings. For each
		 *                     setting, the illustration shows a blue line with a
		 *                     thickness of 30(for which the `capsStyle`
		 *                     applies), and a superimposed black line with a
		 *                     thickness of 1(for which no `capsStyle`
		 *                     applies): 
		 * @param joints      (Not supported in Flash Lite 4) A value from the
		 *                     JointStyle class that specifies the type of joint
		 *                     appearance used at angles. Valid values are:
		 *                     `JointStyle.BEVEL`,
		 *                     `JointStyle.MITER`, and
		 *                     `JointStyle.ROUND`. If a value is not
		 *                     indicated, Flash uses round joints.
		 *
		 *                     For example, the following illustrations show the
		 *                     different `joints` settings. For each
		 *                     setting, the illustration shows an angled blue line
		 *                     with a thickness of 30(for which the
		 *                     `jointStyle` applies), and a superimposed
		 *                     angled black line with a thickness of 1(for which no
		 *                     `jointStyle` applies): 
		 *
		 *                     **Note:** For `joints` set to
		 *                     `JointStyle.MITER`, you can use the
		 *                     `miterLimit` parameter to limit the length
		 *                     of the miter.
		 * @param miterLimit  (Not supported in Flash Lite 4) A number that
		 *                     indicates the limit at which a miter is cut off. Valid
		 *                     values range from 1 to 255(and values outside that
		 *                     range are rounded to 1 or 255). This value is only
		 *                     used if the `jointStyle` is set to
		 *                     `"miter"`. The `miterLimit`
		 *                     value represents the length that a miter can extend
		 *                     beyond the point at which the lines meet to form a
		 *                     joint. The value expresses a factor of the line
		 *                     `thickness`. For example, with a
		 *                     `miterLimit` factor of 2.5 and a
		 *                     `thickness` of 10 pixels, the miter is cut
		 *                     off at 25 pixels.
		 *
		 *                     For example, consider the following angled lines,
		 *                     each drawn with a `thickness` of 20, but
		 *                     with `miterLimit` set to 1, 2, and 4.
		 *                     Superimposed are black reference lines showing the
		 *                     meeting points of the joints:
		 *
		 *                     Notice that a given `miterLimit` value
		 *                     has a specific maximum angle for which the miter is
		 *                     cut off. The following table lists some examples:
		 */
		public function lineStyle (thickness:Object = null, color:uint = 0, alpha:Number = 0, pixelHinting:Boolean = false, scaleMode:String = null, caps:String = null, joints:String = null, miterLimit:Number = 3):void {}
		
		
		/**
		 * Draws a line using the current line style from the current drawing
		 * position to(`x`, `y`); the current drawing position
		 * is then set to(`x`, `y`). If the display object in
		 * which you are drawing contains content that was created with the Flash
		 * drawing tools, calls to the `lineTo()` method are drawn
		 * underneath the content. If you call `lineTo()` before any calls
		 * to the `moveTo()` method, the default position for the current
		 * drawing is(_0, 0_). If any of the parameters are missing, this
		 * method fails and the current drawing position is not changed.
		 * 
		 * @param x A number that indicates the horizontal position relative to the
		 *          registration point of the parent display object(in pixels).
		 * @param y A number that indicates the vertical position relative to the
		 *          registration point of the parent display object(in pixels).
		 */
		public function lineTo (x:Number, y:Number):void {}
		
		
		/**
		 * Moves the current drawing position to(`x`, `y`). If
		 * any of the parameters are missing, this method fails and the current
		 * drawing position is not changed.
		 * 
		 * @param x A number that indicates the horizontal position relative to the
		 *          registration point of the parent display object(in pixels).
		 * @param y A number that indicates the vertical position relative to the
		 *          registration point of the parent display object(in pixels).
		 */
		public function moveTo (x:Number, y:Number):void {}
		
		
		public function readGraphicsData (recurse:Boolean = true):Vector.<IGraphicsData> { return null; }
		
		
	}
	
	
}