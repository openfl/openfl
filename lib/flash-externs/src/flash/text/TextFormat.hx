package flash.text;

#if flash
extern class TextFormat
{
	#if (haxe_ver < 4.3)
	public var align:TextFormatAlign;
	public var blockIndent:Null<Int>;
	public var bold:Null<Bool>;
	public var bullet:Null<Bool>;
	public var color:Null<Int>;
	public var display:TextFormatDisplay;
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
	#else
	@:flash.property var align(get, set):TextFormatAlign;
	@:flash.property var blockIndent(get, set):Null<Int>;
	@:flash.property var bold(get, set):Null<Bool>;
	@:flash.property var bullet(get, set):Null<Bool>;
	@:flash.property var color(get, set):Null<UInt>;
	@:flash.property var display(get, set):TextFormatDisplay;
	@:flash.property var font(get, set):String;
	@:flash.property var indent(get, set):Null<Int>;
	@:flash.property var italic(get, set):Null<Bool>;
	@:flash.property var kerning(get, set):Null<Bool>;
	@:flash.property var leading(get, set):Null<Int>;
	@:flash.property var leftMargin(get, set):Null<Int>;
	@:flash.property var letterSpacing(get, set):Null<Float>;
	@:flash.property var rightMargin(get, set):Null<Int>;
	@:flash.property var size(get, set):Null<Int>;
	@:flash.property var tabStops(get, set):Array<Int>;
	@:flash.property var target(get, set):String;
	@:flash.property var underline(get, set):Null<Bool>;
	@:flash.property var url(get, set):String;
	#end

	public function new(font:String = null, size:Null<Int> = null, color:Null<Int> = null, bold:Null<Bool> = null, italic:Null<Bool> = null,
		underline:Null<Bool> = null, url:String = null, target:String = null, align:TextFormatAlign = null, leftMargin:Null<Int> = null,
		rightMargin:Null<Int> = null, indent:Null<Int> = null, leading:Null<Int> = null);

	#if (haxe_ver >= 4.3)
	private function get_align():TextFormatAlign;
	private function get_blockIndent():Null<Int>;
	private function get_bold():Null<Bool>;
	private function get_bullet():Null<Bool>;
	private function get_color():Null<UInt>;
	private function get_display():TextFormatDisplay;
	private function get_font():String;
	private function get_indent():Null<Int>;
	private function get_italic():Null<Bool>;
	private function get_kerning():Null<Bool>;
	private function get_leading():Null<Int>;
	private function get_leftMargin():Null<Int>;
	private function get_letterSpacing():Null<Float>;
	private function get_rightMargin():Null<Int>;
	private function get_size():Null<Int>;
	private function get_tabStops():Array<Int>;
	private function get_target():String;
	private function get_underline():Null<Bool>;
	private function get_url():String;
	private function set_align(value:TextFormatAlign):TextFormatAlign;
	private function set_blockIndent(value:Null<Int>):Null<Int>;
	private function set_bold(value:Null<Bool>):Null<Bool>;
	private function set_bullet(value:Null<Bool>):Null<Bool>;
	private function set_color(value:Null<UInt>):Null<UInt>;
	private function set_display(value:TextFormatDisplay):TextFormatDisplay;
	private function set_font(value:String):String;
	private function set_indent(value:Null<Int>):Null<Int>;
	private function set_italic(value:Null<Bool>):Null<Bool>;
	private function set_kerning(value:Null<Bool>):Null<Bool>;
	private function set_leading(value:Null<Int>):Null<Int>;
	private function set_leftMargin(value:Null<Int>):Null<Int>;
	private function set_letterSpacing(value:Null<Float>):Null<Float>;
	private function set_rightMargin(value:Null<Int>):Null<Int>;
	private function set_size(value:Null<Int>):Null<Int>;
	private function set_tabStops(value:Array<Int>):Array<Int>;
	private function set_target(value:String):String;
	private function set_underline(value:Null<Bool>):Null<Bool>;
	private function set_url(value:String):String;
	#end
}
#else
typedef TextFormat = openfl.text.TextFormat;
#end
