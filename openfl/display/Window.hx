package openfl.display;


import lime.app.Application;
import lime.project.WindowData;
import lime.ui.Window in LimeWindow;
import openfl.Lib;

@:access(openfl.display.Stage)


class Window extends LimeWindow {
	
	
	public var stage:Stage;
	
	
	public function new (config:WindowData) {
		
		super (config);
		
	}
	
	
	public override function create (application:Application):Void {
		
		super.create (application);
		
		#if !flash
		
		stage = new Stage (width, height, config.background);
		stage.window = this;
		application.addModule (stage);
		
		#else
		
		stage = Lib.current.stage;
		
		#end
		
	}
	
	
}