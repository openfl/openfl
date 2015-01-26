package openfl._v2.display; #if lime_legacy


import openfl.Lib;


class GraphicsEndFill extends IGraphicsData implements IGraphicsFill {
	
	
	public function new () {
		
		super (lime_graphics_end_fill_create ());
		
	}
	
	
	private static var lime_graphics_end_fill_create = Lib.load ("lime", "lime_graphics_end_fill_create", 0);
	
	
}


#end