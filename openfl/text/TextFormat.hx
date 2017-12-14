package openfl.text;


#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


class TextFormat {
	
	
	public var align:TextFormatAlign;
	public var blockIndent:Null<Int>;
	public var bold:Null<Bool>;
	public var bullet:Null<Bool>;
	public var color:Null<Int>;
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
	
	private var __ascent:Null<Float>;
	private var __descent:Null<Float>;
	
	
	public function new (font:String = null, size:Null<Int> = null, color:Null<Int> = null, bold:Null<Bool> = null, italic:Null<Bool> = null, underline:Null<Bool> = null, url:String = null, target:String = null, align:TextFormatAlign = null, leftMargin:Null<Int> = null, rightMargin:Null<Int> = null, indent:Null<Int> = null, leading:Null<Int> = null) {
		
		this.font = font;
		this.size = size;
		this.color = color;
		this.bold = bold;
		this.italic = italic;
		this.underline = underline;
		this.url = url;
		this.target = target;
		this.align = align;
		this.leftMargin = leftMargin;
		this.rightMargin = rightMargin;
		this.indent = indent;
		this.leading = leading;
		
	}
	
	
	public function clone ():TextFormat {
		
		var newFormat = new TextFormat (font, size, color, bold, italic, underline, url, target);
		
		newFormat.align = align;
		newFormat.leftMargin = leftMargin;
		newFormat.rightMargin = rightMargin;
		newFormat.indent = indent;
		newFormat.leading = leading;
		
		newFormat.blockIndent = blockIndent;
		newFormat.bullet = bullet;
		newFormat.kerning = kerning;
		newFormat.letterSpacing = letterSpacing;
		newFormat.tabStops = tabStops;
		
		newFormat.__ascent = __ascent;
		newFormat.__descent = __descent;
		
		return newFormat;
		
	}
	
	
	private function __merge (format:TextFormat):Void {
		
		if (format.font != null) font = format.font;
		if (format.size != null) size = format.size;
		if (format.color != null) color = format.color;
		if (format.bold != null) bold = format.bold;
		if (format.italic != null) italic = format.italic;
		if (format.underline != null) underline = format.underline;
		
		if (format.url != null && format.url != "") url = format.url;
		if (format.url == "" && url == null) url = "";
		
		if (format.target != null) target = format.target;
		if (format.align != null) align = format.align;
		if (format.leftMargin != null) leftMargin = format.leftMargin;
		if (format.rightMargin != null) rightMargin = format.rightMargin;
		if (format.indent != null) indent = format.indent;
		if (format.leading != null) leading = format.leading;
		if (format.blockIndent != null) blockIndent = format.blockIndent;
		if (format.bullet != null) bullet = format.bullet;
		if (format.kerning != null) kerning = format.kerning;
		if (format.letterSpacing != null) letterSpacing = format.letterSpacing;
		if (format.tabStops != null) tabStops = format.tabStops;
		
		if (format.__ascent != null) __ascent = format.__ascent;
		if (format.__descent != null) __descent = format.__descent;
		
	}
	
	
}