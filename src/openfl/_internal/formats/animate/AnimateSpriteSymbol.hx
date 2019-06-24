package openfl._internal.formats.animate;

import openfl.display.DisplayObject;
import openfl.display.MovieClip;
import openfl.geom.Rectangle;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display.MovieClip)
class AnimateSpriteSymbol extends AnimateSymbol
{
	public var baseClassName:String;
	public var frames:Array<AnimateFrame>;
	public var scale9Grid:Rectangle;

	private var library:AnimateLibrary;

	public function new()
	{
		super();

		frames = new Array();
	}

	private function __constructor(movieClip:MovieClip):Void
	{
		#if flash
		@:privateAccess cast(movieClip, flash.display.MovieClip.MovieClip2).__timeline = new AnimateTimeline(movieClip, library, this);
		#else
		movieClip.__timeline = new AnimateTimeline(movieClip, library, this);
		#end
		movieClip.scale9Grid = scale9Grid;
	}

	private override function __createObject(library:AnimateLibrary):MovieClip
	{
		#if !macro
		MovieClip.__constructor = __constructor;
		#end
		this.library = library;

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

		#if flash
		if (!Std.is(movieClip, flash.display.MovieClip.MovieClip2))
		{
			movieClip.scale9Grid = scale9Grid;
		}
		#end

		return movieClip;
	}

	private override function __initObject(library:AnimateLibrary, instance:DisplayObject):Void
	{
		this.library = library;
		__constructor(cast instance);
	}
}
