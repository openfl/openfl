package openfl.utils;

@:enum abstract AssetType(String)
{
	public var BINARY = "BINARY";
	public var FONT = "FONT";
	public var IMAGE = "IMAGE";
	public var MOVIE_CLIP = "MOVIE_CLIP";
	public var MUSIC = "MUSIC";
	public var SOUND = "SOUND";
	@:noCompletion @:dox(hide) public var TEMPLATE = "TEMPLATE";
	public var TEXT = "TEXT";
}
