package openfl._internal.text;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@SuppressWarnings(["checkstyle:FieldDocComment", "checkstyle:Dynamic"])
class TextLine
{
	public var startIndex:Int;
	public var endIndex:Int;
	
	public var ascent:Float;
	public var descent:Float;
	public var height:Int;
	public var leading:Int;
	public var width:Float;
	
	public var offsetY:Float;
	
	public var layoutGroups:Vector<TextLayoutGroup>;

	public function new()
	{
		startIndex = 0;
		endIndex = 0;
		
		// line-level metrics
		ascent = 0;
		descent = 0;
		height = 0;
		leading = 0;
		width = 0;
		
		offsetY = 0;
		
		layoutGroups = new Vector();
	}
	
	public function addLayoutGroup(lg:TextLayoutGroup):Void
	{
		// TODO: check previous and combine if possible?
		layoutGroups.push(lg);
	}
	
	public function shiftX(deltaX:Float):Void
	{
		for (lg in layoutGroups) lg.offsetX += deltaX;
	}
	
	public function finalize(initialY:Float):Void
	{
		width = 0;
		
		if (layoutGroups.length <= 0) return;
		
		for (lg in layoutGroups) {
			
			width += lg.width;
			lg.offsetY = initialY;
			
			// TODO: can two LGs have the same height but different ascents?
			if (lg.height > height)
			{
				height = Math.ceil(lg.height);
				ascent = lg.ascent;
				descent = lg.descent;
			}
			
			if (lg.leading > leading) leading = lg.leading;
		}
		
		for (lg in layoutGroups)
		{
			// aligns the baselines of everything in the line
			// TODO: when removing text, I assume the baseline adjusts as you go... but what happens to the original values?
			lg.ascent = ascent;
			lg.height = height;
			lg.descent = descent;
		}
		
		startIndex = layoutGroups[0].startIndex;
		endIndex = layoutGroups[layoutGroups.length - 1].endIndex;
	}
}