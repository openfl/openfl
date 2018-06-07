package openfl._internal.renderer.canvas;


import openfl.display.CanvasRenderer;
import openfl.media.Video;
import openfl.net.NetStream;

@:access(openfl.media.Video)
@:access(openfl.net.NetStream)


class CanvasVideo {
	
	
	public static function render (video:Video, renderer:CanvasRenderer):Void {
		
		#if (js && html5)
		if (!video.__renderable || video.__worldAlpha <= 0 || video.__stream == null) return;
		
		var context = renderer.context;
		
		if (video.__stream.__video != null) {
			
			renderer.__setBlendMode (video.__worldBlendMode);
			renderer.__pushMaskObject (video);
			
			context.globalAlpha = video.__worldAlpha;
			var scrollRect = video.__scrollRect;
			var smoothing = video.smoothing;
			
			renderer.setTransform (video.__worldTransform, context);
			
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
			
			renderer.__popMaskObject (video);
			
		}
		#end
		
	}
	
	
}