package openfl._internal.swf;


import lime.graphics.Image;
import lime.app.Future;
import lime.app.Promise;
import openfl.display.BitmapData;
import openfl.display.Loader;
import openfl.display.MovieClip;
import openfl.events.Event;
import openfl.media.Sound;
import openfl.text.Font;
import openfl.utils.ByteArray;
import openfl._internal.symbols.BitmapSymbol;
import openfl._internal.swf.SWFLite;
import haxe.Unserializer;
import openfl.Assets;


@:keep class SWFLiteLibrary extends AssetLibrary {
	
	
	private var swf:SWFLite;
	
	
	public function new (id:String) {
		
		super ();
		
		if (id != null) {
			
			swf = SWFLite.unserialize (Assets.getText (id));
			
		}
		
		// Hack to include filter classes, macro.include is not working properly
		
		//var filter = openfl.filters.BlurFilter;
		//var filter = openfl.filters.DropShadowFilter;
		//var filter = openfl.filters.GlowFilter;
		
	}
	
	
	public override function exists (id:String, type:String):Bool {
		
		if (id == "" && type == (cast AssetType.MOVIE_CLIP)) {
			
			return true;
			
		}
		
		if (type == (cast AssetType.IMAGE) || type == (cast AssetType.MOVIE_CLIP)) {
			
			return swf.hasSymbol (id);
			
		}
		
		return false;
		
	}
	
	
	public override function getImage (id:String):Image {
		
		return Image.fromBitmapData (swf.getBitmapData (id));
		
	}
	
	
	public override function getMovieClip (id:String):MovieClip {
		
		return swf.createMovieClip (id);
		
	}
	
	
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