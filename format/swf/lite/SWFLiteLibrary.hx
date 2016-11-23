package format.swf.lite;


import flash.display.BitmapData;
import flash.display.Loader;
import flash.display.MovieClip;
import flash.events.Event;
import flash.media.Sound;
import flash.text.Font;
import flash.utils.ByteArray;
import format.swf.lite.symbols.BitmapSymbol;
import format.swf.lite.SWFLite;
import haxe.Unserializer;
import openfl.Assets;

#if (lime && !lime_legacy)
import lime.graphics.Image;
import lime.app.Future;
import lime.app.Promise;
#end


@:keep class SWFLiteLibrary extends AssetLibrary {
	
	
	private var swf:SWFLite;
	
	
	public function new (id:String) {
		
		super ();
		
		if (id != null) {
			
			swf = SWFLite.unserialize (Assets.getText (id));
			SWFLite.instances.set (id, swf);
			
		}
		
		// Hack to include filter classes, macro.include is not working properly
		
		//var filter = flash.filters.BlurFilter;
		//var filter = flash.filters.DropShadowFilter;
		//var filter = flash.filters.GlowFilter;
		
	}
	
	
	#if (!lime || lime_legacy)
	public override function exists (id:String, type:AssetType):Bool {
	#else
	public override function exists (id:String, type:String):Bool {
	#end
		
		if (id == "" && type == (cast AssetType.MOVIE_CLIP)) {
			
			return true;
			
		}
		
		if (type == (cast AssetType.IMAGE) || type == (cast AssetType.MOVIE_CLIP)) {
			
			return swf.hasSymbol (id);
			
		}
		
		return false;
		
	}
	
	
	#if (!lime || lime_legacy)
	public override function getBitmapData (id:String):BitmapData {
		
		return swf.getBitmapData (id);
		
	}
	#else
	public override function getImage (id:String):Image {
		
		return Image.fromBitmapData (swf.getBitmapData (id));
		
	}
	#end
	
	
	public override function getMovieClip (id:String):MovieClip {
		
		return swf.createMovieClip (id);
		
	}
	
	
	#if !openfl_legacy
	public override function load ():Future<lime.Assets.AssetLibrary> {
		
		var promise = new Promise<lime.Assets.AssetLibrary> ();
		
		#if swflite_preload
		var paths = [];
		var bitmap:BitmapSymbol;
		
		for (symbol in swf.symbols) {
			
			if (Std.is (symbol, BitmapSymbol)) {
				
				bitmap = cast symbol;
				paths.push (bitmap.path);
				
			}
			
		}
		
		if (paths.length == 0) {
			
			promise.complete (this);
			
		} else {
			
			var loaded = 0;
			
			var onLoad = function (_) {
				
				loaded++;
				
				promise.progress (loaded / paths.length);
				
				if (loaded == paths.length) {
					
					promise.complete (this);
					
				}
				
			};
			
			for (path in paths) {
				
				Assets.loadBitmapData (path).onComplete (onLoad).onError (promise.error);
				
			}
			
		}
		#else
		promise.complete (this);
		#end
		
		return promise.future;
		
	}
	#else
	public override function load (handler:AssetLibrary->Void):Void {
		
		#if swflite_preload
		var paths = [];
		var bitmap:BitmapSymbol;
		
		for (symbol in swf.symbols) {
			
			if (Std.is (symbol, BitmapSymbol)) {
				
				bitmap = cast symbol;
				paths.push (bitmap.path);
				
			}
			
		}
		
		if (paths.length == 0) {
			
			handler (this);
			
		} else {
			
			var loaded = 0;
			
			var onLoad = function (_) {
				
				loaded++;
				
				if (loaded == paths.length) {
					
					handler (this);
					
				}
				
			};
			
			for (path in paths) {
				
				Assets.loadBitmapData (path, onLoad);
				
			}
			
		}
		#else
		handler (this);
		#end
		
	}
	#end
	
	
	public override function unload ():Void {
		
		var bitmap:BitmapSymbol;
		
		for (symbol in swf.symbols) {
			
			if (Std.is (symbol, BitmapSymbol)) {
				
				bitmap = cast symbol;
				Assets.cache.removeBitmapData (bitmap.path);
				
			}
			
		}
		
	}
	
	
}