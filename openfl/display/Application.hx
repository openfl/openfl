package openfl.display;


import lime.graphics.RenderContext;
import openfl.display.Stage;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.events.TouchEvent;
import openfl.geom.Point;
import openfl.Lib;


@:access(openfl.display.DisplayObject)
@:access(openfl.display.Stage)
class Application extends lime.app.Application {
	
	
	private var stage:Stage;
	
	
	public function new () {
		
		super ();
		
	}
	
	
	#if !flash
	
	
	public override function create (config:lime.app.Config):Void {
		
		super.create (config);
		
		stage = new Stage (config.width, config.height, config.background);
		stage.addChild (Lib.current);
		
	}
	
	
	private function onKey (event:KeyboardEvent):Void {
		
		var stack = new Array <DisplayObject> ();
		
		if (stage.__focus == null) {
			
			stage.__getInteractive (stack);
			
		} else {
			
			stage.__focus.__getInteractive (stack);
			
		}
		
		if (stack.length > 0) {
			
			stack.reverse ();
			stage.__fireEvent (event, stack);
			
		}
		
	}
	
	
	public override function onKeyDown (keyCode:Int, modifier:Int):Void {
		
		//var event = new KeyboardEvent (event.type == KEY_DOWN ? KeyboardEvent.KEY_DOWN : KeyboardEvent.KEY_UP, true, false, event.code, keyCode, keyLocation, event.ctrlKey, event.altKey, event.shiftKey, event.metaKey)
		onKey (new KeyboardEvent (KeyboardEvent.KEY_DOWN, true, false, keyCode));
		
	}
	
	
	public override function onKeyUp (keyCode:Int, modifier:Int):Void {
		
		//var event = new KeyboardEvent (event.type == KEY_DOWN ? KeyboardEvent.KEY_DOWN : KeyboardEvent.KEY_UP, true, false, event.code, keyCode, keyLocation, event.ctrlKey, event.altKey, event.shiftKey, event.metaKey)
		onKey (new KeyboardEvent (KeyboardEvent.KEY_UP, true, false, keyCode));
		
	}
	
	
	private function onMouse (type:String, x:Float, y:Float):Void {
		
		/*var rect;
		
		if (__canvas != null) {
			
			rect = __canvas.getBoundingClientRect ();
			__mouseX = (event.clientX - rect.left) * (stageWidth / rect.width);
			__mouseY = (event.clientY - rect.top) * (stageHeight / rect.height);
			
		} else {
			
			rect = __div.getBoundingClientRect ();
			//__mouseX = (event.clientX - rect.left) * (__div.style.width / rect.width);
			__mouseX = (event.clientX - rect.left);
			//__mouseY = (event.clientY - rect.top) * (__div.style.height / rect.height);
			__mouseY = (event.clientY - rect.top);
			
		}*/
		
		stage.__mouseX = x;
		stage.__mouseY = y;
		
		var __stack = [];
		
		if (stage.__hitTest (x, y, false, __stack, true)) {
			
			var target = __stack[__stack.length - 1];
			stage.__setCursor (untyped (target).buttonMode ? "pointer" : "default");
			stage.__fireEvent (MouseEvent.__create (type, /*event,*/ target.globalToLocal (new Point (x, y)), cast target), __stack);
			
			if (type == MouseEvent.MOUSE_UP) {
				
				stage.__fireEvent (MouseEvent.__create (MouseEvent.CLICK, /*event,*/ target.globalToLocal (new Point (x, y)), cast target), __stack);
				
			}
			
		} else {
			
			stage.__setCursor (stage.buttonMode ? "pointer" : "default");
			stage.__fireEvent (MouseEvent.__create (type, /*event,*/ new Point (x, y), stage), [ stage ]);
			
			if (type == MouseEvent.MOUSE_UP) {
				
				stage.__fireEvent (MouseEvent.__create (MouseEvent.CLICK, /*event,*/ new Point (x, y), stage), [ stage ]);
				
			}
			
		}
		
		if (stage.__dragObject != null) {
			
			stage.__drag (new Point (x, y));
			
		}
		
	}
	
	
	public override function onMouseDown (x:Float, y:Float, button:Int):Void {
		
		onMouse (MouseEvent.MOUSE_DOWN, x, y);
		
	}
	
	
	public override function onMouseMove (x:Float, y:Float, button:Int):Void {
		
		onMouse (MouseEvent.MOUSE_MOVE, x, y);
		
	}
	
	
	public override function onMouseUp (x:Float, y:Float, button:Int):Void {
		
		onMouse (MouseEvent.MOUSE_UP, x, y);
		
	}
	
	
	private function onTouch (type:String, x:Float, y:Float, id:Int):Void {
		
		/*event.preventDefault ();
		
		var rect;
		
		if (__canvas != null) {
			
			rect = __canvas.getBoundingClientRect ();
			
		} else {
			
			rect = __div.getBoundingClientRect ();
			
		}
		
		var touch = event.changedTouches[0];
		var point = new Point ((touch.pageX - rect.left) * (stageWidth / rect.width), (touch.pageY - rect.top) * (stageHeight / rect.height));
		*/
		var point = new Point (x, y);
		
		stage.__mouseX = point.x;
		stage.__mouseY = point.y;
		
		var __stack = [];
		
		var mouseType = switch (type) {
			
			case TouchEvent.TOUCH_BEGIN: MouseEvent.MOUSE_DOWN;
			case TouchEvent.TOUCH_MOVE: MouseEvent.MOUSE_MOVE;
			case TouchEvent.TOUCH_END: MouseEvent.MOUSE_UP;
			default: null;
			
		}
		
		if (stage.__hitTest (x, x, false, __stack, true)) {
			
			var target = __stack[__stack.length - 1];
			var localPoint = target.globalToLocal (point);
			
			var touchEvent = TouchEvent.__create (type, /*event,*/ null/*touch*/, localPoint, cast target);
			touchEvent.touchPointID = id;
			//touchEvent.isPrimaryTouchPoint = isPrimaryTouchPoint;
			touchEvent.isPrimaryTouchPoint = true;
			
			var mouseEvent = MouseEvent.__create (mouseType, /*cast event,*/ localPoint, cast target);
			mouseEvent.buttonDown = (type != TouchEvent.TOUCH_END);
			
			stage.__fireEvent (touchEvent, __stack);
			stage.__fireEvent (mouseEvent, __stack);
			
		} else {
			
			var touchEvent = TouchEvent.__create (type, /*event,*/ null/*touch*/, point, stage);
			touchEvent.touchPointID = id;
			//touchEvent.isPrimaryTouchPoint = isPrimaryTouchPoint;
			touchEvent.isPrimaryTouchPoint = true;
			
			var mouseEvent = MouseEvent.__create (mouseType, /*cast event,*/ point, stage);
			mouseEvent.buttonDown = (type != TouchEvent.TOUCH_END);
			
			stage.__fireEvent (touchEvent, [ stage ]);
			stage.__fireEvent (mouseEvent, [ stage ]);
			
		}
		
		if (type == TouchEvent.TOUCH_MOVE && stage.__dragObject != null) {
			
			stage.__drag (point);
			
		}
		
	}
	
	
	public override function onTouchMove (x:Float, y:Float, id:Int):Void {
		
		onTouch (TouchEvent.TOUCH_MOVE, x, y, id);
		
	}
	
	
	public override function onTouchEnd (x:Float, y:Float, id:Int):Void {
		
		onTouch (TouchEvent.TOUCH_END, x, y, id);
		
	}
	
	
	public override function onTouchStart (x:Float, y:Float, id:Int):Void {
		
		onTouch (TouchEvent.TOUCH_BEGIN, x, y, id);
		
	}
	
	
	public override function onWindowActivate ():Void {
		
		var event = new openfl.events.Event (openfl.events.Event.ACTIVATE);
		stage.__broadcast (event, true);
		
	}
	
	
	public override function onWindowDeactivate ():Void {
		
		var event = new openfl.events.Event (openfl.events.Event.DEACTIVATE);
		stage.__broadcast (event, true);
		
	}
	
	
	public override function render (context:RenderContext):Void {
		
		stage.__render (context);
		
	}
	
	
	#end
	
	
}