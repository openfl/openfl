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
	public var parent:Application;

	public function new(application:Application)
	{
		parent = application;

		if (Lib.limeApplication == null)
		{
			Lib.limeApplication = parent;
		}

		#if (!flash && !macro)
		if (Lib.current == null) Lib.current = new MovieClip();
		(Lib.current._ : _DisplayObject).__loaderInfo = _LoaderInfo.create(null);
		((Lib.current._ : _DisplayObject).__loaderInfo._ : _LoaderInfo).content = Lib.current;
		#end
	}

	public function createWindow(attributes:WindowAttributes):Window
	{
		var window = new Window(parent, attributes);

		parent._.__windows.push(window);
		parent._.__windowByID.set(window.id, window);

		window.onClose.add(parent._.__onWindowClose.bind(window), false, -10000);

		if (parent._.__window == null)
		{
			parent._.__window = window;

			window.onActivate.add(parent.onWindowActivate);
			window.onRenderContextLost.add(parent.onRenderContextLost);
			window.onRenderContextRestored.add(parent.onRenderContextRestored);
			window.onDeactivate.add(parent.onWindowDeactivate);
			window.onDropFile.add(parent.onWindowDropFile);
			window.onEnter.add(parent.onWindowEnter);
			window.onExpose.add(parent.onWindowExpose);
			window.onFocusIn.add(parent.onWindowFocusIn);
			window.onFocusOut.add(parent.onWindowFocusOut);
			window.onFullscreen.add(parent.onWindowFullscreen);
			window.onKeyDown.add(parent.onKeyDown);
			window.onKeyUp.add(parent.onKeyUp);
			window.onLeave.add(parent.onWindowLeave);
			window.onMinimize.add(parent.onWindowMinimize);
			window.onMouseDown.add(parent.onMouseDown);
			window.onMouseMove.add(parent.onMouseMove);
			window.onMouseMoveRelative.add(parent.onMouseMoveRelative);
			window.onMouseUp.add(parent.onMouseUp);
			window.onMouseWheel.add(parent.onMouseWheel);
			window.onMove.add(parent.onWindowMove);
			window.onRender.add(parent.render);
			window.onResize.add(parent.onWindowResize);
			window.onRestore.add(parent.onWindowRestore);
			window.onTextEdit.add(parent.onTextEdit);
			window.onTextInput.add(parent.onTextInput);

			parent.onWindowCreate();
		}

		parent.onCreateWindow.dispatch(window);

		return window;
	}
}
