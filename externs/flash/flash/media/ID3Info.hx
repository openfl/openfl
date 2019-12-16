package flash.media;

#if flash
@:final extern class ID3Info implements Dynamic
{
	public var album:String;
	public var artist:String;
	public var comment:String;
	public var genre:String;
	public var songName:String;
	public var track:String;
	public var year:String;
	public function new():Void;
}
#else
typedef ID3Info = openfl.media.ID3Info;
#end
