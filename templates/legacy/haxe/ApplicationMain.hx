#if !lime_hybrid


import openfl.Assets;


#if (!macro && !display && !waxe)


@:access(openfl._legacy.Assets)


class ApplicationMain {
	
	
	private static var barA:flash.display.Sprite;
	private static var barB:flash.display.Sprite;
	private static var container:flash.display.Sprite;
	private static var forceHeight:Int;
	private static var forceWidth:Int;
	
	#if hxtelemetry
	public static var telemetryConfig:hxtelemetry.HxTelemetry.Config;
	#end
	
	
	public static function main () {
		
		flash.Lib.setPackage ("::APP_COMPANY::", "::APP_FILE::", "::APP_PACKAGE::", "::APP_VERSION::");
		::if (sslCaCert != "")::flash.net.URLLoader.initialize (openfl.Assets.getString ("::sslCaCert::"));::end::
		
		#if ios
		flash.display.Stage.shouldRotateInterface = function (orientation:Int):Bool {
			::if (WIN_ORIENTATION == "portrait")::return (orientation == flash.display.Stage.OrientationPortrait || orientation == flash.display.Stage.OrientationPortraitUpsideDown);
			::elseif (WIN_ORIENTATION == "landscape")::return (orientation == flash.display.Stage.OrientationLandscapeLeft || orientation == flash.display.Stage.OrientationLandscapeRight);
			::else::return true;::end::
		}
		#end
		
		#if hxtelemetry
		telemetryConfig = new hxtelemetry.HxTelemetry.Config ();
		telemetryConfig.allocations = ::if (config.hxtelemetry != null)::("::config.hxtelemetry.allocations::" == "true")::else::true::end::;
		telemetryConfig.host = ::if (config.hxtelemetry != null)::"::config.hxtelemetry.host::"::else::"localhost"::end::;
		telemetryConfig.app_name = "::APP_TITLE::";
		#end
		
		::if (APP_INIT != null)::::APP_INIT::::end::
		
		::if (WIN_ORIENTATION == "landscape")::#if tizen
		flash.display.Stage.setFixedOrientation (flash.display.Stage.OrientationLandscapeRight);
		#end::end::
		
		flash.Lib.create (function () {
				
				flash.Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
				flash.Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
				flash.Lib.current.loaderInfo = flash.display.LoaderInfo.create (null);
				
				::if (WIN_WIDTH != 0)::::if (WIN_HEIGHT != 0)::#if mobile
				
				forceWidth = ::WIN_WIDTH::;
				forceHeight = ::WIN_HEIGHT::;
				
				container = new flash.display.Sprite ();
				barA = new flash.display.Sprite ();
				barB = new flash.display.Sprite ();
				
				flash.Lib.current.stage.addChild (container);
				container.addChild (flash.Lib.current);
				container.addChild (barA);
				container.addChild (barB);
				
				applyScale ();
				flash.Lib.current.stage.addEventListener (flash.events.Event.RESIZE, applyScale);
				
				#end::end::::end::
				
				#if windows
				try {
					
					var currentPath = haxe.io.Path.directory (Sys.executablePath ());
					Sys.setCwd (currentPath);
					
				} catch (e:Dynamic) {}
				#elseif linux
				try {
					
					if (!sys.FileSystem.exists (Sys.getCwd () + "/lime-legacy.ndll")) {
						
						Sys.setCwd (haxe.io.Path.directory (Sys.executablePath ()));
						
					}
					
				} catch (e:Dynamic) {}
				#end
				
				::if (libraries != null)::::foreach libraries::::if (preload)::
				openfl.Assets.loadLibrary ("::name::", function (_) {});
				::end::::end::::end::
				
				openfl.Assets.initialize ();
				
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
					
					if (Std.is (instance, flash.display.DisplayObject)) {
						
						flash.Lib.current.addChild (cast instance);
						
					}
					
				}
				
			},
			::WIN_WIDTH::, ::WIN_HEIGHT::, 
			::WIN_FPS::, 
			::WIN_BACKGROUND::,
			(::WIN_HARDWARE:: ? flash.Lib.HARDWARE : 0) |
			(::WIN_ALLOW_SHADERS:: ? flash.Lib.ALLOW_SHADERS : 0) |
			(::WIN_REQUIRE_SHADERS:: ? flash.Lib.REQUIRE_SHADERS : 0) |
			(::WIN_DEPTH_BUFFER:: ? flash.Lib.DEPTH_BUFFER : 0) |
			(::WIN_STENCIL_BUFFER:: ? flash.Lib.STENCIL_BUFFER : 0) |
			(::WIN_RESIZABLE:: ? flash.Lib.RESIZABLE : 0) |
			(::WIN_BORDERLESS:: ? flash.Lib.BORDERLESS : 0) |
			(::WIN_VSYNC:: ? flash.Lib.VSYNC : 0) |
			(::WIN_FULLSCREEN:: ? flash.Lib.FULLSCREEN : 0) |
			(::WIN_ANTIALIASING:: == 4 ? flash.Lib.HW_AA_HIRES : 0) |
			(::WIN_ANTIALIASING:: == 2 ? flash.Lib.HW_AA : 0),
			"::APP_TITLE::",
			::if (WIN_ICON != null)::getAsset("::WIN_ICON::")::else::null::end::
			::if (WIN_WIDTH != 0)::::if (WIN_HEIGHT != 0)::#if mobile, ScaledStage #end::end::::end::
		);
		
	}
	
	::if (WIN_WIDTH != 0)::::if (WIN_HEIGHT != 0)::#if mobile
	public static function applyScale (?_) {
		var scaledStage:ScaledStage = cast flash.Lib.current.stage;
		
		var xScale:Float = scaledStage.__stageWidth / forceWidth;
		var yScale:Float = scaledStage.__stageHeight / forceHeight;
		
		if (xScale < yScale) {
			
			flash.Lib.current.scaleX = xScale;
			flash.Lib.current.scaleY = xScale;
			flash.Lib.current.x = (scaledStage.__stageWidth - (forceWidth * xScale)) / 2;
			flash.Lib.current.y = (scaledStage.__stageHeight - (forceHeight * xScale)) / 2;
			
		} else {
			
			flash.Lib.current.scaleX = yScale;
			flash.Lib.current.scaleY = yScale;
			flash.Lib.current.x = (scaledStage.__stageWidth - (forceWidth * yScale)) / 2;
			flash.Lib.current.y = (scaledStage.__stageHeight - (forceHeight * yScale)) / 2;
			
		}
		
		if (flash.Lib.current.x > 0) {
			
			barA.graphics.clear ();
			barA.graphics.beginFill (0x000000);
			barA.graphics.drawRect (0, 0, flash.Lib.current.x, scaledStage.__stageHeight);
			
			barB.graphics.clear ();
			barB.graphics.beginFill (0x000000);
			var x = flash.Lib.current.x + (forceWidth * flash.Lib.current.scaleX);
			barB.graphics.drawRect (x, 0, scaledStage.__stageWidth - x, scaledStage.__stageHeight);
			
		} else {
			
			barA.graphics.clear ();
			barA.graphics.beginFill (0x000000);
			barA.graphics.drawRect (0, 0, scaledStage.__stageWidth, flash.Lib.current.y);
			
			barB.graphics.clear ();
			barB.graphics.beginFill (0x000000);
			var y = flash.Lib.current.y + (forceHeight * flash.Lib.current.scaleY);
			barB.graphics.drawRect (0, y, scaledStage.__stageWidth, scaledStage.__stageHeight - y);
			
		}
		
	}
	#end::end::::end::
	
	
	#if neko
	@:noCompletion public static function __init__ () {
		
		untyped $loader.path = $array (haxe.io.Path.directory (Sys.executablePath ()), $loader.path);
		untyped $loader.path = $array ("./", $loader.path);
		untyped $loader.path = $array ("@executable_path/", $loader.path);
		
	}
	#end
	
	
}


