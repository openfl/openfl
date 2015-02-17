package openfl._internal.renderer.opengl.utils;


import haxe.EnumFlags;
import lime.graphics.opengl.GLBuffer;
import lime.graphics.GLRenderContext;
import lime.utils.Float32Array;
import lime.utils.UInt16Array;
import openfl._internal.renderer.opengl.shaders.DrawTrianglesShader;
import openfl._internal.renderer.opengl.shaders.FillShader;
import openfl._internal.renderer.opengl.utils.GraphicsRenderer.GLBucketData;
import openfl._internal.renderer.opengl.utils.GraphicsRenderer.RenderMode;
import openfl._internal.renderer.RenderSession;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.BlendMode;
import openfl.display.CapsStyle;
import openfl.display.DisplayObject;
import openfl.display.Graphics;
import openfl.display.JointStyle;
import openfl.display.LineScaleMode;
import openfl.display.TriangleCulling;
import openfl.display.Tilesheet;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.gl.GLTexture;
import openfl.utils.Int16Array;
import openfl.Vector;


@:access(openfl.display.DisplayObject)
@:access(openfl.display.Graphics)
@:access(openfl.display.BitmapData)
@:access(openfl.geom.Matrix)


class GraphicsRenderer {
	
	
	public static var graphicsDataPool:Array<GLGraphicsData> = [];
	public static var bucketPool:Array<GLBucket> = [];
	
	private static var objectPosition:Point = new Point();
	private static var objectBounds:Rectangle = new Rectangle();
	
	private static var lastVertsBuffer:GLBuffer;
	private static var lastBucketMode:BucketMode;
	private static var lastTexture:GLTexture;
	private static var lastTextureRepeat:Bool;
	private static var lastTextureSmooth:Bool;
	
	public static function buildCircle (path:DrawPath, glStack:GLStack, localCoords:Bool = false):Void {
		var rectData = path.points;

		var x = rectData[0];
		var y = rectData[1];
		var width = rectData[2];
		var height = (rectData.length == 3) ? width : rectData[3];
		
		if (path.type == Ellipse) {
			width /= 2;
			height /= 2;
			x += width;
			y += height;
		}

		if(localCoords) {
			x -= objectBounds.x;
			y -= objectBounds.y;
		}

		var totalSegs = 40;
		var seg = (Math.PI * 2) / totalSegs;
		
		var bucket = prepareBucket(path, glStack);

		
		if(bucket != null) {
			var verts = bucket.verts;
			var indices = bucket.indices;
			
			var vertPos = Std.int (verts.length / 2);
			
			indices.push (vertPos);
			
			for (i in 0...totalSegs + 1) {
				
				verts.push (x);
				verts.push (y);
				
				verts.push (x + Math.sin (seg * i) * width);
				verts.push (y + Math.cos (seg * i) * height);
				
				indices.push (vertPos++);
				indices.push (vertPos++);
				
			}
			
			indices.push (vertPos - 1);
			
		}
		
		
		if (path.line.width > 0) {
			
			var tempPoints = path.points;
			path.points = [];
			
			for (i in 0...totalSegs + 1) {
				
				path.points.push (x + Math.sin (seg * i) * width);
				path.points.push (y + Math.cos (seg * i) * height);
				
			}
			
			buildLine (path, bucket.line);
			path.points = tempPoints;
			
		}
		
	}
	
	public static function buildComplexPoly (path:DrawPath, glStack:GLStack, localCoords:Bool = false):Void {
		if (path.points.length < 6) return;
		var points = path.points.copy();
		
		if(localCoords) {
			for (i in 0...Std.int(points.length / 2)) {
				points[i * 2] -= objectBounds.x;
				points[i * 2 + 1] -= objectBounds.y;
			}
		}
		
		
		var bucket = prepareBucket(path, glStack);
		bucket.drawMode = glStack.gl.TRIANGLE_FAN;
		bucket.verts = points;
		
		var indices = bucket.indices;
		var length = Std.int (points.length / 2);
		for (i in 0...length) {
			
			indices.push (i);
			
		}
		
		if (path.line.width > 0) {
			
			buildLine (path, bucket.line, localCoords);
			
		}
	}
	
