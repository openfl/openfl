package openfl._internal.swf;


import haxe.Unserializer;
import lime.graphics.Image;
import lime.app.Future;
import lime.app.Promise;
import openfl.display.BitmapData;
import openfl.display.Loader;
import openfl.display.MovieClip;
import openfl.events.Event;
import openfl.media.Sound;
import openfl.net.URLRequest;
import openfl.system.ApplicationDomain;
import openfl.system.LoaderContext;
import openfl.text.Font;
import openfl.utils.ByteArray;
import openfl.Assets;

#if flash
import flash.display.AVM1Movie;
#end


@:keep class SWFLibrary extends AssetLibrary {
	
	
	private var context:LoaderContext;
	private var id:String;
	private var loader:Loader;
	
	
	public function new (id:String) {
		
		super ();
		
		this.id = id;
		
	}
	
	
	public override function exists (id:String, type:String):Bool {
		
		if (id == "" && type == cast AssetType.MOVIE_CLIP) {
			
			return true;
			
		}
		
		if (type == (cast AssetType.IMAGE) || type == (cast AssetType.MOVIE_CLIP)) {
			
			return loader.contentLoaderInfo.applicationDomain.hasDefinition (id);
			
		}
		
		return false;
		
	}
	
	
	public override function getImage (id:String):Image {
		
		return Image.fromBitmapData (Type.createEmptyInstance(cast loader.contentLoaderInfo.applicationDomain.getDefinition (id)));
		
	}
	
	
	public override function getMovieClip (id:String):MovieClip {
		
		if (id == "") {
			
			#if flash
			if (Std.is (loader.content, AVM1Movie)) {
				
				var clip = new MovieClip ();
				clip.addChild (loader);
				return clip;
				
			}
			#end
			
			return cast loader.content;
			
		} else {
			
			return cast Type.createInstance (loader.contentLoaderInfo.applicationDomain.getDefinition (id), []);
			
		}
		
	}
	
	
	public override function isLocal (id:String, type:String):Bool {
		
		return true;
		
	}
	
	
	public override function load ():Future<lime.utils.AssetLibrary> {
		
		var promise = new Promise<lime.utils.AssetLibrary> ();
		
		context = new LoaderContext (false, ApplicationDomain.currentDomain, null);
		context.allowCodeImport = true;
		
		loader = new Loader ();
		loader.contentLoaderInfo.addEventListener (Event.COMPLETE, function (_) {
			
			promise.complete (this);
			
		});
		loader.load (new URLRequest (paths.get (id)), context);
		
		return promise.future;
		
	}
	
	
}