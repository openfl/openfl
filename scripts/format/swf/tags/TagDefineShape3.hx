package format.swf.tags;

import format.swf.SWFData;

class TagDefineShape3 extends TagDefineShape2 implements IDefinitionTag
{
	public static inline var TYPE:Int = 32;

	public function new()
	{
		super();

		type = TYPE;
		name = "DefineShape3";
		version = 3;
		level = 3;
	}

	override public function toString(indent:Int = 0):String
	{
		var str:String = Tag.toStringCommon(type, name, indent) + "ID: " + characterId + ", " + "Bounds: " + shapeBounds;
		str += shapes.toString(indent + 2);
		return str;
	}
}
