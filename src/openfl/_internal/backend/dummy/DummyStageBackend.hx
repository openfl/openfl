package openfl._internal.backend.dummy;

import openfl.display.Stage;
import openfl.display.StageDisplayState;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class DummyStageBackend
{
	public function new(parent:Stage) {}

	public function cancelRender():Void {}

	public function getFrameRate():Int
	{
		return 0;
	}

	public function getFullScreenHeight():UInt
	{
		return 0;
	}

	public function getFullScreenWidth():UInt
	{
		return 0;
	}

	public function getWindowFullscreen():Bool
	{
		return false;
	}

	public function getWindowHeight():Int
	{
		return 0;
	}

	public function getWindowWidth():Int
	{
		return 0;
	}

	public function setFrameRate(value:Float):Void {}

	public function setDisplayState(value:StageDisplayState):Void {}
}
