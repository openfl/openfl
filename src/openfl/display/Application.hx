package openfl.display;

import openfl.utils._internal.Lib;
import openfl.events.Event;
#if lime
import lime.app.Application as LimeApplication;
import lime.ui.WindowAttributes;
#end
#if (sys || air)
import openfl.desktop.NativeApplication;
#end
#if (!flash && sys)
import openfl.display.NativeWindow;
import openfl.display.NativeWindowInitOptions;
import openfl.events.InvokeEvent;
#end

/**
	The Application class is a Lime Application instance that uses
	OpenFL Window by default when a new window is created.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display.DisplayObject)
@:access(openfl.display.LoaderInfo)
@:access(openfl.display.Window)
#if (!flash && sys)
@:access(openfl.display.NativeWindowInitOptions)
#end
@SuppressWarnings("checkstyle:FieldDocComment")
class Application #if lime extends LimeApplication #end
{
	#if !lime
	public static var current:Application;

	public var window:Window;
	#end

	public function new()
	{
		#if lime
		super();
		#end

		if (Lib.application == null)
		{
			Lib.application = this;
		}

		#if (!flash && !macro)
		if (Lib.current == null) Lib.current = new MovieClip();
		Lib.current.__loaderInfo = LoaderInfo.create(null);
		Lib.current.__loaderInfo.content = Lib.current;
		#end
	}

	#if lime
	public override function createWindow(attributes:WindowAttributes):Window
	{
		var window = new Window(this, attributes);

		__windows.push(window);
		__windowByID.set(window.id, window);

		window.onClose.add(__onWindowClose.bind(window), false, -10000);

		if (__window == null)
		{
			__window = window;

			window.onActivate.add(onWindowActivate);
			window.onRenderContextLost.add(onRenderContextLost);
			window.onRenderContextRestored.add(onRenderContextRestored);
			window.onDeactivate.add(onWindowDeactivate);
			window.onDropFile.add(onWindowDropFile);
			window.onEnter.add(onWindowEnter);
			window.onExpose.add(onWindowExpose);
			window.onFocusIn.add(onWindowFocusIn);
			window.onFocusOut.add(onWindowFocusOut);
			window.onFullscreen.add(onWindowFullscreen);
			window.onKeyDown.add(onKeyDown);
			window.onKeyUp.add(onKeyUp);
			window.onLeave.add(onWindowLeave);
			window.onMinimize.add(onWindowMinimize);
			window.onMouseDown.add(onMouseDown);
			window.onMouseMove.add(onMouseMove);
			window.onMouseMoveRelative.add(onMouseMoveRelative);
			window.onMouseUp.add(onMouseUp);
			window.onMouseWheel.add(onMouseWheel);
			window.onMove.add(onWindowMove);
			window.onRender.add(render);
			window.onResize.add(onWindowResize);
			window.onRestore.add(onWindowRestore);
			window.onTextEdit.add(onTextEdit);
			window.onTextInput.add(onTextInput);

			onWindowCreate();

			#if (!flash && sys)
			var initOptions = new NativeWindowInitOptions();
			initOptions.__window = cast __window;
			new NativeWindow(initOptions);
			#end
		}

		onCreateWindow.dispatch(window);

		return window;
	}

	@:noCompletion override public function exec():Int
	{
		#if (!flash && sys)
		// wait for the first update to dispatch invoke event
		// to ensure that the document class constructor has completed
		onUpdate.add(function(delta:Int):Void
		{
			if (NativeApplication.nativeApplication.hasEventListener(InvokeEvent.INVOKE))
			{
				var args = Sys.args();
				var cwd = new openfl.filesystem.File(Sys.getCwd());
				var invokeEvent = new openfl.events.InvokeEvent(InvokeEvent.INVOKE, false, false, cwd, args);
				NativeApplication.nativeApplication.dispatchEvent(invokeEvent);
			}
		}, true);
		#end

		return super.exec();
	}
	#end

	#if (lime >= "8.1.0")
	@:noCompletion override private function __checkForAllWindowsClosed():Void
	{
		if (__windows.length > 0)
		{
			return;
		}
		#if (sys || air)
		if (!NativeApplication.nativeApplication.autoExit)
		{
			return;
		}
		#end
		#if (!flash && sys)
		var exitingEvent = new Event(Event.EXITING, false, true);
		var result = NativeApplication.nativeApplication.dispatchEvent(exitingEvent);
		if (!result)
		{
			return;
		}
		#end
		super.__checkForAllWindowsClosed();
	}

	@:noCompletion override private function __onModuleExit(code:Int):Void
	{
		if (onExit.canceled)
		{
			return;
		}
		if (Lib.application == this)
		{
			Lib.application = null;
		}
		super.__onModuleExit(code);
	}
	#end
}
