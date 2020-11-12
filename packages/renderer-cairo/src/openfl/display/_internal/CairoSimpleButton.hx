package openfl.display._internal;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display.SimpleButton)
class CairoSimpleButton
{
	public static inline function renderDrawable(simpleButton:SimpleButton, renderer:CairoRenderer):Void
	{
		if (!simpleButton.__renderable || simpleButton.__worldAlpha <= 0 || simpleButton.__currentState == null) return;

		renderer.__pushMaskObject(simpleButton);
		renderer.__renderDrawable(simpleButton.__currentState);
		renderer.__popMaskObject(simpleButton);

		renderer.__renderEvent(simpleButton);
	}

	public static inline function renderDrawableMask(simpleButton:SimpleButton, renderer:CairoRenderer):Void
	{
		renderer.__renderDrawableMask(simpleButton.__currentState);
	}
}
