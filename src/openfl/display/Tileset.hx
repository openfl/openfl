package openfl.display;


import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.Vector;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

#if !flash
@:access(openfl.geom.Rectangle)
#end


class Tileset {
	
	
	public var bitmapData (get, set):BitmapData;
	public var rectData:Vector<Float>;
	public var numRects (get, never):Int;
	
	@:noCompletion private var __bitmapData:BitmapData;
	@:noCompletion private var __data:Array<TileData>;
	
	
	#if openfljs
	@:noCompletion private static function __init__ () {
		
		untyped Object.defineProperties (Tileset.prototype, {
			"bitmapData": { get: untyped __js__ ("function () { return this.get_bitmapData (); }"), set: untyped __js__ ("function (v) { return this.set_bitmapData (v); }") },
			"numRects": { get: untyped __js__ ("function () { return this.get_numRects (); }") }
		});
		
	}
	#end
	
	
	// TODO: Add support for adding uniform tile rectangles (margin, spacing, width, height)
	
	public function new (bitmapData:BitmapData, rects:Array<Rectangle> = null) {
		
		__bitmapData = bitmapData;
		rectData = new Vector<Float> ();
		
		__data = new Array ();
		
		if (rects != null) {
			
			for (rect in rects) {
				addRect (rect);
			}
			
		}
		
	}
	
	
	public function addRect (rect:Rectangle):Int {
		
		if (rect == null) return -1;
		
		rectData.push (rect.x);
		rectData.push (rect.y);
		rectData.push (rect.width);
		rectData.push (rect.height);
		
		var tileData = new TileData (rect);
		tileData.__update (__bitmapData);
		__data.push (tileData);
		
		return __data.length - 1;
		
	}
	
	
	public function clone ():Tileset {
		
		var tileset = new Tileset (__bitmapData, null);
		var rect = #if flash new Rectangle () #else Rectangle.__pool.get () #end;
		
		for (tileData in __data) {
			
			rect.setTo (tileData.x, tileData.y, tileData.width, tileData.height);
			tileset.addRect (rect);
			
		}
		
		#if !flash
		Rectangle.__pool.release (rect);
		#end
		
		return tileset;
		
	}
	
	
	public function hasRect (rect:Rectangle):Bool {
		
		for (tileData in __data) {
			
			if (rect.x == tileData.x && rect.y == tileData.y && rect.width == tileData.height && rect.height == tileData.height) {
				
				return true;
				
			}
			
		}
		
		return false;
		
	}
	
	
	public function getRect (id:Int):Rectangle {
		
		if (id < __data.length && id >= 0) {
			
			return new Rectangle (__data[id].x, __data[id].y, __data[id].width, __data[id].height);
			
		}
		
		return null;
		
	}
	
	
	public function getRectID (rect:Rectangle):Null<Int> {
		
		var tileData;
		
		for (i in 0...__data.length) {
			
			tileData = __data[i];
			
			if (rect.x == tileData.x && rect.y == tileData.y && rect.width == tileData.height && rect.height == tileData.height) {
				
				return i;
				
			}
			
		}
		
		return null;
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	@:noCompletion private function get_bitmapData ():BitmapData {
		
		return __bitmapData;
		
	}
	
	
	@:noCompletion private function set_bitmapData (value:BitmapData):BitmapData {
		
		__bitmapData = value;
		
		for (data in __data) {
			data.__update (__bitmapData);
		}
		
		return value;
		
	}
	
	
	@:noCompletion private function get_numRects ():Int {
		
		return __data.length;
		
	}
	
	
}


#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


@:allow(openfl.display.Tileset) @:dox(hide) private class TileData {
	
	
	public var height:Int;
	public var width:Int;
	public var x:Int;
	public var y:Int;
	
	public var __bitmapData:BitmapData;
	public var __uvHeight:Float;
	public var __uvWidth:Float;
	public var __uvX:Float;
	public var __uvY:Float;
	
	
	public function new (rect:Rectangle = null) {
		
		if (rect != null) {
			
			x = Std.int (rect.x);
			y = Std.int (rect.y);
			width = Std.int (rect.width);
			height = Std.int (rect.height);
			
		}
		
	}
	
	
	@:noCompletion private function __update (bitmapData:BitmapData):Void {
		
		if (bitmapData != null) {
			
			var bitmapWidth = bitmapData.width;
			var bitmapHeight = bitmapData.height;
			
			#if (openfl_power_of_two && !flash)
			var newWidth = 1;
			var newHeight = 1;
			
			while (newWidth < bitmapWidth) {
				
				newWidth <<= 1;
				
			}
			
			while (newHeight < bitmapHeight) {
				
				newHeight <<= 1;
				
			}
			
			bitmapWidth = newWidth;
			bitmapHeight = newHeight;
			#end
			
			__uvX = x / bitmapWidth;
			__uvY = y / bitmapHeight;
			__uvWidth = (x + width) / bitmapWidth;
			__uvHeight = (y + height) / bitmapHeight;
			
			#if flash
			__bitmapData = new BitmapData (width, height);
			__bitmapData.copyPixels (bitmapData, new Rectangle (x, y, width, height), new Point ());
			#end
			
		}
		
	}
	
	
}
