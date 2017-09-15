package format.swf;


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

#if (lime && !lime_legacy)
import lime.graphics.Image;
import lime.app.Future;
import lime.app.Promise;
#end

#if !flash
import format.SWF;
#end


@:keep class SWFLibrary extends AssetLibrary {
	
	
	private var context:LoaderContext;
	private var id:String;
	private var loader:Loader;
	
	#if !flash
	private var swf:SWF;
	#end
	
	
	public function new (id:String) {
		
		super ();
		
		this.id = id;
		
	}
	
	
	#if (!lime || lime_legacy)
	public override function exists (id:String, type:AssetType):Bool {
	#else
	public override function exists (id:String, type:String):Bool {
	#end
		
		if (id == "" && type == cast AssetType.MOVIE_CLIP) {
			
			return true;
			
		}
		
		if (type == (cast AssetType.IMAGE) || type == (cast AssetType.MOVIE_CLIP)) {
			
			#if flash
			
			return loader.contentLoaderInfo.applicationDomain.hasDefinition (id);
			
			#else
			
			return swf.hasSymbol (id);
			
			#end
			
		}
		
		return false;
		
	}
	
	
	#if (!lime || lime_legacy)
	public override function getBitmapData (id:String):BitmapData {
		
		#if flash
		
		//var ret/*:Class*/ = loader.contentLoaderInfo.applicationDomain.getDefinition (id);
		//trace(ret);
		
		var bmd = Type.createEmptyInstance(cast loader.contentLoaderInfo.applicationDomain.getDefinition (id));
		return bmd;
		
		#else
		
		return swf.getBitmapData (id);
		
		#end
		
	}
	#else
	public override function getImage (id:String):Image {
		
		#if flash
		
		return Image.fromBitmapData (Type.createEmptyInstance(cast loader.contentLoaderInfo.applicationDomain.getDefinition (id)));
		
		#else
		
		return Image.fromBitmapData (swf.getBitmapData (id));
		
		#end
		
	}
	#end
	
	
	public override function getMovieClip (id:String):MovieClip {
		
		#if flash
		
		if (id == "") {
			
			return cast loader.content;
			
		} else {
			
			return cast Type.createInstance (loader.contentLoaderInfo.applicationDomain.getDefinition (id), []);
			
		}
		
		#else
		
		return swf.createMovieClip (id);
		
		#end
		
	}
	
	
	#if !openfl_legacy
	public override function load ():Future<lime.Assets.AssetLibrary> {
		
		var promise = new Promise<lime.Assets.AssetLibrary> ();
		
		#if flash
		
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
		
		#else
		
		if (swf == null) {
			
			swf = new SWF (Assets.getBytes (id));
			promise.complete (this);
			
		}
		
		#end
		
		return promise.future;
		
	}
	#else
	public override function load (handler:AssetLibrary->Void):Void {
		
		#if flash
		
		context = new LoaderContext (false, ApplicationDomain.currentDomain, null);
		context.allowCodeImport = true;
		
		if (Assets.isLocal (id, AssetType.BINARY)) {
			
			loader = new Loader ();
			loader.contentLoaderInfo.addEventListener (Event.COMPLETE, function (_) {
				
				handler (this);
				
			});
			loader.loadBytes (Assets.getBytes (id), context);
			
		} else {
			
			loader = new Loader ();
			loader.contentLoaderInfo.addEventListener (Event.COMPLETE, function (_) {
				
				handler (this);
				
			});
			loader.load (new URLRequest (Assets.getPath (id)), context);
			
		}
		
		#else
		
		if (swf == null) {
			
			swf = new SWF (Assets.getBytes (id));
			handler (this);
			
		}
		
		#end
		
	}
	#end
	
	
}