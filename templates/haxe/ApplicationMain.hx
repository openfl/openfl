import lime.Assets;


class ApplicationMain {
	
	
	public static var config:lime.app.Config;
	public static var preloader:lime.app.Preloader;
	
	private static var app:lime.app.Application;
	
	
	public static function create ():Void {
		
		preloader = new ::if (PRELOADER_NAME != "")::::PRELOADER_NAME::::else::lime.app.Preloader::end:: ();
		preloader.onComplete = start;
		preloader.create (config);
		
		#if js
		var urls = [];
		var types = [];
		
		::foreach assets::::if (embed)::
		urls.push ("::resourceName::");
		::if (type == "image")::types.push (AssetType.IMAGE);
		::elseif (type == "binary")::types.push (AssetType.BINARY);
		::elseif (type == "text")::types.push (AssetType.TEXT);
		::elseif (type == "sound")::types.push (AssetType.SOUND);
		::elseif (type == "music")::types.push (AssetType.MUSIC);
		::else::types.push (null);::end::
		::end::::end::
		
		preloader.load (urls, types);
		#end
		
	}
	
	
	public static function main () {
		
		config = {
			
			antialiasing: Std.int (::WIN_ANTIALIASING::),
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
		embed (null, ::WIN_WIDTH::, ::WIN_HEIGHT::, "::WIN_FLASHBACKGROUND::");
		#end
		#else
		create ();
		#end
		
	}
	
	
	public static function start ():Void {
		
		app = new openfl.display.Application ();
		app.create (config);
		
		openfl.Lib.current.addChild (new ::APP_MAIN:: ());
		
		var result = app.exec ();
		
		#if sys
		Sys.exit (result);
		#end
		
	}
	
	
}