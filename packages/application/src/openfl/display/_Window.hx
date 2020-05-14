package openfl.display;

import lime.app.Application;
import lime.ui.Window as LimeWindow;
import lime.ui.WindowAttributes;
import openfl._internal.Lib;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(lime.ui.Window) // TODO: No public access?
@:access(openfl.display.LoaderInfo)
@:access(openfl.display.Stage)
@SuppressWarnings("checkstyle:FieldDocComment")
@:noCompletion
class _Window
{
	private var window:Window;

	public function new(window:Window, application:Application, attributes:WindowAttributes)
	{
		this.window = window;

		#if (!flash && !macro)
		// #if commonjs
		// if (Reflect.hasField(attributes, "stage"))
		// {
		// 	stage = Reflect.field(attributes, "stage");
		// 	stage.limeWindow = this;
		// 	Reflect.deleteField(attributes, "stage");
		// }
		// else
		// #end
		window.stage = new Stage(window, Reflect.hasField(attributes.context, "background") ? attributes.context.background : 0xFFFFFF);

		if (Reflect.hasField(attributes, "parameters"))
		{
			try
			{
				(window.stage.loaderInfo._ : _LoaderInfo).parameters = attributes.parameters;
			}
			catch (e:Dynamic) {}
		}

		if (Reflect.hasField(attributes, "resizable") && !attributes.resizable)
		{
			(window.stage._ : _Stage).__setLogicalSize(attributes.width, attributes.height);
		}

		window.application.addModule(window.stage);
		#else
		window.stage = Lib.current.stage;
		#end
	}
}
