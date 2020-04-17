package openfl.display;

#if lime
import lime.app.Application;
import lime.ui.Window as LimeWindow;
import lime.ui.WindowAttributes;
import openfl._internal.Lib;

/**
	The Window class is a Lime Window instance that automatically
	initializes an OpenFL stage for the current window.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display.LoaderInfo)
@:access(openfl.display.Stage)
@SuppressWarnings("checkstyle:FieldDocComment")
class Window extends LimeWindow
{
	@SuppressWarnings("checkstyle:Dynamic")
	@:noCompletion private function new(application:Application, attributes:WindowAttributes)
	{
		super(application, attributes);

		#if (!flash && !macro)
		#if commonjs
		if (Reflect.hasField(attributes, "stage"))
		{
			stage = Reflect.field(attributes, "stage");
			stage.limeWindow = this;
			Reflect.deleteField(attributes, "stage");
		}
		else
		#end
		stage = new Stage(this, Reflect.hasField(attributes.context, "background") ? attributes.context.background : 0xFFFFFF);

		if (Reflect.hasField(attributes, "parameters"))
		{
			try
			{
				stage.loaderInfo.parameters = attributes.parameters;
			}
			catch (e:Dynamic) {}
		}

		if (Reflect.hasField(attributes, "resizable") && !attributes.resizable)
		{
			stage.__setLogicalSize(attributes.width, attributes.height);
		}

		application.addModule(stage);
		#else
		stage = Lib.current.stage;
		#end
	}
}
#end
