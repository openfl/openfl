package openfl.display;

import lime.app.Application;
import lime.ui.Window as LimeWindow;
import lime.ui.WindowAttributes;

/**
	The Window class is a Lime Window instance that automatically
	initializes an OpenFL stage for the current window.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class Window extends LimeWindow
{
	@:allow(openfl) @:noCompletion private var _:Dynamic;

	@:noCompletion private function new(application:Application, attributes:WindowAttributes)
	{
		super(application, attributes);

		_ = new _Window(this, application, attributes);
	}
}
