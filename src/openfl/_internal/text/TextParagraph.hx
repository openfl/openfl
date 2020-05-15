package openfl._internal.text;

import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@SuppressWarnings(["checkstyle:FieldDocComment", "checkstyle:Dynamic"])
class TextParagraph
{
	// paragraphs begin the character after a line break or at textIndex == 0
	public var startIndex:Int;
	public var endIndex:Int;

	public var align:TextFormatAlign;
	public var blockIndent:Int;
	public var bullet:Bool;
	public var indent:Int;
	public var leftMargin:Int;
	public var rightMargin:Int;
	// TODO: tabStops
	
	public var offsetX:Float;
	public var offsetY:Float; // or int?
	
	public var width:Float; // needed?
	public var height:Int;
	
	public var lines:Array<TextLine>;

	public function new(startIndex:Int)
	{
		this.startIndex = startIndex;
		endIndex = startIndex;
		
		offsetX = offsetY = 2; // GUTTER
		
		width = 0;
		height = 0;
		
		lines = [];
		
		align = LEFT;
		blockIndent = 0;
		bullet = false;
		indent = 0;
		leftMargin = 0;
		rightMargin = 0;
	}
	
	public function addLine(line:TextLine):Void
	{
		lines.push(line);
	}
	
	public function setParagraphFormat(format:TextFormat):Void
	{
		// paragraph-level metrics
		
		align = format.align != null ? format.align : align;
		blockIndent = format.blockIndent != null ? format.blockIndent : blockIndent;
		// TODO: bullet = format.bullet;
		indent = format.indent != null ? format.indent : indent;
		leftMargin = format.leftMargin != null ? format.leftMargin : leftMargin;
		rightMargin = format.rightMargin != null ? format.rightMargin : rightMargin;
		// TODO: tabStops
	}
	
	public function addLayoutGroup(lg:TextLayoutGroup):Void
	{
		var line:TextLine = null;
		
		if (lg.lineIndex >= lines.length)
		{
			var end = lines.length == 0 ? startIndex : lines[lines.length - 1].endIndex;
			line = new TextLine();
			line.shiftX(getLineX(lines.push(line) - 1));
		}
		else
		{
			line = lines[lines.length - 1];
			height -= line.height; // in case the height changes after adding the new LG
		}
		
		line.addLayoutGroup(lg);
	}
	
	public function finalize(initialY:Float):Void
	{	
		if (lines.length <= 0) return;
		
		width = 0;
		height = 0;
		
		for (line in lines)
		{
			// do x/offsetX here instead of alg
			
			line.finalize(initialY);
			
			if (line.width > width) width = line.width;
			
			initialY += line.height;
			height += line.height;
		}
		
		endIndex = lines[lines.length - 1].endIndex;
	}
	
	public function getLineX(relativeLineIndex:Int):Float
	{
		return offsetX + leftMargin + blockIndent + (relativeLineIndex == 0 ? indent : 0);
	}
}