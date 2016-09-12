package openfl.media;


import openfl._internal.renderer.RenderSession;
import openfl.display.DisplayObject;
import openfl.display.InteractiveObject;
import openfl.display.Stage;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.net.NetStream;

#if (js && html5)
import openfl._internal.renderer.dom.DOMRenderer;
import js.html.MediaElement;
import js.Browser;
#end

@:access(openfl.geom.Rectangle)
@:access(openfl.net.NetStream)


class Video extends DisplayObject {
	
	
	public var deblocking:Int;
	public var smoothing:Bool;
	
	private var __active:Bool;
	private var __dirty:Bool;
	private var __height:Float;
	private var __stream:NetStream;
	private var __width:Float;
	
	
	public function new (width:Int = 320, height:Int = 240):Void {
		
		super ();
		
		__width = width;
		__height = height;
		
		smoothing = false;
		deblocking = 0;
		
	}
	
	
	public function attachNetStream (netStream:NetStream):Void {
		
		__stream = netStream;
		
		#if (js && html5)
		__stream.__video.play ();
		#end
		
	}
	
	
	public function clear ():Void {
		
		
		
	}
	
	
	private override function __getBounds (rect:Rectangle, matrix:Matrix):Void {
		
		var bounds = Rectangle.__temp;
		bounds.setTo (0, 0, __width, __height);
		bounds.__transform (bounds, matrix);
		
		rect.__expand (bounds.x, bounds.y, bounds.width, bounds.height);
		
	}
	
	
	private override function __hitTest (x:Float, y:Float, shapeFlag:Bool, stack:Array<DisplayObject>, interactiveOnly:Bool, hitObject:DisplayObject):Bool {
		
		if (!hitObject.visible || __isMask) return false;
		if (mask != null && !mask.__hitTestMask (x, y)) return false;
		
		var point = globalToLocal (new Point (x, y));
		
		if (point.x > 0 && point.y > 0 && point.x <= __width && point.y <= __height) {
			
			if (stack != null) {
				
				stack.push (hitObject);
				
			}
			
			return true;
			
		}
		
		return false;
		
	}
	
	
	private override function __hitTestMask (x:Float, y:Float):Bool {
		
		var point = globalToLocal (new Point (x, y));
		
		if (point.x > 0 && point.y > 0 && point.x <= __width && point.y <= __height) {
			
			return true;
			
		}
		
		return false;
		
	}
	
	
	public override function __renderCanvas (renderSession:RenderSession):Void {
		
		#if (js && html5)
		if (!__renderable || __worldAlpha <= 0 || __stream == null) return;
		
		var context = renderSession.context;
		
		if (__stream.__video != null) {
			
			renderSession.maskManager.pushObject (this);
			
			context.globalAlpha = __worldAlpha;
			var transform = __worldTransform;
			
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
			
			if (__scrollRect == null) {
				
				context.drawImage (__stream.__video, 0, 0, width, height);
				
			} else {
				
				context.drawImage (__stream.__video, __scrollRect.x, __scrollRect.y, __scrollRect.width, __scrollRect.height, __scrollRect.x, __scrollRect.y, __scrollRect.width, __scrollRect.height);
				
			}
			
			if (!smoothing) {
				
				untyped (context).mozImageSmoothingEnabled = true;
				//untyped (context).webkitImageSmoothingEnabled = true;
				untyped (context).msImageSmoothingEnabled = true;
				untyped (context).imageSmoothingEnabled = true;
				
			}
			
			renderSession.maskManager.popObject (this);
			
		}
		#end
		
	}
	
	
	public override function __renderDOM (renderSession:RenderSession):Void {
		
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
	
	
	
	
	private override function get_height ():Float {
		
		return __height * scaleY;
		
	}
	
	
	private override function set_height (value:Float):Float {
		
		if (scaleY != 1 || value != __height) {
			
			__setTransformDirty ();
			__dirty = true;
			
		}
		
		scaleY = 1;
		return __height = value;
		
	}
	
	
	private override function get_width ():Float {
		
		return __width * scaleX;
		
	}
	
	
	private override function set_width (value:Float):Float {
		
		if (scaleX != 1 || __width != value) {
			
			__setTransformDirty ();
			__dirty = true;
			
		}
		
		scaleX = 1;
		return __width = value;
		
	}
	
	
}