	public static function buildLine (path:DrawPath, bucket:GLBucketData, localCoords:Bool = false):Void {
		var points = path.points;
		if (points.length == 0) return;
		
		if (localCoords) {
			for (i in 0...Std.int(points.length / 2)) {
				points[i * 2] -= objectBounds.x;
				points[i * 2 + 1] -= objectBounds.y;
			}
		}
		
		if (path.line.width % 2 > 0) {
			
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
		
		var verts = bucket.verts;
		var indices = bucket.indices;
		var length = Std.int (points.length / 2);
		var indexCount = points.length;
		var indexStart = Std.int (verts.length / 6);
		
		var width = path.line.width / 2;
		
		var color = hex2rgb (path.line.color);
		var alpha = path.line.alpha;
		var r = color[0] * alpha;
		var g = color[1] * alpha;
		var b = color[2] * alpha;
		
		var px:Float, py:Float, p1x:Float, p1y:Float, p2x:Float, p2y:Float, p3x:Float, p3y:Float;
		var perpx:Float, perpy:Float, perp2x:Float, perp2y:Float, perp3x:Float, perp3y:Float;
		var a1:Float, b1:Float, c1:Float, a2:Float, b2:Float, c2:Float;
		var denom:Float, pdist:Float, dist:Float;
		
		p1x = points[0];
		p1y = points[1];
		
		p2x = points[2];
		p2y = points[3];
		
		perpx = -(p1y - p2y);
		perpy =  p1x - p2x;
		
		dist = Math.sqrt (Math.abs((perpx * perpx) + (perpy * perpy)));
		
		perpx = perpx / dist;
		perpy = perpy / dist;
		perpx = perpx * width;
		perpy = perpy * width;
		
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
			
			dist = Math.sqrt (Math.abs((perpx * perpx) + (perpy * perpy)));
			perpx = perpx / dist;
			perpy = perpy / dist;
			perpx = perpx * width;
			perpy = perpy * width;
			
			perp2x = -(p2y - p3y);
			perp2y = p2x - p3x;
			
			dist = Math.sqrt (Math.abs((perp2x * perp2x) + (perp2y * perp2y)));
			perp2x = perp2x / dist;
			perp2y = perp2y / dist;
			perp2x = perp2x * width;
			perp2y = perp2y * width;
			
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
				
				dist = Math.sqrt (Math.abs((perp3x * perp3x) + (perp3y * perp3y)));
				perp3x = perp3x / dist;
				perp3y = perp3y / dist;
				perp3x = perp3x * width;
				perp3y = perp3y * width;
				
				verts.push (p2x - perp3x);
				verts.push (p2y - perp3y);
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
		
		dist = Math.sqrt (Math.abs((perpx * perpx) + (perpy * perpy)));
		if (!Math.isFinite(dist)) trace(((perpx * perpx) + (perpy * perpy)));
		perpx = perpx / dist;
		perpy = perpy / dist;
		perpx = perpx * width;
		perpy = perpy * width;
		
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
	
	public static function buildPoly (path:DrawPath, glStack:GLStack):Void {
		if (path.points.length < 6) return;
		var points = path.points;
		
		var l = points.length;
		var sx = points[0];		var sy = points[1];
		var ex = points[l - 2];	var ey = points[l - 1];
		// close polygon
		if (sx != ex || sy != ey) {
			points.push(sx);
			points.push(sy);
		}
		
		var length = Std.int (points.length / 2);
		
		var bucket = prepareBucket(path, glStack);
		var verts = bucket.verts;
		var indices = bucket.indices;
		
		if (bucket != null) {
			var triangles = PolyK.triangulate (points);
			var vertPos = verts.length / 2;
			
			var i = 0;
			while (i < triangles.length) {
				
				indices.push (Std.int (triangles[i] + vertPos));
				indices.push (Std.int (triangles[i] + vertPos));
				indices.push (Std.int (triangles[i+1] + vertPos));
				indices.push (Std.int (triangles[i+2] + vertPos));
				indices.push (Std.int (triangles[i+2] + vertPos));
				i += 3;
				
			}
			
			for (i in 0...length) {
				
				verts.push (points[i * 2]);
				verts.push (points[i * 2 + 1]);
				
			}
		}
		
		if (path.line.width > 0) {
			
			buildLine (path, bucket.line);
			
		}
	}
	
	public static function buildRectangle (path:DrawPath, glStack:GLStack, localCoords:Bool = false):Void {
		var rectData = path.points;
		var x = rectData[0];
		var y = rectData[1];
		var width = rectData[2];
		var height = rectData[3];
		
		if (localCoords) {
			x -= objectBounds.x;
			y -= objectBounds.y;
		}
		
		var bucket = prepareBucket(path, glStack);
		
		if(bucket != null) {
			var verts = bucket.verts;
			var indices = bucket.indices;
			
			var vertPos = Std.int (verts.length / 2);
			
			verts.push (x); 
			verts.push (y);
			verts.push (x + width);
			verts.push (y);
			verts.push (x);
			verts.push (y + height);
			verts.push (x + width);
			verts.push (y + height);
			
			indices.push (vertPos);
			indices.push (vertPos);
			indices.push (vertPos + 1);
			indices.push (vertPos + 2);
			indices.push (vertPos + 3);
			indices.push (vertPos + 3);
		}
		
		
		if (path.line.width > 0) {
			
			var tempPoints = path.points;
			path.points = [ x, y, x + width, y, x + width, y + height, x, y + height, x, y];
			buildLine (path, bucket.line);
			path.points = tempPoints;
			
		}
	}
	
	public static function buildRoundedRectangle (path:DrawPath, glStack:GLStack, localCoords:Bool = false):Void {
		var points = path.points.copy();
		var x = points[0];
		var y = points[1];
		var width = points[2];
		var height = points[3];
		var radius = points[4];
		
		if (localCoords) {
			x -= objectBounds.x;
			y -= objectBounds.y;
		}
		
		var recPoints:Array<Float> = [];
		recPoints.push (x);
		recPoints.push (y + radius);
		
		recPoints = recPoints.concat (quadraticBezierCurve (x, y + height - radius, x, y + height, x + radius, y + height));
		recPoints = recPoints.concat (quadraticBezierCurve (x + width - radius, y + height, x + width, y + height, x + width, y + height - radius));
		recPoints = recPoints.concat (quadraticBezierCurve (x + width, y + radius, x + width, y, x + width - radius, y));
		recPoints = recPoints.concat (quadraticBezierCurve (x + radius, y, x, y, x, y + radius));
		
		var bucket = prepareBucket(path, glStack);
		
		if (bucket != null) {
			var verts = bucket.verts;
			var indices = bucket.indices;
			
			var vecPos = verts.length / 2;
			
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
				i++;
			}
		}
		
		if (path.line.width > 0) {
			
			var tempPoints = path.points;
			path.points = recPoints;
			buildLine (path, bucket.line);
			path.points = tempPoints;
			
		}
	}
	
	public static function buildDrawTriangles (path:DrawPath, object:DisplayObject, glStack:GLStack, localCoords:Bool = false):Void {
		
		var args = Type.enumParameters(path.type);
		
		var vertices:Vector<Float> = cast args[0];
		var indices:Vector<Int> = cast args[1];
		var uvtData:Vector<Float> = cast args[2];
		var culling:TriangleCulling = cast args[3];
		var colors:Vector<Int> = cast args[4];
		var blendMode:Int = args[5];
		
		var a, b, c, d, tx, ty;
		
		if (localCoords) {
			a = 1.0;
			b = 0.0;
			c = 0.0;
			d = 1.0;
			tx = 0.0;
			ty = 0.0;
		} else {
			a = object.__worldTransform.a;
			b = object.__worldTransform.b;
			c = object.__worldTransform.c;
			d = object.__worldTransform.d;
			tx = object.__worldTransform.tx;
			ty = object.__worldTransform.ty;
		}
		
		var hasColors = colors != null && colors.length > 0;
		
		var bucket = prepareBucket(path, glStack);
		bucket.rawVerts = true;
		bucket.glLength = indices.length;
		bucket.stride = 8;
		
		var vertsLength = bucket.glLength * bucket.stride;
		var verts:Float32Array;
		
		if (bucket.glVerts == null || bucket.glVerts.length < vertsLength) {
			verts = new Float32Array(vertsLength);
			bucket.glVerts = verts;
		} else {
			verts = bucket.glVerts;
		}
		
		var v0 = 0; var v1 = 0; var v2 = 0;
		var i0 = 0; var i1 = 0; var i2 = 0;
		
		var x0 = 0.0; var y0 = 0.0;
		var x1 = 0.0; var y1 = 0.0;
		var x2 = 0.0; var y2 = 0.0;
		
		var idx = 0;
		var color = hex2rgba(0xFFFFFFFF);
		var ctmp = color;
		for (i in 0...Std.int(indices.length / 3)) {
			
			i0 = indices[i * 3]; i1 = indices[i * 3 + 1]; i2 = indices[i * 3 + 2];	
			v0 = i0 * 2; v1 = i1 * 2; v2 = i2 * 2;
			
			x0 = vertices[v0];	y0 = vertices[v0 + 1];
			x1 = vertices[v1];	y1 = vertices[v1 + 1];
			x2 = vertices[v2];	y2 = vertices[v2 + 1];
			
			if (localCoords) {
				x0 -= objectBounds.x;
				y0 -= objectBounds.y;
				x1 -= objectBounds.x;
				y1 -= objectBounds.y;
				x2 -= objectBounds.x;
				y2 -= objectBounds.y;
			}
			
			switch(culling) {
				case POSITIVE:
					if (!isCCW(x0, y0, x1, y1, x2, y2)) continue;
				case NEGATIVE:
					if (isCCW(x0, y0, x1, y1, x2, y2)) continue;
				case _:
			}
			
			verts[idx++] = a * x0 + c * y0 + tx;
			verts[idx++] = b * x0 + d * y0 + ty;
			verts[idx++] = uvtData[v0];
			verts[idx++] = uvtData[v0 + 1];
			if (hasColors) {
				ctmp = hex2rgba(colors[i0]);
				verts[idx++] = ctmp[0];
				verts[idx++] = ctmp[1];
				verts[idx++] = ctmp[2];
				verts[idx++] = ctmp[3];
			} else {
				verts[idx++] = color[0];
				verts[idx++] = color[1];
				verts[idx++] = color[2];
				verts[idx++] = color[3];
			}
			
			
			verts[idx++] = a * x1 + c * y1 + tx;
			verts[idx++] = b * x1 + d * y1 + ty;
			verts[idx++] = uvtData[v1];
			verts[idx++] = uvtData[v1 + 1];
			if (hasColors) {
				ctmp = hex2rgba(colors[i1]);
				verts[idx++] = ctmp[0];
				verts[idx++] = ctmp[1];
				verts[idx++] = ctmp[2];
				verts[idx++] = ctmp[3];
			} else {
				verts[idx++] = color[0];
				verts[idx++] = color[1];
				verts[idx++] = color[2];
				verts[idx++] = color[3];
			}
			
			verts[idx++] = a * x2 + c * y2 + tx;
			verts[idx++] = b * x2 + d * y2 + ty;
			verts[idx++] = uvtData[v2];
			verts[idx++] = uvtData[v2 + 1];
			if (hasColors) {
				ctmp = hex2rgba(colors[i2]);
				verts[idx++] = ctmp[0];
				verts[idx++] = ctmp[1];
				verts[idx++] = ctmp[2];
				verts[idx++] = ctmp[3];
			} else {
				verts[idx++] = color[0];
				verts[idx++] = color[1];
				verts[idx++] = color[2];
				verts[idx++] = color[3];
			}
			
		}
		
	}
	
	public static inline function buildDrawTiles (path:DrawPath, glStack:GLStack):Void {
		prepareBucket(path, glStack);
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
		var graphics = object.__graphics;
		var spritebatch = renderSession.spriteBatch;
		var dirty = graphics.__dirty;
		if (graphics.__commands.length <= 0) {
			return;
		}
		
		if (dirty) {
			updateGraphics (object, renderSession.gl, object.cacheAsBitmap);
		}
		
		//TODO find a way to remove drawTiles calls
		if (object.cacheAsBitmap) {
			
			if (dirty) {
				
				var gl = renderSession.gl;
				var bounds = graphics.__bounds;
				var texture = graphics.__cachedTexture;
				
				var w = Math.floor(bounds.width + 0.5);
				var h = Math.floor(bounds.height+ 0.5);

				if (texture == null) {
					texture = new FilterTexture(gl, w, h, false);
					graphics.__cachedTexture = texture;
				}
				
				texture.resize(w, h);
				gl.bindFramebuffer(gl.FRAMEBUFFER, texture.frameBuffer);
				gl.viewport (0, 0, w, h);
				texture.clear();
				renderGraphics(object, renderSession, new Point(w / 2, -h / 2), true);
				gl.bindFramebuffer(gl.FRAMEBUFFER, null);
				
				gl.viewport(0, 0, renderSession.renderer.width, renderSession.renderer.height);
			}
			
			if (!spritebatch.drawing) {
				spritebatch.begin(renderSession);
			}
			
			spritebatch.renderCachedGraphics(object);
			
		} else {
			renderGraphics(object, renderSession, renderSession.projection, false);
		}

	}
	
	public static function renderGraphics (object:DisplayObject, renderSession:RenderSession, projection:Point, ?localCoords:Bool = false):Void {
		var graphics = object.__graphics;
		var gl = renderSession.gl;
		var offset = renderSession.offset;
		
		var glStack = graphics.__glStack[GLRenderer.glContextId];
		var bucket:GLBucket;
		
		var translationMatrix:Matrix;
		if (localCoords) {
			translationMatrix = Matrix.__identity;
		} else {
			translationMatrix = object.__worldTransform;
		}
		
		var batchDrawing = renderSession.spriteBatch.drawing;
		
		for (i in 0...glStack.buckets.length) {
			batchDrawing = renderSession.spriteBatch.drawing;
			bucket = glStack.buckets[i];
			switch(bucket.mode) {
				case Fill, PatternFill:
					if (batchDrawing && !localCoords) {
						renderSession.spriteBatch.end();
					}
					renderSession.stencilManager.pushBucket(bucket, renderSession, projection, translationMatrix.toArray(true));
					var shader = prepareShader(bucket, renderSession, object, projection, translationMatrix.toArray(false));
					renderFill(bucket, shader, renderSession);
					renderSession.stencilManager.popBucket(object, bucket, renderSession);
				case DrawTriangles:
					if (batchDrawing && !localCoords) {
						renderSession.spriteBatch.end();
					}
					var shader = prepareShader(bucket, renderSession, object, projection, null);
					renderDrawTriangles(bucket, cast shader, renderSession);
				case DrawTiles:
					if (!batchDrawing) {
						renderSession.spriteBatch.begin(renderSession);
					}
					renderDrawTiles(object, bucket, renderSession);
				case _:
			}
			
			for (data in bucket.data) {
				if (data.line != null && data.line.verts.length > 0) {
					batchDrawing = renderSession.spriteBatch.drawing;
					if (batchDrawing && !localCoords) {
						renderSession.spriteBatch.end();
					}
					var shader = renderSession.shaderManager.primitiveShader;
				
					renderSession.shaderManager.setShader (shader);
					
					gl.uniformMatrix3fv (shader.translationMatrix, false, translationMatrix.toArray(true));
					gl.uniform2f (shader.projectionVector, projection.x, -projection.y);
					gl.uniform2f (shader.offsetVector, -offset.x, -offset.y);
					gl.uniform1f (shader.alpha, object.__worldAlpha);
					
					gl.bindBuffer (gl.ARRAY_BUFFER, data.line.vertsBuffer);

					gl.vertexAttribPointer (shader.aVertexPosition, 2, gl.FLOAT, false, 4 * 6, 0);
					gl.vertexAttribPointer (shader.colorAttribute, 4, gl.FLOAT, false, 4 * 6, 2 * 4);
					
					gl.bindBuffer (gl.ELEMENT_ARRAY_BUFFER, data.line.indexBuffer);
					gl.drawElements (gl.TRIANGLE_STRIP, data.line.indices.length, gl.UNSIGNED_SHORT, 0);
				}
			}
			
			batchDrawing = renderSession.spriteBatch.drawing;
			if (!batchDrawing && !localCoords) {
				renderSession.spriteBatch.begin(renderSession);
			}
		}
	}

	public static function updateGraphics (object:DisplayObject, gl:GLRenderContext, ?localCoords:Bool = false):Void {
		
		var graphics = object.__graphics;
		objectPosition.setTo(object.x, object.y);
		if (graphics.__bounds != null) objectBounds.copyFrom(graphics.__bounds);
		var glStack:GLStack = null;
		
		if (graphics.__dirty) {
			
			glStack = DrawPath.getStack(graphics, gl);
			
		}
		
		graphics.__dirty = false;
		
		for (data in glStack.buckets) {
			data.reset();
			bucketPool.push(data);
		}
		
		glStack.reset();
		
		for (i in glStack.lastIndex...graphics.__drawPaths.length) {
			var path = graphics.__drawPaths[i];
			
			switch(path.type) {
				case Polygon:
					buildComplexPoly (path, glStack, localCoords);
				case Rectangle(rounded):
					if (rounded) {
						buildRoundedRectangle (path, glStack, localCoords);
					} else {
						buildRectangle (path, glStack, localCoords);
					}
				case Circle, Ellipse:
					buildCircle (path, glStack, localCoords);
				case DrawTriangles(_):
					buildDrawTriangles(path, object, glStack, localCoords);
				case DrawTiles(_):
					buildDrawTiles(path, glStack);
				case _:
			}
			
			glStack.lastIndex++;
		}
		
		glStack.upload();
		
	}
	
	private static function prepareBucket(path:DrawPath, glStack:GLStack):GLBucketData {
		var bucket:GLBucket = null;
		
		switch(path.fill) {
			case Color(c, a):
				bucket = switchBucket(path.fillIndex, glStack, Fill);
				bucket.color = hex2rgb(c);
				bucket.alpha = a;
				bucket.uploadTileBuffer = true;
				
			case Texture(b, m, r, s):
				bucket = switchBucket(path.fillIndex, glStack, PatternFill);
				bucket.bitmap = b;
				bucket.textureRepeat = r;
				bucket.textureSmooth = s;
				bucket.texture = b.getTexture(glStack.gl);
				bucket.uploadTileBuffer = true;
				
				//prepare the matrix
				var tMatrix = bucket.textureMatrix;
				tMatrix.identity();
				var pMatrix:Matrix;
				if (m == null) {
					pMatrix = new Matrix();
				} else {
					pMatrix = m.clone();
				}

				pMatrix = pMatrix.invert();
				pMatrix.__translateTransformed(new Point( -objectPosition.x, -objectPosition.y));
				var tx = (pMatrix.tx) / (b.width);
				var ty = (pMatrix.ty) / (b.height);
				tMatrix.concat(pMatrix);
				bucket.textureTL.x = tx;
				bucket.textureTL.y = ty;
				bucket.textureBR.x = tx + 1;
				bucket.textureBR.y = ty + 1;
				
				tMatrix.scale(1 / b.width, 1 / b.height);
				
				bucket.textureMatrix = tMatrix;
			case _:
				bucket = switchBucket(path.fillIndex, glStack, Line);
				bucket.uploadTileBuffer = false;
		}
		
		switch(path.type) {
			case DrawTriangles(_):
				bucket.mode = DrawTriangles;
				bucket.uploadTileBuffer = false;
			case DrawTiles(_):
				bucket.mode = DrawTiles;
				bucket.uploadTileBuffer = false;
			case _:
		}
		
		bucket.graphicType = path.type;
		var bucketData = bucket.getData();
		
		return bucketData;
	}
	
	private static function getBucket(glStack:GLStack, mode:BucketMode):GLBucket {
		var b = bucketPool.pop();
		if (b == null) {
			b = new GLBucket(glStack.gl);
		}
		b.mode = mode;
		glStack.buckets.push(b);
		return b;
	}
	
	private static function switchBucket (fillIndex:Int, glStack:GLStack, mode:BucketMode):GLBucket {
		var bucket:GLBucket;
		
		if (glStack.buckets.length == 0) {
			bucket = getBucket(glStack, mode);
		} else {
			bucket = glStack.buckets[glStack.buckets.length - 1];
			if (bucket.fillIndex != fillIndex) {
				bucket = getBucket(glStack, mode);
			}
		}
		
		bucket.dirty = true;
		bucket.fillIndex = fillIndex;
		
		return bucket;
	}
	
	private static function prepareShader(bucket:GLBucket, renderSession:RenderSession, object:DisplayObject, projection:Point, translationMatrix:Float32Array) {
		var gl = renderSession.gl;
		var offset = renderSession.offset;
		var shader:Dynamic =  null;
		
		shader = switch(bucket.mode) {
			case Fill:
				renderSession.shaderManager.fillShader;
			case PatternFill:
				renderSession.shaderManager.patternFillShader;
			case DrawTriangles:
				renderSession.shaderManager.drawTrianglesShader;
			case _:
				null;
		}
		
		if (shader == null) return null;
		
		var newShader = renderSession.shaderManager.setShader(shader);
		
		//if (!newShader && lastBucketMode == bucket.mode) {
			//return shader;
		//}
		//
		//lastBucketMode = bucket.mode;
		
		// common uniforms
		gl.uniform2f (shader.projectionVector, projection.x, -projection.y);
		gl.uniform2f (shader.offsetVector, -offset.x, -offset.y);
		gl.uniform1f (shader.alpha, object.__worldAlpha * bucket.alpha);
		
		// specific uniforms
		switch(bucket.mode) {
			case Fill:
				gl.uniformMatrix3fv (shader.translationMatrix, false, translationMatrix);
				gl.uniform3fv (shader.color, new Float32Array (bucket.color));
			case PatternFill:
				gl.uniformMatrix3fv (shader.translationMatrix, false, translationMatrix);		
				gl.uniform1i(shader.sampler, 0);
				gl.uniform2f(shader.patternTL, bucket.textureTL.x, bucket.textureTL.y);
				gl.uniform2f(shader.patternBR, bucket.textureBR.x, bucket.textureBR.y);
				gl.uniformMatrix3fv(shader.patternMatrix, false, bucket.textureMatrix.toArray(false));
			case DrawTriangles:
				if (bucket.texture != null) {
					gl.uniform1i(shader.useTexture, 1);
					gl.uniform1i(shader.sampler, 0);
				} else {
					gl.uniform1i(shader.useTexture, 0);
					gl.uniform3fv(shader.color, new Float32Array (bucket.color));
				}
			case _:
		}
		
		return shader;
	}
	
	private static function renderFill(bucket:GLBucket, shader:Dynamic, renderSession:RenderSession) {
		var gl = renderSession.gl;
		
		if (bucket.mode == PatternFill && bucket.texture != null) {
			bindTexture(gl, bucket);
		}
		
		gl.bindBuffer(gl.ARRAY_BUFFER, bucket.tileBuffer);
		gl.vertexAttribPointer (shader.aVertexPosition, 4, gl.SHORT, false, 0, 0);
		gl.drawArrays(gl.TRIANGLE_STRIP, 0, 4);
	}
	
	private static function renderDrawTriangles(bucket:GLBucket, shader:DrawTrianglesShader, renderSession:RenderSession) {
		var gl = renderSession.gl;
		
		for (data in bucket.data) {
			if (data.destroyed) continue;
			
			if (bucket.texture == null) {
				// TODO draw it with color
			} else {
				bindTexture(gl, bucket);
			}
			
			bindDrawTrianglesBuffer(gl, shader, data);
			gl.drawArrays(gl.TRIANGLES, data.glStart, data.glLength);
		}
	}
	
	private static inline function renderDrawTiles(object:DisplayObject, bucket:GLBucket, renderSession:RenderSession) {
		var args = Type.enumParameters(bucket.graphicType);		
		renderSession.spriteBatch.renderTiles(object, cast args[0], cast args[1], cast args[2], cast args[3], cast args[4]);
	}
	
	private static function bindDrawTrianglesBuffer(gl:GLRenderContext, shader:DrawTrianglesShader, data:GLBucketData) {
		//if (lastVertsBuffer == data.vertsBuffer) {
			//return;
		//}
		//lastVertsBuffer = data.vertsBuffer;
		
		gl.bindBuffer (gl.ARRAY_BUFFER, data.vertsBuffer);
		var stride =  data.stride * 4;
		gl.vertexAttribPointer (shader.aVertexPosition, 2, gl.FLOAT, false, stride, 0);
		gl.vertexAttribPointer (shader.aTextureCoord, 2, gl.FLOAT, false, stride, 2 * 4);
		gl.vertexAttribPointer (shader.colorAttribute, 4, gl.FLOAT, false, stride, 4 * 4);
	}
	
	private static function bindTexture(gl:GLRenderContext, bucket:GLBucket) {
		//if (bucket.texture == lastTexture && bucket.textureRepeat == lastTextureRepeat && bucket.textureSmooth == lastTextureSmooth) {
			//return;
		//}
		//lastTexture = bucket.texture;
		//lastTextureRepeat = bucket.textureRepeat;
		//lastTextureSmooth = bucket.textureSmooth;
		
		gl.bindTexture(gl.TEXTURE_2D, bucket.texture);
		
		// TODO Fix this: webgl can only repeat textures that are power of two
		if (bucket.textureRepeat #if js && bucket.bitmap.__image.powerOfTwo #end) {
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.REPEAT);
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.REPEAT);
		} else {
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
		}
		
