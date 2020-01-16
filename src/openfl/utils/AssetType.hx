package openfl.utils;

/**
	The AssetType enum lists the core set of available
	asset types from the OpenFL command-line tools.
**/
@:enum abstract AssetType(String)
{
	/**
		Binary assets (data that is not readable as text)
	**/
	public var BINARY = "BINARY";

	/**
		Font assets, such as *.ttf or *.otf files
	**/
	public var FONT = "FONT";

	/**
		Image assets, such as *.png or *.jpg files
	**/
	public var IMAGE = "IMAGE";

	/**
		MovieClip assets, such as from a *.swf file
	**/
	public var MOVIE_CLIP = "MOVIE_CLIP";

	/**
		Audio assets, such as *.ogg or *.wav files

		In previous versions of OpenFL, `AssetType.MUSIC` was recommended
		for long background music, but in current versions, both
		`AssetType.MUSIC` and `AssetType.SOUND` behave similarly.

		A future version may implement optimizations specific to each audio type
		again.
	**/
	public var MUSIC = "MUSIC";

	/**
		Audio assets, such as *.ogg or *.wav files

		In previous versions of OpenFL, `AssetType.SOUND` was recommended
		for short or repetitively used sounds, but in current versions, both
		`AssetType.MUSIC` and `AssetType.SOUND` behave similarly.

		A future version may implement optimizations specific to each audio type
		again.
	**/
	public var SOUND = "SOUND";

	/**
		Used internally in the tools
	**/
	@:noCompletion @:dox(hide) public var TEMPLATE = "TEMPLATE";

	/**
		Text assets
	**/
	public var TEXT = "TEXT";
}
