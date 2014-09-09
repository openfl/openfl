package openfl._internal.renderer.opengl.utils;


import lime.graphics.opengl.GLBuffer;
import lime.graphics.GLRenderContext;
import lime.utils.Float32Array;
import lime.utils.UInt16Array;
import openfl._internal.renderer.RenderSession;
import openfl.display.BitmapData;
import openfl.display.BlendMode;
import openfl.display.CapsStyle;
import openfl.display.DisplayObject;
import openfl.display.Graphics;
import openfl.display.JointStyle;
import openfl.display.LineScaleMode;
import openfl.geom.Matrix;
import openfl.geom.Point;


@:access(openfl.display.DisplayObject)
@:access(openfl.display.Graphics)
@:access(openfl.geom.Matrix)


class GraphicsRenderer {
	
	
	public static var graphicsDataPool:Array<GLGraphicsData> = [];
	
	
	public static function buildCircle (graphicsData:DrawPath, webGLData:GLGraphicsData):Void {
		
		var rectData = graphicsData.points;

		var x = rectData[0];
		var y = rectData[1];
		var width = rectData[2];
		var height = (rectData.length == 3) ? width : rectData[3];

		if(graphicsData.type == Ellipse) {

			width /= 2;
			height /= 2;

			x += width;
			y += height;
		}
		
		
		var totalSegs = 40;
		var seg = (Math.PI * 2) / totalSegs;
		
		if (graphicsData.hasFill) {
			
			var color = hex2rgb (graphicsData.fill.color);
			var alpha = getAlpha(graphicsData.fill);
			
			var r = color[0] * alpha;
			var g = color[1] * alpha;
			var b = color[2] * alpha;
			
			var verts = webGLData.points;
			var indices = webGLData.indices;
			
			var vecPos = Std.int (verts.length / 6);
			
			indices.push (vecPos);
			
			for (i in 0...totalSegs + 1) {
				
				verts.push (x);
				verts.push (y);
				verts.push (r);
				verts.push (g);
				verts.push (b);
				verts.push (alpha);
				
				verts.push (x + Math.sin (seg * i) * width);
				verts.push (y + Math.cos (seg * i) * height);
				verts.push (r);
				verts.push (g);
				verts.push (b);
				verts.push (alpha);
				
				indices.push (vecPos++);
				indices.push (vecPos++);
				
			}
			
			indices.push (vecPos - 1);
			
		}
		
		if (graphicsData.line.width > 0) {
			
			var tempPoints = graphicsData.points;
			graphicsData.points = [];
			
			for (i in 0...totalSegs + 1) {
				
				graphicsData.points.push (x + Math.sin (seg * i) * width);
				graphicsData.points.push (y + Math.cos (seg * i) * height);
				
			}
			
			buildLine (graphicsData, webGLData);
			graphicsData.points = tempPoints;
			
		}
		
	}
	
	
	private static function buildComplexPoly (graphicsData:DrawPath, webGLData:GLGraphicsData):Void {
		
		var points:Array<Float> = graphicsData.points.copy();
		if (points.length < 6) return;
		
		var indices = webGLData.indices;
		webGLData.points = points;
		webGLData.alpha = getAlpha(graphicsData.fill);
		webGLData.color = hex2rgb (graphicsData.fill.color);
		
		var minX:Null<Float> = null;
		var maxX:Null<Float> = null;
		var minY:Null<Float> = null;
		var maxY:Null<Float> = null;
		var x,y;
		
		var i = 0;
		while (i < points.length) {
			
			x = points[i];
			y = points[i + 1];
			
			minX = (minX == null || x < minX) ? x : minX;
			maxX = (maxX == null || x > maxX) ? x : maxX;
			minY = (minY == null || y < minY) ? y : minY;
			maxY = (maxY == null || y > maxY) ? y : maxY;
			
			i += 2;
			
		}
		
		points.push (minX);
		points.push (minY);
		points.push (maxX);
		points.push (minY);
		points.push (maxX);
		points.push (maxY);
		points.push (minX);
		points.push (maxY);
		
		var length = Std.int (points.length / 2);
		
		for (i in 0...length) {
			
			indices.push (i);
			
		}
		
	}
	
	
	public static function buildLine (graphicsData:DrawPath, webGLData:GLGraphicsData):Void {
		
		var points:Array<Float> = graphicsData.points;
		if (points.length == 0) return;
		
		if (graphicsData.line.width % 2 > 0) {
			
			for (i in 0...points.length) {
				
				points[i] += 0.5;
				
			}
		
		}
		
		var firstPoint = new Point (points[0], points[1]);
		var lastPoint = new Point (points[Std.int (points.length - 2)], points[Std.int (points.length - 1)]);
		
		if (firstPoint.x == lastPoint.x && firstPoint.y == lastPoint.y) {
			
			points = points.copy ();
			
			points.pop ();
			points.pop ();
			
			lastPoint = new Point (points[Std.int (points.length - 2)], points[Std.int (points.length - 1)]);
			
			var midPointX = lastPoint.x + (firstPoint.x - lastPoint.x) * 0.5;
			var midPointY = lastPoint.y + (firstPoint.y - lastPoint.y) * 0.5;
			
			points.unshift (midPointY);
			points.unshift (midPointX);
			points.push (midPointX);
			points.push (midPointY);
			
		}
		
		var verts = webGLData.points;
		var indices = webGLData.indices;
		var length = Std.int (points.length / 2);
		var indexCount = points.length;
		var indexStart = Std.int (verts.length / 6);
		
		var width = graphicsData.line.width / 2;
		
		var color = hex2rgb (graphicsData.line.color);
		var alpha = graphicsData.line.alpha;
		var r = color[0] * alpha;
		var g = color[1] * alpha;
		var b = color[2] * alpha;
		
		var px, py, p1x, p1y, p2x, p2y, p3x, p3y;
		var perpx:Float, perpy:Float, perp2x:Float, perp2y:Float, perp3x:Float, perp3y:Float;
		var a1, b1, c1, a2, b2, c2;
		var denom, pdist, dist;
		
		p1x = points[0];
		p1y = points[1];
		
		p2x = points[2];
		p2y = points[3];
		
		perpx = -(p1y - p2y);
		perpy =  p1x - p2x;
		
		dist = Math.sqrt ((perpx * perpx) + (perpy * perpy));
		
		perpx /= dist;
		perpy /= dist;
		perpx *= width;
		perpy *= width;
		
		verts.push (p1x - perpx);
		verts.push (p1y - perpy);
		verts.push (r);
		verts.push (g);
		verts.push (b);
		verts.push (alpha);
		
		verts.push (p1x + perpx);
		verts.push (p1y + perpy);
		verts.push (r);
		verts.push (g);
		verts.push (b);
		verts.push (alpha);
		
		for (i in 1...(length - 1)) {
			
			p1x = points[(i - 1) * 2];
			p1y = points[(i - 1) * 2 + 1];
			p2x = points[(i) * 2];
			p2y = points[(i) * 2 + 1];
			p3x = points[(i + 1) * 2];
			p3y = points[(i + 1) * 2 + 1];
			
			perpx = -(p1y - p2y);
			perpy = p1x - p2x;
			
			dist = Math.sqrt ((perpx * perpx) + (perpy * perpy));
			perpx /= dist;
			perpy /= dist;
			perpx *= width;
			perpy *= width;
			
			perp2x = -(p2y - p3y);
			perp2y = p2x - p3x;
			
			dist = Math.sqrt ((perp2x * perp2x) + (perp2y * perp2y));
			perp2x /= dist;
			perp2y /= dist;
			perp2x *= width;
			perp2y *= width;
			
			a1 = (-perpy + p1y) - (-perpy + p2y);
			b1 = (-perpx + p2x) - (-perpx + p1x);
			c1 = (-perpx + p1x) * (-perpy + p2y) - (-perpx + p2x) * (-perpy + p1y);
			a2 = (-perp2y + p3y) - (-perp2y + p2y);
			b2 = (-perp2x + p2x) - (-perp2x + p3x);
			c2 = (-perp2x + p3x) * (-perp2y + p2y) - (-perp2x + p2x) * (-perp2y + p3y);
			
			denom = (a1 * b2) - (a2 * b1);
			
			if (Math.abs (denom) < 0.1) {
				
				denom += 10.1;
				
				verts.push (p2x - perpx);
				verts.push (p2y - perpy);
				verts.push (r);
				verts.push (g);
				verts.push (b);
				verts.push (alpha);
				
				verts.push (p2x + perpx);
				verts.push (p2y + perpy);
				verts.push (r);
				verts.push (g);
				verts.push (b);
				verts.push (alpha);
				
				continue;
				
			}
			
			px = ((b1 * c2) - (b2 * c1)) / denom;
			py = ((a2 * c1) - (a1 * c2)) / denom;
			
			pdist = (px - p2x) * (px - p2x) + (py - p2y) + (py - p2y);
			
			if (pdist > 140 * 140) {
				
				perp3x = perpx - perp2x;
				perp3y = perpy - perp2y;
				
				dist = Math.sqrt ((perp3x * perp3x) + (perp3y * perp3y));
				perp3x /= dist;
				perp3y /= dist;
				perp3x *= width;
				perp3y *= width;
				
				verts.push (p2x - perp3x);
				verts.push (p2y -perp3y);
				verts.push (r);
				verts.push (g);
				verts.push (b);
				verts.push (alpha);
				
				verts.push (p2x + perp3x);
				verts.push (p2y + perp3y);
				verts.push (r);
				verts.push (g);
				verts.push (b);
				verts.push (alpha);
				
				verts.push (p2x - perp3x);
				verts.push (p2y -perp3y);
				verts.push (r);
				verts.push (g);
				verts.push (b);
				verts.push (alpha);
				
				indexCount++;
				
			} else {
				
				verts.push (px);
				verts.push (py);
				verts.push (r);
				verts.push (g);
				verts.push (b);
				verts.push (alpha);
				
				verts.push (p2x - (px - p2x));
				verts.push (p2y - (py - p2y));
				verts.push (r);
				verts.push (g);
				verts.push (b);
				verts.push (alpha);
				
			}
			
		}
		
		p1x = points[(length - 2) * 2];
		p1y = points[(length - 2) * 2 + 1];
		p2x = points[(length - 1) * 2];
		p2y = points[(length - 1) * 2 + 1];
		perpx = -(p1y - p2y);
		perpy = p1x - p2x;
		
		dist = Math.sqrt ((perpx * perpx) + (perpy * perpy));
		perpx /= dist;
		perpy /= dist;
		perpx *= width;
		perpy *= width;
		
		verts.push (p2x - perpx);
		verts.push (p2y - perpy);
		verts.push (r);
		verts.push (g);
		verts.push (b);
		verts.push (alpha);
		
		verts.push (p2x + perpx);
		verts.push (p2y + perpy);
		verts.push (r);
		verts.push (g);
		verts.push (b);
		verts.push (alpha);
		
		indices.push (indexStart);
		
		for (i in 0...indexCount) {
			
			indices.push (indexStart++);
			
		}
		
		indices.push (indexStart - 1);
		
	}
	
	
	public static function buildPoly (graphicsData:DrawPath, webGLData:GLGraphicsData):Void {
		
		var points:Array<Float> = graphicsData.points;
		if (points.length < 6) return;
		
		var verts = webGLData.points;
		var indices = webGLData.indices;
		var length = Std.int (points.length / 2);
		
		var color = hex2rgb (graphicsData.fill.color);
		var alpha = getAlpha(graphicsData.fill);
		var r = color[0] * alpha;
		var g = color[1] * alpha;
		var b = color[2] * alpha;
		
		var triangles = PolyK.triangulate (points);
		var vertPos = verts.length / 6;
		
		var i = 0;
		while (i < triangles.length) {
			
			indices.push (Std.int (triangles[i] + vertPos));
			indices.push (Std.int (triangles[i] + vertPos));
			indices.push (Std.int (triangles[i+1] + vertPos));
			indices.push (Std.int (triangles[i+2] +vertPos));
			indices.push (Std.int (triangles[i + 2] + vertPos));
			i += 3;
			
		}
		
		for (i in 0...length) {
			
			verts.push (points[i * 2]);
			verts.push (points[i * 2 + 1]);
			verts.push (r);
			verts.push (g);
			verts.push (b);
			verts.push (alpha);
			
		}
		
	}
	
	
	public static function buildRectangle (graphicsData:DrawPath, webGLData:GLGraphicsData):Void {
		
		var rectData = graphicsData.points;
		var x = rectData[0];
		var y = rectData[1];
		var width = rectData[2];
		var height = rectData[3];
		
		if (graphicsData.hasFill) {
			
			var color = hex2rgb (graphicsData.fill.color);
			var alpha = getAlpha(graphicsData.fill);
			var r = color[0] * alpha;
			var g = color[1] * alpha;
			var b = color[2] * alpha;
			
			var verts = webGLData.points;
			var indices = webGLData.indices;
			
			var vertPos = Std.int (verts.length / 6);
			
			verts.push (x);
			verts.push (y);
			verts.push (r);
			verts.push (g);
			verts.push (b);
			verts.push (alpha);
			
			verts.push (x + width);
			verts.push (y);
			verts.push (r);
			verts.push (g);
			verts.push (b);
			verts.push (alpha);
			
			verts.push (x);
			verts.push (y + height);
			verts.push (r);
			verts.push (g);
			verts.push (b);
			verts.push (alpha);
			
			verts.push (x + width);
			verts.push (y + height);
			verts.push (r);
			verts.push (g);
			verts.push (b);
			verts.push (alpha);
			
			indices.push (vertPos);
			indices.push (vertPos);
			indices.push (vertPos + 1);
			indices.push (vertPos + 2);
			indices.push (vertPos + 3);
			indices.push (vertPos + 3);
			
		}
		
		if (graphicsData.line.width > 0) {
			
			var tempPoints = graphicsData.points;
			graphicsData.points = [ x, y, x + width, y, x + width, y + height, x, y + height, x, y];
			buildLine (graphicsData, webGLData);
			graphicsData.points = tempPoints;
			
		}
		
	}
	
	
	public static function buildRoundedRectangle (graphicsData:DrawPath, webGLData:GLGraphicsData):Void {
		
		// TODO implementation differ from Flash!
		
		var points = graphicsData.points.copy();
		var x = points[0];
		var y = points[1];
		var width = points[2];
		var height = points[3];
		var radius = points[4];
		
		var recPoints:Array<Float> = [];
		recPoints.push (x);
		recPoints.push (y + radius);
		
		recPoints = recPoints.concat (quadraticBezierCurve (x, y + height - radius, x, y + height, x + radius, y + height));
		recPoints = recPoints.concat (quadraticBezierCurve (x + width - radius, y + height, x + width, y + height, x + width, y + height - radius));
		recPoints = recPoints.concat (quadraticBezierCurve (x + width, y + radius, x + width, y, x + width - radius, y));
		recPoints = recPoints.concat (quadraticBezierCurve (x + radius, y, x, y, x, y + radius));
		
		if (graphicsData.hasFill) {
			
			var color = hex2rgb (graphicsData.fill.color);
			var alpha = getAlpha(graphicsData.fill);
			var r = color[0] * alpha;
			var g = color[1] * alpha;
			var b = color[2] * alpha;
			
			var verts = webGLData.points;
			var indices = webGLData.indices;
			
			var vecPos = verts.length / 6;
			
			var triangles = PolyK.triangulate (recPoints);
			
			var i = 0;
			while (i < triangles.length) {
				
				indices.push (Std.int (triangles[i] + vecPos));
				indices.push (Std.int (triangles[i] + vecPos));
				indices.push (Std.int (triangles[i + 1] + vecPos));
				indices.push (Std.int (triangles[i + 2] + vecPos));
				indices.push (Std.int (triangles[i + 2] + vecPos));
				i += 3;
				
			}
			
			i = 0;
			while (i < recPoints.length) {
				
				verts.push (recPoints[i]);
				verts.push (recPoints[++i]);
				verts.push (r);
				verts.push (g);
				verts.push (b);
				verts.push (alpha);
				i++;
			}
			
		}
		
		if (graphicsData.line.width > 0) {
			
			var tempPoints = graphicsData.points;
			graphicsData.points = recPoints;
			buildLine (graphicsData, webGLData);
			graphicsData.points = tempPoints;
			
		}
		
	}
	
	
	private static function quadraticBezierCurve (fromX:Float, fromY:Float, cpX:Float, cpY:Float, toX:Float, toY:Float):Array<Float> {
		
		var xa, ya, xb, yb, x, y;
		var n = 20;
		var points = [];
		
		var getPt = function (n1:Float , n2:Float, perc:Float):Float {
			
			var diff = n2 - n1;
			return n1 + (diff * perc);
			
		}
		
		var j = 0.0;
		for (i in 0...(n + 1)) {
			
			j = i / n;
			
			xa = getPt (fromX, cpX, j);
			ya = getPt (fromY, cpY, j);
			xb = getPt (cpX, toX, j);
			yb = getPt (cpY, toY, j);
			
			x = getPt (xa, xb, j);
			y = getPt (ya, yb, j);
			
			points.push (x);
			points.push (y);
			
		}
		
		return points;
		
	}
	
	
	public static function render (object:DisplayObject, renderSession:RenderSession):Void {
		
		// cache as bitmap

		renderSession.spriteBatch.end();

		renderGraphics(object, renderSession);

		renderSession.spriteBatch.begin(renderSession);

	}
	
	
	public static function renderGraphics (object:DisplayObject, renderSession:RenderSession):Void {
		
		var graphics = object.__graphics;
		var gl:GLRenderContext = renderSession.gl;
		var projection = renderSession.projection;
		var offset = renderSession.offset;
		var shader = renderSession.shaderManager.primitiveShader;
		var webGLData:GLGraphicsData;
		
		if (graphics.__dirty) {
			
			updateGraphics (graphics, gl);
			
		}
		
		var webGL = graphics.__glData[GLRenderer.glContextId];
		
		for (i in 0...webGL.data.length) {
			
			if (webGL.data[i].mode == 1) {
				
				webGLData = webGL.data[i];
				renderSession.stencilManager.pushStencil (object, webGLData, renderSession);
				
				gl.drawElements (gl.TRIANGLE_FAN, 4, gl.UNSIGNED_SHORT, (webGLData.indices.length - 4) * 2);
				
				renderSession.stencilManager.popStencil (object, webGLData, renderSession);
				
			} else {
				
				webGLData = webGL.data[i];
				
				renderSession.shaderManager.setShader (shader);
				shader = renderSession.shaderManager.primitiveShader;
				gl.uniformMatrix3fv (shader.translationMatrix, false, object.__worldTransform.toArray (true));
				
				gl.uniform2f (shader.projectionVector, projection.x, -projection.y);
				gl.uniform2f (shader.offsetVector, -offset.x, -offset.y);
				
				// TODO tintColor
				gl.uniform3fv (shader.tintColor, new Float32Array (hex2rgb (0xFFFFFF)));
				
				gl.uniform1f (shader.alpha, object.__worldAlpha);
				
				gl.bindBuffer (gl.ARRAY_BUFFER, webGLData.buffer);
				
				gl.vertexAttribPointer (shader.aVertexPosition, 2, gl.FLOAT, false, 4 * 6, 0);
				gl.vertexAttribPointer (shader.colorAttribute, 4, gl.FLOAT, false, 4 * 6, 2 * 4);
				
				gl.bindBuffer (gl.ELEMENT_ARRAY_BUFFER, webGLData.indexBuffer);
				gl.drawElements (gl.TRIANGLE_STRIP, webGLData.indices.length, gl.UNSIGNED_SHORT, 0);
				
			}
			
		}
		
	}
	
	
	private static function switchMode (webGL:GLData, type:Int):GLGraphicsData {
		
		var webGLData:GLGraphicsData;
		
		if (webGL.data == null || webGL.data.length == 0) {
			
			var data = graphicsDataPool.pop ();
			if (data == null) data = new GLGraphicsData (webGL.gl);
			webGLData = data;
			webGLData.mode = type;
			webGL.data.push (webGLData);
			
		} else {
			
			webGLData = webGL.data[Std.int (webGL.data.length - 1)];
			
			if (webGLData.mode != type || type == 1) {
				
				var data = graphicsDataPool.pop ();
				if (data == null) data = new GLGraphicsData (webGL.gl);
				webGLData = data;
				webGLData.mode = type;
				webGL.data.push (webGLData);
				
			}
			
		}
		
		webGLData.dirty = true;
		
		return webGLData;
		
	}
	
	
	private static var DEFAULT_LINE_STYLE:LineStyle = {
		
		width: 0,
		color: 0,
		alpha: 1,
		scaleMode: LineScaleMode.NORMAL,
		caps: CapsStyle.ROUND,
		joints: JointStyle.ROUND,
		miterLimit: 3
		
	}
	
