package;


class OpenFLApplication extends lime.app.Application {
	
	
	private var stage:openfl.display.Stage;
	
	
	public function new () {
		
		super ();
		
	}
	
	
	public override function create (config:lime.app.Config):Void {
		
		super.create (config);
		
		stage = new openfl.display.Stage (config.width, config.height, config.element, config.background);
		
		stage.addChild (openfl.Lib.current);
		openfl.Lib.current.addChild (new ::APP_MAIN:: ());
		
	}
	
	
	public override function render ():Void {
		
		lime.graphics.opengl.GL.clearColor (1, 0, 0, 1);
		lime.graphics.opengl.GL.clear (lime.graphics.opengl.GL.COLOR_BUFFER_BIT);
		
	}
	
	
}