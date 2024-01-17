package;

import openfl.display.DisplayObject;
import openfl.display.Sprite;
import openfl.geom.Rectangle;
import openfl.Lib;
import utest.Assert;
import utest.Test;

class LibTest extends Test
{
	public function test_getDefinitionByName()
	{
		Assert.isNull(Lib.getDefinitionByName(null));
		Assert.isNull(Lib.getDefinitionByName("hello"));
		Assert.equals(String, Lib.getDefinitionByName("String"));
		Assert.isNull(Lib.getDefinitionByName("false"));
		Assert.isNull(Lib.getDefinitionByName("Bool"));
		Assert.isNull(Lib.getDefinitionByName("100"));
		#if !js
		Assert.equals(Int, Lib.getDefinitionByName("Int"));
		#else
		Assert.isNull(Lib.getDefinitionByName("Int"));
		#end
		Assert.isNull(Lib.getDefinitionByName("100.1"));
		#if !js
		Assert.equals(Float, Lib.getDefinitionByName("Float"));
		#else
		Assert.isNull(Lib.getDefinitionByName("Float"));
		#end

		Assert.isNull(Lib.getDefinitionByName("DisplayObject"));
		Assert.equals(DisplayObject, Lib.getDefinitionByName("openfl.display.DisplayObject"));
		Assert.isNull(Lib.getDefinitionByName("Rectangle"));
		Assert.equals(Rectangle, Lib.getDefinitionByName("openfl.geom.Rectangle"));
		Assert.equals(Sprite, Lib.getDefinitionByName("openfl.display.Sprite"));
	}

	public function test_getQualifiedClassName()
	{
		Assert.isNull(Lib.getQualifiedClassName(null));
		Assert.equals("String", Lib.getQualifiedClassName("hello"));
		Assert.equals("String", Lib.getQualifiedClassName(String));
		#if !js
		Assert.equals("Bool", Lib.getQualifiedClassName(false));
		#else
		Assert.isNull(Lib.getQualifiedClassName(false));
		#end
		Assert.equals("Bool", Lib.getQualifiedClassName(Bool));
		#if !js
		Assert.equals("Int", Lib.getQualifiedClassName(100));
		#else
		Assert.isNull(Lib.getQualifiedClassName(100));
		#end
		Assert.equals("Int", Lib.getQualifiedClassName(Int));
		#if !js
		Assert.equals("Float", Lib.getQualifiedClassName(100.1));
		#else
		Assert.isNull(Lib.getQualifiedClassName(100.1));
		#end
		Assert.equals("Float", Lib.getQualifiedClassName(Float));

		var prefix = #if flash "flash." #else "openfl." #end;

		Assert.equals(prefix + "display.Sprite", Lib.getQualifiedClassName(new Sprite()));
		Assert.equals(prefix + "display.Sprite", Lib.getQualifiedClassName(Sprite));
		Assert.equals(prefix + "geom.Rectangle", Lib.getQualifiedClassName(new Rectangle()));
		Assert.equals(prefix + "geom.Rectangle", Lib.getQualifiedClassName(Rectangle));
		Assert.equals(prefix + "display.DisplayObject", Lib.getQualifiedClassName(DisplayObject));
	}

	public function test_getQualifiedSuperclassName()
	{
		Assert.isNull(Lib.getQualifiedSuperclassName(null));
		Assert.isNull(Lib.getQualifiedSuperclassName("hello"));
		Assert.isNull(Lib.getQualifiedSuperclassName(String));
		Assert.isNull(Lib.getQualifiedSuperclassName(false));
		Assert.isNull(Lib.getQualifiedSuperclassName(Bool));
		Assert.isNull(Lib.getQualifiedSuperclassName(100));
		Assert.isNull(Lib.getQualifiedSuperclassName(Int));

		var prefix = #if flash "flash." #else "openfl." #end;

		Assert.equals(prefix + "display.DisplayObjectContainer", Lib.getQualifiedSuperclassName(new Sprite()));
		Assert.equals(prefix + "display.DisplayObjectContainer", Lib.getQualifiedSuperclassName(Sprite));
		Assert.isNull(Lib.getQualifiedSuperclassName(new Rectangle()));
		Assert.isNull(Lib.getQualifiedSuperclassName(Rectangle));
		Assert.equals(prefix + "events.EventDispatcher", Lib.getQualifiedSuperclassName(DisplayObject));
	}

	public function test_encodeURIComponent()
	{
		Assert.equals("hello%20world", Lib.encodeURIComponent("hello world"));
	}

	public function test_decodeURIComponent()
	{
		Assert.equals("hello world", Lib.decodeURIComponent("hello%20world"));
	}
}
