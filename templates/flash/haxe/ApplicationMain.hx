import openfl.Lib;
import openfl.net.URLLoader;


class ApplicationMain {
	
	
	//public static var images (default, null) = new Map <String, Image> ();
	//public static var urlLoaders = new Map <String, URLLoader> ();
	
	private var app:lime.app.Application;
	
	
	public static function main () {
		
		var app = new openfl.display.Application ();
		
		var config:lime.app.Config = {
			
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
		
		app.create (config);
		
		openfl.Lib.current.addChild (new ::APP_MAIN:: ());
		
		var result = app.exec ();
		
		#if sys
		Sys.exit (result);
		#end
		
	}
	
	
}