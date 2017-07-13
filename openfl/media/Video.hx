package openfl.media; #if !openfl_legacy


import openfl._internal.renderer.RenderSession;
import openfl.display.DisplayObject;
import openfl.display.InteractiveObject;
import openfl.display.Stage;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.net.NetStream;

#if (js && html5)
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
	
	
	private override function __getBounds (rect:Rectangle):Void {
		
		rect.setTo (0, 0, __width, __height);
		
	}
	
	
	private override function __hitTest (x:Float, y:Float, shapeFlag:Bool, stack:UnshrinkableArray<DisplayObject>, interactiveOnly:Bool, hitObject:DisplayObject):Bool {
		
		if (!__mustEvaluateHitTest() || !hitObject.visible || __isMask) return false;
		if (mask != null && !mask.__hitTestMask (x, y)) return false;
		
		var input_point = Point.pool.get();
		input_point.setTo(x, y);
		var point = globalToLocal (input_point);
		Point.pool.put(input_point);
		
		if (point.x > 0 && point.y > 0 && point.x <= __width && point.y <= __height) {
			
			if (stack != null) {
				
				stack.push (hitObject);
				
			}
			
			return true;
			
		}
		
		return false;
		
	}
	
	
	private override function __hitTestMask (x:Float, y:Float):Bool {
		
		var input_point = Point.pool.get();
		input_point.setTo(x, y);
		var point = globalToLocal (input_point);
		Point.pool.put(input_point);
		
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
			
			if (__mask != null) {
				
				renderSession.maskManager.pushMask (__mask);
				
			}
			
			context.globalAlpha = __renderAlpha;
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
				
				context.drawImage (__stream.__video, 0, 0);
				
			} else {
				
				context.drawImage (__stream.__video, __scrollRect.x, __scrollRect.y, __scrollRect.width, __scrollRect.height, __scrollRect.x, __scrollRect.y, __scrollRect.width, __scrollRect.height);
				
			}
			
			if (!smoothing) {
				
				untyped (context).mozImageSmoothingEnabled = true;
				//untyped (context).webkitImageSmoothingEnabled = true;
				untyped (context).msImageSmoothingEnabled = true;
				untyped (context).imageSmoothingEnabled = true;
				
			}
			
			if (__mask != null) {
				
				renderSession.maskManager.popMask ();
				
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


#else


import openfl.display.DisplayObject;


class Video extends DisplayObject implements Dynamic {
	
	
	public function new (width:Int = 320, height:Int = 240):Void {
		
		super (null, "video");
		
	}
	
	
}


#end
