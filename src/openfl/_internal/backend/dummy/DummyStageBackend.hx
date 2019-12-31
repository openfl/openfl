package openfl._internal.backend.dummy;

import openfl.display.Stage;
import openfl.display.Window in OpenFLWindow;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class DummyStageBackend
{
	public function new(parent:Stage, window:OpenFLWindow, color:Null<Int> = null) {}
}
