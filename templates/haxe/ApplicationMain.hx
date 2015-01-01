import lime.Assets;
#if !macro


class ApplicationMain {
	
	
	public static var config:lime.app.Config;
	public static var preloader:openfl.display.Preloader;
	
	private static var app:lime.app.Application;
	
	
	public static function create ():Void {
		
		app = new openfl.display.Application ();
		app.create (config);
		
		var display = ::if (PRELOADER_NAME != "")::new ::PRELOADER_NAME:: ()::else::new NMEPreloader ()::end::;
		
		preloader = new openfl.display.Preloader (display);
		preloader.onComplete = init;
		preloader.create (config);
		
		#if js
		var urls = [];
		var types = [];
		
		::foreach assets::::if (embed)::
		urls.push (::if (type == "font")::"::fontName::"::else::"::resourceName::"::end::);
		::if (type == "image")::types.push (AssetType.IMAGE);
		::elseif (type == "binary")::types.push (AssetType.BINARY);
		::elseif (type == "text")::types.push (AssetType.TEXT);
		::elseif (type == "font")::types.push (AssetType.FONT);
		::elseif (type == "sound")::types.push (AssetType.SOUND);
		::elseif (type == "music")::types.push (AssetType.MUSIC);
		::else::types.push (null);::end::
		::end::::end::
		
		preloader.load (urls, types);
		#end
		
		var result = app.exec ();
		
		#if sys
		Sys.exit (result);
		#end
		
	}
	
	
	public static function init ():Void {
		
		var loaded = 0;
		var total = 0;
		var library_onLoad = function (__) {
			
			loaded++;
			
			if (loaded == total) {
				
				start ();
				
			}
			
		}
		
		preloader = null;
		
		::if (libraries != null)::::foreach libraries::::if (preload)::
		total++;
		openfl.Assets.loadLibrary ("::name::", library_onLoad);
		::end::::end::::end::
		
		if (loaded == total) {
			
			start ();
			
		}
		
	}
	
	
	public static function main () {
		
		config = {
			
			antialiasing: Std.int (::WIN_ANTIALIASING::),
			background: Std.int (::WIN_BACKGROUND::),
			borderless: ::WIN_BORDERLESS::,
			depthBuffer: ::WIN_DEPTH_BUFFER::,
			fps: Std.int (::WIN_FPS::),
			fullscreen: ::WIN_FULLSCREEN::,
			height: Std.int (::WIN_HEIGHT::),
			orientation: "::WIN_ORIENTATION::",
			resizable: ::WIN_RESIZABLE::,
			stencilBuffer: ::WIN_STENCIL_BUFFER::,
			title: "::APP_TITLE::",
			vsync: ::WIN_VSYNC::,
			width: Std.int (::WIN_WIDTH::),
			
		}
		
		#if js
		#if munit
		flash.Lib.embed (null, ::WIN_WIDTH::, ::WIN_HEIGHT::, "::WIN_FLASHBACKGROUND::");
		#end
		#else
		create ();
		#end
		
	}
	
	
	public static function start ():Void {
		
		openfl.Lib.current.stage.align = openfl.display.StageAlign.TOP_LEFT;
		openfl.Lib.current.stage.scaleMode = openfl.display.StageScaleMode.NO_SCALE;
		
		var hasMain = false;
		
		for (methodName in Type.getClassFields (::APP_MAIN::)) {
			
			if (methodName == "main") {
				
				hasMain = true;
				break;
				
			}
			
		}
		
		if (hasMain) {
			
			Reflect.callMethod (::APP_MAIN::, Reflect.field (::APP_MAIN::, "main"), []);
			
		} else {
			
			var instance:DocumentClass = Type.createInstance (DocumentClass, []);
			
			/*if (Std.is (instance, openfl.display.DisplayObject)) {
				
				openfl.Lib.current.addChild (cast instance);
				
			}*/
			
		}
		
		openfl.Lib.current.stage.dispatchEvent (new openfl.events.Event (openfl.events.Event.RESIZE, false, false));
		
	}
	
	
	#if neko
	@:noCompletion public static function __init__ () {
		
		var loader = new neko.vm.Loader (untyped $loader);
		loader.addPath (haxe.io.Path.directory (Sys.executablePath ()));
		loader.addPath ("./");
		loader.addPath ("@executable_path/");
		
	}
	#end
	
	
}


@:build(DocumentClass.build())
@:keep class DocumentClass extends ::APP_MAIN:: {}


#else


import haxe.macro.Context;
import haxe.macro.Expr;


class DocumentClass {
	
	
	macro public static function build ():Array<Field> {
		
		var classType = Context.getLocalClass ().get ();
		var searchTypes = classType;
		
		while (searchTypes.superClass != null) {
			
			if (searchTypes.pack.length == 2 && searchTypes.pack[1] == "display" && searchTypes.name == "DisplayObject") {
				
				var fields = Context.getBuildFields ();
				
				var method = macro {
					
					openfl.Lib.current.addChild (this);
					super ();
					dispatchEvent (new openfl.events.Event (openfl.events.Event.ADDED_TO_STAGE, false, false));
					
				}
				
				fields.push ({ name: "new", access: [ APublic ], kind: FFun({ args: [], expr: method, params: [], ret: macro :Void }), pos: Context.currentPos () });
				
				return fields;
				
			}
			
			searchTypes = searchTypes.superClass.t.get ();
			
		}
		
		return null;
		
	}
	
	
}


#end
