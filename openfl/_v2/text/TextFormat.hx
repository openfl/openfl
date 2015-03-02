package openfl._v2.text; #if lime_legacy


@:keep class TextFormat {
	
	
	public var align:String;
	public var blockIndent:Null<Float>;
	public var bold:Null<Bool>;
	public var bullet:Null<Bool>;
	public var color:Null<Int>;
	public var display:String;
	public var font:String;
	public var indent:Null<Float>;
	public var italic:Null<Bool>;
	public var kerning:Null<Float>;
	public var leading:Null<Float>;
	public var leftMargin:Null<Float>;
	public var letterSpacing:Null<Float>;
	public var rightMargin:Null<Float>;
	public var size:Null<Float>;
	public var tabStops:Array<Int>;
	public var target:String;
	public var underline:Null<Bool>;
	public var url:String;
	
	
	public function new (font:String = null, size:Null<Float> = null, color:Null<Int> = null, bold:Null<Bool> = null, italic:Null<Bool> = null, underline:Null<Bool> = null, url:String = null, target:String = null, align:String = null, leftMargin:Null<Float> = null, rightMargin:Null<Float> = null, indent:Null<Float> = null, leading:Null<Float> = null) {
		
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
	
	
}


#end