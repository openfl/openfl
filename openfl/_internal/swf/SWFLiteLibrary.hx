package openfl._internal.swf;


import haxe.Unserializer;
import lime.app.Future;
import lime.app.Promise;
import lime.graphics.Image;
import lime.graphics.ImageChannel;
import lime.math.Vector2;
import lime.Assets in LimeAssets;
import openfl._internal.swf.SWFLite;
import openfl._internal.symbols.BitmapSymbol;
import openfl.display.BitmapData;
import openfl.display.Loader;
import openfl.display.MovieClip;
import openfl.events.Event;
import openfl.media.Sound;
import openfl.text.Font;
import openfl.utils.ByteArray;
import openfl.Assets;


@:keep class SWFLiteLibrary extends AssetLibrary {
	
	
	private var swf:SWFLite;
	
	
	public function new (id:String) {
		
		super ();
		
		if (id != null) {
			
			swf = SWFLite.unserialize (Assets.getText (id));
			
		}
		
		// Hack to include filter classes, macro.include is not working properly
		
		//var filter = flash.filters.BlurFilter;
		//var filter = flash.filters.DropShadowFilter;
		//var filter = flash.filters.GlowFilter;
		
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
		
		#if (swf_preload || swflite_preload)
		
		var bitmapSymbols:Array<BitmapSymbol> = [];
		
		for (symbol in swf.symbols) {
			
			if (Std.is (symbol, BitmapSymbol)) {
				
				bitmapSymbols.push (cast symbol);
				
			}
			
		}
		
		if (bitmapSymbols.length == 0) {
			
			promise.complete (this);
			
		} else {
			
			var loaded = -1;
			
			var onLoad = function () {
				
				loaded++;
				
				promise.progress (loaded, bitmapSymbols.length);
				
				if (loaded == bitmapSymbols.length) {
					
					promise.complete (this);
					
				}
				
			};
			
			for (symbol in bitmapSymbols) {
				
				if (Assets.cache.hasBitmapData (symbol.path)) {
					
					onLoad ();
					
				} else {
					
					LimeAssets.loadImage (symbol.path, false).onComplete (function (image) {
						
						if (image != null) {
							
							if (symbol.alpha != null && symbol.alpha != "") {
								
								LimeAssets.loadImage (symbol.alpha, false).onComplete (function (alpha) {
									
									if (alpha != null) {
										
										image.copyChannel (alpha, alpha.rect, new Vector2 (), ImageChannel.RED, ImageChannel.ALPHA);
										image.buffer.premultiplied = true;
										
										#if !sys
										image.premultiplied = true;
										#end
										
										var bitmapData = BitmapData.fromImage (image);
										Assets.cache.setBitmapData (symbol.path, bitmapData);
										
										onLoad ();
										
									} else {
										
										promise.error ('Failed to load image alpha : ${symbol.alpha}');
										
									}
									
								}).onError (promise.error);
								
							} else {
								
								var bitmapData = BitmapData.fromImage (image);
								Assets.cache.setBitmapData (symbol.path, bitmapData);
								onLoad ();
								
							}
							
						} else {
							
							promise.error ('Failed to load image : ${symbol.path}');
							
						}
						
					}).onError (promise.error);
					
				}
				
			}
			
			onLoad ();
			
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