		if (bucket.textureSmooth) {
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
		} else {
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.NEAREST);
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.NEAREST);						
		}
	}

	private static inline function isCCW(x1:Float, y1:Float, x2:Float, y2:Float, x3:Float, y3:Float) {
		return ((x2 - x1) * (y3 - y1) - (y2 - y1) * (x3 - x1)) < 0;
	}
	
	public static inline function hex2rgb (hex:Null<Int>):Array<Float> {
		return hex == #if java 0 #else null #end ? [0,0,0] : [(hex >> 16 & 0xFF) / 255, ( hex >> 8 & 0xFF) / 255, (hex & 0xFF) / 255];
	}
	
	public static inline function hex2rgba (hex:Null<Int>):Array<Float> {
		return hex == #if java 0 #else null #end ? [1,1,1,1] : [(hex >> 16 & 0xFF) / 255, ( hex >> 8 & 0xFF) / 255, (hex & 0xFF) / 255, (hex >> 24 & 0xFF) / 255];
	}

}

class GLStack {

	public var lastIndex:Int = 0;
	public var buckets:Array<GLBucket>;
	public var gl:GLRenderContext;

	public function new (gl:GLRenderContext) {
		this.gl = gl;
		buckets = [];
		lastIndex = 0;
	}
	
	public function reset() {
		buckets = [];
		lastIndex = 0;
	}
	
