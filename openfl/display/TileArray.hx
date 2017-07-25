package openfl.display;


import lime.graphics.opengl.GLBuffer;
import lime.graphics.GLRenderContext;
import lime.utils.Float32Array;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import openfl.Vector;

@:access(openfl.display.Tileset)
@:access(openfl.geom.ColorTransform)
@:access(openfl.geom.Matrix)
@:access(openfl.geom.Rectangle)


@:beta class TileArray {
	
	
	private static inline var ID_INDEX = 0;
	private static inline var RECT_INDEX = 1;
	private static inline var MATRIX_INDEX = 5;
	private static inline var ALPHA_INDEX = 11;
	private static inline var COLOR_TRANSFORM_INDEX = 12;
	private static inline var DATA_LENGTH = 21;
	
	private static inline var SOURCE_DIRTY_INDEX = 0;
	private static inline var MATRIX_DIRTY_INDEX = 1;
	private static inline var ALPHA_DIRTY_INDEX = 2;
	private static inline var COLOR_TRANSFORM_DIRTY_INDEX = 3;
	private static inline var ALL_DIRTY_INDEX = 4;
	private static inline var DIRTY_LENGTH = 5;
	
	public var alpha (get, set):Float;
	public var id (get, set):Int;
	public var length (get, set):Int;
	public var position:Int;
	public var shader (get, set):Shader;
	public var tileset (get, set):Tileset;
	public var visible (get, set):Bool;
	
	private var __buffer:GLBuffer;
	private var __bufferContext:GLRenderContext;
	private var __bufferDirty:Bool;
	private var __bufferData:Float32Array;
	private var __bufferSkipped:Vector<Bool>;
	private var __cacheAlpha:Float;
	private var __cacheDefaultTileset:Tileset;
	private var __data:Vector<Float>;
	private var __dirty:Vector<Bool>;
	private var __length:Int;
	private var __shaders:Vector<Shader>;
	private var __tilesets:Vector<Tileset>;
	private var __visible:Vector<Bool>;
	
	
	public function new (length:Int = 0) {
		
		__cacheAlpha = -1;
		__data = new Vector<Float> (length * DATA_LENGTH);
		__dirty = new Vector<Bool> (length * DIRTY_LENGTH);
		__shaders = new Vector<Shader> (length);
		__tilesets = new Vector<Tileset> (length);
		__visible = new Vector<Bool> (length);
		__length = length;
		
	}
	
	
	public function getColorTransform (colorTransform:ColorTransform = null):ColorTransform {
		
		if (colorTransform == null) colorTransform = new ColorTransform ();
		var i = COLOR_TRANSFORM_INDEX + (position * DATA_LENGTH);
		colorTransform.redMultiplier = __data[i];
		colorTransform.greenMultiplier = __data[i + 1];
		colorTransform.blueMultiplier = __data[i + 2];
		colorTransform.alphaMultiplier = __data[i + 3];
		colorTransform.redOffset = __data[i + 4];
		colorTransform.greenOffset = __data[i + 5];
		colorTransform.blueOffset = __data[i + 6];
		colorTransform.alphaOffset = __data[i + 7];
		return colorTransform;
		
	}
	
	
	public function getMatrix (matrix:Matrix = null):Matrix {
		
		if (matrix == null) matrix = new Matrix ();
		var i = MATRIX_INDEX + (position * DATA_LENGTH);
		matrix.a = __data[i];
		matrix.b = __data[i + 1];
		matrix.c = __data[i + 2];
		matrix.d = __data[i + 3];
		matrix.tx = __data[i + 4];
		matrix.ty = __data[i + 5];
		return matrix;
		
	}
	
	
	public function getRect (rect:Rectangle = null):Rectangle {
		
		if (rect == null) rect = new Rectangle ();
		var i = RECT_INDEX + (position * DATA_LENGTH);
		rect.x = __data[i];
		rect.y = __data[i + 1];
		rect.width = __data[i + 2];
		rect.height = __data[i + 3];
		return rect;
		
	}
	
	
	public function setColorTransform (redMultiplier:Float, greenMultiplier:Float, blueMultiplier:Float, alphaMultiplier:Float, redOffset:Float, greenOffset:Float, blueOffset:Float, alphaOffset:Float):Void {
		
		var i = COLOR_TRANSFORM_INDEX + (position * DATA_LENGTH);
		__data[i] = redMultiplier;
		__data[i + 1] = greenMultiplier;
		__data[i + 2] = blueMultiplier;
		__data[i + 3] = alphaMultiplier;
		__data[i + 4] = redOffset;
		__data[i + 5] = greenOffset;
		__data[i + 6] = blueOffset;
		__data[i + 7] = alphaOffset;
		__dirty[COLOR_TRANSFORM_DIRTY_INDEX + (position * DIRTY_LENGTH)] = true;
		
	}
	
	
	public function setMatrix (a:Float, b:Float, c:Float, d:Float, tx:Float, ty:Float):Void {
		
		var i = MATRIX_INDEX + (position * DATA_LENGTH);
		__data[i] = a;
		__data[i + 1] = b;
		__data[i + 2] = c;
		__data[i + 3] = d;
		__data[i + 4] = tx;
		__data[i + 5] = ty;
		__dirty[MATRIX_DIRTY_INDEX + (position * DIRTY_LENGTH)] = true;
		
	}
	
	
	public function setRect (x:Float, y:Float, width:Float, height:Float):Void {
		
		__data[ID_INDEX + (position * DATA_LENGTH)] = -1;
		var i = RECT_INDEX + (position * DATA_LENGTH);
		__data[i] = x;
		__data[i + 1] = y;
		__data[i + 2] = width;
		__data[i + 3] = height;
		__dirty[SOURCE_DIRTY_INDEX + (position * DIRTY_LENGTH)] = true;
		
	}
	
	
	private inline function __init (position:Int):Void {
		
		this.position = position;
		
		alpha = 1;
		setColorTransform (1, 1, 1, 1, 0, 0, 0, 0);
		id = 0;
		setMatrix (1, 0, 0, 1, 0, 0);
		tileset = null;
		visible = true;
		
		__dirty[ALL_DIRTY_INDEX + (position * DIRTY_LENGTH)] = true;
		
	}
	
	
	#if !flash
	private function __updateGLBuffer (gl:GLRenderContext, defaultTileset:Tileset, worldAlpha:Float, defaultColorTransform:ColorTransform):GLBuffer {
		
		// TODO: More closely align internal data format with GL buffer format?
		
		var attributeLength = 25;
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
			
			var matrix = Matrix.__pool.get ();
			var colorTransform = new ColorTransform ();
			var rect = null;
			
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
					
					if (rect == null) {
						
						rect = #if flash new Rectangle (); #else Rectangle.__pool.get (); #end
						
					}
					
					getRect (rect);
					
					tileWidth = rect.width;
					tileHeight = rect.height;
					bitmapWidth = tileset.bitmapData.width;
					bitmapHeight = tileset.bitmapData.height;
					uvX = rect.x / bitmapWidth;
					uvY = rect.y / bitmapHeight;
					uvWidth = rect.right / bitmapWidth;
					uvHeight = rect.bottom / bitmapHeight;
					
				}
				
				getMatrix (matrix);
				x = matrix.__transformX (0, 0);
				y = matrix.__transformY (0, 0);
				x2 = matrix.__transformX (tileWidth, 0);
				y2 = matrix.__transformY (tileWidth, 0);
				x3 = matrix.__transformX (0, tileHeight);
				y3 = matrix.__transformY (0, tileHeight);
				x4 = matrix.__transformX (tileWidth, tileHeight);
				y4 = matrix.__transformY (tileWidth, tileHeight);
				
				alpha *= worldAlpha;
				
				getColorTransform (colorTransform);
				colorTransform.__combine (defaultColorTransform);
				
				redMultiplier = colorTransform.redMultiplier;
				greenMultiplier = colorTransform.greenMultiplier;
				blueMultiplier = colorTransform.blueMultiplier;
				alphaMultiplier = colorTransform.alphaMultiplier;
				redOffset = colorTransform.redOffset;
				greenOffset = colorTransform.greenOffset;
				blueOffset = colorTransform.blueOffset;
				alphaOffset = colorTransform.alphaOffset;
				
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
					__bufferData[offset + (attributeLength * i) + 10] = greenMultiplier;
					__bufferData[offset + (attributeLength * i) + 15] = blueMultiplier;
					__bufferData[offset + (attributeLength * i) + 20] = alphaMultiplier;
					
					__bufferData[offset + (attributeLength * i) + 21] = redOffset;
					__bufferData[offset + (attributeLength * i) + 22] = greenOffset;
					__bufferData[offset + (attributeLength * i) + 23] = blueOffset;
					__bufferData[offset + (attributeLength * i) + 24] = alphaOffset;
					
				}
				
				__bufferSkipped[i] = false;
				position++;
				
			}
			
			gl.bufferData (gl.ARRAY_BUFFER, __bufferData.byteLength, __bufferData, gl.DYNAMIC_DRAW);
			
			if (rect != null) Rectangle.__pool.release (rect);
			Matrix.__pool.release (matrix);
			
			__cacheAlpha = worldAlpha;
			__cacheDefaultTileset = defaultTileset;
			__bufferDirty = false;
			
		}
		
		return __buffer;
		
	}
	#end
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private inline function get_alpha ():Float {
		
		return __data[ALPHA_INDEX + (position * DATA_LENGTH)];
		
	}
	
	
	private inline function set_alpha (value:Float):Float {
		
		__dirty[ALPHA_DIRTY_INDEX + (position * DIRTY_LENGTH)] = true;
		return __data[ALPHA_INDEX + (position * DATA_LENGTH)] = value;
		
	}
	
	
	private inline function get_id ():Int {
		
		return Std.int (__data[ID_INDEX + (position * DATA_LENGTH)]);
		
	}
	
	
	private inline function set_id (value:Int):Int {
		
		__dirty[SOURCE_DIRTY_INDEX + (position * DIRTY_LENGTH)] = true;
		__data[ID_INDEX + (position * DATA_LENGTH)] = value;
		return value;
		
	}
	
	
	private inline function get_length ():Int {
		
		return __length;
		
	}
	
	
	private function set_length (value:Int):Int {
		
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
	
	
	private inline function get_shader ():Shader {
		
		return __shaders[position];
		
	}
	
	
	private inline function set_shader (value:Shader):Shader {
		
		__shaders[position] = value;
		return value;
		
	}
	
	
	private inline function get_tileset ():Tileset {
		
		return __tilesets[position];
		
	}
	
	
	private inline function set_tileset (value:Tileset):Tileset {
		
		__tilesets[position] = value;
		return value;
		
	}
	
	
	private inline function get_visible ():Bool {
		
		return __visible[position];
		
	}
	
	
	private inline function set_visible (value:Bool):Bool {
		
		__visible[position] = value;
		return value;
		
	}
	
	
}