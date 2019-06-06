package openfl._internal.symbols;

import openfl._internal.formats.swf.SWFLite;
import openfl._internal.symbols.timeline.Frame;
import openfl.display.MovieClip;
import openfl.geom.Rectangle;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display.MovieClip)
class SpriteSymbol extends SWFSymbol
{
	public var baseClassName:String;
	public var frames:Array<Frame>;
	public var scale9Grid:Rectangle;

	public function new()
	{
		super();

		frames = new Array<Frame>();
	}

	private override function __createObject(swf:SWFLite):MovieClip
	{
		#if !macro
		MovieClip.__initSWF = swf;
		MovieClip.__initSymbol = this;
		#end

		#if flash
		if (className == "flash.display.MovieClip")
		{
			className = "flash.display.MovieClip2";
		}
		#end

		var symbolType = null;

		if (className != null)
		{
			symbolType = Type.resolveClass(className);

			if (symbolType == null)
			{
				// Log.warn ("Could not resolve class \"" + className + "\"");
			}
		}

		if (symbolType == null && baseClassName != null)
		{
			#if flash
			if (baseClassName == "flash.display.MovieClip")
			{
				baseClassName = "flash.display.MovieClip2";
			}
			#end

			symbolType = Type.resolveClass(baseClassName);

			if (symbolType == null)
			{
				// Log.warn ("Could not resolve class \"" + className + "\"");
			}
		}

		var movieClip:MovieClip = null;

		if (symbolType != null)
		{
			movieClip = Type.createInstance(symbolType, []);
		}
		else
		{
			#if flash
			movieClip = new flash.display.MovieClip.MovieClip2();
			#else
			movieClip = new MovieClip();
			#end
		}

		movieClip.scale9Grid = scale9Grid;

		return movieClip;
	}
}
