package flash.display; #if (!display && flash)


extern class Shape extends DisplayObject {
	
	
	public var graphics (default, null):Graphics;
	
	public function new ();
	
	
}


#else
typedef Shape = openfl.display.Shape;
#end