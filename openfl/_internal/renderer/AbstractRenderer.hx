package openfl._internal.renderer;


import openfl.display.Shape;
import openfl.display.Stage;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


class AbstractRenderer {
	
	
	public var height:Int;
	public var width:Int;
	public var transparent:Bool;
	public var viewport:Rectangle;
	
	private var renderSession:RenderSession;
	private var stage:Stage;
	
	
	private function new (stage:Stage) {
		
		this.stage = stage;
		
		width = stage.stageWidth;
		height = stage.stageHeight;
		
	}
	
	
	public function clear ():Void {
		
		
		
	}
	
	
	public function render ():Void {
		
		
		
	}
	
	
	public function renderStage3D ():Void {
		
		
		
	}
	
	
	//public function renderShape (shape:Shape):Void {
		//
		//
		//
	//}
	
	
	//public function setViewport (x:Int, y:Int, width:Int, height:Int):Void {
		//
		//
		//
	//}
	
	
	public function resize (width:Int, height:Int):Void {
		
		this.width = width;
		this.height = height;
		
	}
	
	
}