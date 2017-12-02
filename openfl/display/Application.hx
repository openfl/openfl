package openfl.display;


import lime.app.Application in LimeApplication;
import lime.app.Config;
import openfl._internal.Lib;
import openfl.display.MovieClip;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.display.DisplayObject)
@:access(openfl.display.LoaderInfo)


class Application extends LimeApplication {
	
	
	public function new () {
		
		super ();
		
		if (Lib.application == null) {
			
			Lib.application = this;
			
		}
		
	}
	
	
	public override function create (config:Config):Void {
		
		this.config = config;
		
		backend.create (config);
		
		#if (!flash && !macro)
		if (Lib.current == null) Lib.current = new MovieClip ();
		Lib.current.__loaderInfo = LoaderInfo.create (null);
		Lib.current.__loaderInfo.content = Lib.current;
		#end
		
		if (config != null) {
			
			if (Reflect.hasField (config, "fps")) {
				
				frameRate = config.fps;
				
			}
			
			if (Reflect.hasField (config, "windows")) {
				
				for (windowConfig in config.windows) {
					
					var window = new Window (windowConfig);
					createWindow (window);
					
					#if (flash || html5)
					break;
					#end
					
				}
				
			}
			
			if (preloader == null || preloader.complete) {
				
				onPreloadComplete ();
				
			}
			
		}
		
	}
	
	
}