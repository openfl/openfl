package openfl.display;


import lime.app.Application;
import lime.ui.Window in LimeWindow;
import openfl._internal.Lib;

#if (lime >= "7.0.0")
import lime.ui.WindowAttributes;
#else
import lime.app.Config;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.display.LoaderInfo)
@:access(openfl.display.Stage)


class Window extends LimeWindow {
	
	
	#if (lime >= "7.0.0")
	@:noCompletion private function new (application:Application, attributes:WindowAttributes) {
		
		super (application, attributes);
		
		#if (!flash && !macro)
		
		stage = new Stage (this, Reflect.hasField (attributes.context, "background") ? attributes.context.background : 0xFFFFFF);
		
		if (Reflect.hasField (attributes, "parameters")) {
			
			try {
				
				stage.loaderInfo.parameters = attributes.parameters;
				
			} catch (e:Dynamic) {}
			
		}
		
		if (Reflect.hasField (attributes, "resizable") && !attributes.resizable) {
			
			stage.__setLogicalSize (attributes.width, attributes.height);
			
		}
		
		application.addModule (stage);
		
		#else
		
		stage = Lib.current.stage;
		
		#end
		
		
	}
	#else
	public function new (config:WindowConfig = null) {
		
		super (config);
		
	}
	#end
	
	
	#if (lime < "7.0.0")
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
	#end
	
	
}