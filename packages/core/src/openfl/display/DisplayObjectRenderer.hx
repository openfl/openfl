package openfl.display;

#if !flash
import openfl._internal.renderer.DisplayObjectRendererType;
import openfl.events.EventDispatcher;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import openfl.media.Video;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class DisplayObjectRenderer extends EventDispatcher
{
	@:allow(openfl) @:noCompletion private function new()
	{
		if (_ == null)
		{
			_ = new _DisplayObjectRenderer(this);
		}

		super();
	}
}
#else
typedef DisplayObjectRenderer = Dynamic;
#end