	private static var DEFAULT_FILL_STYLE:FillStyle = {
		
		color: null,
		alpha: 1,
		bitmap: null,
		matrix: null,
		repeat: true,
		smooth: false
		
	}
	
	
	private static var __currentPath:DrawPath;
	private static var __graphicsData:Array<DrawPath>;
	private static var __hasFill:Bool;
	private static var __line:LineStyle;
	private static var __fill:FillStyle;
	
	
	public static function endFill ():Void {
		
		__hasFill = false;
		__fill = Reflect.copy (DEFAULT_FILL_STYLE);
		
	}
	
	
	private inline static function graphicDataPop ():Void {
		
		if (__currentPath.points.length == 0) __graphicsData.pop ();
		
	}
	
	
	private static function moveTo (x:Float, y:Float):Void {
		
		graphicDataPop ();
		
		__currentPath = new DrawPath ();
		__currentPath.update (__line, __hasFill, __fill);
		__currentPath.type = Polygon;
		__currentPath.points.push (x);
		__currentPath.points.push (y);
		
		__graphicsData.push (__currentPath);
		
	}
	
	
	public static function updateGraphics (graphics:Graphics, gl:GLRenderContext):Void {
		
		var webGL = null;
		
		if (graphics.__dirty) {
			
			var bounds = graphics.__bounds;
			
			__graphicsData = new Array ();
			__currentPath = new DrawPath ();
			__hasFill = false;
			__line = Reflect.copy (DEFAULT_LINE_STYLE);
			__fill = Reflect.copy (DEFAULT_FILL_STYLE);
			
			if (!graphics.__visible || graphics.__commands.length == 0 || bounds == null || bounds.width == 0 || bounds.height == 0) {
				
				webGL = graphics.__glData[GLRenderer.glContextId] = new GLData (gl);
				
			} else {
				
				webGL = graphics.__glData[GLRenderer.glContextId];
				
				if (webGL == null) {
					
					webGL = graphics.__glData[GLRenderer.glContextId] = new GLData (gl);
					
				}
				
				for (command in graphics.__commands) {
					
					switch (command) {
						
						case BeginBitmapFill (bitmap, matrix, repeat, smooth):
							
							endFill ();
							
							__hasFill = bitmap != null;
							__fill.bitmap = bitmap;
							__fill.matrix = matrix;
							__fill.repeat = repeat;
							__fill.smooth = smooth;
						
						case BeginFill (rgb, alpha):
							
							endFill ();
							
							__hasFill = true;
							__fill.color = rgb;
							__fill.alpha = alpha;
						
						case CubicCurveTo (cx, cy, cx2, cy2, x, y):
							
							if (__currentPath.points.length == 0) {
								
								moveTo (0, 0);
								
							}
							
							var n = 20;
							var dt:Float = 0;
							var dt2:Float = 0;
							var dt3:Float = 0;
							var t2:Float = 0;
							var t3:Float = 0;
							
							var points = __currentPath.points;
							var fromX = points[points.length-2];
							var fromY = points[points.length-1];
							
							var px:Float = 0;
							var py:Float = 0;
							
							var tmp:Float = 0;
							
							for (i in 1...(n + 1)) {
								
								tmp = i / n;
								
								dt = 1 - tmp;
								dt2 = dt * dt;
								dt3 = dt2 * dt;
								
								t2 = tmp * tmp;
								t3 = t2 * tmp;
								
								px = dt3 * fromX + 3 * dt2 * tmp * cx + 3 * dt * t2 * cx2 + t3 * x;
								py = dt3 * fromY + 3 * dt2 * tmp * cy + 3 * dt * t2 * cy2 + t3 * y;
								
								points.push (px);
								points.push (py);
								
							}
						
						case CurveTo (cx, cy, x, y):
							
							if (__currentPath.points.length == 0) {
								
								moveTo (0, 0);
								
							}
							
							var xa:Float = 0;
							var ya:Float = 0;
							var n = 20;
							
							var points = __currentPath.points;
							var fromX = points[points.length-2];
							var fromY = points[points.length-1];
							
							var px:Float = 0;
							var py:Float = 0;
							
							var tmp:Float = 0;
							
							for (i in 1...(n + 1)) {
								
								tmp = i / n;
								
								xa = fromX + ((cx - fromX) * tmp);
								ya = fromY + ((cy - fromY) * tmp);
								
								px = xa + (((cx + (x - cx) * tmp)) - xa) * tmp;
								py = ya + (((cy + (y - cy) * tmp)) - ya) * tmp;
								
								points.push (px);
								points.push (py);
								
							}
						
						case DrawCircle (x, y, radius):
							
							graphicDataPop ();
							
							__currentPath = new DrawPath ();
							__currentPath.update (__line, __hasFill, __fill);
							__currentPath.type = Circle;
							__currentPath.points = [ x, y, radius ];
							
							__graphicsData.push (__currentPath);
						
						case DrawEllipse (x, y, width, height):
							
							graphicDataPop ();
							
							__currentPath = new DrawPath ();
							__currentPath.update (__line, __hasFill, __fill);
							__currentPath.type = Ellipse;
							__currentPath.points = [ x, y, width, height ];
							
							__graphicsData.push (__currentPath);
						
						case DrawRect (x, y, width, height):
							
							graphicDataPop();
							
							__currentPath = new DrawPath ();
							__currentPath.update (__line, __hasFill, __fill);
							__currentPath.type = Rectangle (false);
							__currentPath.points = [ x, y, width, height ];
							
							__graphicsData.push (__currentPath);
						
						case DrawRoundRect (x, y, width, height, rx, ry):
							
							graphicDataPop ();
							
							__currentPath = new DrawPath ();
							__currentPath.update (__line, __hasFill, __fill);
							__currentPath.type = Rectangle (true);
							__currentPath.points = [ x, y, width, height, rx, ry != -1 ? ry : rx ];
							
							__graphicsData.push (__currentPath);
						
						case EndFill:
							
							endFill ();
						
						case LineStyle (thickness, color, alpha, pixelHinting, scaleMode, caps, joints, miterLimit):
							
							if (thickness == null || thickness < 0) {
								
								__line.width = 0;
								
							} else if (thickness == 0) {
								
								__line.width = 1;
								
							} else {
								
								__line.width = thickness;
								
							}
							
							graphicDataPop ();
							
							__line.color = color;
							__line.alpha = alpha;
							__line.scaleMode = scaleMode;
							__line.caps = caps;
							__line.joints = joints;
							__line.miterLimit = miterLimit;
							
							__currentPath = new DrawPath ();
							__currentPath.update (__line, __hasFill, __fill);
							__currentPath.points = [];
							__currentPath.type = Polygon;
							
							__graphicsData.push (__currentPath);
						
						case LineTo (x, y):
							
							__currentPath.points.push (x);
							__currentPath.points.push (y);
						
						case MoveTo (x, y):
							
							graphicDataPop ();
							
							__currentPath = new DrawPath ();
							__currentPath.update (__line, __hasFill, __fill);
							__currentPath.type = Polygon;
							__currentPath.points.push (x);
							__currentPath.points.push (y);
							
							__graphicsData.push (__currentPath);
						
						default:
							
					}
					
				}
				
			}
			
			graphics.__glGraphicsData = __graphicsData;
			
		}
		
		graphics.__dirty = false;
		
		
		//if (graphics.clearDirty) {
			
			//graphics.clearDirty = false;
			
			for (i in 0...webGL.data.length) {
				
				var graphicsData = webGL.data[i];
				graphicsData.reset ();
				graphicsDataPool.push (graphicsData);
				
			}
			
			webGL.data = [];
			webGL.lastIndex = 0;
			
		//}
		
		
		var webGLData:GLGraphicsData;
		
		for (i in webGL.lastIndex...graphics.__glGraphicsData.length) {
			
			var data = graphics.__glGraphicsData[i];
			
			if (data.type == Polygon) {
				
				if (data.hasFill) {
					
					if (data.points.length > 6) {
						
						if (data.points.length > 10) { // 5 * 2
							
							webGLData = switchMode (webGL, 1);
							buildComplexPoly (data, webGLData);
							
						} else {
							
							webGLData = switchMode (webGL, 0);
							buildPoly (data, webGLData);
							
						}
						
					}
					
				}
				
				if (data.line.width > 0) {
					
					webGLData = switchMode (webGL, 0);
					buildLine (data, webGLData);
					
				}
				
			} else {
				
				webGLData = switchMode (webGL, 0);

				switch(data.type) {
					case Rectangle(rounded):
						if(rounded) {
							buildRoundedRectangle (data, webGLData);
						} else {
							buildRectangle (data, webGLData);
						}
					case Circle, Ellipse:
						buildCircle (data, webGLData);
					case _:
				}
				
			}
			
			webGL.lastIndex++;
			
		}
		
		for (i in 0...webGL.data.length) {
			
			webGLData = webGL.data[i];
			if (webGLData.dirty) webGLData.upload ();
			
		}
		
	}
	
	
	public static inline function hex2rgb (hex:Null<Int>):Array<Float> {
		
		return hex == null ? [0,0,0] : [(hex >> 16 & 0xFF) / 255, ( hex >> 8 & 0xFF) / 255, (hex & 0xFF) / 255];
		
	}
	
