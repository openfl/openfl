package openfl._internal.renderer.dom;


import openfl._internal.renderer.AbstractMaskManager;
import openfl.display.DisplayObject;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;

@:access(openfl.display.DisplayObject)
@:access(openfl.geom.Matrix)
@:access(openfl.geom.Rectangle)
@:keep


class DOMMaskManager extends AbstractMaskManager {
	
	
	public var currentClipRect:Rectangle;
	
	private var clipRects:Array<Rectangle>;
	private var numClipRects:Int;
	
	
	public function new (renderSession:RenderSession) {
		
		super (renderSession);
		
		clipRects = new Array ();
		numClipRects = 0;
		
	}
	
	
	public override function pushMask (mask:DisplayObject):Void {
		
		// TODO: Handle true mask shape, as well as alpha test
		
		pushRect (mask.getBounds (mask), mask.__getRenderTransform ());
		
	}
	
	
	public override function pushObject (object:DisplayObject, handleScrollRect:Bool = true):Void {
		
		if (handleScrollRect && object.__scrollRect != null) {
			
			pushRect (object.__scrollRect, object.__renderTransform);
			
		}
		
		if (object.__mask != null) {
			
			pushMask (object.__mask);
			
		}
		
	}
	
	
	public override function pushRect (rect:Rectangle, transform:Matrix):Void {
		
		// TODO: Handle rotation?
		
		if (numClipRects == clipRects.length) {
			
			clipRects[numClipRects] = new Rectangle ();
			
		}
		
		var clipRect = clipRects[numClipRects];
		rect.__transform (clipRect, transform);
		
		if (numClipRects > 0) {
			
			var parentClipRect = clipRects[numClipRects - 1];
			clipRect.__contract (parentClipRect.x, parentClipRect.y, parentClipRect.width, parentClipRect.height);
			
		}
		
		if (clipRect.height < 0) {
			
			clipRect.height = 0;
			
		}
		
		if (clipRect.width < 0) {
			
			clipRect.width = 0;
			
		}
		
		currentClipRect = clipRect;
		numClipRects++;
		
	}
	
	
	public override function popMask ():Void {
		
		popRect ();
		
	}
	
	
	public override function popObject (object:DisplayObject, handleScrollRect:Bool = true):Void {
		
		if (object.__mask != null) {
			
			popMask ();
			
		}
		
		if (handleScrollRect && object.__scrollRect != null) {
			
			popRect ();
			
		}
		
	}
	
	
	public override function popRect ():Void {
		
		if (numClipRects > 0) {
			
			numClipRects--;
			
			if (numClipRects > 0) {
				
				currentClipRect = clipRects[numClipRects - 1];
				
			} else {
				
				currentClipRect = null;
				
			}
			
		}
		
	}
	
	
	public function updateClip (displayObject:DisplayObject):Void {
		
		if (currentClipRect == null) {
			
			displayObject.__worldClipChanged = (displayObject.__worldClip != null);
			displayObject.__worldClip = null;
			
		} else {
			
			if (displayObject.__worldClip == null) {
				
				displayObject.__worldClip = new Rectangle ();
				
			}
			
			var clip = Rectangle.__pool.get ();
			var matrix = Matrix.__pool.get ();
			
			matrix.copyFrom (displayObject.__renderTransform);
			matrix.invert ();
			
			currentClipRect.__transform (clip, matrix);
			
			if (clip.equals (displayObject.__worldClip)) {
				
				displayObject.__worldClipChanged = false;
				
			} else {
				
				displayObject.__worldClip.copyFrom (clip);
				displayObject.__worldClipChanged = true;
				
			}
			
			Rectangle.__pool.release (clip);
			Matrix.__pool.release (matrix);
			
		}
		
	}
	
	
}