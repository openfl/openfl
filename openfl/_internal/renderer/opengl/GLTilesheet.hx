package openfl._internal.renderer.opengl;


import haxe.EnumFlags;
import lime.graphics.opengl.GLBuffer;
import lime.graphics.GLRenderContext;
import lime.utils.Float32Array;
import lime.utils.UInt16Array;
import lime.utils.UInt32Array;
import openfl._internal.renderer.opengl.shaders2.*;
import openfl._internal.renderer.opengl.shaders2.DefaultShader.DefUniform;
import openfl._internal.renderer.opengl.utils.VertexAttribute;
import openfl._internal.renderer.opengl.utils.VertexAttribute.ElementType;
import openfl._internal.renderer.opengl.utils.VertexArray;
import openfl._internal.renderer.RenderSession;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.BlendMode;
import openfl.display.DisplayObject;
import openfl.display.Graphics;
import openfl.display.Tilesheet;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.gl.GLTexture;
import openfl.utils.Int16Array;
import openfl.Vector;
import openfl.display.Shader in FlashShader;

@:access(openfl.display.DisplayObject)
@:access(openfl.display.Graphics)
@:access(openfl.display.BitmapData)
@:access(openfl.geom.Matrix)


class GLTilesheet {
	
	
	public static var bucketPool:Array<GLBucket> = [];
	
	private static var objectPosition:Point = new Point();
	private static var objectBounds:Rectangle = new Rectangle();
	private static var overrideMatrix:Matrix;
	
	
	public static inline function buildDrawTiles (path:DrawPath, glStack:GLStack):Void {
		prepareBucket(path, glStack);
	}
	
	
	public static function render (object:DisplayObject, renderSession:RenderSession):Void {
		
		var graphics = object.__graphics;
		var bounds = graphics.__bounds;
		var spritebatch = renderSession.spriteBatch;
		var dirty = graphics.__dirty;
		
		if (!graphics.__visible || graphics.__commands.length == 0 || bounds == null || bounds.width == 0 || bounds.height == 0) {
			
			graphics.__glStack.splice (0, graphics.__glStack.length);
			return;
			
		}
		
		if (dirty) {
			updateGraphics (object, object.__graphics, renderSession.gl, object.cacheAsBitmap);
		}
		
		renderGraphics(object, renderSession, false);

	}
	
	public static function renderGraphics (object:DisplayObject, renderSession:RenderSession, ?localCoords:Bool = false):Void {
		var graphics = object.__graphics;
		var gl = renderSession.gl;
		
		var glStack = graphics.__glStack[GLRenderer.glContextId];
		if (glStack == null) return;
		var bucket:GLBucket;
		
		var translationMatrix:Matrix;
		if (localCoords) {
			translationMatrix = Matrix.__identity;
		} else {
			translationMatrix = object.__worldTransform;
		}
		
		var clipRect = @:privateAccess renderSession.spriteBatch.clipRect;
		var batchDrawing = renderSession.spriteBatch.drawing;
		
		batchDrawing = renderSession.spriteBatch.drawing;
		
		for (i in 0...glStack.buckets.length) {
			batchDrawing = renderSession.spriteBatch.drawing;
			
			if (batchDrawing && !localCoords) {
				renderSession.spriteBatch.finish();
			}
			
			renderSession.blendModeManager.setBlendMode(object.__blendMode);
			
			if (clipRect != null) {
				gl.enable(gl.SCISSOR_TEST);
				gl.scissor(Math.floor(clipRect.x), 
							Math.floor(clipRect.y),
							Math.floor(clipRect.width),
							Math.floor(clipRect.height)
						);
			}
			
			bucket = glStack.buckets[i];
			
			switch(bucket.mode) {
				case DrawTiles:
					if (!batchDrawing) {
						renderSession.spriteBatch.begin(renderSession, clipRect);
					}
					var args = Type.enumParameters(bucket.graphicType);		
					renderSession.spriteBatch.renderTiles(object, cast args[0], cast args[1], cast args[2], cast args[3], cast args[4], cast args[5]);
					
					renderSession.spriteBatch.finish();
				case _:
			}
			
			var ct:ColorTransform = object.__worldColorTransform;
			
			if (clipRect != null) {
				gl.disable(gl.SCISSOR_TEST);
			}
			
			batchDrawing = renderSession.spriteBatch.drawing;
			if (!batchDrawing && !localCoords) {
				renderSession.spriteBatch.begin(renderSession, clipRect);
			}
		}
	}

