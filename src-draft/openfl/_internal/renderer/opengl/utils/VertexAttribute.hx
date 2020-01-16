package openfl._internal.renderer.opengl.utils;

import lime.graphics.opengl.GL;
import lime.utils.ArrayBufferView;
import lime.utils.Float32Array;

@SuppressWarnings("checkstyle:FieldDocComment")
class VertexAttribute
{
	public var components:Int;
	public var normalized:Bool = false;
	public var type:ElementType;
	public var name:String;
	public var enabled:Bool = true;
	public var elements(get, never):Int;

	public var defaultValue:Float32Array;

	public function new(components:Int, type:ElementType, normalized:Bool = false, name:String, defaultValue:Float32Array = null)
	{
		this.components = components;
		this.type = type;
		this.normalized = normalized;
		this.name = name;

		if (defaultValue == null)
		{
			this.defaultValue = new Float32Array(components);
		}
		else
		{
			this.defaultValue = defaultValue;
		}
	}

	public function copy():VertexAttribute
	{
		return new VertexAttribute(components, type, normalized, name, defaultValue);
	}

	private inline function getElementsBytes():Int
	{
		return switch (type)
		{
			case BYTE, UNSIGNED_BYTE: 1;
			case SHORT, UNSIGNED_SHORT: 2;
			default: 4;
		}
	}

	private inline function get_elements():Int
	{
		return Math.floor((components * getElementsBytes()) / 4);
	}
}
