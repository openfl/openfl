package openfl.display;


import openfl.geom.ColorTransform;
import openfl.geom.Matrix;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.display.TileArray)
@:access(openfl.geom.ColorTransform)
@:access(openfl.geom.Matrix)


class Tile {
	
	
	public var alpha (default, set):Float;
	@:beta public var colorTransform (get, set):ColorTransform;
	public var data:Dynamic;
	public var id (default, set):Int;
	public var matrix (default, set):Matrix;
	public var originX (default, set):Float;
	public var originY (default, set):Float;
	public var rotation (get, set):Float;
	public var scaleX (get, set):Float;
	public var scaleY (get, set):Float;
	@:beta public var shader (default, set):Shader;
	public var tileset (default, set):Tileset;
	public var visible (default, set):Bool;
	public var x (get, set):Float;
	public var y (get, set):Float;
	
	private var __alphaDirty:Bool;
	private var __colorTransform:ColorTransform;
	private var __colorTransformDirty:Bool;
	private var __rotation:Null<Float>;
	private var __rotationCosine:Float;
	private var __rotationSine:Float;
	private var __scaleX:Null<Float>;
	private var __scaleY:Null<Float>;
	private var __shaderDirty:Bool;
	private var __sourceDirty:Bool;
	private var __transformDirty:Bool;
	private var __visibleDirty:Bool;
	
	
	public function new (id:Int = 0, x:Float = 0, y:Float = 0, scaleX:Float = 1, scaleY:Float = 1, rotation:Float = 0, originX:Float = 0, originY:Float = 0) {
		
		this.id = id;
		
		this.matrix = new Matrix ();
		if (x != 0) this.x = x;
		if (y != 0) this.y = y;
		if (scaleX != 1) this.scaleX = scaleX;
		if (scaleY != 1) this.scaleY = scaleY;
		if (rotation != 0) this.rotation = rotation;
		this.originX = originX;
		this.originY = originY;
		
		alpha = 1;
		visible = true;
		
		__alphaDirty = true;
		__sourceDirty = true;
		__transformDirty = true;
		__visibleDirty = true;
		
	}
	
	
	public function clone ():Tile {
		
		var tile = new Tile (id);
		tile.matrix = matrix.clone ();
		tile.tileset = tileset;
		return tile;
		
	}
	
	
	private static function __fromTileArray (position:Int, tileArray:TileArray):Tile {
		
		var cachePosition = tileArray.position;
		tileArray.position = position;
		
		var tile = new Tile ();
		tile.alpha = tileArray.alpha;
		tile.id = tileArray.id;
		tileArray.getMatrix (tile.matrix);
		
		tileArray.position = cachePosition;
		
		return tile;
		
	}
	
	
	private function __updateTileArray (position:Int, tileArray:TileArray, forceUpdate:Bool):Void {
		
		var cachePosition = tileArray.position;
		tileArray.position = position;
		
		if (__shaderDirty || forceUpdate) {
			
			tileArray.shader = shader;
			__shaderDirty = false;
			
		}
		
		if (__colorTransformDirty || forceUpdate) {
			
			if (__colorTransform == null) {
				
				tileArray.setColorTransform (1, 1, 1, 1, 0, 0, 0, 0);
				
			} else {
				
				tileArray.setColorTransform (__colorTransform.redMultiplier, __colorTransform.greenMultiplier, __colorTransform.blueMultiplier, __colorTransform.alphaMultiplier, __colorTransform.redOffset, __colorTransform.greenOffset, __colorTransform.blueOffset, __colorTransform.alphaOffset);
				
			}
			
			__colorTransformDirty = false;
			
		}
		
		if (__visibleDirty || forceUpdate) {
			
			tileArray.visible = visible;
			tileArray.__bufferDirty = true;
			__visibleDirty = false;
			
		}
		
		if (__alphaDirty || forceUpdate) {
			
			tileArray.alpha = alpha;
			tileArray.__bufferDirty = true;
			__alphaDirty = false;
			
		}
		
		if (__sourceDirty || forceUpdate) {
			
			tileArray.id = id;
			tileArray.tileset = tileset;
			tileArray.__bufferDirty = true;
			__sourceDirty = true;
			
		}
		
		if (__transformDirty || forceUpdate) {
			
			if (originX != 0 || originY != 0) {
				
				var tempMatrix = #if flash new Matrix (); #else Matrix.__pool.get (); #end
				tempMatrix.setTo (1, 0, 0, 1, -originX, -originY);
				tempMatrix.concat (matrix);
				
				tileArray.setMatrix (tempMatrix.a, tempMatrix.b, tempMatrix.c, tempMatrix.d, tempMatrix.tx, tempMatrix.ty);
				
				#if !flash
				Matrix.__pool.release (tempMatrix);
				#end
				
			} else {
				
				tileArray.setMatrix (matrix.a, matrix.b, matrix.c, matrix.d, matrix.tx, matrix.ty);
				
			}
			
			tileArray.__bufferDirty = true;
			__transformDirty = false;
			
		}
		
		tileArray.position = cachePosition;
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private function set_alpha (value:Float):Float {
		
		__alphaDirty = true;
		return alpha = value;
		
	}
	
	
	private function get_colorTransform ():ColorTransform {
		
		if (__colorTransform == null) {
			__colorTransform = new ColorTransform ();
		}
		
		return __colorTransform;
		
	}
	
	
	private function set_colorTransform (value:ColorTransform):ColorTransform {
		
		#if flash
		
		if (__colorTransform == null) {
			
			__colorTransform = new ColorTransform ();
			
		} else if (value == null) {
			
			__colorTransform.redMultiplier = 1;
			__colorTransform.greenMultiplier = 1;
			__colorTransform.blueMultiplier = 1;
			__colorTransform.alphaMultiplier = 1;
			__colorTransform.redOffset = 0;
			__colorTransform.greenOffset = 0;
			__colorTransform.blueOffset = 0;
			__colorTransform.alphaOffset = 0;
			return value;
			
		}
		
		__colorTransform.redMultiplier = value.redMultiplier;
		__colorTransform.greenMultiplier = value.greenMultiplier;
		__colorTransform.blueMultiplier = value.blueMultiplier;
		__colorTransform.alphaMultiplier = value.alphaMultiplier;
		__colorTransform.redOffset = value.redOffset;
		__colorTransform.greenOffset = value.greenOffset;
		__colorTransform.blueOffset = value.blueOffset;
		__colorTransform.alphaOffset = value.alphaOffset;
		return value;
		
		#else
		
		if (__colorTransform == null) {
			
			if (value != null) {
				__colorTransform = value.__clone ();
			}
			
		} else {
			
			if (value != null) {
				__colorTransform.__copyFrom (value);
			} else {
				__colorTransform.__identity ();
			}
			
		}
		
		__colorTransformDirty = true;
		return value;
		
		#end
		
	}
	
	
	private function set_id (value:Int):Int {
		
		__sourceDirty = true;
		return id = value;
		
	}
	
	
	private function set_matrix (value:Matrix):Matrix {
		
		__rotation = null;
		__scaleX = null;
		__scaleY = null;
		__transformDirty = true;
		return this.matrix = value;
		
	}
	
	
	private function set_originX (value:Float):Float {
		
		__transformDirty = true;
		return this.originX = value;
		
	}
	
	
	private function set_originY (value:Float):Float {
		
		__transformDirty = true;
		return this.originY = value;
		
	}
	
	
	private function get_rotation ():Float {
		
		if (__rotation == null) {
			
			if (matrix.b == 0 && matrix.c == 0) {
				
				__rotation = 0;
				__rotationSine = 0;
				__rotationCosine = 1;
				
			} else {
				
				var radians = Math.atan2 (matrix.d, matrix.c) - (Math.PI / 2);
				
				__rotation = radians * (180 / Math.PI);
				__rotationSine = Math.sin (radians);
				__rotationCosine = Math.cos (radians);
				
			}
			
		}
		
		return __rotation;
		
	}
	
	
	private function set_rotation (value:Float):Float {
		
		if (value != __rotation) {
			
			__rotation = value;
			var radians = value * (Math.PI / 180);
			__rotationSine = Math.sin (radians);
			__rotationCosine = Math.cos (radians);
			
			var __scaleX = this.scaleX;
			var __scaleY = this.scaleY;
			
			matrix.a = __rotationCosine * __scaleX;
			matrix.b = __rotationSine * __scaleX;
			matrix.c = -__rotationSine * __scaleY;
			matrix.d = __rotationCosine * __scaleY;
			
			__transformDirty = true;
			
		}
		
		return value;
		
	}
	
	
	private function get_scaleX ():Float {
		
		if (__scaleX == null) {
			
			if (matrix.b == 0) {
				
				__scaleX = matrix.a;
				
			} else {
				
				__scaleX = Math.sqrt (matrix.a * matrix.a + matrix.b * matrix.b);
				
			}
			
		}
		
		return __scaleX;
		
	}
	
	
	private function set_scaleX (value:Float):Float {
		
		if (__scaleX != value) {
			
			__scaleX = value;
			
			if (matrix.b == 0) {
				
				matrix.a = value;
				
			} else {
				
				var rotation = this.rotation;
				
				var a = __rotationCosine * value;
				var b = __rotationSine * value;
				
				matrix.a = a;
				matrix.b = b;
				
			}
			
			__transformDirty = true;
			
		}
		
		return value;
		
	}
	
	
	private function get_scaleY ():Float {
		
		if (__scaleY == null) {
			
			if (matrix.c == 0) {
				
				__scaleY = matrix.d;
				
			} else {
				
				__scaleY = Math.sqrt (matrix.c * matrix.c + matrix.d * matrix.d);
				
			}
			
		}
		
		return __scaleY;
		
	}
	
	
	private function set_scaleY (value:Float):Float {
		
		if (__scaleY != value) {
			
			__scaleY = value;
			
			if (matrix.c == 0) {
				
				matrix.d = value;
				
			} else {
				
				var rotation = this.rotation;
				
				var c = -__rotationSine * value;
				var d = __rotationCosine * value;
				
				matrix.c = c;
				matrix.d = d;
				
			}
			
			__transformDirty = true;
			
		}
		
		return value;
		
	}
	
	
	private function set_shader (value:Shader):Shader {
		
		__shaderDirty = true;
		return shader = value;
		
	}
	
	
	private function set_tileset (value:Tileset):Tileset {
		
		__sourceDirty = true;
		return tileset = value;
		
	}
	
	
	private function set_visible (value:Bool):Bool {
		
		__visibleDirty = true;
		return visible = value;
		
	}
	
	
	private function get_x ():Float {
		
		return matrix.tx;
		
	}
	
	
	private function get_y ():Float {
		
		return matrix.ty;
		
	}
	
	
	private function set_x (value:Float):Float {
		
		__transformDirty = true;
		return matrix.tx = value;
		
	}
	
	
	private function set_y (value:Float):Float {
		
		__transformDirty = true;
		return matrix.ty = value;
		
	}
	
	
}