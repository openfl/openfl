package openfl._internal.formats.xfl.symbol;

import openfl.Assets;
import openfl.fl.core.UIComponent;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl._internal.formats.xfl.display.XFLMovieClip;
import openfl._internal.formats.xfl.display.XFLSprite;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.text.TextField;
import openfl.text.TextFieldType;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import openfl._internal.formats.xfl.dom.DOMBitmapItem;
import openfl._internal.formats.xfl.dom.DOMBitmapInstance;
import openfl._internal.formats.xfl.dom.DOMComponentInstance;
import openfl._internal.formats.xfl.dom.DOMDynamicText;
import openfl._internal.formats.xfl.dom.DOMShape;
import openfl._internal.formats.xfl.dom.DOMRectangle;
import openfl._internal.formats.xfl.dom.DOMStaticText;
import openfl._internal.formats.xfl.dom.DOMSymbolInstance;
import openfl._internal.formats.xfl.dom.DOMSymbolItem;
import openfl._internal.formats.xfl.XFL;

class Symbols
{
	public static function createShape(xfl:XFL, instance:DOMShape):Shape
	{
		var shape:Shape = new Shape(instance);
		if (instance.matrix != null)
		{
			shape.transform.matrix = instance.matrix;
		}
		// TODO: a.drewke, this increases rendering time a lot
		// shape.cacheAsBitmap = true;
		return shape;
	}

	public static function createRectangle(xfl:XFL, instance:DOMRectangle):Rectangle
	{
		var rectangle:Rectangle = new Rectangle(instance);
		if (instance.matrix != null)
		{
			rectangle.transform.matrix = instance.matrix;
		}
		// TODO: a.drewke, this increases rendering time a lot
		// rectangle.cacheAsBitmap = true;
		return rectangle;
	}

	public static function createBitmap(xfl:XFL, instance:DOMBitmapInstance):Bitmap
	{
		var bitmap:Bitmap = null;
		var bitmapData:BitmapData = null;
		for (document in openfl._internal.formats.xfl.documents)
		{
			if (document.media.exists(instance.libraryItemName))
			{
				var bitmapItem:DOMBitmapItem = document.media.get(instance.libraryItemName).item;
				var assetUrl:String = document.path + "/LIBRARY/" + bitmapItem.name;
				if (Assets.exists(assetUrl) == true) bitmapData = Assets.getBitmapData(assetUrl);
				if (bitmapData != null) break;
			}
		}
		if (bitmapData == null)
		{
			trace("createBitmap(): " + instance.libraryItemName + ": not found");
			bitmapData = new BitmapData(1, 1, false, 0xFFFFFF);
		}
		bitmap = new Bitmap(bitmapData);
		if (instance.matrix != null)
		{
			bitmap.transform.matrix = instance.matrix;
		}
		return bitmap;
	}

	public static function createDynamicText(instance:DOMDynamicText):TextField
	{
		var textField:TextField = new TextField();
		textField.type = instance.type == DOMDynamicText.TYPE_INPUT ? TextFieldType.INPUT : TextFieldType.DYNAMIC;
		textField.width = instance.width;
		textField.height = instance.height;
		textField.name = instance.name;
		textField.selectable = instance.isSelectable;
		textField.multiline = instance.multiLine;
		if (textField.multiline == true)
		{
			textField.wordWrap = true;
		}
		if (instance.matrix != null)
		{
			textField.transform.matrix = instance.matrix;
		}

		textField.x += instance.left;
		textField.y += instance.top;
		for (textRun in instance.textRuns)
		{
			var format:TextFormat = new TextFormat();
			var pos:Int = textField.text.length;
			textField.appendText(textRun.characters);
			if (textRun.textAttrs.face != null) format.font = textRun.textAttrs.face;
			if (textRun.textAttrs.alignment != null)
			{
				switch (textRun.textAttrs.alignment)
				{
					case "center":
						format.align = TextFormatAlign.CENTER;
					case "justify":
						format.align = TextFormatAlign.JUSTIFY;
					case "left":
						format.align = TextFormatAlign.LEFT;
					case "right":
						format.align = TextFormatAlign.RIGHT;
					default:
						format.align = TextFormatAlign.LEFT;
				}
			}
			if (textRun.textAttrs.size != null) format.size = Std.int(textRun.textAttrs.size);
			if (textRun.textAttrs.fillColor != 0)
			{
				if (textRun.textAttrs.alpha != 0)
				{
					// need to add alpha to color
					format.color = textRun.textAttrs.fillColor;
				}
				else
				{
					format.color = textRun.textAttrs.fillColor;
				}
			}
			textField.setTextFormat(format, pos, textField.text.length);
			textField.defaultTextFormat = format;
		}
		return textField;
	}

