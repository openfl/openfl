package flash.text;

#if flash
extern class TextFormat
{
	public var align:TextFormatAlign;
	public var blockIndent:Null<Int>;
	public var bold:Null<Bool>;
	public var bullet:Null<Bool>;
	public var color:Null<Int>;
	#if flash
	public var display:flash.text.TextFormatDisplay;
	#end
	public var font:String;
	public var indent:Null<Int>;
	public var italic:Null<Bool>;
	public var kerning:Null<Bool>;
	public var leading:Null<Int>;
	public var leftMargin:Null<Int>;
	public var letterSpacing:Null<Float>;
	public var rightMargin:Null<Int>;
	public var size:Null<Int>;
	public var tabStops:Array<Int>;
	public var target:String;
	public var underline:Null<Bool>;
	public var url:String;
	public function new(font:String = null, size:Null<Int> = null, color:Null<Int> = null, bold:Null<Bool> = null, italic:Null<Bool> = null,
		underline:Null<Bool> = null, url:String = null, target:String = null, align:TextFormatAlign = null, leftMargin:Null<Int> = null,
		rightMargin:Null<Int> = null, indent:Null<Int> = null, leading:Null<Int> = null);
}
#else
typedef TextFormat = openfl.text.TextFormat;
#end