@:build(DocumentClass.build())
@:keep class DocumentClass extends ::APP_MAIN:: {}


::if (WIN_WIDTH != 0)::::if (WIN_HEIGHT != 0)::#if mobile
class ScaledStage extends flash.display.Stage {
	
	
	public var __stageHeight (get, null):Int;
	public var __stageWidth (get, null):Int;
	
	
	public function new (inHandle:Dynamic, inWidth:Int, inHeight:Int) {
		
		super (inHandle, 0, 0);
		
	}
	
	
	private function get___stageHeight ():Int {
		
		return super.get_stageHeight ();
		
	}
	
	
	private function get___stageWidth():Int {
		
		return super.get_stageWidth ();
		
	}
	
	
	private override function get_stageHeight ():Int {
		
		return ::WIN_HEIGHT::;
	
	}
	
	private override function get_stageWidth ():Int {
		
		return ::WIN_WIDTH::;
	
	}
	
	
}
#end::end::::end::


#elseif macro


import haxe.macro.Context;
import haxe.macro.Expr;


class DocumentClass {
	
	
	macro public static function build ():Array<Field> {
		
		var classType = Context.getLocalClass ().get ();
		var searchTypes = classType;
		
		while (searchTypes.superClass != null) {
			
			if (searchTypes.pack.length >= 2 && (searchTypes.pack[1] == "display" || searchTypes.pack[2] == "display") && searchTypes.name == "DisplayObject") {
				
				var fields = Context.getBuildFields ();
				var method = macro { return flash.Lib.current.stage; }
				
				fields.push ({ name: "get_stage", access: [ APrivate, AOverride ], kind: FFun({ args: [], expr: method, params: [], ret: macro :flash.display.Stage }), pos: Context.currentPos () });
				return fields;
				
			}
			
			searchTypes = searchTypes.superClass.t.get ();
			
		}
		
		return null;
		
	}
	
	
}


#elseif waxe


