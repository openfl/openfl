package openfl.display;


import lime.graphics.opengl.GLBuffer;
import lime.graphics.GLRenderContext;
import lime.utils.Float32Array;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import openfl.Vector;

@:access(openfl.display.Tileset)
@:access(openfl.geom.Matrix)
@:access(openfl.geom.Rectangle)


@:beta class TileArray {
	
	
	private static inline var ID_INDEX = 0;
	private static inline var RECT_INDEX = 1;
	private static inline var MATRIX_INDEX = 5;
	private static inline var ALPHA_INDEX = 11;
	private static inline var DATA_LENGTH = 12;
	
	public var alpha (get, set):Float;
	public var id (get, set):Int;
	public var length (get, set):Int;
	public var position:Int;
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
	private var __length:Int;
	private var __tilesets:Vector<Tileset>;
	private var __visible:Vector<Bool>;
	
	
	public function new (length:Int = 0) {
		
		__cacheAlpha = -1;
		__data = new Vector<Float> (length * DATA_LENGTH);
		__tilesets = new Vector<Tileset> (length);
		__visible = new Vector<Bool> (length);
		__length = length;
		
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
	
	
	public function setMatrix (a:Float, b:Float, c:Float, d:Float, tx:Float, ty:Float):Void {
		
		var i = MATRIX_INDEX + (position * DATA_LENGTH);
		__data[i] = a;
		__data[i + 1] = b;
		__data[i + 2] = c;
		__data[i + 3] = d;
		__data[i + 4] = tx;
		__data[i + 5] = ty;
		
	}
	
	
	public function setRect (x:Float, y:Float, width:Float, height:Float):Void {
		
		__data[ID_INDEX + (position * DATA_LENGTH)] = -1;
		var i = RECT_INDEX + (position * DATA_LENGTH);
		__data[i] = x;
		__data[i + 1] = y;
		__data[i + 2] = width;
		__data[i + 3] = height;
		
	}
	
	
	private inline function __init (position:Int):Void {
		
		this.position = position;
		
		alpha = 1;
		id = 0;
		setMatrix (1, 0, 0, 1, 0, 0);
		tileset = null;
		visible = true;
		
	}
	
	
	#if !flash
	private function __updateGLBuffer (gl:GLRenderContext, defaultTileset:Tileset, worldAlpha:Float):GLBuffer {
		
		// TODO: More closely align internal data format with GL buffer format?
		
		var itemSize = 30;
		var bufferLength = __length * itemSize;
		
		if (__bufferData == null) {
			
			__bufferData = new Float32Array (bufferLength);
			__bufferSkipped = new Vector<Bool> (__length);
			__bufferDirty = true;
			
		} else if (__bufferData.length != bufferLength) {
			
			var data = new Float32Array (bufferLength);
			
			if (__bufferData.length <= data.length) {
				
				data.set (__bufferData);
				
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
		
		if (__bufferDirty || (__cacheAlpha != worldAlpha) || (__cacheDefaultTileset != defaultTileset)) {
			
			var matrix = Matrix.__pool.get ();
			var rect = null;
			
			// TODO: Dirty algorithm per tile?
			
			var offset = 0;
			var alpha, visible, tileset, tileData, id;
			var bitmapWidth, bitmapHeight, tileWidth:Float, tileHeight:Float;
			var uvX, uvY, uvWidth, uvHeight;
			var x, y, x2, y2, x3, y3, x4, y4;
			
			position = 0;
			
			var __skipTile = function (i, offset:Int):Void {
				
				__bufferData[offset + 4] = 0;
				__bufferData[offset + 9] = 0;
				__bufferData[offset + 14] = 0;
				__bufferData[offset + 19] = 0;
				__bufferData[offset + 24] = 0;
				__bufferData[offset + 29] = 0;
				__bufferSkipped[i] = true;
				
			}
			
			for (i in 0...__length) {
				
				offset = i * itemSize;
				
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
				
				// transform
				
				getMatrix (matrix);
				x = matrix.__transformX (0, 0);
				y = matrix.__transformY (0, 0);
				x2 = matrix.__transformX (tileWidth, 0);
				y2 = matrix.__transformY (tileWidth, 0);
				x3 = matrix.__transformX (0, tileHeight);
				y3 = matrix.__transformY (0, tileHeight);
				x4 = matrix.__transformX (tileWidth, tileHeight);
				y4 = matrix.__transformY (tileWidth, tileHeight);
				
				__bufferData[offset + 0] = x;
				__bufferData[offset + 1] = y;
				__bufferData[offset + 5] = x2;
				__bufferData[offset + 6] = y2;
				__bufferData[offset + 10] = x3;
				__bufferData[offset + 11] = y3;
				
				__bufferData[offset + 15] = x3;
				__bufferData[offset + 16] = y3;
				__bufferData[offset + 20] = x2;
				__bufferData[offset + 21] = y2;
				__bufferData[offset + 25] = x4;
				__bufferData[offset + 26] = y4;
				
				// uv
				
				__bufferData[offset + 2] = uvX;
				__bufferData[offset + 3] = uvY;
				__bufferData[offset + 7] = uvWidth;
				__bufferData[offset + 8] = uvY;
				__bufferData[offset + 12] = uvX;
				__bufferData[offset + 13] = uvHeight;
				
				__bufferData[offset + 17] = uvX;
				__bufferData[offset + 18] = uvHeight;
				__bufferData[offset + 22] = uvWidth;
				__bufferData[offset + 23] = uvY;
				__bufferData[offset + 27] = uvWidth;
				__bufferData[offset + 28] = uvHeight;
				
				// alpha
				
				alpha *= worldAlpha;
				__bufferData[offset + 4] = alpha;
				__bufferData[offset + 9] = alpha;
				__bufferData[offset + 14] = alpha;
				__bufferData[offset + 19] = alpha;
				__bufferData[offset + 24] = alpha;
				__bufferData[offset + 29] = alpha;
				
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
		
		return __data[ALPHA_INDEX + (position * DATA_LENGTH)] = value;
		
	}
	
	
	private inline function get_id ():Int {
		
		return Std.int (__data[ID_INDEX + (position * DATA_LENGTH)]);
		
	}
	
	
	private inline function set_id (value:Int):Int {
		
		__data[ID_INDEX + (position * DATA_LENGTH)] = value;
		return value;
		
	}
	
	
	private inline function get_length ():Int {
		
		return __length;
		
	}
	
	
	private function set_length (value:Int):Int {
		
		__data.length = value * DATA_LENGTH;
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