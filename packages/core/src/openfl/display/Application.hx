package openfl.display;

import lime.app.Application as LimeApplication;
import lime.ui.WindowAttributes;

/**
	The Application class is a Lime Application instance that uses
	OpenFL Window by default when a new window is created.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class Application extends LimeApplication
{
	@:allow(openfl) @:noCompletion private var _:_Application;

	public function new()
	{
		super();

		_ = new _Application(this);
	}

	public override function createWindow(attributes:WindowAttributes):Window
	{
		return _.createWindow(attributes);
	}
}
