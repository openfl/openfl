package openfl._v2.text; #if lime_legacy


class TextLineMetrics {
	
	
	public var ascent:Float;
	public var descent:Float;
	public var height:Float;
	public var leading:Float;
	public var width:Float;
	public var x:Float;
	
	
	public function new(x:Float = 0, width:Float = 0, height:Float = 0, ascent:Float = 0, descent:Float = 0, leading:Float = 0) {
		
		this.x = x;
		this.width = width;
		this.height = height;
		this.ascent = ascent;
		this.descent = descent;
		this.leading = leading;
		
	}
	
	
}


#end