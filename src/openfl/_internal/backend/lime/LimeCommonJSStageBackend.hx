package openfl._internal.backend.lime;

import openfl.display.Stage;

class LimeCommonJSStageBackend extends LimeStageBackend
{
	public function new(stage:Stage, width:Dynamic = 0, height:Dynamic = 0, color:Null<Int> = null, documentClass:Class<Dynamic> = null,
			windowAttributes:Dynamic = null)
	{
		parent = stage;

		if (windowAttributes == null) windowAttributes = {};
		var app = null;

		if (!Math.isNaN(width))
		{
			// if (Lib.current == null) Lib.current = new MovieClip ();

			if (Lib.current.__loaderInfo == null)
			{
				Lib.current.__loaderInfo = LoaderInfo.create(null);
				Lib.current.__loaderInfo.content = Lib.current;
			}

			var resizable = (width == 0 && width == 0);
			element = Browser.document.createElement("div");

			if (resizable)
			{
				element.style.width = "100%";
				element.style.height = "100%";
			}

			windowAttributes.width = width;
			windowAttributes.height = height;
			windowAttributes.element = element;
			windowAttributes.resizable = resizable;

			windowAttributes.stage = this;

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
			window = app.createWindow(windowAttributes);

			super(stage, window, color);

			if (documentClass != null)
			{
				DisplayObject.__initStage = this;
				var sprite:Sprite = cast Type.createInstance(documentClass, []);
				// addChild (sprite); // done by init stage
				sprite.dispatchEvent(new Event(Event.ADDED_TO_STAGE, false, false));
			}

			if (app != null)
			{
				app.addModule(this);
				app.exec();
			}
		}
	}