class ApplicationMain {
	
	
	public static var autoShowFrame:Bool = true;
	public static var frame:wx.Frame;
	#if openfl
	static public var nmeStage:wx.NMEStage;
	#end
	
	
	public static function main () {
		
		#if openfl
		flash.Lib.setPackage ("::APP_COMPANY::", "::APP_FILE::", "::APP_PACKAGE::", "::APP_VERSION::");
		::if (sslCaCert != "")::flash.net.URLLoader.initialize (openfl.Assets.getString ("::sslCaCert::"));::end::
		#end
		
		wx.App.boot (function () {
			
			::if (APP_FRAME != null)::
			frame = wx.::APP_FRAME::.create (null, null, "::APP_TITLE::", null, { width: ::WIN_WIDTH::, height: ::WIN_HEIGHT:: });
			::else::
			frame = wx.Frame.create (null, null, "::APP_TITLE::", null, { width: ::WIN_WIDTH::, height: ::WIN_HEIGHT:: });
			::end::
			
			#if openfl
			var stage = wx.NMEStage.create (frame, null, null, { width: ::WIN_WIDTH::, height: ::WIN_HEIGHT:: });
			#end
			
			var hasMain = false;
			for (methodName in Type.getClassFields (::APP_MAIN::)) {
				if (methodName == "main") {
					hasMain = true;
					break;
				}
			}
			
			if (hasMain) {
				Reflect.callMethod (::APP_MAIN::, Reflect.field (::APP_MAIN::, "main"), []);
			}else {
				var instance = Type.createInstance (::APP_MAIN::, []);
			}
			
			if (autoShowFrame) {
				wx.App.setTopWindow (frame);
				frame.shown = true;
			}
			
		});
		
	}
	
	#if neko
	@:noCompletion public static function __init__ () {
		
		untyped $loader.path = $array (haxe.io.Path.directory (Sys.executablePath ()), $loader.path);
		untyped $loader.path = $array ("./", $loader.path);
		untyped $loader.path = $array ("@executable_path/", $loader.path);
		
	}
	#end
	
	
}


#else


import ::APP_MAIN::;

class ApplicationMain {
	
	
	public static function main () {
		
		
		
	}
	
	
}


#end


#else


#if !macro


@:access(lime.Assets)


class ApplicationMain {
	
	
	public static var config:lime.app.Config;
	public static var preloader:openfl.display.Preloader;
	
	
	public static function create ():Void {
		
		var app = new lime.app.Application ();
		app.create (config);
		openfl.Lib.application = app;
		
		#if !flash
		var stage = new openfl._legacy.display.HybridStage (app.window.width, app.window.height, config.background);
		stage.addChild (openfl.Lib.current);
		app.addModule (stage);
		#end
		
		var display = ::if (PRELOADER_NAME != "")::new ::PRELOADER_NAME:: ()::else::new NMEPreloader ()::end::;
		
		preloader = new openfl.display.Preloader (display);
		preloader.onComplete = init;
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
		
		::if (libraries != null)::::foreach libraries::::if (preload)::
		total++;
		openfl.Assets.loadLibrary ("::name::", library_onLoad);
		::end::::end::::end::
		
		if (total == 0) {
			
			start ();
			
		}
		
	}
	
	
	public static function main () {
		
		config = {
			
			antialiasing: Std.int (::WIN_ANTIALIASING::),
			background: Std.int (::WIN_BACKGROUND::),
			borderless: ::WIN_BORDERLESS::,
			company: "::META_COMPANY::",
			depthBuffer: ::WIN_DEPTH_BUFFER::,
			file: "::APP_FILE::",
			fps: Std.int (::WIN_FPS::),
			fullscreen: ::WIN_FULLSCREEN::,
			height: Std.int (::WIN_HEIGHT::),
			orientation: "::WIN_ORIENTATION::",
			packageName: "::META_PACKAGE_NAME::",
			resizable: ::WIN_RESIZABLE::,
			stencilBuffer: ::WIN_STENCIL_BUFFER::,
			title: "::APP_TITLE::",
			version: "::META_VERSION::",
			vsync: ::WIN_VSYNC::,
			width: Std.int (::WIN_WIDTH::),
			
		}
		
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
			
			if (Std.is (instance, flash.display.DisplayObject)) {
				
				flash.Lib.current.addChild (cast instance);
				
			}
			
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
			
			if (searchTypes.pack.length >= 2 && (searchTypes.pack[1] == "display" || searchTypes.pack[2] == "display") && searchTypes.name == "DisplayObject") {
				
				var fields = Context.getBuildFields ();
				var method = macro { return flash.Lib.current.stage; }
				
				fields.push ({ name: "get_stage", access: [ APrivate, AOverride ], kind: FFun({ args: [], expr: method, params: [], ret: macro :flash.display.Stage }), pos: Context.currentPos () });
				return fields;
				
			}
			
			searchTypes = searchTypes.superClass.t.get ();
			
		}
		
		return null;
		
	}
	
	
}


#end


#end
