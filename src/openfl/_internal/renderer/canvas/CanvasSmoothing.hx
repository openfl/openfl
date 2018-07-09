package openfl._internal.renderer.canvas;

import lime.graphics.CanvasRenderContext;

class CanvasSmoothing {
	public static inline function setEnabled(context:CanvasRenderContext, enabled:Bool) {
		(cast context).mozImageSmoothingEnabled = enabled;
		// (cast context).webkitImageSmoothingEnabled = enabled;
		(cast context).msImageSmoothingEnabled = enabled;
		(cast context).imageSmoothingEnabled = enabled;
	}
}