	public function upload() {
		for (bucket in buckets) {
			
			if (bucket.dirty) bucket.upload ();
			
		}
	}

}

class GLBucket {
	public var gl:GLRenderContext;
	public var color:Array<Float>;
	public var alpha:Float;	
	public var dirty:Bool;
	public var graphicType:GraphicType;
	
	public var lastIndex:Int;
	
	public var fillIndex:Int = 0;
	
	public var mode:BucketMode;
	
	public var data:Array<GLBucketData> = [];
	
	public var bitmap:BitmapData;
	public var texture:GLTexture;
	public var textureMatrix:Matrix;
	public var textureRepeat:Bool = false;
	public var textureSmooth:Bool = true;
	public var textureTL:Point;
	public var textureBR:Point;
	
	public var tileBuffer:GLBuffer;
	public var glTile:Int16Array;
	public var tile:Array<Int>;
	
	public var uploadTileBuffer = true;
	
	public function new (gl:GLRenderContext) {
		
		this.gl = gl;
		
		color = [0, 0, 0];
		lastIndex = 0;
		alpha = 1;
		dirty = true;
		
		mode = Fill;
		
		textureMatrix = new Matrix();
		textureTL = new Point();
		textureBR = new Point(1, 1);
	}
	
	public function getData():GLBucketData {
		var result:GLBucketData = null;
		var remove = false;
		for (d in data) {
			if (d.destroyed) {
				result = d;
				remove = true;
				break;
			}
		}
		
		if (result == null) {
			result = new GLBucketData(gl);
		}
		
		result.destroyed = false;
		result.parent = this;
		
		if(remove) data.remove(result);
		data.push(result);
		
		return result;
	}
	
