package openfl.media; #if !flash #if !lime_legacy


import openfl._internal.renderer.RenderSession;
import openfl.display.DisplayObject;
import openfl.display.Stage;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.net.NetStream;

#if js
import openfl._internal.renderer.dom.DOMRenderer;
import js.html.MediaElement;
import js.Browser;
#end

@:access(openfl.net.NetStream)


class Video extends DisplayObject {
	
	
	public var deblocking:Int;
	public var smoothing:Bool;
	
	@:noCompletion private var __active:Bool;
	@:noCompletion private var __dirty:Bool;
	@:noCompletion private var __height:Float;
	@:noCompletion private var __stream:NetStream;
	@:noCompletion private var __width:Float;
	
	
	public function new (width:Int = 320, height:Int = 240):Void {
		
		super ();
		
		__width = width;
		__height = height;
		
		smoothing = false;
		deblocking = 0;
		
	}
	
	
	public function attachNetStream (ns:NetStream):Void {
		
		__stream = ns;
		
		#if (js && html5)
		__stream.__video.play ();
		#end
		
	}
	
	
	public function clear ():Void {
		
		
		
	}
	
	
	@:noCompletion private override function __getBounds (rect:Rectangle, matrix:Matrix):Void {
		
		var bounds = new Rectangle (0, 0, __width, __height);
		bounds.transform (__worldTransform);
		
		rect.__expand (bounds.x, bounds.y, bounds.width, bounds.height);
		
	}
	
	
	@:noCompletion private override function __hitTest (x:Float, y:Float, shapeFlag:Bool, stack:Array<DisplayObject>, interactiveOnly:Bool):Bool {
		
		if (!visible) return false;
		
		var point = globalToLocal (new Point (x, y));
		
		if (point.x > 0 && point.y > 0 && point.x <= __width && point.y <= __height) {
			
			if (stack != null) {
				
				stack.push (this);
				
			}
			
			return true;
			
		}
		
		return false;
		
	}
	
	
	@:noCompletion @:dox(hide) public override function __renderCanvas (renderSession:RenderSession):Void {
		
		#if (js && html5)
		if (!__renderable || __worldAlpha <= 0) return;
		
		var context = renderSession.context;
		
		if (__stream.__video != null) {
			
			if (__mask != null) {
				
				renderSession.maskManager.pushMask (__mask);
				
			}
			
			context.globalAlpha = __worldAlpha;
			var transform = __worldTransform;
			
			if (renderSession.roundPixels) {
				
				context.setTransform (transform.a, transform.b, transform.c, transform.d, Std.int (transform.tx), Std.int (transform.ty));
				
			} else {
				
				context.setTransform (transform.a, transform.b, transform.c, transform.d, transform.tx, transform.ty);
				
			}
			
			if (!smoothing) {
				
				untyped (context).mozImageSmoothingEnabled = false;
				untyped (context).webkitImageSmoothingEnabled = false;
				context.imageSmoothingEnabled = false;
				
			}
			
			if (scrollRect == null) {
				
				context.drawImage (__stream.__video, 0, 0);
				
			} else {
				
				context.drawImage (__stream.__video, scrollRect.x, scrollRect.y, scrollRect.width, scrollRect.height, scrollRect.x, scrollRect.y, scrollRect.width, scrollRect.height);
				
			}
			
			if (!smoothing) {
				
				untyped (context).mozImageSmoothingEnabled = true;
				untyped (context).webkitImageSmoothingEnabled = true;
				context.imageSmoothingEnabled = true;
				
			}
			
			if (__mask != null) {
				
				renderSession.maskManager.popMask ();
				
			}
			
		}
		#end
		
	}
	
	
	@:noCompletion @:dox(hide) public override function __renderDOM (renderSession:RenderSession):Void {
		
		#if (js && html5)
		if (stage != null && __worldVisible && __renderable) {
			
			if (!__active) {
				
				DOMRenderer.initializeElement (this, __stream.__video, renderSession);
				__active = true;
				__dirty = true;
				
			}
			
			if (__dirty) {
				
				__stream.__video.width = Std.int (__width);
				__stream.__video.height = Std.int (__height);
				__dirty = false;
				
			}
			
			DOMRenderer.applyStyle (this, renderSession, true, true, true);
			
		} else {
			
			if (__active) {
				
				renderSession.element.removeChild (__stream.__video);
				__active = false;
				
			}
			
		}
		#end
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	@:noCompletion private override function get_height ():Float {
		
		return __height * scaleY;
		
	}
	
	
	@:noCompletion private override function set_height (value:Float):Float {
		
		if (scaleY != 1 || value != __height) {
			
			__setTransformDirty ();
			__dirty = true;
			
		}
		
		scaleY = 1;
		return __height = value;
		
	}
	
	
	@:noCompletion private override function get_width ():Float {
		
		return __width * scaleX;
		
	}
	
	
	@:noCompletion private override function set_width (value:Float):Float {
		
		if (scaleX != 1 || __width != value) {
			
			__setTransformDirty ();
			__dirty = true;
			
		}
		
		scaleX = 1;
		return __width = value;
		
	}
	
	
}


#else


import openfl.display.DisplayObject;


class Video extends DisplayObject implements Dynamic {
	
	
	public function new (width:Int = 320, height:Int = 240):Void {
		
		super (null, "video");
		
	}
	
	
}


#end
#else
typedef Video = flash.media.Video;
#end