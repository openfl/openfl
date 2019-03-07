package xfl;

import openfl._internal.formats.xfl.dom.DOMSymbolItem;
import openfl.display.XFLMovieClip;
import openfl.display.XFLSprite;

/**
 * XFL custom symbol loader interface
 */
interface XFLCustomSymbolLoader
{
	public function createMovieClip(xfl:XFL, symbolItem:DOMSymbolItem):XFLMovieClip;
	public function onMovieClipLoaded(xfl:XFL, symbolItem:DOMSymbolItem, movieClip:XFLMovieClip):Void;
	public function createSprite(xfl:XFL, symbolItem:DOMSymbolItem):XFLSprite;
	public function onSpriteLoaded(xfl:XFL, symbolItem:DOMSymbolItem, sprite:XFLSprite):Void;
}
