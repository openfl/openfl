package openfl.display;

import openfl.display.Shader.GLShaderParameter;

class GLShaderData
{
	public var keys = new Array<String>();
	public var values = new Array<GLShaderParameter>();

	public function new()
	{
	}

	public function set(key:String, value:GLShaderParameter)
	{
		for(i in 0...keys.length)
		{
			if(keys[i] == key)
			{
				values[i] = value;
				return;
			}
		}

		keys.push(key);
		values.push(value);
	}

	public function get(key:String):GLShaderParameter
	{
		for(i in 0...keys.length)
		{
			if(keys[i] == key)
			{
				return values[i];
			}
		}

		throw "Unknown parameter " + key;
	}
}
