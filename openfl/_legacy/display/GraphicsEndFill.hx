package openfl._legacy.display; #if openfl_legacy


import openfl.Lib;


class GraphicsEndFill extends IGraphicsData implements IGraphicsFill {
	
	
	public function new () {
		
		super (lime_graphics_end_fill_create ());
		
	}
	
	
	private static var lime_graphics_end_fill_create = Lib.load ("lime-legacy", "lime_legacy_graphics_end_fill_create", 0);
	
	
}


#end