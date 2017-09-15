package format.swf.tags;

import format.swf.SWFData;

class TagDefineShape2 extends TagDefineShape implements IDefinitionTag
{
	public static inline var TYPE:Int = 22;
	
	public function new() {
		
		super ();
		
		type = TYPE;
		name = "DefineShape2";
		version = 2;
		level = 2;
		
	}
	
	override public function toString(indent:Int = 0):String {
		var str:String = Tag.toStringCommon(type, name, indent) +
			"ID: " + characterId + ", " +
			"Bounds: " + shapeBounds;
		str += shapes.toString(indent + 2);
		return str;
	}
}