	public static function createStaticText(instance:DOMStaticText):TextField
	{
		var textField:TextField = new TextField();
		textField.width = instance.width;
		textField.height = instance.height;
		textField.selectable = instance.isSelectable;
		textField.multiline = instance.multiLine;
		if (textField.multiline == true)
		{
			textField.wordWrap = true;
		}
		if (instance.matrix != null)
		{
			textField.transform.matrix = instance.matrix;
		}
		textField.x += instance.left;
		textField.y += instance.top;
		for (textRun in instance.textRuns)
		{
			var format:TextFormat = new TextFormat();
			var pos:Int = textField.text.length;
			textField.appendText(textRun.characters);
			if (textRun.textAttrs.face != null) format.font = textRun.textAttrs.face;
			if (textRun.textAttrs.alignment != null)
			{
				switch (textRun.textAttrs.alignment)
				{
					case "center":
						format.align = TextFormatAlign.CENTER;
					case "justify":
						format.align = TextFormatAlign.JUSTIFY;
					case "left":
						format.align = TextFormatAlign.LEFT;
					case "right":
						format.align = TextFormatAlign.RIGHT;
					default:
						format.align = TextFormatAlign.LEFT;
				}
			}
			if (textRun.textAttrs.size != null) format.size = Std.int(textRun.textAttrs.size);
			if (textRun.textAttrs.fillColor != 0)
			{
				if (textRun.textAttrs.alpha != 0)
				{
					// need to add alpha to color
					format.color = textRun.textAttrs.fillColor;
				}
				else
				{
					format.color = textRun.textAttrs.fillColor;
				}
			}
			textField.setTextFormat(format, pos, textField.text.length);
			textField.defaultTextFormat = format;
		}
		return textField;
	}

	public static function createSymbol(xfl:XFL, instance:DOMSymbolInstance):DisplayObject
	{
		for (document in openfl._internal.formats.xfl.documents)
		{
			if (document.symbols.exists(instance.libraryItemName))
			{
				var symbolItem:DOMSymbolItem = DOMSymbolItem.load(document.path + "/LIBRARY", document.symbols.get(instance.libraryItemName).fileName);
				// have a movie clip by default
				if ((symbolItem.linkageBaseClass == null || symbolItem.linkageBaseClass == "")
					&& (symbolItem.linkageClassName == null
						|| StringTools.startsWith(symbolItem.linkageClassName, "fl.controls.") == false))
				{
					return createMovieClip(xfl, instance);
				}
				// otherwise determine class name
				var className:String = symbolItem.linkageBaseClass;
				if (className == null || className == "")
				{
					className = StringTools.replace(symbolItem.linkageClassName, "fl.controls.", "openfl.fl.controls.");
				}
				switch (className)
				{
					case "flash.display.Sprite":
						return createSprite(xfl, instance);
					default:
						return createOther(xfl, instance, className);
				}
			}
		}
		return null;
	}

	private static function createMovieClip(xfl:XFL, instance:DOMSymbolInstance):XFLMovieClip
	{
		var symbolItem:DOMSymbolItem = null;
		var movieClip:XFLMovieClip = null;
		var loadedByCustomLoader:Bool = false;
		for (document in openfl._internal.formats.xfl.documents)
		{
			if (document.symbols.exists(instance.libraryItemName))
			{
				symbolItem = DOMSymbolItem.load(document.path + "/LIBRARY", document.symbols.get(instance.libraryItemName).fileName);
				if (openfl._internal.formats.xfl.customSymbolLoader != null)
				{
					movieClip = openfl._internal.formats.xfl.customSymbolLoader.createMovieClip(xfl, symbolItem);
					if (movieClip != null) loadedByCustomLoader = true;
				}
				if (movieClip == null)
				{
					movieClip = new XFLMovieClip(new XFLSymbolArguments(xfl, symbolItem.linkageClassName, symbolItem.timeline,
						symbolItem.parametersAreLocked));
				}
				// TODO: a.drewke, hack to inject timeline name into symbol instance if it has no name
				if ((instance.name == null || instance.name == "") && symbolItem.timeline.name != null && symbolItem.timeline.name != "")
				{
					instance.name = symbolItem.timeline.name;
				}
				if (instance.name != null && instance.name != "")
				{
					movieClip.name = instance.name;
				}
				break;
			}
		}
		if (movieClip != null)
		{
			if (instance.matrix != null)
			{
				movieClip.transform.matrix = instance.matrix;
			}
			if (instance.color != null)
			{
				movieClip.transform.colorTransform = instance.color;
			}
			if (loadedByCustomLoader == true)
			{
				openfl._internal.formats.xfl.customSymbolLoader.onMovieClipLoaded(xfl, symbolItem, movieClip);
			}
			/*
				// TODO: a.drewke
				movieClip.cacheAsBitmap = instance.cacheAsBitmap;
				if (instance.exportAsBitmap) {
					movieClip.flatten();
				}
			 */
		}
		return movieClip;
	}

