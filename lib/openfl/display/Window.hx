package openfl.display;


// import lime.app.Config;
// import lime.ui.Window in LimeWindow;
typedef WindowConfig = Dynamic;

@:jsRequire("openfl/display/Window", "default")


extern class Window implements Dynamic /*extends LimeWindow*/ {
	
	
	public var stage:Stage;
	
	public function new (config:WindowConfig = null);
	
	
}