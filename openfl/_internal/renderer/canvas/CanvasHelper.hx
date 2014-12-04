package openfl._internal.renderer.canvas;


class CanvasHelper{
	
	
	
	public static function blendModeToCompositeOperation (blendMode:openfl.display.BlendMode) : String
	{
		switch blendMode
		{
			case ADD : return "lighter";
			case DARKEN : return "darken";
			case DIFFERENCE : return "difference";
			case ERASE : return "xor";
			case HARDLIGHT : return "hard-light";
			case LIGHTEN : return "lighten";
			case MULTIPLY : return "multiply";
			case OVERLAY : return "overlay";
			case SCREEN : return "screen";
			default : return "source-over";
		}
	}
	
	
}