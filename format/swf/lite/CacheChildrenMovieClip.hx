package format.swf.lite;

import format.swf.lite.MovieClip;
import format.swf.lite.SWFLite;
import format.swf.lite.symbols.SpriteSymbol;

class CacheChildrenMovieClip extends MovieClip
{
	public function new(swf:SWFLite, symbol:SpriteSymbol)
	{
		enableChildrenCache();
		super(swf,symbol);
	}
}
