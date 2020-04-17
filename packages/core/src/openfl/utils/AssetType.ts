/**
	The AssetType enum lists the core set of available
	asset types from the OpenFL command-line tools.
**/
export enum AssetType
{
	/**
		Binary assets (data that is not readable as text)
	**/
	BINARY = "BINARY",

	/**
		Font assets, such as *.ttf or *.otf files
	**/
	FONT = "FONT",

	/**
		Image assets, such as *.png or *.jpg files
	**/
	IMAGE = "IMAGE",

	/**
		MovieClip assets, such as from a *.swf file
	**/
	MOVIE_CLIP = "MOVIE_CLIP",

	/**
		Audio assets, such as *.ogg or *.wav files

		In previous versions of OpenFL, `AssetType.MUSIC` was recommended
		for long background music, but in current versions, both
		`AssetType.MUSIC` and `AssetType.SOUND` behave similarly.

		A future version may implement optimizations specific to each audio type
		again.
	**/
	MUSIC = "MUSIC",

	/**
		Audio assets, such as *.ogg or *.wav files

		In previous versions of OpenFL, `AssetType.SOUND` was recommended
		for short or repetitively used sounds, but in current versions, both
		`AssetType.MUSIC` and `AssetType.SOUND` behave similarly.

		A future version may implement optimizations specific to each audio type
		again.
	**/
	SOUND = "SOUND",

	/**
		Used internally in the tools

		@hidden
	**/
	TEMPLATE = "TEMPLATE",

	/**
		Text assets
	**/
	TEXT = "TEXT"
}

export default AssetType;
