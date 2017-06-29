package openfl._internal.timeline;


#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


@:keep class Frame {
	
	
	public var label:String;
	public var objects:Array <FrameObject>;
	public var scriptDef:Map<Int,String>;
	public var scripts:Map<Int,Void->Void>;
	
	
	public function new () {
		
		objects = new Array <FrameObject> ();
		
	}
	
	
}