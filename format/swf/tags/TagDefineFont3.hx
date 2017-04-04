package format.swf.tags;

class TagDefineFont3 extends TagDefineFont2 implements IDefinitionTag
{
	public static inline var TYPE:Int = 75;
	private static var unitDivisor:Int = 20;
	
	public function new() {
		
		super ();
		
		type = TYPE;
		name = "DefineFont3";
		version = 8;
		level = 2;
		
	}
	
	override public function toString(indent:Int = 0):String {
		var str:String = Tag.toStringCommon(type, name, indent) +
			"ID: " + characterId + ", " +
			"FontName: " + fontName + ", " +
			"Italic: " + italic + ", " +
			"Bold: " + bold + ", " +
			"Glyphs: " + glyphShapeTable.length;
		return str + toStringCommon(indent);
	}
}