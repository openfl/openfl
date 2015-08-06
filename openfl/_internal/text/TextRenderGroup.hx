package openfl._internal.text;


import openfl.text.TextFormat;


class TextRenderGroup {
	
	
	public var ascent:Int;
	public var descent:Int;
	public var endIndex:Int;
	public var format:TextFormat;
	public var leading:Int;
	public var lineIndex:Int;
	public var offsetX:Int;
	public var offsetY:Int;
	public var startIndex:Int;
	public var width:Int;
	
	
	public function new (format:TextFormat, startIndex:Int, endIndex:Int) {
		
		this.format = format;
		this.startIndex = startIndex;
		this.endIndex = endIndex;
		
	}
	
	
}