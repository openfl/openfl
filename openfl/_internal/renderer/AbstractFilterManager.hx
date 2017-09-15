package openfl._internal.renderer;


import openfl.display.DisplayObject;
import openfl.display.Shader;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.display.DisplayObject)
@:keep


class AbstractFilterManager {
	
	
	private var renderSession:RenderSession;
	
	
	public function new (renderSession:RenderSession) {
		
		this.renderSession = renderSession;
		
	}
	
	
	public function pushObject (object:DisplayObject):Shader {
		
		return null;
		
	}
	
	
	public function popObject (object:DisplayObject):Void {
		
		
		
	}
	
	
}