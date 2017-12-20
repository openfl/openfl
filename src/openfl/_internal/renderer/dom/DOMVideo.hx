package openfl._internal.renderer.dom;


import openfl._internal.renderer.dom.DOMRenderer;
import openfl._internal.renderer.RenderSession;
import openfl.media.Video;
import openfl.net.NetStream;

@:access(openfl.media.Video)
@:access(openfl.net.NetStream)


class DOMVideo {
	
	
	public static function clear (video:Video, renderSession:RenderSession):Void {
		
		#if (js && html5)
		if (video.__active) {
			
			renderSession.element.removeChild (video.__stream.__video);
			video.__active = false;
			
		}
		#end
		
	}
	
	
	public static function render (video:Video, renderSession:RenderSession):Void {
		
		#if (js && html5)
		if (video.stage != null && video.__stream != null && video.__worldVisible && video.__renderable) {
			
			if (!video.__active) {
				
				DOMRenderer.initializeElement (video, video.__stream.__video, renderSession);
				video.__active = true;
				video.__dirty = true;
				
			}
			
			if (video.__dirty) {
				
				video.__stream.__video.width = Std.int (video.__width);
				video.__stream.__video.height = Std.int (video.__height);
				video.__dirty = false;
				
			}
			
			DOMRenderer.updateClip (video, renderSession);
			DOMRenderer.applyStyle (video, renderSession, true, true, true);
			
		} else {
			
			clear (video, renderSession);
			
		}
		#end
		
	}
	
	
}