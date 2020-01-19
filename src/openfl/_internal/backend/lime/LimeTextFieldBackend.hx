package openfl._internal.backend.lime;

#if lime
import openfl.events.Event;
import openfl.text.TextField;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.text.TextField)
class LimeTextFieldBackend
{
	private var parent:TextField;

	public function new(parent:TextField)
	{
		this.parent = parent;
	}

	public function disableInput():Void
	{
		var window = parent.stage.limeWindow;

		window.textInputEnabled = false;
		window.onTextInput.remove(window_onTextInput);
	}

	public function enableInput():Void
	{
		var window = parent.stage.limeWindow;

		window.textInputEnabled = true;

		if (!window.onTextInput.has(window_onTextInput))
		{
			window.onTextInput.add(window_onTextInput);
		}
	}

	public function stopInput():Void
	{
		var window = parent.stage.limeWindow;
		window.onTextInput.remove(window_onTextInput);
	}

	// Event Handlers
	private function window_onTextInput(value:String):Void
	{
		parent.__replaceSelectedText(value, true);

		// TODO: Dispatch change if at max chars?
		parent.dispatchEvent(new Event(Event.CHANGE, true));
	}
}
#end