	public static function updateGraphics (object:DisplayObject, graphics:Graphics, gl:GLRenderContext, ?localCoords:Bool = false):Void {
		
		objectPosition.setTo(object.x, object.y);
		
		if (graphics.__bounds == null) {
			objectBounds = new Rectangle();
		} else {
			objectBounds.copyFrom(graphics.__bounds);
		}
		
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
				case DrawTiles(_):
					buildDrawTiles(path, glStack);
				case OverrideMatrix(m):
					overrideMatrix = m;
				case _:
			}
			
			glStack.lastIndex++;
		}
		
		for (bucket in glStack.buckets) {
			
			if (bucket.uploadTileBuffer) {
				
				bucket.uploadTile(
					Math.ceil(objectBounds.left), 
					Math.ceil(objectBounds.top),
					Math.floor(objectBounds.right), 
					Math.floor(objectBounds.bottom));
					
			}
			
			
			bucket.optimize();
		}
		
		glStack.upload();
		
	}
	
	private static function prepareBucket(path:DrawPath, glStack:GLStack):GLBucket {
		var bucket:GLBucket = null;
		
		bucket = switchBucket(path.fillIndex, glStack, None);
		bucket.uploadTileBuffer = false;
		
		switch(path.type) {
			case DrawTiles(_):
				bucket.mode = DrawTiles;
				bucket.uploadTileBuffer = false;
			case _:
		}
		
		bucket.graphicType = path.type;
		bucket.overrideMatrix = overrideMatrix;
		
		return bucket;
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
		
		var bucket:GLBucket = null;
		
		for (b in glStack.buckets) {
			if (b.fillIndex == fillIndex) {
				bucket = b;
				break;
			}
		}
		
		if (bucket == null) {
			bucket = getBucket(glStack, mode);
		}
		
		bucket.dirty = true;
		bucket.fillIndex = fillIndex;
		
		return bucket;
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
			
			if (bucket.dirty) {
				bucket.upload ();
			}
			
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
	
	public var fillIndex:Int = -1;
	
	public var mode:BucketMode;
	
	public var fills:Array<GLBucketData> = [];
	
	public var bitmap:BitmapData;
	public var texture:GLTexture;
	public var textureMatrix:Matrix;
	public var textureRepeat:Bool = false;
	public var textureSmooth:Bool = true;
	public var textureTL:Point;
	public var textureBR:Point;
	
	public var overrideMatrix:Matrix;
	
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
		
		mode = None;
		
		textureMatrix = new Matrix();
		textureTL = new Point();
		textureBR = new Point(1, 1);
	}
	
	public function getData(type:BucketDataType):GLBucketData {
		var data:Array<GLBucketData>;
		data = fills;
		var result:GLBucketData = null;
		var remove = false;
		for (d in data) {
			if (d.available) {
				result = d;
				remove = true;
				break;
			}
		}
		
		if (result == null) {
			result = new GLBucketData(gl);
		}
		
		result.available = false;
		result.parent = this;
		result.type = type;
		
		if(remove) data.remove(result);
		data.push(result);
		

		
		return result;
	}
	
	public function optimize() {
		
		inline function opt(data:Array<GLBucketData>, type:BucketDataType) {
			if (data.length > 1) {
				var result:Array<GLBucketData> = [];
				var tmp:GLBucketData = null;
				var last:GLBucketData = null;
				var idx:Int = 0;
				var vi:Int = 0;
				var ii:Int = 0;
				var before = data.length;
				for (d in data) {
					if (d.available || d.rawVerts || d.rawIndices) {
						if (tmp != null) {
							result.push(tmp);
							tmp = null;
						}
						result.push(d);
						last = d;
						//trace("destroyed or raw data");
						continue;
					}
					//trace("last null? "+(last == null)+" or same drawmode? "+ (last != null && last.drawMode == d.drawMode) + " " + d.drawMode);
					if (last == null || (last.drawMode == d.drawMode)) {
						if (tmp == null) {
							tmp = d;
						} else {
							vi = tmp.verts.length;
							ii = tmp.indices.length;
							for (j in 0...d.verts.length) {
								tmp.verts[j + vi] = d.verts[j];
							}
							for (j in 0...d.indices.length) {
								tmp.indices[j + ii] = d.indices[j] + idx;
							}
						}
						idx = tmp.indices[tmp.indices.length - 1] + 1;
						last = d;
					} else {
						if (tmp != null) {
							result.push(tmp);
							tmp = null;
						}
						result.push(d);
						last = d;
						continue;
					}
					
				}
				
				if (result.length == 0 && tmp != null) {
					result.push(tmp);
				}
				
				if(result.length > 0) {
					this.fills = result;
				}
			}
		}
		
	}
	
	
	public function reset ():Void {
		for (fill in fills) {
			fill.reset();
		}
		
		fillIndex = -1;
		uploadTileBuffer = true;
		graphicType = GraphicType.Polygon;
	}
	
	public function uploadTile (x:Int, y:Int, w:Int, h:Int):Void {
		
		if(tileBuffer == null) {
			tileBuffer = gl.createBuffer();
		}
		
		
		tile = [
			x, y,	0, 0,
			w, y, 	1, 0,
			x, h, 	0, 1,
			w, h,	1, 1
		];
		
		glTile = new Int16Array (tile);
		
		gl.bindBuffer (gl.ARRAY_BUFFER, tileBuffer);
		gl.bufferData (gl.ARRAY_BUFFER, glTile, gl.STATIC_DRAW);
		
	}
	
	public function upload ():Void {

		for (fill in fills) {
			if (!fill.available) {
				fill.upload();
			}
		}
		
		dirty = false;
		
	}
}

