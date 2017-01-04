package openfl._internal.renderer;


import openfl.display.BitmapData;
import openfl.display.DisplayObject;
import openfl.display.Shader;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.display.DisplayObject)
@:keep


class AbstractFilterManager {
	
	
	public var useCPUFilters:Bool = true;
	
	private var renderSession:RenderSession;
	
	
	public function new (renderSession:RenderSession) {
		
		this.renderSession = renderSession;
		
	}
	
	
	public function renderFilters (object:DisplayObject, src:BitmapData):BitmapData {
	
		return null;

	}

	public function pushObject (object:DisplayObject):Shader {
		
		return null;
		
	}
	
	
	public function popObject (object:DisplayObject):Void {
		
		
		
	}
	
	
}