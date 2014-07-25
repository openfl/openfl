package openfl._internal.renderer;


import openfl.display.Shape;
import openfl.display.Stage;


class AbstractRenderer {
	
	
	public var height:Int;
	public var width:Int;
	
	private var renderSession:RenderSession;
	
	
	private function new (width:Int, height:Int) {
		
		this.width = width;
		this.height = height;
		
	}
	
	
	public function render (stage:Stage):Void {
		
		
		
	}
	
	
	public function renderShape (shape:Shape):Void {
		
		
		
	}
	
	
	public function resize (width:Int, height:Int):Void {
		
		
		
	}
	
	
}