	private static inline function getAlpha(fill:FillStyle):Float {
		return fill.color == null ? 0 : fill.alpha;
	}
	
	
}

class GLData {

	public var lastIndex:Int = 0;
	public var data:Array<GLGraphicsData>;
	public var gl:GLRenderContext;

	public function new (gl:GLRenderContext) {
		this.gl = gl;
		data = [];
		lastIndex = 0;
	}

}

class GLGraphicsData {
	
	
	//public static var graphicsDataPool = [];
	
	public var alpha:Float;
	public var buffer:GLBuffer;
	public var color:Array<Float>;
	public var dirty:Bool;
	public var gl:GLRenderContext;
	public var glPoints:Float32Array;
	public var glIndices:UInt16Array;
	public var indexBuffer:GLBuffer;
	public var indices:Array<Int>;
	public var lastIndex:Int;
	public var mode:Int;
	public var points:Array<Float>;
	
	
	public function new (gl:GLRenderContext) {
		
		this.gl = gl;
		
		color = [ 0, 0, 0];
		points = [];
		indices = [];
		lastIndex = 0;
		buffer = gl.createBuffer ();
		indexBuffer = gl.createBuffer ();
		mode = 1;
		alpha = 1;
		dirty = true;
		
	}
	
	
	public function reset ():Void {
		
		points = [];
		indices = [];
		lastIndex = 0;
		
	}
	
	
	public function upload ():Void {
		
		var gl = this.gl;
		
		glPoints = new Float32Array (cast points);
		
		gl.bindBuffer (gl.ARRAY_BUFFER, buffer);
		gl.bufferData (gl.ARRAY_BUFFER, glPoints, gl.STATIC_DRAW);
		
		glIndices = new UInt16Array (cast indices);
		
		gl.bindBuffer (gl.ELEMENT_ARRAY_BUFFER, indexBuffer);
		gl.bufferData (gl.ELEMENT_ARRAY_BUFFER, glIndices, gl.STATIC_DRAW);
		
		dirty = false;
		
	}
	
	
}


