package openfl._internal.text;


import openfl.text.TextFormat;


class TextRenderGroup {
	
	
	public var end:Int;
	public var format:TextFormat;
	public var start:Int;
	public var x:Int;
	public var y:Int;
	
	
	public function new (format:TextFormat, start:Int, end:Int) {
		
		this.format = format;
		this.start = start;
		this.end = end;
		
	}
	
	
}