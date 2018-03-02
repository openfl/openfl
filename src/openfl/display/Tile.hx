package openfl.display;


import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.geom.ColorTransform)


class Tile #if ((openfl < "9.0.0") && enable_tile_array) implements ITile #end {
	
	
	public var alpha (get, set):Float;
	public var colorTransform (get, set):ColorTransform;
	public var data:Dynamic;
	public var id (get, set):Int;
	public var matrix (get, set):Matrix;
	public var originX (get, set):Float;
	public var originY (get, set):Float;
	public var parent (default, null):TileGroup;
	public var rect (get, set):Rectangle;
	public var rotation (get, set):Float;
	public var scaleX (get, set):Float;
	public var scaleY (get, set):Float;
	@:beta public var shader (get, set):DisplayObjectShader;
	public var tileset (get, set):Tileset;
	public var visible (get, set):Bool;
	public var x (get, set):Float;
	public var y (get, set):Float;
	
	private var __alpha:Float;
	private var __colorTransform:ColorTransform;
	private var __dirty:Bool;
	private var __id:Int;
	private var __length:Int;
	private var __matrix:Matrix;
	private var __originX:Float;
	private var __originY:Float;
	private var __rect:Rectangle;
	private var __rotation:Null<Float>;
	private var __rotationCosine:Float;
	private var __rotationSine:Float;
	private var __scaleX:Null<Float>;
	private var __scaleY:Null<Float>;
	private var __shader:DisplayObjectShader;
	private var __tileset:Tileset;
	private var __visible:Bool;
	
	
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
		
		__dirty = true;
		__length = 0;
		__originX = originX;
		__originY = originY;
		__alpha = 1;
		__visible = true;
		
	}
	
	
	public function clone ():Tile {
		
		var tile = new Tile (__id);
		tile.__alpha = __alpha;
		tile.__originX = __originX;
		tile.__originY = __originY;
		
		if (__rect != null) tile.__rect = __rect.clone ();
		
		tile.matrix = __matrix.clone ();
		tile.__shader = __shader;
		tile.tileset = __tileset;
		
		if (__colorTransform != null) {
			
			#if flash
			tile.__colorTransform = new ColorTransform (__colorTransform.redMultiplier, __colorTransform.greenMultiplier, __colorTransform.blueMultiplier, __colorTransform.alphaMultiplier, __colorTransform.redOffset, __colorTransform.greenOffset, __colorTransform.blueOffset, __colorTransform.alphaOffset);
			#else
			tile.__colorTransform = __colorTransform.__clone ();
			#end
			
		}
		
		return tile;
		
	}
	
	
	public function invalidate ():Void {
		
		__setRenderDirty ();
		
	}
	
	
	private inline function __setRenderDirty ():Void {
		
		#if !flash
		if (!__dirty) {
			
			__dirty = true;
			
			if (parent != null) {
				
				parent.__setRenderDirty ();
				
			}
			
		}
		#end
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private function get_alpha ():Float {
		
		return __alpha;
		
	}
	
	
	private function set_alpha (value:Float):Float {
		
		if (value != __alpha) {
			
			__alpha = value;
			__setRenderDirty ();
			
		}
		
		return value;
		
	}
	
	
	private function get_colorTransform ():ColorTransform {
		
		return __colorTransform;
		
	}
	
	
	private function set_colorTransform (value:ColorTransform):ColorTransform {
		
		if (value != __colorTransform) {
			
			__colorTransform = value;
			__setRenderDirty ();
			
		}
		
		return value;
		
	}
	
	
	private function get_id ():Int {
		
		return __id;
		
	}
	
	
	private function set_id (value:Int):Int {
		
		if (value != __id) {
			
			__id = value;
			__setRenderDirty ();
			
		}
		
		return value;
		
	}
	
	
	private function get_matrix ():Matrix {
		
		return __matrix;
		
	}
	
	
	private function set_matrix (value:Matrix):Matrix {
		
		if (value != __matrix) {
			
			__rotation = null;
			__scaleX = null;
			__scaleY = null;
			__matrix = value;
			__setRenderDirty ();
			
		}
		
		return value;
		
	}
	
	
	private function get_originX ():Float {
		
		return __originX;
		
	}
	
	
	private function set_originX (value:Float):Float {
		
		if (value != __originX) {
			
			__originX = value;
			__setRenderDirty ();
			
		}
		
		return value;
		
	}
	
	
	private function get_originY ():Float {
		
		return __originY;
		
	}
	
	
	private function set_originY (value:Float):Float {
		
		if (value != __originY) {
			
			__originY = value;
			__setRenderDirty ();
			
		}
		
		return value;
		
	}
	
	
	private function get_rect ():Rectangle {
		
		return __rect;
		
	}
	
	
	private function set_rect (value:Rectangle):Rectangle {
		
		if (value != __rect) {
			
			__rect = value;
			__setRenderDirty ();
			
		}
		
		return value;
		
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
		
		if (value != __scaleX) {
			
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
		
		if (value != __scaleY) {
			
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
			
			__setRenderDirty ();
			
		}
		
		return value;
		
	}
	
	
	private function get_shader ():DisplayObjectShader {
		
		return __shader;
		
	}
	
	
	private function set_shader (value:DisplayObjectShader):DisplayObjectShader {
		
		if (value != __shader) {
			
			__shader = value;
			__setRenderDirty ();
			
		}
		
		return value;
		
	}
	
	
	private function get_tileset ():Tileset {
		
		return __tileset;
		
	}
	
	
	private function set_tileset (value:Tileset):Tileset {
		
		if (value != __tileset) {
			
			__tileset = value;
			__setRenderDirty ();
			
		}
		
		return value;
		
	}
	
	
	private function get_visible ():Bool {
		
		return __visible;
		
	}
	
	
	private function set_visible (value:Bool):Bool {
		
		if (value != __visible) {
			
			__visible = value;
			__setRenderDirty ();
			
		}
		
		return value;
		
	}
	
	
	private function get_x ():Float {
		
		return __matrix.tx;
		
	}
	
	
	private function set_x (value:Float):Float {
		
		if (value != __matrix.tx) {
			
			__matrix.tx = value;
			__setRenderDirty ();
			
		}
		
		return value;
		
	}
	
	
	private function get_y ():Float {
		
		return __matrix.ty;
		
	}
	
	
	private function set_y (value:Float):Float {
		
		if (value != __matrix.ty) {
			
			__matrix.ty = value;
			__setRenderDirty ();
			
		}
		
		return value;
		
	}
	
	
}