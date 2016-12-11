package openfl._internal.swf;


import flash.display.BitmapData;
import flash.display.Loader;
import flash.display.MovieClip;
import flash.events.Event;
import flash.media.Sound;
import flash.net.URLRequest;
import flash.system.ApplicationDomain;
import flash.system.LoaderContext;
import flash.text.Font;
import flash.utils.ByteArray;
import haxe.Unserializer;
import openfl.Assets;

import lime.graphics.Image;
import lime.app.Future;
import lime.app.Promise;


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
			
			return cast loader.content;
			
		} else {
			
			return cast Type.createInstance (loader.contentLoaderInfo.applicationDomain.getDefinition (id), []);
			
		}
		
	}
	
	
	public override function load ():Future<lime.utils.AssetLibrary> {
		
		var promise = new Promise<lime.utils.AssetLibrary> ();
		
		context = new LoaderContext (false, ApplicationDomain.currentDomain, null);
		context.allowCodeImport = true;
		
		if (Assets.isLocal (id, AssetType.BINARY)) {
			
			loader = new Loader ();
			loader.contentLoaderInfo.addEventListener (Event.COMPLETE, function (_) {
				
				promise.complete (this);
				
			});
			loader.loadBytes (Assets.getBytes (id), context);
			
		} else {
			
			loader = new Loader ();
			loader.contentLoaderInfo.addEventListener (Event.COMPLETE, function (_) {
				
				promise.complete (this);
				
			});
			loader.load (new URLRequest (Assets.getPath (id)), context);
			
		}
		
		return promise.future;
		
	}
	
	
}