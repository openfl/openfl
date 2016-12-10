package;


#if macro
import haxe.macro.Compiler;
import haxe.macro.Context;
import haxe.macro.Expr;
#else
import DefaultAssetLibrary;
#end

@:access(lime.app.Application)
@:access(lime.Assets)
@:access(openfl.display.Stage)


class ApplicationMain {
	
	
	#if !macro
	
	
	public static var config:lime.app.Config;
	public static var preloader:openfl.display.Preloader;
	
	
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
					allowHighDPI: ::allowHighDPI::,
					antialiasing: ::antialiasing::,
					background: ::background::,
					borderless: ::borderless::,
					depthBuffer: ::depthBuffer::,
					display: ::display::,
					fullscreen: ::fullscreen::,
					hardware: ::hardware::,
					height: ::height::,
					hidden: #if munit true #else ::hidden:: #end,
					maximized: ::maximized::,
					minimized: ::minimized::,
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
		embed (null, ::WIN_WIDTH::, ::WIN_HEIGHT::, "::WIN_FLASHBACKGROUND::");
		#end
		#else
		create ();
		#end
		
	}
	
	
	public static function create ():Void {
		
		var app = new openfl.display.Application ();
		app.create (config);
		
		preloader = getPreloader ();
		preloader.onComplete.add (registerLibrary);
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
		
		#if (sys && !ios && !nodejs && !emscripten)
		lime.system.System.exit (result);
		#end
		
	}
	
	
	#if (js && html5)
	@:keep @:expose("lime.embed")
	public static function embed (element:Dynamic, width:Null<Int> = null, height:Null<Int> = null, background:String = null, assetsPrefix:String = null) {
		
		var htmlElement:js.html.Element = null;
		
		if (Std.is (element, String)) {
			
			htmlElement = cast js.Browser.document.getElementById (cast (element, String));
			
		} else if (element == null) {
			
			htmlElement = cast js.Browser.document.createElement ("div");
			
		} else {
			
			htmlElement = cast element;
			
		}
		
		var color = null;
		
		if (background != null && background != "") {
			
			background = StringTools.replace (background, "#", "");
			
			if (background.indexOf ("0x") > -1) {
				
				color = Std.parseInt (background);
				
			} else {
				
				color = Std.parseInt ("0x" + background);
				
			}
			
		}
		
		if (width == null) {
			
			width = 0;
			
		}
		
		if (height == null) {
			
			height = 0;
			
		}
		
		config.windows[0].background = color;
		config.windows[0].element = htmlElement;
		config.windows[0].width = width;
		config.windows[0].height = height;
		config.assetsPrefix = assetsPrefix;
		
		create ();
		
	}
	
	
	@:keep @:expose("openfl.embed")
	public static function _embed (element:Dynamic, width:Null<Int> = null, height:Null<Int> = null, background:String = null, assetsPrefix:String = null) {
		
		embed (element, width, height, background, assetsPrefix);
		
	}
	#end
	
	
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
	
	
	private static function registerLibrary ():Void {
		
		lime.Assets.registerLibrary ("default", new DefaultAssetLibrary ());
		
		var classReference = Type.resolveClass ("DefaultAssetLibrary");
		
		if (classReference != null) {
			
			lime.Assets.registerLibrary ("default", Type.createInstance (classReference, []));
			
		} else {
			
			lime.utils.Log.warn ("Could not load DefaultAssetLibrary (class not found)");
			
		}
		
	}
	
	
	public static function start ():Void {
		
		#if flash
		
		ApplicationMain.getEntryPoint ();
		
		#else
		
		try {
			
			ApplicationMain.getEntryPoint ();
			
		} catch (e:Dynamic) {
			
			openfl.Lib.current.stage.__handleError (e);
			
		}
		
		openfl.Lib.current.stage.dispatchEvent (new openfl.events.Event (openfl.events.Event.RESIZE, false, false));
		
		if (openfl.Lib.current.stage.window.fullscreen) {
			
			openfl.Lib.current.stage.dispatchEvent (new openfl.events.FullScreenEvent (openfl.events.FullScreenEvent.FULL_SCREEN, false, false, true, true));
			
		}
		#end
		
	}
	
	
	#end
	
	
	macro public static function getEntryPoint () {
		
		var hasMain = false;
		
		switch (Context.follow (Context.getType ("::APP_MAIN::"))) {
			
			case TInst (t, params):
				
				var type = t.get ();
				
				for (method in type.statics.get ()) {
					
					if (method.name == "main") {
						
						hasMain = true;
						break;
						
					}
					
				}
				
				if (hasMain) {
					
					return Context.parse ("@:privateAccess ::APP_MAIN::.main ()", Context.currentPos ());
					
				} else if (type.constructor != null) {
					
					return macro { new DocumentClass (); };
					
				} else {
					
					Context.fatalError ("Main class \"::APP_MAIN::\" has neither a static main nor a constructor.", Context.currentPos ());
					
				}
				
			default:
				
				Context.fatalError ("Main class \"::APP_MAIN::\" isn't a class.", Context.currentPos ());
			
		}
		
		return null;
		
	}
	
	
	macro public static function getPreloader () {
		
		::if (PRELOADER_NAME != "")::
		try {
			
			var type = Context.getType ("::PRELOADER_NAME::");
			
			switch (type) {
				
				case TInst (classType, _):
					
					var searchTypes = classType.get ();
					
					while (searchTypes != null) {
						
						if (searchTypes.pack.length == 2 && searchTypes.pack[0] == "openfl" && searchTypes.pack[1] == "display" && searchTypes.name == "Preloader") {
							
							return macro { new ::PRELOADER_NAME:: (); };
							
						}
						
						if (searchTypes.superClass != null) {
							
							searchTypes = searchTypes.superClass.t.get ();
							
						} else {
							
							searchTypes = null;
							
						}
						
					}
				
				default:
				
			}
			
		} catch (e:Dynamic) {}
		
		return macro { new openfl.display.Preloader (new ::PRELOADER_NAME:: ()); }
		::else::
		return macro { new openfl.display.Preloader (new openfl.display.Preloader.DefaultPreloader ()); };
		::end::
		
	}
	
	
	#if (neko && !macro)
	@:noCompletion @:dox(hide) public static function __init__ () {
		
		// Copy from https://github.com/HaxeFoundation/haxe/blob/development/std/neko/_std/Sys.hx#L164
		// since Sys.programPath () isn't available in __init__
		var sys_program_path = {
			var m = neko.vm.Module.local().name;
			try {
				sys.FileSystem.fullPath(m);
			} catch (e:Dynamic) {
				// maybe the neko module name was supplied without .n extension...
				if (!StringTools.endsWith(m, ".n")) {
					try {
						sys.FileSystem.fullPath(m + ".n");
					} catch (e:Dynamic) {
						m;
					}
				} else {
					m;
				}
			}
		};
		
		var loader = new neko.vm.Loader (untyped $loader);
		loader.addPath (haxe.io.Path.directory (#if (haxe_ver >= 3.3) sys_program_path #else Sys.executablePath () #end));
		loader.addPath ("./");
		loader.addPath ("@executable_path/");
		
	}
	#end
	
	
}


#if !macro


@:build(DocumentClass.build())
@:keep class DocumentClass extends ::APP_MAIN:: {}


#else


class DocumentClass {
	
	
	macro public static function build ():Array<Field> {
		
		var classType = Context.getLocalClass ().get ();
		var searchTypes = classType;
		
		while (searchTypes != null) {
			
			if (searchTypes.module == "openfl.display.DisplayObject" || searchTypes.module == "flash.display.DisplayObject") {
				
				var fields = Context.getBuildFields ();
				
				var method = macro {
					
					openfl.Lib.current.addChild (this);
					super ();
					dispatchEvent (new openfl.events.Event (openfl.events.Event.ADDED_TO_STAGE, false, false));
					
				}
				
				fields.push ({ name: "new", access: [ APublic ], kind: FFun({ args: [], expr: method, params: [], ret: macro :Void }), pos: Context.currentPos () });
				
				return fields;
				
			}
			
			if (searchTypes.superClass != null) {
				
				searchTypes = searchTypes.superClass.t.get ();
				
			} else {
				
				searchTypes = null;
				
			}
			
		}
		
		return null;
		
	}
	
	
}


#end