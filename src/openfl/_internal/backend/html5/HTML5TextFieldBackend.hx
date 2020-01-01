package openfl._internal.backend.html5;

#if openfl_html5
import openfl.events.Event;
import openfl.text.TextField;

@:access(openfl.text.TextField)
class HTML5TextFieldBackend
{
	private var parent:TextField;

	public function new(parent:TextField)
	{
		this.parent = parent;
	}

	public function disableInput():Void {}

	public function enableInput():Void {}

	public function stopInput():Void {}
}
#end