class PolyK {
	
	
	public static function triangulate (p:Array<Float>):Array<Int> {
		
		var sign = true;

		var n = p.length >> 1;
		if (n < 3) return [];
		
		var tgs:Array<Int> = [];
		var avl:Array<Int> = [for (i in 0...n) i];
		
		var i = 0;
		var al = n;
		var earFound = false;
		
		while (al > 3) {
			
			var i0 = avl[(i + 0) % al];
			var i1 = avl[(i + 1) % al];
			var i2 = avl[(i + 2) % al];
			
			var ax = p[2* i0], ay = p[2 * i0 + 1];
			var bx = p[2 * i1], by = p[2 * i1 + 1];
			var cx = p[2 * i2], cy = p[2 * i2 + 1];
			
			earFound = false;
			
			if (PolyK._convex (ax, ay, bx, by, cx, cy, sign)) {
				
				earFound = true;
				
				for (j in 0...al) {
					
					var vi = avl[j];
					if (vi == i0 || vi == i1 || vi == i2) continue;
					
					if (PolyK._PointInTriangle (p[2 * vi], p[2 * vi + 1], ax, ay, bx, by, cx, cy)) {
						
						earFound = false;
						break;
						
					}
					
				}
				
			}
			
			if (earFound) {
				
				tgs.push (i0);
				tgs.push (i1);
				tgs.push (i2);
				avl.splice ((i + 1) % al, 1);
				al--;
				i = 0;
				
			} else if (i++ > 3 * al) {
				
				if (sign) {
					
					tgs = [];
					avl = [for (k in 0...n) k];
					
					i = 0;
					al = n;
					sign = false;
					
				} else {
					
					trace ("Warning: shape too complex to fill");
					return [];
					
				}
				
			}
			
		}
		
		tgs.push (avl[0]);
		tgs.push (avl[1]);
		tgs.push (avl[2]);
		return tgs;
		
	}
	
	
	public static function _PointInTriangle (px:Float, py:Float, ax:Float, ay:Float, bx:Float, by:Float, cx:Float, cy:Float) {
		
		var v0x = Std.int(cx-ax);
		var v0y = Std.int(cy-ay);
		var v1x = Std.int(bx-ax);
		var v1y = Std.int(by-ay);
		var v2x = Std.int(px-ax);
		var v2y = Std.int(py-ay);
		
		var dot00 = (v0x * v0x) + (v0y * v0y);
		var dot01 = (v0x * v1x) + (v0y * v1y);
		var dot02 = (v0x * v2x) + (v0y * v2y);
		var dot11 = (v1x * v1x) + (v1y * v1y);
		var dot12 = (v1x * v2x) + (v1y * v2y);
		
		var invDenom = 1 / (dot00 * dot11 - dot01 * dot01);
		var u = (dot11 * dot02 - dot01 * dot12) * invDenom;
		var v = (dot00 * dot12 - dot01 * dot02) * invDenom;
		
		return (u >= 0) && (v >= 0) && (u + v < 1);
		
	}
	
	
	public static function _convex (ax:Float, ay:Float, bx:Float, by:Float, cx:Float, cy:Float, sign:Bool) {
		
		return ((ay - by) * (cx - bx) + (bx - ax) * (cy - by) >= 0) == sign;
		
	}
		
}


