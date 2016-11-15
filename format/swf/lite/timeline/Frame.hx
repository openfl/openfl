package format.swf.lite.timeline;


@:keep class Frame {
	
	
	public var label:String;
	public var objects:Array <FrameObject>;
	
	
	public function new () {
		
		objects = new Array <FrameObject> ();
		
	}
	
	
}