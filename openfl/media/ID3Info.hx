package openfl.media; #if (!display && !flash)


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


#if flash
@:native("flash.media.ID3Info")
#end

@:final extern class ID3Info implements Dynamic {
	
	
	public var album:String;
	public var artist:String;
	public var comment:String;
	public var genre:String;
	public var songName:String;
	public var track:String;
	public var year:String;
	
	
	public function new ():Void;
	
	
}


#end