package openfl.display;


import lime.ui.Window in LimeWindow;

#if (lime < "7.0.0")
import lime.app.Config;
#end


extern class Window extends LimeWindow {
	
	
	#if (lime < "7.0.0")
	public function new (config:WindowConfig = null);
	#end
	
	
}