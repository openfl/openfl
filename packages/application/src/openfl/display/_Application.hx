package openfl.display;

import lime.app.Application as LimeApplication;
import lime.ui.WindowAttributes;
import openfl._internal.Lib;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(lime.app.Application) // TODO: No public access?
@:access(openfl.display.DisplayObject)
@:access(openfl.display.LoaderInfo)
@:access(openfl.display.Window)
@SuppressWarnings("checkstyle:FieldDocComment")
@:noCompletion
class _Application
{
	private var application:Application;

	public function new(application:Application)
	{
		this.application = application;

		if (Lib.limeApplication == null)
		{
			Lib.limeApplication = application;
		}

		#if (!flash && !macro)
		if (Lib.current == null) Lib.current = new MovieClip();
		(Lib.current._ : _DisplayObject).__loaderInfo = _LoaderInfo.create(null);
		((Lib.current._ : _DisplayObject).__loaderInfo._ : _LoaderInfo).content = Lib.current;
		#end
	}

	public function createWindow(attributes:WindowAttributes):Window
	{
		var window = new Window(application, attributes);

		this.application.__windows.push(window);
		this.application.__windowByID.set(window.id, window);

		window.onClose.add(this.application.__onWindowClose.bind(window), false, -10000);

		if (this.application.__window == null)
		{
			this.application.__window = window;

			window.onActivate.add(application.onWindowActivate);
			window.onRenderContextLost.add(application.onRenderContextLost);
			window.onRenderContextRestored.add(application.onRenderContextRestored);
			window.onDeactivate.add(application.onWindowDeactivate);
			window.onDropFile.add(application.onWindowDropFile);
			window.onEnter.add(application.onWindowEnter);
			window.onExpose.add(application.onWindowExpose);
			window.onFocusIn.add(application.onWindowFocusIn);
			window.onFocusOut.add(application.onWindowFocusOut);
			window.onFullscreen.add(application.onWindowFullscreen);
			window.onKeyDown.add(application.onKeyDown);
			window.onKeyUp.add(application.onKeyUp);
			window.onLeave.add(application.onWindowLeave);
			window.onMinimize.add(application.onWindowMinimize);
			window.onMouseDown.add(application.onMouseDown);
			window.onMouseMove.add(application.onMouseMove);
			window.onMouseMoveRelative.add(application.onMouseMoveRelative);
			window.onMouseUp.add(application.onMouseUp);
			window.onMouseWheel.add(application.onMouseWheel);
			window.onMove.add(application.onWindowMove);
			window.onRender.add(application.render);
			window.onResize.add(application.onWindowResize);
			window.onRestore.add(application.onWindowRestore);
			window.onTextEdit.add(application.onTextEdit);
			window.onTextInput.add(application.onTextInput);

			application.onWindowCreate();
		}

		application.onCreateWindow.dispatch(window);

		return window;
	}
}
