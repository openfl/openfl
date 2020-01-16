package openfl;

import openfl.display.DisplayObject;
import openfl.display.Sprite;
import openfl.geom.Rectangle;

class LibTest
{
	@Test public function getDefinitionByName()
	{
		Assert.isNull(Lib.getDefinitionByName(null));
		Assert.isNull(Lib.getDefinitionByName("hello"));
		Assert.areEqual(String, Lib.getDefinitionByName("String"));
		Assert.isNull(Lib.getDefinitionByName("false"));
		Assert.isNull(Lib.getDefinitionByName("Bool"));
		Assert.isNull(Lib.getDefinitionByName("100"));
		#if !js
		Assert.areEqual(Int, Lib.getDefinitionByName("Int"));
		#else
		Assert.isNull(Lib.getDefinitionByName("Int"));
		#end
		Assert.isNull(Lib.getDefinitionByName("100.1"));
		#if !js
		Assert.areEqual(Float, Lib.getDefinitionByName("Float"));
		#else
		Assert.isNull(Lib.getDefinitionByName("Float"));
		#end

		Assert.isNull(Lib.getDefinitionByName("DisplayObject"));
		Assert.areEqual(DisplayObject, Lib.getDefinitionByName("openfl.display.DisplayObject"));
		Assert.isNull(Lib.getDefinitionByName("Rectangle"));
		Assert.areEqual(Rectangle, Lib.getDefinitionByName("openfl.geom.Rectangle"));
		Assert.areEqual(Sprite, Lib.getDefinitionByName("openfl.display.Sprite"));
	}

	@Test public function getQualifiedClassName()
	{
		Assert.isNull(Lib.getQualifiedClassName(null));
		Assert.areEqual("String", Lib.getQualifiedClassName("hello"));
		Assert.areEqual("String", Lib.getQualifiedClassName(String));
		#if !js
		Assert.areEqual("Bool", Lib.getQualifiedClassName(false));
		#else
		Assert.isNull(Lib.getQualifiedClassName(false));
		#end
		Assert.areEqual("Bool", Lib.getQualifiedClassName(Bool));
		#if !js
		Assert.areEqual("Int", Lib.getQualifiedClassName(100));
		#else
		Assert.isNull(Lib.getQualifiedClassName(100));
		#end
		Assert.areEqual("Int", Lib.getQualifiedClassName(Int));
		#if !js
		Assert.areEqual("Float", Lib.getQualifiedClassName(100.1));
		#else
		Assert.isNull(Lib.getQualifiedClassName(100.1));
		#end
		Assert.areEqual("Float", Lib.getQualifiedClassName(Float));

		var prefix = #if flash "flash." #else "openfl." #end;

		Assert.areEqual(prefix + "display.Sprite", Lib.getQualifiedClassName(new Sprite()));
		Assert.areEqual(prefix + "display.Sprite", Lib.getQualifiedClassName(Sprite));
		Assert.areEqual(prefix + "geom.Rectangle", Lib.getQualifiedClassName(new Rectangle()));
		Assert.areEqual(prefix + "geom.Rectangle", Lib.getQualifiedClassName(Rectangle));
		Assert.areEqual(prefix + "display.DisplayObject", Lib.getQualifiedClassName(DisplayObject));
	}

	@Test public function getQualifiedSuperclassName()
	{
		Assert.isNull(Lib.getQualifiedSuperclassName(null));
		Assert.isNull(Lib.getQualifiedSuperclassName("hello"));
		Assert.isNull(Lib.getQualifiedSuperclassName(String));
		Assert.isNull(Lib.getQualifiedSuperclassName(false));
		Assert.isNull(Lib.getQualifiedSuperclassName(Bool));
		Assert.isNull(Lib.getQualifiedSuperclassName(100));
		Assert.isNull(Lib.getQualifiedSuperclassName(Int));

		var prefix = #if flash "flash." #else "openfl." #end;

		Assert.areEqual(prefix + "display.DisplayObjectContainer", Lib.getQualifiedSuperclassName(new Sprite()));
		Assert.areEqual(prefix + "display.DisplayObjectContainer", Lib.getQualifiedSuperclassName(Sprite));
		Assert.isNull(Lib.getQualifiedSuperclassName(new Rectangle()));
		Assert.isNull(Lib.getQualifiedSuperclassName(Rectangle));
		Assert.areEqual(prefix + "events.EventDispatcher", Lib.getQualifiedSuperclassName(DisplayObject));
	}
}
