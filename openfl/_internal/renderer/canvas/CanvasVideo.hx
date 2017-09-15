package openfl._internal.renderer.canvas;


import openfl._internal.renderer.RenderSession;
import openfl.media.Video;
import openfl.net.NetStream;

@:access(openfl.media.Video)
@:access(openfl.net.NetStream)


class CanvasVideo {
	
	
	public static function render (video:Video, renderSession:RenderSession):Void {
		
		#if (js && html5)
		if (!video.__renderable || video.__worldAlpha <= 0 || video.__stream == null) return;
		
		var context = renderSession.context;
		
		if (video.__stream.__video != null) {
			
			renderSession.blendModeManager.setBlendMode (video.__worldBlendMode);
			renderSession.maskManager.pushObject (video);
			
			context.globalAlpha = video.__worldAlpha;
			var transform = video.__worldTransform;
			var scrollRect = video.__scrollRect;
			var smoothing = video.smoothing;
			
			if (renderSession.roundPixels) {
				
				context.setTransform (transform.a, transform.b, transform.c, transform.d, Std.int (transform.tx), Std.int (transform.ty));
				
			} else {
				
				context.setTransform (transform.a, transform.b, transform.c, transform.d, transform.tx, transform.ty);
				
			}
			
			if (!smoothing) {
				
				untyped (context).mozImageSmoothingEnabled = false;
				//untyped (context).webkitImageSmoothingEnabled = false;
				untyped (context).msImageSmoothingEnabled = false;
				untyped (context).imageSmoothingEnabled = false;
				
			}
			
			if (scrollRect == null) {
				
				context.drawImage (video.__stream.__video, 0, 0, video.width, video.height);
				
			} else {
				
				context.drawImage (video.__stream.__video, scrollRect.x, scrollRect.y, scrollRect.width, scrollRect.height, scrollRect.x, scrollRect.y, scrollRect.width, scrollRect.height);
				
			}
			
			if (!smoothing) {
				
				untyped (context).mozImageSmoothingEnabled = true;
				//untyped (context).webkitImageSmoothingEnabled = true;
				untyped (context).msImageSmoothingEnabled = true;
				untyped (context).imageSmoothingEnabled = true;
				
			}
			
			renderSession.maskManager.popObject (video);
			
		}
		#end
		
	}
	
	
}