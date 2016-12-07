package openfl._internal.swf;


import haxe.Unserializer;
import lime.app.Future;
import lime.app.Promise;
import lime.graphics.Image;
import lime.graphics.ImageChannel;
import lime.math.Vector2;
import lime.Assets in LimeAssets;
import lime.Assets.AssetLibrary in LimeAssetLibrary;
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
			
			return swf != null && swf.hasSymbol (id);
			
		}
		
		return false;
		
	}
	
	
	public override function getImage (id:String):Image {
		
		return swf != null? Image.fromBitmapData (swf.getBitmapData (id)) : null;
		
	}
	
	
	public override function getMovieClip (id:String):MovieClip {
		
		return swf != null? swf.createMovieClip (id) : null;
		
	}
	
	
	public override function isLocal (id:String, type:String):Bool {
		
		return swf != null && switch (cast(type, Assets.AssetType)) {
			
			case MOVIE_CLIP: true;
			
			default:         Assets.cache.exists(id, cast type);
			
		}
		
	}
	
	
	public override function loadText (id:String):Future<String> {
		
		var text = super.loadText (id);
		
		if (swf == null) {
			
			text.onComplete (function (text) this.swf = SWFLite.unserialize (text));
			
		}
			
		return text;
		
	}
	
	
	public override function loadFromManifest (manifest:Array<{type:String, id:String}>):Future<LimeAssetLibrary> {
		
		for (asset in manifest) {
			
			if (asset.type == cast TEXT) {
				
				var promise = new Promise<LimeAssetLibrary> ();
				
				var text = loadText (asset.id);
				var textSize:Int = 0;
				
				// We count loading the TEXT asset as half the work.
				//
				// The other half is loading BitmapData assets.
				// To account for this, we integer divide the progress by 2
				// using: >> 1
				text.onProgress (function (a,b) {
					textSize = b;
					promise.progress (a >> 1, b);
				});
				
				text.onComplete (function (text) {
					
					var rest = this.load ();
					
					// When text is loaded, the work is half done.
					//
					// To account for this:
					// - start counting from half of total (b)
					// - divide progress (a) by 2
					rest.onProgress (function (a,b) promise.progress ((b >> 1) + (a >> 1), b));
					rest.onComplete (promise.complete);
					rest.onError    (promise.error);
					
				});
				
				text.onError (promise.error);
				
				return promise.future;
			}
			
		}
		
		return load ();
		
	}
	
	
	public override function load ():Future<LimeAssetLibrary> {
		
		var promise = new Promise<LimeAssetLibrary> ();
		
		var bitmapSymbols:Array<BitmapSymbol> = [];
		
		if (swf != null) for (symbol in swf.symbols) {
			
			if (Std.is (symbol, BitmapSymbol)) {
				
				bitmapSymbols.push (cast symbol);
				
			}
			
		}
		
		if (bitmapSymbols.length == 0) {
			
			promise.complete (this);
			
		} else {
			
			var loaded = -1, total = bitmapSymbols.length;
			
			var onLoad : ?Dynamic -> Void;
			onLoad = function (?bitmapData) {
				
				loaded++;
				trace("SWFLiteLibrary onLoad", loaded, total);
				
				promise.progress (loaded * 1000, total * 1000);
				
				if (loaded == total) {
					
					promise.complete (this);
					
				} else {
					
					var symbol = bitmapSymbols[loaded];
						
					if (symbol.getBitmapDataFromCache() != null) {
						
						onLoad ();
						
					} else {
					
						
						symbol.loadBitmapData (this)
							.onComplete (onLoad)
							.onProgress (function (bytesLoaded, bytesTotal) {
								
								var weightedLoad  : Int = (loaded * 1000) + Std.int((bytesLoaded / bytesTotal) * 1000);
								var weightedTotal : Int = total * 1000;
								trace ("BitmapData loaded", bytesLoaded, bytesTotal, weightedLoad, weightedTotal, weightedLoad/weightedTotal);
								promise.progress (weightedLoad, weightedTotal);
								
							}).onError (promise.error);
					
					}
				}
				
			};
			
			onLoad ();
			
		}
		
		return promise.future;
		
	}
	
	
	public override function unload ():Void {
		
		if (swf == null) return;
		
		var bitmap:BitmapSymbol;
		
		for (symbol in swf.symbols) {
			
			if (Std.is (symbol, BitmapSymbol)) {
				
				bitmap = cast symbol;
				Assets.cache.removeBitmapData (bitmap.path);
				
			}
			
		}
		
	}
	
	
}