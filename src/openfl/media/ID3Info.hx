package openfl.media; #if !flash


#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


@:final class ID3Info {
	
	
	public var album:String;
	public var artist:String;
	public var comment:String;
	public var genre:String;
	public var songName:String;
	public var track:String;
	public var year:String;
	
	
	public function new ():Void {
		
		
		
	}
	
	
}


#else
typedef ID3Info = flash.media.ID3Info;
#end