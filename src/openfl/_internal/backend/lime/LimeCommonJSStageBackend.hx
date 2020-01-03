package openfl._internal.backend.lime;

#if (lime && commonjs)
import js.Browser;
import lime.graphics.RenderContextType;
import openfl.display.Application as OpenFLApplication;
import openfl.display.DisplayObject;
import openfl.display.LoaderInfo;
import openfl.display.Sprite;
import openfl.display.Stage;
import openfl.events.Event;
import openfl.Lib;

@:access(openfl.display.DisplayObject)
@:access(openfl.display.LoaderInfo)
class LimeCommonJSStageBackend extends LimeStageBackend
{
	public function new(stage:Stage, width:Dynamic = 0, height:Dynamic = 0, color:Null<Int> = null, documentClass:Class<Dynamic> = null,
			windowAttributes:Dynamic = null)
	{
		parent = stage;

		if (windowAttributes == null) windowAttributes = {};
		var app = null;

		// TODO: Workaround need to set reference here
		parent.__backend = cast this;

		if (!Math.isNaN(width))
		{
			// if (Lib.current == null) Lib.current = new MovieClip ();

			if (Lib.current.__loaderInfo == null)
			{
				Lib.current.__loaderInfo = LoaderInfo.create(null);
				Lib.current.__loaderInfo.content = Lib.current;
			}

			var resizable = (width == 0 && width == 0);
			parent.element = Browser.document.createElement("div");

			if (resizable)
			{
				parent.element.style.width = "100%";
				parent.element.style.height = "100%";
			}

			windowAttributes.width = width;
			windowAttributes.height = height;
			windowAttributes.element = parent.element;
			windowAttributes.resizable = resizable;

			windowAttributes.stage = parent;

			if (!Reflect.hasField(windowAttributes, "context")) windowAttributes.context = {};
			var contextAttributes = windowAttributes.context;
			if (Reflect.hasField(windowAttributes, "renderer"))
			{
				var type = Std.string(windowAttributes.renderer);
				if (type == "webgl1")
				{
					contextAttributes.type = RenderContextType.WEBGL;
					contextAttributes.version = "1";
				}
				else if (type == "webgl2")
				{
					contextAttributes.type = RenderContextType.WEBGL;
					contextAttributes.version = "2";
				}
				else
				{
					Reflect.setField(contextAttributes, "type", windowAttributes.renderer);
				}
			}
			if (!Reflect.hasField(contextAttributes, "stencil")) contextAttributes.stencil = true;
			if (!Reflect.hasField(contextAttributes, "depth")) contextAttributes.depth = true;
			if (!Reflect.hasField(contextAttributes, "background")) contextAttributes.background = null;

			app = new OpenFLApplication();
			parent.limeWindow = app.createWindow(windowAttributes);

			super(stage, parent.limeWindow, color);

			if (documentClass != null)
			{
				DisplayObject.__initStage = parent;
				var sprite:Sprite = cast Type.createInstance(documentClass, []);
				// addChild (sprite); // done by init stage
				sprite.dispatchEvent(new Event(Event.ADDED_TO_STAGE, false, false));
			}

			if (app != null)
			{
				app.addModule(parent);
				app.exec();
			}
		}
	}
}
#end