class GLBucketData {
	public var type:BucketDataType;
	
	public var gl:GLRenderContext;
	public var drawMode:Int;
	public var glLength:Int = 0;
	public var glStart:Int = 0;
	
	public var vertexArray:VertexArray;
	public var glVerts:Float32Array;
	public var lastVertsSize:Int = 0;
	public var verts:Array<Float>;
	public var rawVerts:Bool = false;
	public var stride:Int = 0;
	
	public var indexBuffer:GLBuffer;
	public var glIndices:UInt16Array;
	public var indices:Array<Int>;
	public var rawIndices:Bool = false;
	
	public var available:Bool = false;
	
	public var parent:GLBucket;
	
	public function new (gl:GLRenderContext) {
		this.gl = gl;
		drawMode = gl.TRIANGLE_STRIP;
		verts = [];
		indices = [];
		vertexArray = new VertexArray([]);
	}
	
	public function reset():Void {
		available = true;
		verts = [];
		indices = [];
		glLength = 0;
		glStart = 0;
		stride = 0;
		rawVerts = false;
		rawIndices = false;
		drawMode = gl.TRIANGLE_STRIP;
	}
	
	public function upload():Void {
		
		// only upload a verts buffer if verts has anything inside
		if ((rawVerts && glVerts != null && glVerts.length > 0) || verts.length > 0) {
			
			if (!rawVerts) glVerts = new Float32Array (verts);
			
			vertexArray.buffer = glVerts.buffer;
			
			if (glVerts.length <= lastVertsSize) {
				vertexArray.bind();
				var end = glLength * stride;
				if (glLength > 0 && lastVertsSize > end) {
					var view = glVerts.subarray(0, end);
					vertexArray.upload(view);
				} else {
					vertexArray.upload(glVerts);
				}
			} else {
				vertexArray.setContext(gl, glVerts);
				lastVertsSize = glVerts.length;
			}
			
		}
		
		// only upload a index buffer is there is no length provided and indices has anything inside
		if (glLength == 0 && ((rawIndices && glIndices != null && glIndices.length > 0) || indices.length > 0)) {
			
			if (indexBuffer == null) {
				indexBuffer = gl.createBuffer ();
			}
			
			if (!rawIndices) glIndices = new UInt16Array (indices);
			gl.bindBuffer (gl.ELEMENT_ARRAY_BUFFER, indexBuffer);
			gl.bufferData (gl.ELEMENT_ARRAY_BUFFER, glIndices, gl.STREAM_DRAW);
		}
	}
}

enum BucketMode {
	None;
	DrawTiles;
}

enum BucketDataType {
	Fill;
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


enum GraphicType {

	Polygon;
	Rectangle(rounded:Bool);
	Circle;
	Ellipse;
	DrawTiles (sheet:Tilesheet, tileData:Array<Float>, smooth:Bool, flags:Int, shader:FlashShader, count:Int);
	OverrideMatrix (matrix:Matrix);

}

@:enum abstract RenderMode(Int) {
	var DEFAULT = 0;
	var STENCIL = 1;
}


class DrawPath {


	public var fill:FillType;
	public var fillIndex:Int = 0;
	public var isRemovable:Bool = true;

	public var points:Array<Float> = null;

	public var type:GraphicType = Polygon;

	public function new(makeArray:Bool=true) {
		fill = None;
		if (makeArray)
		{
			points = [];
		}
	}

	public function update(fill:FillType, fillIndex:Int):Void {
		this.fill = fill;
		this.fillIndex = fillIndex;
	}

	public static function getStack(graphics:Graphics, gl:GLRenderContext):GLStack {
		return PathBuilder.build(graphics, gl);
	}

}

@:access(openfl._internal.renderer.opengl.utils.GraphicsRenderer)
@:access(openfl.display.Graphics)
class PathBuilder {

	private static var __currentPath:DrawPath;
	private static var __drawPaths:Array<DrawPath>;
	private static var __fill:FillType;
	private static var __fillIndex:Int = 0;

