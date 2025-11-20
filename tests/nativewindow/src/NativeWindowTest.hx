package;

import openfl.display.NativeWindowSystemChrome;
import openfl.Lib;
import openfl.display.NativeWindow;
import openfl.display.NativeWindowInitOptions;
import openfl.display.NativeWindowType;
import openfl.events.Event;
import utest.Assert;
import utest.Async;
import utest.Test;

class NativeWindowTest extends Test
{
	public function test_new():Void
	{
		var nativeWindow = new NativeWindow(new NativeWindowInitOptions());
		Assert.isFalse(nativeWindow.active);
		// Assert.isFalse(nativeWindow.alwaysInFront);
		Assert.isFalse(nativeWindow.closed);
		Assert.isTrue(nativeWindow.maximizable);
		Assert.isTrue(nativeWindow.minimizable);
		Assert.isTrue(nativeWindow.resizable);
		Assert.isNull(nativeWindow.owner);
		Assert.notNull(nativeWindow.stage);
		Assert.equals(NativeWindowSystemChrome.STANDARD, nativeWindow.systemChrome);
		Assert.equals("", nativeWindow.title);
		Assert.isFalse(nativeWindow.transparent);
		Assert.equals(NativeWindowType.NORMAL, nativeWindow.type);
		Assert.isFalse(nativeWindow.visible);
	}

	@:timeout(2000)
	public function test_activate(async:Async):Void
	{
		#if !flash
		if (Sys.getEnv("SDL_VIDEODRIVER") == "dummy")
		{
			// activation doesn't seem to work when using the dummy video driver
			// which we need sometimes when running tests on the CI server
			Assert.pass("Skipping NativeWindow activate() test");
			async.done();
			return;
		}
		#end
		var nativeWindow = new NativeWindow(new NativeWindowInitOptions());
		var dispatchedActivate = false;
		nativeWindow.addEventListener(Event.ACTIVATE, function(event:Event):Void
		{
			dispatchedActivate = true;
		});
		Assert.isFalse(nativeWindow.active);
		nativeWindow.activate();
		Lib.setTimeout(function():Void
		{
			if (async.timedOut)
			{
				return;
			}
			Assert.isTrue(nativeWindow.active);
			Assert.isTrue(dispatchedActivate);
			nativeWindow.close();
			async.done();
		}, 1000);
	}

	@:timeout(1000)
	public function test_close(async:Async):Void
	{
		var nativeWindow = new NativeWindow(new NativeWindowInitOptions());
		var dispatchedClosing = false;
		nativeWindow.addEventListener(Event.CLOSING, function(event:Event):Void
		{
			dispatchedClosing = true;
		});
		var dispatchedClose = false;
		nativeWindow.addEventListener(Event.CLOSE, function(event:Event):Void
		{
			dispatchedClose = true;
		});
		nativeWindow.activate();
		Assert.isFalse(nativeWindow.closed);
		Assert.isFalse(dispatchedClosing);
		Assert.isFalse(dispatchedClose);
		nativeWindow.close();
		Lib.setTimeout(function():Void
		{
			if (async.timedOut)
			{
				return;
			}
			Assert.isTrue(nativeWindow.closed);
			// Event.CLOSING is not dispatched when calling close()
			Assert.isFalse(dispatchedClosing);
			Assert.isTrue(dispatchedClose);
			async.done();
		}, 250);
	}

	#if !flash
	@:timeout(1000)
	public function test_closing(async:Async)
	{
		var nativeWindow = new NativeWindow(new NativeWindowInitOptions());
		var cancelClosing = true;
		var dispatchedClosing = false;
		nativeWindow.addEventListener(Event.CLOSING, function(event:Event):Void
		{
			dispatchedClosing = true;
			if (cancelClosing)
			{
				event.preventDefault();
			}
		});
		var dispatchedClose = false;
		nativeWindow.addEventListener(Event.CLOSE, function(event:Event):Void
		{
			dispatchedClose = true;
		});
		nativeWindow.activate();
		Assert.isFalse(nativeWindow.closed);
		Assert.isFalse(dispatchedClosing);
		Assert.isFalse(dispatchedClose);
		// normally, closing a window programmatically doesn't dispatch
		// Event.CLOSING. the event is intended to be dispatched if the user
		// closes it interactively. however, by bypassing NativeWindow.close(),
		// and using Lime's version of close(), it's like simulating the user
		// closing the window interactively.
		@:privateAccess nativeWindow.__window.close();
		Lib.setTimeout(function():Void
		{
			if (async.timedOut)
			{
				return;
			}
			Assert.isFalse(nativeWindow.closed);
			Assert.isTrue(dispatchedClosing);
			Assert.isFalse(dispatchedClose);
			cancelClosing = false;
			dispatchedClosing = false;
			@:privateAccess nativeWindow.__window.close();
			Lib.setTimeout(function():Void
			{
				if (async.timedOut)
				{
					return;
				}
				Assert.isTrue(nativeWindow.closed);
				Assert.isTrue(dispatchedClosing);
				Assert.isTrue(dispatchedClose);
				async.done();
			}, 250);
		}, 250);
	}
	#end
}
