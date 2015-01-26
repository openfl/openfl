package openfl._v2.display; #if lime_legacy


import openfl.Lib;


class GraphicsSolidFill extends IGraphicsData implements IGraphicsFill {
	
	
	public var alpha:Float;
	public var color:UInt;
	
	
	public function new (color:Int = 0, alpha:Float = 1.0) {
		
		this.color = color;
		this.alpha = alpha;
		
		super (lime_graphics_solid_fill_create (color, alpha));
		
	}
	
	
	private static var lime_graphics_solid_fill_create = Lib.load ("lime", "lime_graphics_solid_fill_create", 2);
	
	
}


#end