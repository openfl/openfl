package openfl.display;


import lime.app.Application;
import lime.app.Config;
import lime.ui.Window in LimeWindow;
import openfl._internal.Lib;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.display.LoaderInfo)
@:access(openfl.display.Stage)


class Window extends LimeWindow {
	
	
	public function new (config:WindowConfig = null) {
		
		super (config);
		
	}
	
	
	public override function create (application:Application):Void {
		
		super.create (application);
		
		#if (!flash && !macro)
		
		stage = new Stage (this, Reflect.hasField (config, "background") ? config.background : 0xFFFFFF);
		
		if (Reflect.hasField (config, "parameters")) {
			
			try {
				
				stage.loaderInfo.parameters = config.parameters;
				
			} catch (e:Dynamic) {}
			
		}
		
		if (Reflect.hasField (config, "resizable") && !config.resizable) {
			
			stage.__setLogicalSize (config.width, config.height);
			
		}
		
		application.addModule (stage);
		
		#else
		
		stage = Lib.current.stage;
		
		#end
		
	}
	
	
}