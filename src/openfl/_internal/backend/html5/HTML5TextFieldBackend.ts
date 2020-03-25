namespace openfl._internal.backend.html5;

#if openfl_html5
import Event from "openfl/events/Event";
import openfl.text.TextField;

@: access(openfl.text.TextField)
class HTML5TextFieldBackend
{
	private parent: TextField;

	public new(parent: TextField)
	{
		this.parent = parent;
	}

	public disableInput(): void { }

	public enableInput(): void { }

	public stopInput(): void { }
}
#end
