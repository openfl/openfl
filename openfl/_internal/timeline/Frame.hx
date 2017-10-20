package openfl._internal.timeline;


#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


@:keep class Frame {
	
	
	public var label:String;
	public var objects:Array<FrameObject>;
	public var script:Void->Void;
	public var scriptSource:String;
	//public var scriptType:FrameScriptType;
	
	
	public function new () {
		
		
		
	}
	
	
}