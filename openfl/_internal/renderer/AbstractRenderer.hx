package openfl._internal.renderer;


import lime.graphics.RenderContext;
import openfl.display.Shape;
import openfl.display.Stage;


class AbstractRenderer {
	
	
	public var height:Int;
	public var width:Int;
	public var contextLost:Bool = false;
	
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
	
	
	public function handleContextLost():Void {
		
		contextLost = true;
		
	}
	
	
	public function handleContextRestored(context:RenderContext):Void {
		
		contextLost = false;
		
	}
	
	
}