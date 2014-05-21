package openfl.display;


class InteractiveObject extends DisplayObject {
	
	
	public var doubleClickEnabled:Bool;
	public var focusRect:Dynamic;
	public var mouseEnabled:Bool;
	public var tabEnabled:Bool;
	public var tabIndex:Int;
	
	
	public function new () {
		
		super ();
		
		mouseEnabled = true;
		
	}
	
	
	private override function __getInteractive (stack:Array<DisplayObject>):Void {
		
		stack.push (this);
		
		if (parent != null) {
			
			parent.__getInteractive (stack);
			
		}
		
	}
	
	
}