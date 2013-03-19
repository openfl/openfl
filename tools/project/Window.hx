typedef Window = { 
	
	@:optional var width:Int;
	@:optional var height:Int;
	@:optional var background:Int;
	@:optional var parameters:String;
	@:optional var fps:Int;
	@:optional var hardware:Bool;
	@:optional var resizable:Bool;
	@:optional var borderless:Bool;
	@:optional var vsync:Bool;
	@:optional var fullscreen:Bool;
	@:optional var antialiasing:Int;
	@:optional var orientation:Orientation;
	@:optional var allowShaders:Bool;
	@:optional var requireShaders:Bool;
	@:optional var depthBuffer:Bool;
	@:optional var stencilBuffer:Bool;
	
}