	public function reset ():Void {
		for (d in data) {
			d.destroy();
		}
		fillIndex = 0;
		uploadTileBuffer = true;
		graphicType = GraphicType.Polygon;
	}
	
	public function upload ():Void {
		
		if (uploadTileBuffer) {
			if(tileBuffer == null) {
				tileBuffer = gl.createBuffer();
				tile = [
					0, 0, 		0, 0,
					4096, 0, 	1, 0,
					0, 4096, 	0, 1,
					4096, 4096, 1, 1
				];
				glTile = new Int16Array (tile);
			}
			gl.bindBuffer (gl.ARRAY_BUFFER, tileBuffer);
			gl.bufferData (gl.ARRAY_BUFFER, glTile, gl.STATIC_DRAW);
			uploadTileBuffer = false;
		}

		for (d in data) {
			if (!d.destroyed) {
				d.upload();
			}
		}
		
		dirty = false;
		
	}
}

class GLBucketData {
	public var gl:GLRenderContext;
	public var drawMode:Int;
	public var glLength:Int = 0;
	public var glStart:Int = 0;
	
	public var vertsBuffer:GLBuffer;
	public var lastVertsSize:Int = 0;
	public var glVerts:Float32Array;
	public var verts:Array<Float>;
	public var rawVerts:Bool = false;
	public var stride:Int = 0;
	
