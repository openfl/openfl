package openfl.text; #if !flash #if (display || openfl_next || js)


class TextLineMetrics {
	
	
	public var ascent:Float;
	public var descent:Float;
	public var height:Float;
	public var leading:Float;
	public var width:Float;
	public var x:Float;
	
	
	public function new (x:Float, width:Float, height:Float, ascent:Float, descent:Float, leading:Float) {
		
		this.x = x;
		this.width = width;
		this.height = height;
		this.ascent = ascent;
		this.descent = descent;
		this.leading = leading;
		
	}
	
	
}


#else
typedef TextLineMetrics = openfl._v2.text.TextLineMetrics;
#end
#else
typedef TextLineMetrics = flash.text.TextLineMetrics;
#end