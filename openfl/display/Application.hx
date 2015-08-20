package openfl.display;


import lime.app.Application in LimeApplication;
import lime.app.Config;
import openfl.Lib;


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
		
		frameRate = config.windows[0].fps;
		
		for (i in 0...config.windows.length) {
			
			var window = new openfl.display.Window (config.windows[i]);
			addWindow (window);
			
			if (Lib.current.stage == null) {
				
				window.stage.addChild (Lib.current);
				
			}
			
			#if (flash || html5)
			break;
			#end
			
		}
		
		init (this);
		
	}
	
	
}