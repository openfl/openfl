namespace openfl._internal.backend.lime;

#if lime
import Event from "../events/Event";
import openfl.text.TextField;

#if!openfl_debug
@: fileXml('tags="haxe,release"')
@: noDebug
#end
@: access(openfl.text.TextField)
class LimeTextFieldBackend
{
	private parent: TextField;

	public constructor(parent: TextField)
	{
		this.parent = parent;
	}

	public disableInput(): void
	{
		var window = parent.stage.limeWindow;

		window.textInputEnabled = false;
		window.onTextInput.remove(window_onTextInput);
	}

	public enableInput(): void
	{
		var window = parent.stage.limeWindow;

		window.textInputEnabled = true;

		if (!window.onTextInput.has(window_onTextInput))
		{
			window.onTextInput.add(window_onTextInput);
		}
	}

	public stopInput(): void
	{
		var window = parent.stage.limeWindow;
		window.onTextInput.remove(window_onTextInput);
	}

	// Event Handlers
	private window_onTextInput(value: string): void
	{
		parent.__replaceSelectedText(value, true);

		// TODO: Dispatch change if at max chars?
		parent.dispatchEvent(new Event(Event.CHANGE, true));
	}
}
#end
