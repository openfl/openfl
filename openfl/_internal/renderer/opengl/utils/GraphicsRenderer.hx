package openfl._internal.renderer.opengl.utils;


import lime.graphics.GLBuffer;
import lime.graphics.GLRenderContext;
import lime.utils.Float32Array;
import lime.utils.UInt16Array;
import openfl._internal.renderer.RenderSession;
import openfl.display.Graphics;
import openfl.geom.Point;


@:access(openfl.display.Graphics)


class  GraphicsRenderer {
	
	
	public static var POLY = 0;
	public static var RECT = 1;
	public static var CIRC = 2;
	public static var ELIP = 3;
	public static var RREC = 4;
	
	public static var graphicsDataPool:Array<Dynamic>;
	
	private static var last:Int;
	
	
	public static function buildCircle (graphicsData:Dynamic, webGLData:GLGraphicsData):Void {
		
		var rectData = graphicsData.points;
		var x = rectData[0];
		var y = rectData[1];
		var width = rectData[2];
		var height = rectData[3];
		
		var totalSegs = 40;
		var seg = (Math.PI * 2) / totalSegs;
		
		if (graphicsData.fill != null) {
			
			var color = hex2rgb (graphicsData.fillColor);
			var alpha = graphicsData.fillAlpha;
			
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
		
		if (graphicsData.lineWidth > 0) {
			
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
	
	
	private static function buildComplexPoly (graphicsData:Dynamic, webGLData:GLGraphicsData):Void {
		
		var points:Array<Float> = graphicsData.points.slice ();
		if (points.length < 6) return;
		
		var indices = webGLData.indices;
		webGLData.points = points;
		webGLData.alpha = graphicsData.fillAlpha;
		webGLData.color = hex2rgb (graphicsData.fillColor);
		
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
	
	
	public static function buildLine (graphicsData:Dynamic, webGLData:GLGraphicsData):Void {
		
		var points:Array<Float> = graphicsData.points;
		if (points.length == 0) return;
		
		if (graphicsData.lineWidth % 2 > 0) {
			
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
		
		var width = graphicsData.lineWidth / 2;
		
		var color = hex2rgb (graphicsData.lineColor);
		var alpha = graphicsData.lineAlpha;
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
	
	
	public static function buildPoly (graphicsData:Dynamic, webGLData:GLGraphicsData):Void {
		
		var points:Array<Float> = graphicsData.points;
		if (points.length < 6) return;
		
		var verts = webGLData.points;
		var indices = webGLData.indices;
		var length = Std.int (points.length / 2);
		
		var color = hex2rgb (graphicsData.fillColor);
		var alpha = graphicsData.fillAlpha;
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
	
	
	public static function buildRectangle (graphicsData:Dynamic, webGLData:GLGraphicsData):Void {
		
		var rectData = graphicsData.points;
		var x = rectData[0];
		var y = rectData[1];
		var width = rectData[2];
		var height = rectData[3];
		
		if (graphicsData.fill != null) {
			
			var color = hex2rgb (graphicsData.fillColor);
			var alpha = graphicsData.fillAlpha;
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
		
		if (graphicsData.lineWidth > 0) {
			
			var tempPoints = graphicsData.points;
			graphicsData.points = [ x, y, x + width, y, x + width, y + height, x, y + height, x, y];
			buildLine (graphicsData, webGLData);
			graphicsData.points = tempPoints;
			
		}
		
	}
	
	
	public static function buildRoundedRectangle (graphicsData:Dynamic, webGLData:GLGraphicsData):Void {
		
		var points = graphicsData.points;
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
		
		if (graphicsData.fill != null) {
			
			var color = hex2rgb (graphicsData.fillColor);
			var alpha = graphicsData.fillAlpha;
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
			
			var i = 0;
			while (i++ < recPoints.length) {
				
				verts.push (recPoints[i]);
				verts.push (recPoints[++i]);
				verts.push (r);
				verts.push (g);
				verts.push (b);
				verts.push (alpha);
				
			}
			
		}
		
		if (graphicsData.lineWidth > 0) {
			
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
	
	
	public static function renderGraphics (graphics:Graphics, renderSession:RenderSession):Void {
		
		/*
		var gl:GLRenderContext = renderSession.gl;
		var projection = renderSession.projection;
		var offset = renderSession.offset;
		var shader = renderSession.shaderManager.primitiveShader;
		var webGLData:GLGraphicsData;
		
		if (graphics.__dirty) {
			
			updateGraphics (graphics, gl);
			
		}
		
		var webGL:Dynamic = graphics._webGL[GLRenderer.glContextId];
		
		for (i in 0...webGL.data.length) {
			
			if (webGL.data[i].mode == 1) {
				
				webGLData = webGL.data[i];
				renderSession.stencilManager.pushStencil (graphics, webGLData, renderSession);
				
				gl.drawElements (gl.TRIANGLE_FAN, 4, gl.UNSIGNED_SHORT, (webGLData.indices.length - 4) * 2);
				
				renderSession.stencilManager.popStencil (graphics, webGLData, renderSession);
				
				last = webGLData.mode;
				
			} else {
				
				webGLData = webGL.data[i];
				
				renderSession.shaderManager.setShader (shader);
				shader = renderSession.shaderManager.primitiveShader;
				gl.uniformMatrix3fv (shader.translationMatrix, false, graphics.worldTransform.toArray (true));
				
				gl.uniform2f (shader.projectionVector, projection.x, -projection.y);
				gl.uniform2f (shader.offsetVector, -offset.x, -offset.y);
				
				gl.uniform3fv (shader.tintColor, new Float32Array (hex2rgb (graphics.tint)));
				
				gl.uniform1f (shader.alpha, graphics.worldAlpha);
				
				gl.bindBuffer (gl.ARRAY_BUFFER, webGLData.buffer);
				
				gl.vertexAttribPointer (shader.aVertexPosition, 2, gl.FLOAT, false, 4 * 6, 0);
				gl.vertexAttribPointer (shader.colorAttribute, 4, gl.FLOAT, false, 4 * 6, 2 * 4);
				
				gl.bindBuffer (gl.ELEMENT_ARRAY_BUFFER, webGLData.indexBuffer);
				gl.drawElements (gl.TRIANGLE_STRIP, webGLData.indices.length, gl.UNSIGNED_SHORT, 0);
				
			}
			
		}*/
		
	}
	
	
	private static function switchMode (webGL:Dynamic, type):GLGraphicsData {
		
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
	
	
	public static function updateGraphics (graphics:Graphics, gl:GLRenderContext):Void {
		
		/*
		var webGL = graphics._webGL[GLRenderer.glContextId];
		
		if (webGL == null) {
			
			webGL = graphics._webGL[GLRenderer.glContextId] = { lastIndex: 0, data: [], gl: gl };
			
		}
		
		graphics.__dirty = false;
		
		if (graphics.clearDirty) {
			
			graphics.clearDirty = false;
			
			for (i in 0...webGL.data.length) {
				
				var graphicsData = webGL.data[i];
				graphicsData.reset ();
				graphicsDataPool.push (graphicsData);
				
			}
			
			webGL.data = [];
			webGL.lastIndex = 0;
			
		}
		
		var webGLData;
		
		for (i in webGL.lastIndex...graphics.graphicsData.length) {
			
			var data:Dynamic = graphics.graphicsData[i];
			
			if (data.type == GraphicsRenderer.POLY) {
				
				if (data.fill != null) {
					
					if (data.points.length > 6) {
						
						if (data.points.length > 5 * 2) {
							
							webGLData = switchMode (webGL, 1);
							buildComplexPoly (data, webGLData);
							
						} else {
							
							webGLData = switchMode (webGL, 0);
							buildPoly (data, webGLData);
							
						}
						
					}
					
				}
				
				if (data.lineWidth > 0) {
					
					webGLData = switchMode (webGL, 0);
					buildLine (data, webGLData);
					
				}
				
			} else {
				
				webGLData = switchMode (webGL, 0);
				
				if (data.type == GraphicsRenderer.RECT) {
					
					buildRectangle (data, webGLData);
					
				} else if (data.type == GraphicsRenderer.CIRC || data.type == GraphicsRenderer.ELIP) {
					
					buildCircle (data, webGLData);
					
				} else if (data.type == GraphicsRenderer.RREC) {
					
					buildRoundedRectangle (data, webGLData);
					
				}
				
			}
			
			webGL.lastIndex++;
			
		}
		
		for (i in 0...webGL.data.length) {
			
			webGLData = cast webGL.data[i];
			if (webGLData.dirty) webGLData.upload ();
			
		}*/
		
	}
	
	
	public static function hex2rgb (hex) {
		
		return [(hex >> 16 & 0xFF) / 255, ( hex >> 8 & 0xFF) / 255, (hex & 0xFF) / 255];
		
	}
	
	
}


class GLGraphicsData {
	
	
	public static var graphicsDataPool = [];
	
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
	
	
	public static function triangulate (p:Dynamic) {
		
		var sign = true;
		
		var n = p.length >> 1;
		if (n < 3) return [];
		
		var tgs = [];
		var avl = [];
		
		for (i in 0...n) avl.push (i);
		
		var i = 0;
		var al = n;
		
		while (al > 3) {
			
			var i0 = avl[(i + 0) % al];
			var i1 = avl[(i + 1) % al];
			var i2 = avl[(i + 2) % al];
			
			var ax = p[2* i0], ay = p[2 * i0 + 1];
			var bx = p[2 * i1], by = p[2 * i1 + 1];
			var cx = p[2 * i2], cy = p[2 * i2 + 1];
			
			var earFound = false;
			
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
					avl = [];
					
					for (i in 0...n) avl.push (i);
					
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
	
	
	public static function _PointInTriangle (px, py, ax, ay, bx, by, cx, cy) {
		
		var v0x = cx-ax;
		var v0y = cy-ay;
		var v1x = bx-ax;
		var v1y = by-ay;
		var v2x = px-ax;
		var v2y = py-ay;
		
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
	
	
	public static function _convex (ax, ay, bx, by, cx, cy, sign) {
		
		return ((ay - by) * (cx - bx) + (bx - ax) * (cy - by) >= 0) == sign;
		
	}
	
	
}