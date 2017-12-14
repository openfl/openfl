package openfl.display;


import openfl.geom.Point;
import openfl.geom.Rectangle;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

#if !flash
@:access(openfl.geom.Rectangle)
#end


class Tileset {
	
	
	public var bitmapData (get, set):BitmapData;
	
	private var __bitmapData:BitmapData;
	private var __data:Array<TileData>;
	
	
	#if openfljs
	private static function __init__ () {
		
		untyped Object.defineProperty (Tileset.prototype, "bitmapData", { get: untyped __js__ ("function () { return this.get_bitmapData (); }"), set: untyped __js__ ("function (v) { return this.set_bitmapData (v); }") });
		
	}
	#end
	
	
	// TODO: Add support for adding uniform tile rectangles (margin, spacing, width, height)
	
	public function new (bitmapData:BitmapData, rects:Array<Rectangle> = null) {
		
		__data = new Array ();
		
		__bitmapData = bitmapData;
		
		if (rects != null) {
			
			for (rect in rects) {
				addRect (rect);
			}
			
		}
		
	}
	
	
	public function addRect (rect:Rectangle):Int {
		
		if (rect == null) return -1;
		
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
	
	
	public function getRect (id:Int):Rectangle {
		
		if (id < __data.length && id >= 0) {
			
			return new Rectangle (__data[id].x, __data[id].y, __data[id].width, __data[id].height);
			
		}
		
		return null;
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private function get_bitmapData ():BitmapData {
		
		return __bitmapData;
		
	}
	
	
	private function set_bitmapData (value:BitmapData):BitmapData {
		
		__bitmapData = value;
		
		for (data in __data) {
			data.__update (__bitmapData);
		}
		
		return value;
		
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
	
	
	private function __update (bitmapData:BitmapData):Void {
		
		if (bitmapData != null) {
			
			__uvX = x / bitmapData.width;
			__uvY = y / bitmapData.height;
			__uvWidth = (x + width) / bitmapData.width;
			__uvHeight = (y + height) / bitmapData.height;
			
			#if flash
			__bitmapData = new BitmapData (width, height);
			__bitmapData.copyPixels (bitmapData, new Rectangle (x, y, width, height), new Point ());
			#end
			
		}
		
	}
	
	
}