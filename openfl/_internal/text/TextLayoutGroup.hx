package openfl._internal.text;


import openfl.text.TextFormat;


class TextLayoutGroup {
	
	
	public var advances:Array<Float>;
	public var ascent:Float;
	public var descent:Float;
	public var endIndex:Int;
	public var format:TextFormat;
	public var height:Float;
	public var leading:Int;
	public var lineIndex:Int;
	public var offsetX:Float;
	public var offsetY:Float;
	public var startIndex:Int;
	public var width:Float;
	
	
	public function new (format:TextFormat, startIndex:Int, endIndex:Int) {
		
		this.format = format;
		this.startIndex = startIndex;
		this.endIndex = endIndex;
		
	}
	
	
}