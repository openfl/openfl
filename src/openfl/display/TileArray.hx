package openfl.display;


import lime.graphics.opengl.GLBuffer;
import lime.utils.Float32Array;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import openfl.Vector;

#if (lime >= "7.0.0")
import lime.graphics.OpenGLRenderContext;
import lime.graphics.WebGLRenderContext;
#else
import lime.graphics.opengl.WebGLContext;
import lime.graphics.GLRenderContext;
#end

@:access(openfl.display.Tileset)
@:access(openfl.geom.ColorTransform)
@:access(openfl.geom.Matrix)
@:access(openfl.geom.Rectangle)


#if ((openfl < "9.0.0") && enable_tile_array)
@:deprecated class TileArray implements ITile {
	
	
	@:noCompletion private static inline var ID_INDEX = 0;
	@:noCompletion private static inline var RECT_INDEX = 1;
	@:noCompletion private static inline var MATRIX_INDEX = 5;
	@:noCompletion private static inline var ALPHA_INDEX = 11;
	@:noCompletion private static inline var COLOR_TRANSFORM_INDEX = 12;
	@:noCompletion private static inline var DATA_LENGTH = 21;
	
	@:noCompletion private static inline var SOURCE_DIRTY_INDEX = 0;
	@:noCompletion private static inline var MATRIX_DIRTY_INDEX = 1;
	@:noCompletion private static inline var ALPHA_DIRTY_INDEX = 2;
	@:noCompletion private static inline var COLOR_TRANSFORM_DIRTY_INDEX = 3;
	@:noCompletion private static inline var ALL_DIRTY_INDEX = 4;
	@:noCompletion private static inline var DIRTY_LENGTH = 5;
	
	public var alpha (get, set):Float;
	public var colorTransform (get, set):ColorTransform;
	public var id (get, set):Int;
	public var length (get, set):Int;
	public var matrix (get, set):Matrix;
	public var position:Int;
	public var rect (get, set):Rectangle;
	public var shader (get, set):Shader;
	public var tileset (get, set):Tileset;
	public var visible (get, set):Bool;
	
	@:noCompletion private var __buffer:GLBuffer;
	@:noCompletion private var __bufferContext:GLRenderContext;
	@:noCompletion private var __bufferDirty:Bool;
	@:noCompletion private var __bufferData:Float32Array;
	@:noCompletion private var __bufferLength:Int;
	@:noCompletion private var __bufferSkipped:Vector<Bool>;
	@:noCompletion private var __cacheAlpha:Float;
	@:noCompletion private var __cacheDefaultTileset:Tileset;
	@:noCompletion private var __colorTransform:ColorTransform;
	@:noCompletion private var __data:Vector<Float>;
	@:noCompletion private var __dirty:Vector<Bool>;
	@:noCompletion private var __length:Int;
	@:noCompletion private var __matrix:Matrix;
	@:noCompletion private var __rect:Rectangle;
	@:noCompletion private var __shaders:Vector<Shader>;
	@:noCompletion private var __tilesets:Vector<Tileset>;
	@:noCompletion private var __visible:Vector<Bool>;
	
	
	#if openfljs
	@:noCompletion private static function __init__ () {
		
		untyped Object.defineProperties (TileArray.prototype, {
			"alpha": { get: untyped __js__ ("function () { return this.get_alpha (); }"), set: untyped __js__ ("function (v) { return this.set_alpha (v); }") },
			"colorTransform": { get: untyped __js__ ("function () { return this.get_colorTransform (); }"), set: untyped __js__ ("function (v) { return this.set_colorTransform (v); }") },
			"id": { get: untyped __js__ ("function () { return this.get_id (); }"), set: untyped __js__ ("function (v) { return this.set_id (v); }") },
			"length": { get: untyped __js__ ("function () { return this.get_length (); }"), set: untyped __js__ ("function (v) { return this.set_length (v); }") },
			"matrix": { get: untyped __js__ ("function () { return this.get_matrix (); }"), set: untyped __js__ ("function (v) { return this.set_matrix (v); }") },
			"rect": { get: untyped __js__ ("function () { return this.get_rect (); }"), set: untyped __js__ ("function (v) { return this.set_rect (v); }") },
			"shader": { get: untyped __js__ ("function () { return this.get_shader (); }"), set: untyped __js__ ("function (v) { return this.set_shader (v); }") },
			"tileset": { get: untyped __js__ ("function () { return this.get_tileset (); }"), set: untyped __js__ ("function (v) { return this.set_tileset (v); }") },
			"visible": { get: untyped __js__ ("function () { return this.get_visible (); }"), set: untyped __js__ ("function (v) { return this.set_visible (v); }") },
		});
		
	}
	#end
	
	
	public function new (length:Int = 0) {
		
		__cacheAlpha = -1;
		__data = new Vector<Float> (length * DATA_LENGTH);
		__dirty = new Vector<Bool> (length * DIRTY_LENGTH);
		__shaders = new Vector<Shader> (length);
		__tilesets = new Vector<Tileset> (length);
		__visible = new Vector<Bool> (length);
		__length = length;
		
	}
	
	
	public function iterator ():TileArrayIterator {
		
		return @:privateAccess new TileArrayIterator (this);
		
	}
	
	
	@:noCompletion private inline function __init (position:Int):Void {
		
		this.position = position;
		
		alpha = 1;
		colorTransform = null;
		id = 0;
		matrix = null;
		tileset = null;
		visible = true;
		
		__dirty[ALL_DIRTY_INDEX + (position * DIRTY_LENGTH)] = true;
		
	}
	
	
	#if !flash
	@:noCompletion private function __updateGLBuffer (gl:GLRenderContext, defaultTileset:Tileset, worldAlpha:Float, defaultColorTransform:ColorTransform):GLBuffer {
		
		// TODO: More closely align internal data format with GL buffer format?
		
		var attributeLength = 13;
		var stride = attributeLength * 6;
		var bufferLength = __length * stride;
		
		if (__bufferData == null) {
			
			__bufferData = new Float32Array (bufferLength);
			__bufferSkipped = new Vector<Bool> (__length);
			__bufferDirty = true;
			
		} else if (__bufferData.length != bufferLength) {
			
			// TODO: Use newer Lime GL buffer API to pass length, do not need to recreate if size shrinks
			
			var data = new Float32Array (bufferLength);
			
			if (__bufferData.length <= data.length) {
				
				data.set (__bufferData);
				
				if (__bufferData.length == 0) {
					
					__bufferDirty = true;
					
				} else {
					
					var cacheLength = __bufferData.length;
					for (i in cacheLength...bufferLength) {
						__dirty[ALL_DIRTY_INDEX + (position * DIRTY_LENGTH)] = true;
					}
					
				}
				
			} else {
				
				data.set (__bufferData.subarray (0, data.length));
				
			}
			
			__bufferData = data;
			__bufferSkipped.length = __length;
			__bufferDirty = true;
			
		}
		
		if (__buffer == null || __bufferContext != gl) {
			
			__bufferContext = gl;
			__buffer = gl.createBuffer ();
			
		}
		
		gl.bindBuffer (gl.ARRAY_BUFFER, __buffer);
		
		// TODO: Handle __dirty flags, copy only changed values
		
		if (__bufferDirty || (__cacheAlpha != worldAlpha) || (__cacheDefaultTileset != defaultTileset)) {
			
			var tileMatrix, tileColorTransform, tileRect = null;
			
			// TODO: Dirty algorithm per tile?
			
			var offset = 0;
			var alpha, visible, tileset, tileData, id;
			var bitmapWidth, bitmapHeight, tileWidth:Float, tileHeight:Float;
			var uvX, uvY, uvWidth, uvHeight;
			var x, y, x2, y2, x3, y3, x4, y4;
			var redMultiplier, greenMultiplier, blueMultiplier, alphaMultiplier;
			var redOffset, greenOffset, blueOffset, alphaOffset;
			
			position = 0;
			
			var __skipTile = function (i, offset:Int):Void {
				
				for (i in 0...6) {
					
					__bufferData[offset + (attributeLength * i) + 4] = 0;
					
				}
				
				__bufferSkipped[i] = true;
				
			}
			
			for (i in 0...__length) {
				
				position = i;
				offset = i * stride;
				
				alpha = this.alpha;
				visible = this.visible;
				
				if (!visible || alpha <= 0) {
					
					__skipTile (i, offset);
					continue;
					
				}
				
				tileset = this.tileset;
				if (tileset == null) tileset = defaultTileset;
				if (tileset == null) {
					
					__skipTile (i, offset);
					continue;
					
				}
				
				id = this.id;
				
				if (id > -1) {
					
					if (id >= tileset.__data.length) {
						
						__skipTile (i, offset);
						continue;
						
					}
					
					tileData = tileset.__data[id];
					
					if (tileData == null) {
						
						__skipTile (i, offset);
						continue;
						
					}
					
					tileWidth = tileData.width;
					tileHeight = tileData.height;
					uvX = tileData.__uvX;
					uvY = tileData.__uvY;
					uvWidth = tileData.__uvWidth;
					uvHeight = tileData.__uvHeight;
					
				} else {
					
					tileRect = this.rect;
					
					if (tileRect == null) {
						
						__skipTile (i, offset);
						continue;
						
					}
					
					tileWidth = tileRect.width;
					tileHeight = tileRect.height;
					
					if (tileWidth <= 0 || tileHeight <= 0) {
						
						__skipTile (i, offset);
						continue;
						
					}
					
					bitmapWidth = tileset.__bitmapData.width;
					bitmapHeight = tileset.__bitmapData.height;
					uvX = tileRect.x / bitmapWidth;
					uvY = tileRect.y / bitmapHeight;
					uvWidth = tileRect.right / bitmapWidth;
					uvHeight = tileRect.bottom / bitmapHeight;
					
				}
				
				tileMatrix = this.matrix;
				x = tileMatrix.__transformX (0, 0);
				y = tileMatrix.__transformY (0, 0);
				x2 = tileMatrix.__transformX (tileWidth, 0);
				y2 = tileMatrix.__transformY (tileWidth, 0);
				x3 = tileMatrix.__transformX (0, tileHeight);
				y3 = tileMatrix.__transformY (0, tileHeight);
				x4 = tileMatrix.__transformX (tileWidth, tileHeight);
				y4 = tileMatrix.__transformY (tileWidth, tileHeight);
				
				alpha *= worldAlpha;
				
				tileColorTransform = this.colorTransform;
				tileColorTransform.__combine (defaultColorTransform);
				
				redMultiplier = tileColorTransform.redMultiplier;
				greenMultiplier = tileColorTransform.greenMultiplier;
				blueMultiplier = tileColorTransform.blueMultiplier;
				alphaMultiplier = tileColorTransform.alphaMultiplier;
				redOffset = tileColorTransform.redOffset;
				greenOffset = tileColorTransform.greenOffset;
				blueOffset = tileColorTransform.blueOffset;
				alphaOffset = tileColorTransform.alphaOffset;
				
				__bufferData[offset + 0] = x;
				__bufferData[offset + 1] = y;
				__bufferData[offset + 2] = uvX;
				__bufferData[offset + 3] = uvY;
				
				__bufferData[offset + attributeLength + 0] = x2;
				__bufferData[offset + attributeLength + 1] = y2;
				__bufferData[offset + attributeLength + 2] = uvWidth;
				__bufferData[offset + attributeLength + 3] = uvY;
				
				__bufferData[offset + (attributeLength * 2) + 0] = x3;
				__bufferData[offset + (attributeLength * 2) + 1] = y3;
				__bufferData[offset + (attributeLength * 2) + 2] = uvX;
				__bufferData[offset + (attributeLength * 2) + 3] = uvHeight;
				
				__bufferData[offset + (attributeLength * 3) + 0] = x3;
				__bufferData[offset + (attributeLength * 3) + 1] = y3;
				__bufferData[offset + (attributeLength * 3) + 2] = uvX;
				__bufferData[offset + (attributeLength * 3) + 3] = uvHeight;
				
				__bufferData[offset + (attributeLength * 4) + 0] = x2;
				__bufferData[offset + (attributeLength * 4) + 1] = y2;
				__bufferData[offset + (attributeLength * 4) + 2] = uvWidth;
				__bufferData[offset + (attributeLength * 4) + 3] = uvY;
				
				__bufferData[offset + (attributeLength * 5) + 0] = x4;
				__bufferData[offset + (attributeLength * 5) + 1] = y4;
				__bufferData[offset + (attributeLength * 5) + 2] = uvWidth;
				__bufferData[offset + (attributeLength * 5) + 3] = uvHeight;
				
				for (i in 0...6) {
					
					__bufferData[offset + (attributeLength * i) + 4] = alpha;
					
					// 4 x 4 matrix
					__bufferData[offset + (attributeLength * i) + 5] = redMultiplier;
					__bufferData[offset + (attributeLength * i) + 6] = greenMultiplier;
					__bufferData[offset + (attributeLength * i) + 7] = blueMultiplier;
					__bufferData[offset + (attributeLength * i) + 8] = alphaMultiplier;
					
					__bufferData[offset + (attributeLength * i) + 9] = redOffset / 255;
					__bufferData[offset + (attributeLength * i) + 10] = greenOffset / 255;
					__bufferData[offset + (attributeLength * i) + 11] = blueOffset / 255;
					__bufferData[offset + (attributeLength * i) + 12] = alphaOffset / 255;
					
				}
				
				__bufferSkipped[i] = false;
				
			}
			
			if (__bufferLength >= __bufferData.byteLength) {
				
				(gl:WebGLContext).bufferSubData (gl.ARRAY_BUFFER, 0, __bufferData);
				
			} else {
				
				(gl:WebGLContext).bufferData (gl.ARRAY_BUFFER, __bufferData, gl.DYNAMIC_DRAW);
				
			}
			
			__bufferLength = __bufferData.byteLength;
			
			__cacheAlpha = worldAlpha;
			__cacheDefaultTileset = defaultTileset;
			__bufferDirty = false;
			
		}
		
		return __buffer;
		
	}
	#end
	
	
	
	
	// Get & Set Methods
	
	
	
	
	@:noCompletion private inline function get_alpha ():Float {
		
		return __data[ALPHA_INDEX + (position * DATA_LENGTH)];
		
	}
	
	
	@:noCompletion private inline function set_alpha (value:Float):Float {
		
		__dirty[ALPHA_DIRTY_INDEX + (position * DIRTY_LENGTH)] = true;
		return __data[ALPHA_INDEX + (position * DATA_LENGTH)] = value;
		
	}
	
	@:noCompletion private function get_colorTransform ():ColorTransform {
		
		if (__colorTransform == null) __colorTransform = new ColorTransform ();
		var i = COLOR_TRANSFORM_INDEX + (position * DATA_LENGTH);
		__colorTransform.redMultiplier = __data[i];
		__colorTransform.greenMultiplier = __data[i + 1];
		__colorTransform.blueMultiplier = __data[i + 2];
		__colorTransform.alphaMultiplier = __data[i + 3];
		__colorTransform.redOffset = __data[i + 4];
		__colorTransform.greenOffset = __data[i + 5];
		__colorTransform.blueOffset = __data[i + 6];
		__colorTransform.alphaOffset = __data[i + 7];
		return __colorTransform;
		
	}
	
	
	@:noCompletion private function set_colorTransform (value:ColorTransform):ColorTransform {
		
		var i = COLOR_TRANSFORM_INDEX + (position * DATA_LENGTH);
		
		if (value != null) {
			
			__data[i] = value.redMultiplier;
			__data[i + 1] = value.greenMultiplier;
			__data[i + 2] = value.blueMultiplier;
			__data[i + 3] = value.alphaMultiplier;
			__data[i + 4] = value.redOffset;
			__data[i + 5] = value.greenOffset;
			__data[i + 6] = value.blueOffset;
			__data[i + 7] = value.alphaOffset;
			
		} else {
			
			__data[i] = 1;
			__data[i + 1] = 1;
			__data[i + 2] = 1;
			__data[i + 3] = 1;
			__data[i + 4] = 0;
			__data[i + 5] = 0;
			__data[i + 6] = 0;
			__data[i + 7] = 0;
			
		}
		
		__dirty[COLOR_TRANSFORM_DIRTY_INDEX + (position * DIRTY_LENGTH)] = true;
		return value;
		
	}
	
	
	
	@:noCompletion private inline function get_id ():Int {
		
		return Std.int (__data[ID_INDEX + (position * DATA_LENGTH)]);
		
	}
	
	
	@:noCompletion private inline function set_id (value:Int):Int {
		
		__dirty[SOURCE_DIRTY_INDEX + (position * DIRTY_LENGTH)] = true;
		__data[ID_INDEX + (position * DATA_LENGTH)] = value;
		return value;
		
	}
	
	
	@:noCompletion private inline function get_length ():Int {
		
		return __length;
		
	}
	
	
	@:noCompletion private function set_length (value:Int):Int {
		
		__data.length = value * DATA_LENGTH;
		__dirty.length = value * DIRTY_LENGTH;
		__shaders.length = value;
		__tilesets.length = value;
		__visible.length = value;
		
		if (value > __length) {
			
			var cachePosition = position;
			
			for (i in __length...value) {
				
				__init (i);
				
			}
			
			position = cachePosition;
			
		}
		
		__length = value;
		return value;
		
	}
	
	
	@:noCompletion private function get_matrix ():Matrix {
		
		if (__matrix == null) __matrix = new Matrix ();
		var i = MATRIX_INDEX + (position * DATA_LENGTH);
		__matrix.a = __data[i];
		__matrix.b = __data[i + 1];
		__matrix.c = __data[i + 2];
		__matrix.d = __data[i + 3];
		__matrix.tx = __data[i + 4];
		__matrix.ty = __data[i + 5];
		return __matrix;
		
	}
	
	
	@:noCompletion private function set_matrix (value:Matrix):Matrix {
		
		var i = MATRIX_INDEX + (position * DATA_LENGTH);
		
		if (value != null) {
			
			__data[i] = value.a;
			__data[i + 1] = value.b;
			__data[i + 2] = value.c;
			__data[i + 3] = value.d;
			__data[i + 4] = value.tx;
			__data[i + 5] = value.ty;
				
		} else {
			
			__data[i] = 1;
			__data[i + 1] = 0;
			__data[i + 2] = 0;
			__data[i + 3] = 1;
			__data[i + 4] = 0;
			__data[i + 5] = 0;
			
		}
		
		__dirty[MATRIX_DIRTY_INDEX + (position * DIRTY_LENGTH)] = true;
		return value;
		
	}
	
	
	@:noCompletion private function get_rect ():Rectangle {
		
		if (__rect == null) __rect = new Rectangle ();
		var i = RECT_INDEX + (position * DATA_LENGTH);
		__rect.x = __data[i];
		__rect.y = __data[i + 1];
		__rect.width = __data[i + 2];
		__rect.height = __data[i + 3];
		return __rect;
		
	}
	
	
	@:noCompletion private function set_rect (value:Rectangle):Rectangle {
		
		if (value != null) {
			
			__data[ID_INDEX + (position * DATA_LENGTH)] = -1;
			var i = RECT_INDEX + (position * DATA_LENGTH);
			__data[i] = value.x;
			__data[i + 1] = value.y;
			__data[i + 2] = value.width;
			__data[i + 3] = value.height;
			
		} else {
			
			var i = RECT_INDEX + (position * DATA_LENGTH);
			__data[i] = 0;
			__data[i + 1] = 0;
			__data[i + 2] = 0;
			__data[i + 3] = 0;
			
		}
		
		__dirty[SOURCE_DIRTY_INDEX + (position * DIRTY_LENGTH)] = true;
		return value;
		
	}
	
	
	@:noCompletion private inline function get_shader ():Shader {
		
		return __shaders[position];
		
	}
	
	
	@:noCompletion private inline function set_shader (value:Shader):Shader {
		
		__shaders[position] = value;
		return value;
		
	}
	
	
	@:noCompletion private inline function get_tileset ():Tileset {
		
		return __tilesets[position];
		
	}
	
	
	@:noCompletion private inline function set_tileset (value:Tileset):Tileset {
		
		__tilesets[position] = value;
		return value;
		
	}
	
	
	@:noCompletion private inline function get_visible ():Bool {
		
		return __visible[position];
		
	}
	
	
	@:noCompletion private inline function set_visible (value:Bool):Bool {
		
		__visible[position] = value;
		return value;
		
	}
	
	
}




private class TileArrayIterator {
	
	
	@:noCompletion private var cachePosition:Int;
	@:noCompletion private var data:TileArray;
	@:noCompletion private var position:Int;
	
	
	@:noCompletion private function new (data:TileArray) {
		
		this.data = data;
		cachePosition = data.position;
		position = 0;
		
	}
	
	
	public function hasNext ():Bool {
		
		if (position < data.length) {
			
			return true;
			
		} else {
			
			data.position = cachePosition;
			return false;
			
		}
		
	}
	
	
	public function next ():ITile {
		
		data.position = position++;
		return data;
		
	}
	
	
}
#end