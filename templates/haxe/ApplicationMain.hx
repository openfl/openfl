#if !macro


@:access(lime.app.Application)
@:access(lime.Assets)
@:access(openfl.display.Stage)


class ApplicationMain {
	
	
	public static var config:lime.app.Config;
	public static var preloader:openfl.display.Preloader;
	
	
	public static function create ():Void {
		
		var app = new openfl.display.Application ();
		app.create (config);
		
		var display = ::if (PRELOADER_NAME != "")::new ::PRELOADER_NAME:: ()::else::new NMEPreloader ()::end::;
		
		preloader = new openfl.display.Preloader (display);
		app.setPreloader (preloader);
		preloader.onComplete.add (init);
		preloader.create (config);
		
		#if (js && html5)
		var urls = [];
		var types = [];
		
		::foreach assets::::if (embed)::
		urls.push (::if (type == "font")::"::fontName::"::else::"::resourceName::"::end::);
		::if (type == "image")::types.push (lime.Assets.AssetType.IMAGE);
		::elseif (type == "binary")::types.push (lime.Assets.AssetType.BINARY);
		::elseif (type == "text")::types.push (lime.Assets.AssetType.TEXT);
		::elseif (type == "font")::types.push (lime.Assets.AssetType.FONT);
		::elseif (type == "sound")::types.push (lime.Assets.AssetType.SOUND);
		::elseif (type == "music")::types.push (lime.Assets.AssetType.MUSIC);
		::else::types.push (null);::end::
		::end::::end::
		
		if (config.assetsPrefix != null) {
			
			for (i in 0...urls.length) {
				
				if (types[i] != lime.Assets.AssetType.FONT) {
					
					urls[i] = config.assetsPrefix + urls[i];
					
				}
				
			}
			
		}
		
		preloader.load (urls, types);
		#end
		
		var result = app.exec ();
		
		#if (sys && !nodejs && !emscripten)
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
		
		::if (libraries != null)::::foreach libraries::::if (preload)::total++;
		::end::::end::::end::
		::if (libraries != null)::::foreach libraries::::if (preload)::openfl.Assets.loadLibrary ("::name::").onComplete (library_onLoad);
		::end::::end::::end::
		
		if (total == 0) {
			
			start ();
			
		}
		
	}
	
	
	public static function main () {
		
		config = {
			
			build: "::meta.buildNumber::",
			company: "::meta.company::",
			file: "::APP_FILE::",
			fps: ::WIN_FPS::,
			name: "::meta.title::",
			orientation: "::WIN_ORIENTATION::",
			packageName: "::meta.packageName::",
			version: "::meta.version::",
			windows: [
				::foreach windows::
				{
					antialiasing: ::antialiasing::,
					background: ::background::,
					borderless: ::borderless::,
					depthBuffer: ::depthBuffer::,
					display: ::display::,
					fullscreen: ::fullscreen::,
					hardware: ::hardware::,
					height: ::height::,
					parameters: "::parameters::",
					resizable: ::resizable::,
					stencilBuffer: ::stencilBuffer::,
					title: "::title::",
					vsync: ::vsync::,
					width: ::width::,
					x: ::x::,
					y: ::y::
				},::end::
			]
			
		};
		
		#if hxtelemetry
		var telemetry = new hxtelemetry.HxTelemetry.Config ();
		telemetry.allocations = ::if (config.hxtelemetry != null)::("::config.hxtelemetry.allocations::" == "true")::else::true::end::;
		telemetry.host = ::if (config.hxtelemetry != null)::"::config.hxtelemetry.host::"::else::"localhost"::end::;
		telemetry.app_name = config.name;
		Reflect.setField (config, "telemetry", telemetry);
		#end
		
		#if (js && html5)
		#if (munit || utest)
		openfl.Lib.embed (null, ::WIN_WIDTH::, ::WIN_HEIGHT::, "::WIN_FLASHBACKGROUND::");
		#end
		#else
		create ();
		#end
		
	}
	
	
	public static function start ():Void {
		
		var hasMain = false;
		var entryPoint = Type.resolveClass ("::APP_MAIN::");
		
		for (methodName in Type.getClassFields (entryPoint)) {
			
			if (methodName == "main") {
				
				hasMain = true;
				break;
				
			}
			
		}
		
		lime.Assets.initialize ();
		
		if (hasMain) {
			
			Reflect.callMethod (entryPoint, Reflect.field (entryPoint, "main"), []);
			
		} else {
			
			var instance:DocumentClass = Type.createInstance (DocumentClass, []);
			
			/*if (Std.is (instance, openfl.display.DisplayObject)) {
				
				openfl.Lib.current.addChild (cast instance);
				
			}*/
			
		}
		
		#if !flash
		if (openfl.Lib.current.stage.window.fullscreen) {
			
			openfl.Lib.current.stage.dispatchEvent (new openfl.events.FullScreenEvent (openfl.events.FullScreenEvent.FULL_SCREEN, false, false, true, true));
			
		}
		
		openfl.Lib.current.stage.dispatchEvent (new openfl.events.Event (openfl.events.Event.RESIZE, false, false));
		#end
		
	}
	
	
	#if neko
	@:noCompletion @:dox(hide) public static function __init__ () {
		
		var loader = new neko.vm.Loader (untyped $loader);
		loader.addPath (haxe.io.Path.directory (#if (haxe_ver > 3.3) Sys.programPath () #else Sys.executablePath () #end));
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