typedef LineStyle = {
	
	width:Float,
	color:Int,
	alpha:Float,
	
	scaleMode:LineScaleMode,
	caps:CapsStyle,
	joints:JointStyle,
	miterLimit:Float
	
}


typedef FillStyle = {
	
	color:Null<Int>,
	alpha:Float,
	bitmap:BitmapData,
	repeat:Bool,
	matrix:Matrix,
	smooth:Bool
	
}


@:access(openfl._internal.renderer.opengl.utils.GraphicsRenderer)
@:access(openfl.display.Graphics)


class DrawPath {
	
	
	public var hasFill:Bool = false;
	
	public var line:LineStyle;
	public var fill:FillStyle;
	
	public var points:Array<Float> = [];
	
	public var type:GraphicType = Polygon;
	
	
	public function new() {
		
		line = Reflect.copy (GraphicsRenderer.DEFAULT_LINE_STYLE);
		fill = Reflect.copy (GraphicsRenderer.DEFAULT_FILL_STYLE);
		
	}
	
	
	public function update (line:LineStyle, hasFill:Bool, fill:FillStyle):Void {
		
		updateLine (line);
		updateFill (hasFill, fill);
		
	}
	
	
	public function updateFill (hasFill:Bool, fill:FillStyle):Void {
		
		this.hasFill = hasFill;
		this.fill = Reflect.copy (fill);
		
	}
	
	
	public function updateLine (line:LineStyle):Void {
		
		this.line.width = line.width;
		this.line.color = line.color;
		this.line.alpha = line.alpha;
		this.line.scaleMode = line.scaleMode == null ? LineScaleMode.NORMAL : line.scaleMode;
		this.line.caps = line.caps == null ? CapsStyle.ROUND : line.caps;
		this.line.joints = line.joints == null ? JointStyle.ROUND : line.joints;
		this.line.miterLimit = line.miterLimit;
		
	}
	
	
}


enum GraphicType {

	Polygon;
	Rectangle(rounded:Bool);
	Circle;
	Ellipse;

}