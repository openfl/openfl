package openfl.display;


import lime.graphics.RenderContext;
import lime.ui.KeyEvent;
import lime.ui.MouseEvent;
import lime.ui.TouchEvent;
import lime.ui.WindowEvent;


@:access(openfl.display.Stage)
class Application extends lime.app.Application {
	
	
	private var stage:openfl.display.Stage;
	
	
	public function new () {
		
		super ();
		
	}
	
	
	public override function create (config:lime.app.Config):Void {
		
		super.create (config);
		
		stage = new openfl.display.Stage (config.width, config.height, config.element, config.background);
		
		stage.addChild (openfl.Lib.current);
		
	}
	
	
	public override function onKeyDown (event:KeyEvent):Void {
		
		stage.application_onKey (event);
		
	}
	
	
	public override function onKeyUp (event:KeyEvent):Void {
		
		stage.application_onKey (event);
		
	}
	
	
	public override function onMouseDown (event:MouseEvent):Void {
		
		stage.application_onMouse (event);
		
	}
	
	
	public override function onMouseMove (event:MouseEvent):Void {
		
		stage.application_onMouse (event);
		
	}
	
	
	public override function onMouseUp (event:MouseEvent):Void {
		
		stage.application_onMouse (event);
		
	}
	
	
	public override function onTouchMove (event:TouchEvent):Void {
		
		stage.application_onTouch (event);
		
	}
	
	
	public override function onTouchEnd (event:TouchEvent):Void {
		
		stage.application_onTouch (event);
		
	}
	
	
	public override function onTouchStart (event:TouchEvent):Void {
		
		stage.application_onTouch (event);
		
	}
	
	
	public override function onWindowActivate (event:WindowEvent):Void {
		
		stage.application_onWindow (event);
		
	}
	
	
	public override function onWindowDeactivate (event:WindowEvent):Void {
		
		stage.application_onWindow (event);
		
	}
	
	
	public override function render (context:RenderContext):Void {
		
		stage.__render (context);
		
	}
	
	
}