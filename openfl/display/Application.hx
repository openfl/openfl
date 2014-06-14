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
		
		#if !flash
		stage = new openfl.display.Stage (config.width, config.height, config.background);
		stage.addChild (openfl.Lib.current);
		#end
		
	}
	
	
	public override function onKeyDown (event:KeyEvent):Void {
		
		#if !flash
		stage.application_onKey (event);
		#end
		
	}
	
	
	public override function onKeyUp (event:KeyEvent):Void {
		
		#if !flash
		stage.application_onKey (event);
		#end
		
	}
	
	
	public override function onMouseDown (event:MouseEvent):Void {
		
		#if !flash
		stage.application_onMouse (event);
		#end
		
	}
	
	
	public override function onMouseMove (event:MouseEvent):Void {
		
		#if !flash
		stage.application_onMouse (event);
		#end
		
	}
	
	
	public override function onMouseUp (event:MouseEvent):Void {
		
		#if !flash
		stage.application_onMouse (event);
		#end
		
	}
	
	
	public override function onTouchMove (event:TouchEvent):Void {
		
		#if !flash
		stage.application_onTouch (event);
		#end
		
	}
	
	
	public override function onTouchEnd (event:TouchEvent):Void {
		
		#if !flash
		stage.application_onTouch (event);
		#end
		
	}
	
	
	public override function onTouchStart (event:TouchEvent):Void {
		
		#if !flash
		stage.application_onTouch (event);
		#end
		
	}
	
	
	public override function onWindowActivate (event:WindowEvent):Void {
		
		#if !flash
		stage.application_onWindow (event);
		#end
		
	}
	
	
	public override function onWindowDeactivate (event:WindowEvent):Void {
		
		#if !flash
		stage.application_onWindow (event);
		#end
		
	}
	
	
	public override function render (context:RenderContext):Void {
		
		#if !flash
		stage.__render (context);
		#end
		
	}
	
	
}