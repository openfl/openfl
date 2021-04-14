package openfl.display._internal;

@:access(openfl.display.SimpleButton)
class CanvasSimpleButton
{
	public static function renderDrawable(simpleButton:SimpleButton, renderer:CanvasRenderer):Void
	{
		if (!simpleButton.__renderable || simpleButton.__worldAlpha <= 0 || simpleButton.__currentState == null) return;

		#if !neko
		renderer.__pushMaskObject(simpleButton);
		renderer.__renderDrawable(simpleButton.__currentState);
		renderer.__popMaskObject(simpleButton);

		renderer.__renderEvent(simpleButton);
		#end
	}

	public static function renderDrawableMask(simpleButton:SimpleButton, renderer:CanvasRenderer):Void
	{
		// var bounds = Rectangle.__pool.get ();
		// simpleButton.__getLocalBounds (bounds);

		// renderer.context.rect (bounds.x, bounds.y, bounds.width, bounds.height);

		// Rectangle.__pool.release (bounds);
		renderer.__renderDrawableMask(simpleButton.__currentState);
	}
}
