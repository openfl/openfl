package openfl._legacy.display; #if (openfl_legacy && hybrid)


import lime.app.IModule;
import lime.graphics.RenderContext;
import lime.ui.Gamepad;
import lime.ui.GamepadAxis;
import lime.ui.GamepadButton;
import lime.ui.KeyCode;
import lime.ui.KeyModifier;


class HybridStage extends ManagedStage implements IModule {
	
	
	public function new (width:Int, height:Int, color:Null<Int> = null) {
		
		var flags = 0x00000080; // allow shaders
		
		super (width, height, flags);
		
		if (color != null) {
			
			this.color = color;
			
		}
		
		pumpEvent ( { type: ManagedStage.etResize, x: width, y: height } );
		
	}
	
	
	public function init (context:RenderContext):Void {
		
		//switch (context) {
			//
			//case OPENGL (gl):
				//
				//__renderer = new GLRenderer (stageWidth, stageHeight, gl);
			//
			//case CANVAS (context):
				//
				//__renderer = new CanvasRenderer (stageWidth, stageHeight, context);
			//
			//case DOM (element):
				//
				//__renderer = new DOMRenderer (stageWidth, stageHeight, element);
			//
			//default:
			//
		//}
		
	}
	
	
	public function onGamepadAxisMove (gamepad:Gamepad, axis:GamepadAxis, value:Float):Void {
		
		
		
	}
	
	
	public function onGamepadButtonDown (gamepad:Gamepad, button:GamepadButton):Void {
		
		
		
	}
	
	
	public function onGamepadButtonUp (gamepad:Gamepad, button:GamepadButton):Void {
		
		
		
	}
	
	
	public function onGamepadConnect (gamepad:Gamepad):Void {
		
		
		
	}
	
	
	public function onGamepadDisconnect (gamepad:Gamepad):Void {
		
		
		
	}
	
	
	public function onKeyDown (keyCode:KeyCode, modifier:KeyModifier):Void {
		
		//__onKey (KeyboardEvent.KEY_DOWN, keyCode, modifier);
		
	}
	
	
	public function onKeyUp (keyCode:KeyCode, modifier:KeyModifier):Void {
		
		//__onKey (KeyboardEvent.KEY_UP, keyCode, modifier);
		
	}
	
	
	public function onMouseDown (x:Float, y:Float, button:Int):Void {
		
		//var type = switch (button) {
			//
			//case 1: MouseEvent.MIDDLE_MOUSE_DOWN;
			//case 2: MouseEvent.RIGHT_MOUSE_DOWN;
			//default: MouseEvent.MOUSE_DOWN;
			//
		//}
		//
		//__onMouse (type, x, y, button);
		
	}
	
	
	public function onMouseMove (x:Float, y:Float):Void {
		
		//__onMouse (MouseEvent.MOUSE_MOVE, x, y, 0);
		
	}
	
	
	public function onMouseMoveRelative (x:Float, y:Float):Void {
		
		
		
	}
	
	
	public function onMouseUp (x:Float, y:Float, button:Int):Void {
		
		//var type = switch (button) {
			//
			//case 1: MouseEvent.MIDDLE_MOUSE_UP;
			//case 2: MouseEvent.RIGHT_MOUSE_UP;
			//default: MouseEvent.MOUSE_UP;
			//
		//}
		//
		//__onMouse (type, x, y, button);
		
	}
	
	
	public function onMouseWheel (deltaX:Float, deltaY:Float):Void {
		
		//__onMouseWheel (deltaX, deltaY);
		
	}
	
	
	public function onRenderContextLost ():Void {
		
		
		
	}
	
	
	public function onRenderContextRestored (context:RenderContext):Void {
		
		
		
	}
	
	
	public function onTouchMove (x:Float, y:Float, id:Int):Void {
		
		//__onTouch (TouchEvent.TOUCH_MOVE, x, y, id);
		
	}
	
	
	public function onTouchEnd (x:Float, y:Float, id:Int):Void {
		
		//__onTouch (TouchEvent.TOUCH_END, x, y, id);
		
	}
	
	
	public function onTouchStart (x:Float, y:Float, id:Int):Void {
		
		//__onTouch (TouchEvent.TOUCH_BEGIN, x, y, id);
		
	}
	
	
	public function onWindowActivate ():Void {
		
		//var event = new Event (Event.ACTIVATE);
		//__broadcast (event, true);
		//
	}
	
	
	public function onWindowClose ():Void {
		
		
		
	}
	
	
	public function onWindowDeactivate ():Void {
		
		//var event = new Event (Event.DEACTIVATE);
		//__broadcast (event, true);
		
	}
	
	
	public function onWindowFocusIn ():Void {
		
		
		
	}
	
	
	public function onWindowFocusOut ():Void {
		
		
		
	}
	
	
	public function onWindowFullscreen ():Void {
		
		
		
	}
	
	
	public function onWindowMinimize ():Void {
		
		
		
	}
	
	
	public function onWindowMove (x:Float, y:Float):Void {
		
		
		
	}
	
	
	public function onWindowResize (width:Int, height:Int):Void {
		
		//stageWidth = width;
		//stageHeight = height;
		//
		//if (__renderer != null) {
			//
			//__renderer.resize (width, height);
			//
		//}
		//
		//var event = new Event (Event.RESIZE);
		//__broadcast (event, false);
		
	}
	
	
	public function onWindowRestore ():Void {
		
		
		
	}
	
	
	public function render (context:RenderContext):Void {
		
		__render (true);
		
		//if (__rendering) return;
		//__rendering = true;
		//
		//__broadcast (new Event (Event.ENTER_FRAME), true);
		//
		//if (__invalidated) {
			//
			//__invalidated = false;
			//__broadcast (new Event (Event.RENDER), true);
			//
		//}
		//
		//__renderable = true;
		//__update (false, true);
		//
		//if (__renderer != null) {
			//
			//__renderer.render (this);
			//
		//}
		//
		//__rendering = false;
		
	}
	
	
	public function update (deltaTime:Int):Void {
		
		
		
	}
	
	
}


#end