	public var indexBuffer:GLBuffer;
	public var glIndices:UInt16Array;
	public var indices:Array<Int>;
	public var rawIndices:Bool = false;
	
	public var line:GLBucketData;
	public var destroyed:Bool = false;
	
	public var parent:GLBucket;
	
	public function new (gl:GLRenderContext, ?initLine = true) {
		this.gl = gl;
		drawMode = gl.TRIANGLE_STRIP;
		verts = [];
		vertsBuffer = gl.createBuffer ();
		indices = [];
		indexBuffer = gl.createBuffer ();
		
		if(initLine) {
			line = new GLBucketData(gl, false);
		}
	}
	
	public function destroy():Void {
		destroyed = true;
		verts = [];
		indices = [];
		glLength = 0;
		glStart = 0;
		stride = 0;
		rawVerts = false;
		rawIndices = false;
		if (line != null) line.destroy();
	}
	
	public function upload():Void {
		
		// only upload a verts buffer if verts has anything inside
		if ((rawVerts && glVerts != null && glVerts.length > 0) || verts.length > 0) {
			if (!rawVerts) glVerts = new Float32Array (verts);
			gl.bindBuffer (gl.ARRAY_BUFFER, vertsBuffer);
			if (glVerts.length <= lastVertsSize) {
				var end = glLength * 4 * stride;
				if (glLength > 0 && lastVertsSize > end) {
					var view = glVerts.subarray(0, end);
					gl.bufferSubData(gl.ARRAY_BUFFER, 0, view);
					view = null;
				} else {
					gl.bufferSubData(gl.ARRAY_BUFFER, 0, glVerts);
				}
			} else {
				gl.bufferData (gl.ARRAY_BUFFER, glVerts, gl.STREAM_DRAW);
				lastVertsSize = glVerts.length;
			}
			
		}
		
		// only upload a index buffer is there is no length provided and indices has anything inside
		if (glLength == 0 && ((rawIndices && glIndices != null && glIndices.length > 0) || indices.length > 0)) {
			if(!rawIndices) glIndices = new UInt16Array (indices);
			gl.bindBuffer (gl.ELEMENT_ARRAY_BUFFER, indexBuffer);
			gl.bufferData (gl.ELEMENT_ARRAY_BUFFER, glIndices, gl.STREAM_DRAW);
		}
		
		if (line != null) line.upload();
	}
}