	private static function createSprite(xfl:XFL, instance:DOMSymbolInstance):XFLSprite
	{
		var symbolItem:DOMSymbolItem = null;
		var sprite:XFLSprite = null;
		var loadedByCustomLoader:Bool = false;
		for (document in openfl._internal.formats.xfl.documents)
		{
			if (document.symbols.exists(instance.libraryItemName))
			{
				symbolItem = DOMSymbolItem.load(document.path + "/LIBRARY", document.symbols.get(instance.libraryItemName).fileName);
				if (openfl._internal.formats.xfl.customSymbolLoader != null)
				{
					sprite = openfl._internal.formats.xfl.customSymbolLoader.createSprite(xfl, symbolItem);
					if (sprite != null) loadedByCustomLoader = true;
				}
				if (sprite == null)
				{
					sprite = new XFLSprite(new XFLSymbolArguments(xfl, symbolItem.linkageClassName, symbolItem.timeline, symbolItem.parametersAreLocked));
				}
				// TODO: a.drewke, hack to inject timeline name into symbol instance if it has no name
				if ((instance.name == null || instance.name == "") && symbolItem.timeline.name != null && symbolItem.timeline.name != "")
				{
					instance.name = symbolItem.timeline.name;
				}
				if (instance.name != null && instance.name != "")
				{
					sprite.name = instance.name;
				}
				break;
			}
		}
		if (sprite != null)
		{
			if (instance.matrix != null)
			{
				sprite.transform.matrix = instance.matrix;
			}
			if (instance.color != null)
			{
				sprite.transform.colorTransform = instance.color;
			}
			if (loadedByCustomLoader == true)
			{
				openfl._internal.formats.xfl.customSymbolLoader.onSpriteLoaded(xfl, symbolItem, sprite);
			}
			/*
				// TODO: a.drewke
				sprite.cacheAsBitmap = instance.cacheAsBitmap;
				if (instance.exportAsBitmap) {
					sprite.flatten();
				}
			 */
		}
		return sprite;
	}

	private static function createOther(xfl:XFL, instance:DOMSymbolInstance, className:String):Sprite
	{
		var symbolItem:DOMSymbolItem = null;
		var other:Sprite = null;
		for (document in openfl._internal.formats.xfl.documents)
		{
			if (document.symbols.exists(instance.libraryItemName))
			{
				symbolItem = DOMSymbolItem.load(document.path + "/LIBRARY", document.symbols.get(instance.libraryItemName).fileName);
				var classType:Class<Dynamic> = Type.resolveClass(className);
				var otherName:String = (instance.name == null || instance.name == "")
					&& symbolItem.timeline.name != null
					&& symbolItem.timeline.name != "" ? symbolItem.timeline.name : instance.name;
				other = Type.createInstance(classType, [
					otherName,
					new XFLSymbolArguments(xfl, symbolItem.linkageClassName, symbolItem.timeline, symbolItem.parametersAreLocked)
				]);
				other.name = otherName;
				break;
			}
		}
		if (other != null)
		{
			if (instance.matrix != null)
			{
				other.transform.matrix = instance.matrix;
			}
			if (instance.color != null)
			{
				other.transform.colorTransform = instance.color;
			}
			/*
				// TODO: a.drewke
				other.cacheAsBitmap = instance.cacheAsBitmap;
				if (instance.exportAsBitmap) {
					other.flatten();
				}
			 */
		}
		return other;
	}

