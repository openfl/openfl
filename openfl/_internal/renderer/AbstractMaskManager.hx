package openfl._internal.renderer;


import openfl.display.*;
import openfl.geom.*;

@:access(openfl.display.DisplayObject)
@:keep


class AbstractMaskManager {
	
	
	private var renderSession:RenderSession;
	
	
	public function new (renderSession:RenderSession) {
		
		this.renderSession = renderSession;
		
	}
	
	
	public function pushMask (mask:DisplayObject):Void {
		
		
		
	}
	
	
	public function pushRect (rect:Rectangle, transform:Matrix):Void {
		
		
		
	}
	
	
	public function popMask ():Void {
		
		
		
	}
	
	public function popRect ():Void {
		
		
		
	}
	
	
}