enum BucketMode {
	None;
	Fill;
	PatternFill;
	Line;
	PatternLine;
	DrawTriangles;
	DrawTiles;
}


class GLGraphicsData {
	
	public var gl:GLRenderContext;
	
	public var tint:Array<Float> = [1.0, 1.0, 1.0];
	public var alpha:Float = 1.0;
	public var dirty:Bool = true;
	public var mode:RenderMode = RenderMode.DEFAULT;
	public var lastIndex:Int = 0;
	
	public var data:Array<Float> = [];
	public var glData:Float32Array;
	public var dataBuffer:GLBuffer;
	
	public var indices:Array<Int> = [];
	public var glIndices:UInt16Array;
	public var indexBuffer:GLBuffer;
	
	
	public function new (gl:GLRenderContext) {
		
		this.gl = gl;
		
		dataBuffer = gl.createBuffer();
		indexBuffer = gl.createBuffer();
		
	}
	
	
	public function reset ():Void {
		
		data = [];
		indices = [];
		lastIndex = 0;
		
	}
	
	
	public function upload ():Void {
		
		glData = new Float32Array (cast data);
		gl.bindBuffer (gl.ARRAY_BUFFER, dataBuffer);
		gl.bufferData (gl.ARRAY_BUFFER, glData, gl.STATIC_DRAW);
		
		
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


enum GraphicType {

	Polygon;
	Rectangle(rounded:Bool);
	Circle;
	Ellipse;
	DrawTriangles(vertices:Vector<Float>, indices:Vector<Int>, uvtData:Vector<Float>, culling:TriangleCulling, colors:Vector<Int>, blendMode:Int);
	DrawTiles (sheet:Tilesheet, tileData:Array<Float>, smooth:Bool, flags:Int, count:Int);

}

@:enum abstract RenderMode(Int) {
	var DEFAULT = 0;
	var STENCIL = 1;
}