	public static function createComponent(xfl:XFL, instance:DOMComponentInstance):DisplayObject
	{
		var component:DisplayObject = null;
		for (document in openfl._internal.formats.xfl.documents)
		{
			if (document.symbols.exists(instance.libraryItemName))
			{
				var symbolItem:DOMSymbolItem = DOMSymbolItem.load(document.path + "/LIBRARY", document.symbols.get(instance.libraryItemName).fileName);
				var className:String = symbolItem.linkageClassName;
				if (StringTools.startsWith(className, "fl.")) className = "openfl." + className.substr("fl.".length);
				var classType:Class<Dynamic> = Type.resolveClass(className);
				var componentName:String = (instance.name == null || instance.name == "")
					&& symbolItem.timeline.name != null
					&& symbolItem.timeline.name != "" ? symbolItem.timeline.name : instance.name;
				component = Type.createInstance(classType, [
					componentName,
					new XFLSymbolArguments(xfl, symbolItem.linkageClassName, symbolItem.timeline, symbolItem.parametersAreLocked)
				]);
				component.name = componentName;
				var instanceVariablesLeft:Array<String> = [];
				for (variable in instance.variables)
				{
					instanceVariablesLeft.push(variable.variable);
				}
				var instanceFields:Array<String> = Type.getInstanceFields(classType);
				for (variable in instance.variables)
				{
					if (instanceFields.indexOf(variable.variable) != -1 || instanceFields.indexOf("set_" + variable.variable) != -1)
					{
						switch (variable.type)
						{
							case "List":
								Reflect.setProperty(component, variable.variable, variable.defaultValue);
								instanceVariablesLeft.remove(variable.variable);
							case "Boolean":
								Reflect.setProperty(component, variable.variable, variable.defaultValue == "true");
								instanceVariablesLeft.remove(variable.variable);
							case "Number":
								Reflect.setProperty(component, variable.variable, Std.parseFloat(variable.defaultValue));
								instanceVariablesLeft.remove(variable.variable);
							case "String":
								if (variable.variable == "source")
								{
									trace("createComponent(): skipping variable 'source': FIXME!");
								}
								else
								{
									Reflect.setProperty(component, variable.variable, variable.defaultValue);
									instanceVariablesLeft.remove(variable.variable);
								}
							default:
								trace("createComponent(): unknown variable type '" + variable.type + "': " + variable);
						}
					}
				}
				if (instanceVariablesLeft.length > 0)
				{
					trace("createComponent(): left unset variables: " + instanceVariablesLeft);
				}
				break;
			}
		}
		if (component != null)
		{
			if (instance.matrix != null)
			{
				var matrix:Matrix = instance.matrix.clone();
				matrix.tx = 0.0;
				matrix.ty = 0.0;
				var dimension:Point = new Point(1.0, 1.0);
				var rotatedDimension:Point = matrix.transformPoint(dimension);
				matrix.tx = instance.matrix.tx;
				matrix.ty = instance.matrix.ty;
				matrix.a = Math.abs(instance.matrix.a) < 0.0001 ? 0.0 : 1.0;
				matrix.d = Math.abs(instance.matrix.d) < 0.0001 ? 0.0 : 1.0;
				component.scaleX = Math.abs(instance.matrix.a) < 0.0001 ? rotatedDimension.x : instance.matrix.a;
				component.scaleY = Math.abs(instance.matrix.d) < 0.0001 ? rotatedDimension.y : instance.matrix.d;
				component.transform.matrix = matrix;
			}
		}
		if ((component is DisplayObjectContainer) == true)
		{
			var container:DisplayObjectContainer = cast(component, DisplayObjectContainer);
			var containerWidth:Float = container.width;
			var containerHeight:Float = container.height;
			var containerScaleX:Float = container.scaleX;
			var containerScaleY:Float = container.scaleY;
			container.scaleX = 1.0;
			container.scaleY = 1.0;
			var parametersAreBlocked:Bool = false;
			var children:Array<DisplayObject> = null;
			if ((component is XFLSprite) == true)
			{
				var xflSprite:XFLSprite = cast(component, XFLSprite);
				children = xflSprite.children;
				parametersAreBlocked = xflSprite.xflSymbolArguments.parametersAreLocked;
			}
			else if ((component is XFLMovieClip) == true)
			{
				var xflMovieClip:XFLMovieClip = cast(component, XFLMovieClip);
				children = xflMovieClip.children;
				parametersAreBlocked = xflMovieClip.xflSymbolArguments.parametersAreLocked;
			}
			for (childIdx in 0...container.numChildren)
			{
				var child:DisplayObject = container.getChildAt(childIdx);
				if (children != null && children.indexOf(child) == -1)
				{
					child.x = child.x / containerScaleX;
					child.y = child.y / containerScaleY;
					child.width = child.width / containerScaleX;
					child.height = child.height / containerScaleY;
				}
				else if (parametersAreBlocked == false)
				{
					child.x = child.x * containerScaleX;
					child.y = child.y * containerScaleY;
					child.width = child.width * containerScaleX;
					child.height = child.height * containerScaleY;
				}
			}
			if ((component is UIComponent) == true)
			{
				cast(component, UIComponent).setSize(containerWidth * containerScaleX, containerHeight * containerScaleY);
			}
		}
		return component;
	}
}