	private static function closePath():Void {
		var l = __currentPath.points == null ? 0 : __currentPath.points.length;
		if (l <= 0) return;
		// the paths are only closed when the type is a polygon and there is a fill
		if (__currentPath.type == Polygon && __currentPath.fill != None) {
			var sx = __currentPath.points[0];
			var sy = __currentPath.points[1];
			var ex = __currentPath.points[l - 2];
			var ey = __currentPath.points[l - 1];
		}
	}

	private static function endFill ():Void {
		
		__fill = None;
		__fillIndex++;
		
	}

	private static inline function moveTo (x:Float, y:Float) {
		
		graphicDataPop ();
		__currentPath = new DrawPath ();
		__currentPath.update(__fill, __fillIndex);
		__currentPath.type = Polygon;
		__currentPath.points.push (x);
		__currentPath.points.push (y);
		
		__drawPaths.push (__currentPath);
		
	}

	private inline static function graphicDataPop ():Void {
		
		if (__currentPath.isRemovable && ( __currentPath.points == null || __currentPath.points.length == 0)) {
			__drawPaths.pop ();
		} else {
			closePath();
		}
		
	}

	public static function build(graphics:Graphics, gl:GLRenderContext):GLStack {
		
		var glStack:GLStack = null;
		var bounds = graphics.__bounds;
		
		__drawPaths = new Array<DrawPath> ();
		__currentPath = new DrawPath ();
		__fill = None;
		__fillIndex = 0;
		
		glStack = graphics.__glStack[GLRenderer.glContextId];
			
		if (glStack == null) {
			
			glStack = graphics.__glStack[GLRenderer.glContextId] = new GLStack (gl);
			
		}
		
		if (!graphics.__visible || graphics.__commands.length == 0 || bounds == null || bounds.width == 0 || bounds.height == 0) {
			
			//glStack = graphics.__glStack[GLRenderer.glContextId] = new GLStack (gl);
			
		} else {
			
			var data = new DrawCommandReader (graphics.__commands);
			
			for (type in graphics.__commands.types) {
				
				switch (type) {
					
					case BEGIN_BITMAP_FILL:
						
						var c = data.readBeginBitmapFill ();
						endFill ();
						__fill = c.bitmap != null ? Texture (c.bitmap, c.matrix, c.repeat, c.smooth) : None;
						
						if (__currentPath.points == null || __currentPath.points.length == 0) {
							
							graphicDataPop ();
							__currentPath = new DrawPath ();
							__currentPath.update (__fill, __fillIndex);
							__currentPath.points = [];
							__currentPath.type = Polygon;
							__drawPaths.push (__currentPath);
							
						}
					
					case BEGIN_FILL:
						
						var c = data.readBeginFill ();
						endFill ();
						__fill = c.alpha > 0 ? Color (c.color & 0xFFFFFF, c.alpha) : None;
						
						if (__currentPath.points == null || __currentPath.points.length == 0) {
							
							graphicDataPop ();
							__currentPath = new DrawPath ();
							__currentPath.update (__fill, __fillIndex);
							__currentPath.points = [];
							__currentPath.type = Polygon;
							__drawPaths.push (__currentPath);
							
						}
					
					case END_FILL:
						
						var c = data.readEndFill ();
						endFill ();
					
					case MOVE_TO:
						
						var c = data.readMoveTo ();
						moveTo(c.x, c.y);
					
					case DRAW_TILES:
						
						var c = data.readDrawTiles ();
						graphicDataPop ();
						
						__fillIndex++;
						__currentPath = new DrawPath (false);
						__currentPath.update (__fill, __fillIndex);
						__currentPath.type = GraphicType.DrawTiles (c.sheet, c.tileData, c.smooth, c.flags, c.shader, c.count);
						__currentPath.isRemovable = false;
						__drawPaths.push (__currentPath);
					
					case OVERRIDE_MATRIX:
						
						var c = data.readOverrideMatrix ();
						graphicDataPop ();
						
						__currentPath = new DrawPath ();
						__currentPath.update (__fill, __fillIndex);
						__currentPath.type = GraphicType.OverrideMatrix(c.matrix);
						__currentPath.isRemovable = false;
						__drawPaths.push (__currentPath);
					
					default:
						
						data.skip (type);
					
				}
				
			}
			
			closePath ();
			data.destroy ();
			
		}
		
		graphics.__drawPaths = __drawPaths;
		
		return glStack;
		
	}
	
	
}

enum FillType {
	None;
	Color(color:Int, alpha:Float);
	Texture(bitmap:BitmapData, matrix:Matrix, repeat:Bool, smooth:Bool);
	Gradient;
}

