package openfl.display;


import openfl._internal.Lib;

#if lime
import lime.app.Application;
import lime.ui.Window as LimeWindow;
import lime.ui.WindowAttributes;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.display.LoaderInfo)
@:access(openfl.display.Stage)


class Window #if lime extends LimeWindow #end {
	
	
	@:noCompletion private function new (application:Application, attributes:#if lime WindowAttributes #else Dynamic #end) {
		
		#if lime
		super (application, attributes);
		#end
		
		#if (!flash && !macro)
		
		#if commonjs
		if (Reflect.hasField (attributes, "stage")) {
			
			stage = Reflect.field (attributes, "stage");
			stage.window = this;
			Reflect.deleteField (attributes, "stage");
			
		} else
		#end
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
	
	
}