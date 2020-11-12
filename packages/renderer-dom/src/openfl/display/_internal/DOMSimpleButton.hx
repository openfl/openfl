package openfl.display._internal;

@:access(openfl.display.DisplayObject)
@:access(openfl.display.SimpleButton)
class DOMSimpleButton
{
	public static function renderDrawable(simpleButton:SimpleButton, renderer:DOMRenderer):Void
	{
		#if !neko
		renderer.__pushMaskObject(simpleButton);

		for (previousState in simpleButton.__previousStates)
		{
			renderer.__renderDrawable(previousState);
		}

		simpleButton.__previousStates.length = 0;

		if (simpleButton.__currentState != null)
		{
			if (simpleButton.__currentState.stage != simpleButton.stage)
			{
				simpleButton.__currentState.__setStageReference(simpleButton.stage);
			}

			renderer.__renderDrawable(simpleButton.__currentState);
		}

		renderer.__popMaskObject(simpleButton);

		renderer.__renderEvent(simpleButton);
		#end
	}

	public static function renderDrawableClear(simpleButton:SimpleButton, renderer:DOMRenderer):Void
	{
		DOMDisplayObject.renderDrawableClear(simpleButton, renderer);
	}
}
