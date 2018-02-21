package openfl.display;


import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.display.TileArray)
@:access(openfl.display.Tilemap)
@:access(openfl.geom.ColorTransform)
@:access(openfl.geom.Matrix)


class Tile implements ITile {
	
	
	private static var __tempMatrix = new Matrix ();
	
	public var alpha (get, set):Float;
	@:beta public var colorTransform (get, set):ColorTransform;
	public var data:Dynamic;
	public var id (get, set):Int;
	public var matrix (get, set):Matrix;
	public var originX (get, set):Float;
	public var originY (get, set):Float;
	public var parent (default, null):Tilemap;
	@:beta public var rect (get, set):Rectangle;
	public var rotation (get, set):Float;
	public var scaleX (get, set):Float;
	public var scaleY (get, set):Float;
	@:beta public var shader (get, set):Shader;
	public var tileset (get, set):Tileset;
	public var visible (get, set):Bool;
	public var x (get, set):Float;
	public var y (get, set):Float;
	
	private var __alpha:Float;
	private var __alphaDirty:Bool;
	private var __colorTransform:ColorTransform;
	private var __colorTransformDirty:Bool;
	private var __id:Int;
	private var __matrix:Matrix;
	private var __originX:Float;
	private var __originY:Float;
	private var __rect:Rectangle;
	private var __rotation:Null<Float>;
	private var __rotationCosine:Float;
	private var __rotationSine:Float;
	private var __scaleX:Null<Float>;
	private var __scaleY:Null<Float>;
	private var __shader:Shader;
	private var __shaderDirty:Bool;
	private var __sourceDirty:Bool;
	private var __tileset:Tileset;
	private var __transformDirty:Bool;
	private var __visible:Bool;
	private var __visibleDirty:Bool;
	
	
	#if openfljs
	private static function __init__ () {
		
		untyped Object.defineProperties (Tile.prototype, {
			"alpha": { get: untyped __js__ ("function () { return this.get_alpha (); }"), set: untyped __js__ ("function (v) { return this.set_alpha (v); }") },
			"colorTransform": { get: untyped __js__ ("function () { return this.get_colorTransform (); }"), set: untyped __js__ ("function (v) { return this.set_colorTransform (v); }") },
			"id": { get: untyped __js__ ("function () { return this.get_id (); }"), set: untyped __js__ ("function (v) { return this.set_id (v); }") },
			"matrix": { get: untyped __js__ ("function () { return this.get_matrix (); }"), set: untyped __js__ ("function (v) { return this.set_matrix (v); }") },
			"originX": { get: untyped __js__ ("function () { return this.get_originX (); }"), set: untyped __js__ ("function (v) { return this.set_originX (v); }") },
			"originY": { get: untyped __js__ ("function () { return this.get_originY (); }"), set: untyped __js__ ("function (v) { return this.set_originY (v); }") },
			"rect": { get: untyped __js__ ("function () { return this.get_rect (); }"), set: untyped __js__ ("function (v) { return this.set_rect (v); }") },
			"rotation": { get: untyped __js__ ("function () { return this.get_rotation (); }"), set: untyped __js__ ("function (v) { return this.set_rotation (v); }") },
			"scaleX": { get: untyped __js__ ("function () { return this.get_scaleX (); }"), set: untyped __js__ ("function (v) { return this.set_scaleX (v); }") },
			"scaleY": { get: untyped __js__ ("function () { return this.get_scaleY (); }"), set: untyped __js__ ("function (v) { return this.set_scaleY (v); }") },
			"shader": { get: untyped __js__ ("function () { return this.get_shader (); }"), set: untyped __js__ ("function (v) { return this.set_shader (v); }") },
			"tileset": { get: untyped __js__ ("function () { return this.get_tileset (); }"), set: untyped __js__ ("function (v) { return this.set_tileset (v); }") },
			"visible": { get: untyped __js__ ("function () { return this.get_visible (); }"), set: untyped __js__ ("function (v) { return this.set_visible (v); }") },
			"x": { get: untyped __js__ ("function () { return this.get_x (); }"), set: untyped __js__ ("function (v) { return this.set_x (v); }") },
			"y": { get: untyped __js__ ("function () { return this.get_y (); }"), set: untyped __js__ ("function (v) { return this.set_y (v); }") },
		});
		
	}
	#end
	
	
	public function new (id:Int = 0, x:Float = 0, y:Float = 0, scaleX:Float = 1, scaleY:Float = 1, rotation:Float = 0, originX:Float = 0, originY:Float = 0) {
		
		__id = id;
		
		__matrix = new Matrix ();
		if (x != 0) this.x = x;
		if (y != 0) this.y = y;
		if (scaleX != 1) this.scaleX = scaleX;
		if (scaleY != 1) this.scaleY = scaleY;
		if (rotation != 0) this.rotation = rotation;
		
		__originX = originX;
		__originY = originY;
		__alpha = 1;
		__visible = true;
		
		__alphaDirty = true;
		__sourceDirty = true;
		__transformDirty = true;
		__visibleDirty = true;
		
	}
	
	
	public function clone ():Tile {
		
		var tile = new Tile (__id);
		tile.matrix = __matrix.clone ();
		tile.tileset = __tileset;
		return tile;
		
	}
	
	
	private static function __fromTileArray (position:Int, tileArray:TileArray):Tile {
		
		var cachePosition = tileArray.position;
		tileArray.position = position;
		
		var tile = new Tile ();
		tile.alpha = tileArray.alpha;
		tile.id = tileArray.id;
		tileArray.matrix = tile.matrix;
		
		tileArray.position = cachePosition;
		
		return tile;
		
	}
	
	
	private inline function __setRenderDirty ():Void {
		
		#if !flash
		if (parent != null) {
			
			parent.__setRenderDirty ();
			
		}
		#end
		
	}
	
	
	private function __updateTileArray (position:Int, tileArray:TileArray, forceUpdate:Bool):Void {
		
		var cachePosition = tileArray.position;
		tileArray.position = position;
		
		if (__shaderDirty || forceUpdate) {
			
			tileArray.shader = __shader;
			__shaderDirty = false;
			
		}
		
		if (__colorTransformDirty || forceUpdate) {
			
			tileArray.colorTransform = __colorTransform;
			__colorTransformDirty = false;
			
		}
		
		if (__visibleDirty || forceUpdate) {
			
			tileArray.visible = __visible;
			tileArray.__bufferDirty = true;
			__visibleDirty = false;
			
		}
		
		if (__alphaDirty || forceUpdate) {
			
			tileArray.alpha = __alpha;
			tileArray.__bufferDirty = true;
			__alphaDirty = false;
			
		}
		
		if (__sourceDirty || forceUpdate) {
			
			if (__rect == null) {
				
				tileArray.id = __id;
				
			} else {
				
				tileArray.rect = rect;
				
			}
			
			tileArray.tileset = __tileset;
			tileArray.__bufferDirty = true;
			__sourceDirty = true;
			
		}
		
		if (__transformDirty || forceUpdate) {
			
			if (__originX != 0 || __originY != 0) {
				
				__tempMatrix.setTo (1, 0, 0, 1, -__originX, -__originY);
				__tempMatrix.concat (__matrix);
				tileArray.matrix = __tempMatrix;
				
			} else {
				
				tileArray.matrix = __matrix;
				
			}
			
			tileArray.__bufferDirty = true;
			__transformDirty = false;
			
		}
		
		tileArray.position = cachePosition;
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private function get_alpha ():Float {
		
		return __alpha;
		
	}
	
	
	private function set_alpha (value:Float):Float {
		
		__alphaDirty = true;
		__setRenderDirty ();
		return __alpha = value;
		
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
		__setRenderDirty ();
		return value;
		
		#end
		
	}
	
	
	private function get_id ():Int {
		
		return __id;
		
	}
	
	
	private function set_id (value:Int):Int {
		
		__sourceDirty = true;
		__setRenderDirty ();
		return __id = value;
		
	}
	
	
	private function get_matrix ():Matrix {
		
		return __matrix;
		
	}
	
	
	private function set_matrix (value:Matrix):Matrix {
		
		__rotation = null;
		__scaleX = null;
		__scaleY = null;
		__transformDirty = true;
		__setRenderDirty ();
		return __matrix = value;
		
	}
	
	
	private function get_originX ():Float {
		
		return __originX;
		
	}
	
	
	private function set_originX (value:Float):Float {
		
		__transformDirty = true;
		__setRenderDirty ();
		return __originX = value;
		
	}
	
	
	private function get_originY ():Float {
		
		return __originY;
		
	}
	
	
	private function set_originY (value:Float):Float {
		
		__transformDirty = true;
		__setRenderDirty ();
		return __originY = value;
		
	}
	
	
	private function get_rect ():Rectangle {
		
		return __rect;
		
	}
	
	
	private function set_rect (value:Rectangle):Rectangle {
		
		__sourceDirty = true;
		__setRenderDirty ();
		return __rect = value;
		
	}
	
	
	private function get_rotation ():Float {
		
		if (__rotation == null) {
			
			if (__matrix.b == 0 && __matrix.c == 0) {
				
				__rotation = 0;
				__rotationSine = 0;
				__rotationCosine = 1;
				
			} else {
				
				var radians = Math.atan2 (__matrix.d, __matrix.c) - (Math.PI / 2);
				
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
			
			__matrix.a = __rotationCosine * __scaleX;
			__matrix.b = __rotationSine * __scaleX;
			__matrix.c = -__rotationSine * __scaleY;
			__matrix.d = __rotationCosine * __scaleY;
			
			__transformDirty = true;
			__setRenderDirty ();
			
		}
		
		return value;
		
	}
	
	
	private function get_scaleX ():Float {
		
		if (__scaleX == null) {
			
			if (matrix.b == 0) {
				
				__scaleX = __matrix.a;
				
			} else {
				
				__scaleX = Math.sqrt (__matrix.a * __matrix.a + __matrix.b * __matrix.b);
				
			}
			
		}
		
		return __scaleX;
		
	}
	
	
	private function set_scaleX (value:Float):Float {
		
		if (__scaleX != value) {
			
			__scaleX = value;
			
			if (__matrix.b == 0) {
				
				__matrix.a = value;
				
			} else {
				
				var rotation = this.rotation;
				
				var a = __rotationCosine * value;
				var b = __rotationSine * value;
				
				__matrix.a = a;
				__matrix.b = b;
				
			}
			
			__transformDirty = true;
			__setRenderDirty ();
			
		}
		
		return value;
		
	}
	
	
	private function get_scaleY ():Float {
		
		if (__scaleY == null) {
			
			if (__matrix.c == 0) {
				
				__scaleY = matrix.d;
				
			} else {
				
				__scaleY = Math.sqrt (__matrix.c * __matrix.c + __matrix.d * __matrix.d);
				
			}
			
		}
		
		return __scaleY;
		
	}
	
	
	private function set_scaleY (value:Float):Float {
		
		if (__scaleY != value) {
			
			__scaleY = value;
			
			if (__matrix.c == 0) {
				
				__matrix.d = value;
				
			} else {
				
				var rotation = this.rotation;
				
				var c = -__rotationSine * value;
				var d = __rotationCosine * value;
				
				__matrix.c = c;
				__matrix.d = d;
				
			}
			
			__transformDirty = true;
			__setRenderDirty ();
			
		}
		
		return value;
		
	}
	
	
	private function get_shader ():Shader {
		
		return __shader;
		
	}
	
	
	private function set_shader (value:Shader):Shader {
		
		__shaderDirty = true;
		__setRenderDirty ();
		return __shader = value;
		
	}
	
	
	private function get_tileset ():Tileset {
		
		return __tileset;
		
	}
	
	
	private function set_tileset (value:Tileset):Tileset {
		
		__sourceDirty = true;
		__setRenderDirty ();
		return __tileset = value;
		
	}
	
	
	private function get_visible ():Bool {
		
		return __visible;
		
	}
	
	
	private function set_visible (value:Bool):Bool {
		
		__visibleDirty = true;
		__setRenderDirty ();
		return __visible = value;
		
	}
	
	
	private function get_x ():Float {
		
		return __matrix.tx;
		
	}
	
	
	private function set_x (value:Float):Float {
		
		__transformDirty = true;
		__setRenderDirty ();
		return __matrix.tx = value;
		
	}
	
	
	private function get_y ():Float {
		
		return __matrix.ty;
		
	}
	
	
	private function set_y (value:Float):Float {
		
		__transformDirty = true;
		__setRenderDirty ();
		return __matrix.ty = value;
		
	}
	
	
}