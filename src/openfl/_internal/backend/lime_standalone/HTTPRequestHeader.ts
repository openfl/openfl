namespace openfl._internal.backend.lime_standalone;

class HTTPRequestHeader
{
	public name: string;
	public value: string;

	public new(name: string, value: string = "")
	{
		this.name = name;
		this.value = value;
	}
}
