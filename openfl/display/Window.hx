package openfl.display;


import lime.app.Application;
import lime.app.Config;
import lime.ui.Window in LimeWindow;
import openfl.Lib;

@:access(openfl.display.Stage)


class Window extends LimeWindow {
	
	
	public function new (config:WindowConfig = null) {
		
		super (config);
		
	}
	
	
	public override function create (application:Application):Void {
		
		super.create (application);
		
		#if (!flash && !openfl_legacy)
		
		stage = new Stage (this, Reflect.hasField (config, "background") ? config.background : 0xFFFFFF);
		application.addModule (stage);
		
		#else
		
		stage = Lib.current.stage;
		
		#end
		
	}
	
	
}