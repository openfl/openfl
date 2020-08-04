package openfl._internal.formats.xfl.symbol;

import openfl._internal.formats.xfl.XFL;
import openfl._internal.formats.xfl.dom.DOMFrame;
import openfl._internal.formats.xfl.dom.DOMBitmapInstance;
import openfl._internal.formats.xfl.dom.DOMComponentInstance;
import openfl._internal.formats.xfl.dom.DOMDynamicText;
import openfl._internal.formats.xfl.dom.DOMStaticText;
import openfl._internal.formats.xfl.dom.DOMLayer;
import openfl._internal.formats.xfl.dom.DOMShape;
import openfl._internal.formats.xfl.dom.DOMRectangle;
import openfl._internal.formats.xfl.dom.DOMTimeline;
import openfl._internal.formats.xfl.dom.DOMSymbolInstance;
import openfl._internal.formats.xfl.geom.Matrix;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.FrameLabel;
import openfl._internal.formats.xfl.display.XFLMovieClip;

/**
 * Shared between Sprite and MovieClip
 */
class Shared
{
	public static function init(layers:Array<DOMLayer>, timeline:DOMTimeline, labels:Array<FrameLabel>):Int
	{
		var totalFrames:Int = 0;
		if (timeline != null)
		{
			for (layer in timeline.layers)
			{
				for (frame in layer.frames)
				{
					var pushLabel:Bool = frame.name != null;
					if (pushLabel == true)
					{
						for (label in labels)
						{
							if (label.name == frame.name)
							{
								pushLabel = false;
								break;
							}
						}
					}
					if (pushLabel == true)
					{
						labels.push(new FrameLabel(frame.name, frame.index));
					}
				}
			}
			for (layer in timeline.layers)
			{
				if (layer.type != "guide" && layer.frames.length > 0)
				{
					layers.push(layer);
					for (frame in layer.frames)
					{
						if (frame.index + frame.duration > totalFrames)
						{
							totalFrames = frame.index + frame.duration;
						}
					}
				}
			}
		}
		layers.reverse();
		return totalFrames;
	}

	public static function flatten(container:DisplayObjectContainer):Void
	{
		/*
			var bounds = container.getBounds(container);
			var bitmapData = null;
			if (bounds.width > 0 && bounds.height > 0) {
				bitmapData = new BitmapData(Std.int(bounds.width), Std.int(bounds.height), true, 0x00000000);
				var matrix = new Matrix();
				matrix.translate(-bounds.left, -bounds.top);
				bitmapData.draw(container, matrix);
			}
			for (i in 0...container.numChildren) {
				var child = container.getChildAt (0);
				if ((child is MovieClip)) {
					untyped child.stop ();
				}
				container.removeChildAt(0);
			}
			if (bounds.width > 0 && bounds.height > 0) {
				var bitmap = new Bitmap(bitmapData);
				bitmap.smoothing = true;
				bitmap.x = bounds.left;
				bitmap.y = bounds.top;
				container.addChild(bitmap);
			}
		 */
	}

	private static function createMaskDisplayObjects(xfl:XFL, container:DisplayObjectContainer, layers:Array<DOMLayer>,
			children:Array<DisplayObject>):Array<Array<DisplayObject>>
	{
		var maskDisplayObjects:Array<Array<DisplayObject>> = [];
		var currentLayer:Int = 0;
		for (layer in layers)
		{
			// TODO: a.drewke, handle hit area correctly
			if (layer.name == "HitArea" || layer.name == "hitbox") continue;
			if (layer.type != "mask")
			{
				maskDisplayObjects[layer.index] = null;
				currentLayer++;
				continue;
			}
			maskDisplayObjects[layer.index] = [];
			for (i in 0...layer.frames.length)
			{
				var frame:DOMFrame = layer.frames[i];
				var frameAnonymousObjectId:Int = 0;
				for (element in frame.elements)
				{
					if ((element is DOMSymbolInstance))
					{
						var symbol:DisplayObject = element.name != null ? container.getChildByName(element.name) : null;
						if (symbol != null)
						{
							trace("createFrames(): movie clip with name '" + symbol.name + "' already exists");
							continue;
						}
						symbol = Symbols.createSymbol(xfl, cast element);
						if (symbol != null)
						{
							symbol.visible = false;
							container.addChild(symbol);
							children.push(symbol);
							maskDisplayObjects[layer.index].push(symbol);
						}
					}
					else if ((element is DOMBitmapInstance))
					{
						var bitmap:Bitmap = Symbols.createBitmap(xfl, cast element);
						if (bitmap != null)
						{
							bitmap.name = "xfl_anonymous_" + currentLayer + "_" + frame.index + "_" + (frameAnonymousObjectId++);
							bitmap.visible = false;
							container.addChild(bitmap);
							children.push(bitmap);
							maskDisplayObjects[layer.index].push(bitmap);
						}
					}
					else if ((element is DOMComponentInstance))
					{
						var name:String = cast(element, DOMComponentInstance).name;
						var component:DisplayObject = name != null ? container.getChildByName(name) : null;
						if (component != null)
						{
							trace("createFrames(): component with name '" + component.name + "' already exists");
							continue;
						}
						component = Symbols.createComponent(xfl, cast element);
						if (component != null)
						{
							component.name = component.name;
							component.visible = false;
							container.addChild(component);
							children.push(component);
							maskDisplayObjects[layer.index].push(component);
						}
					}
					else if ((element is DOMShape))
					{
						var shape:Shape = Symbols.createShape(xfl, cast element);
						shape.name = "xfl_anonymous_" + currentLayer + "_" + frame.index + "_" + (frameAnonymousObjectId++);
						shape.visible = false;
						container.addChild(shape);
						children.push(shape);
						maskDisplayObjects[layer.index].push(shape);
					}
					else if ((element is DOMRectangle))
					{
						var rectangle:Rectangle = Symbols.createRectangle(xfl, cast element);
						rectangle.name = "xfl_anonymous_" + currentLayer + "_" + frame.index + "_" + (frameAnonymousObjectId++);
						rectangle.visible = false;
						container.addChild(rectangle);
						children.push(rectangle);
						maskDisplayObjects[layer.index].push(rectangle);
					}
					else if ((element is DOMDynamicText))
					{
						var text:DisplayObject = element.name != null ? container.getChildByName(element.name) : null;
						if (text != null)
						{
							trace("createFrames(): dynamic text with name '" + text.name + "' already exists");
							continue;
						}
						text = Symbols.createDynamicText(cast element);
						if (text != null)
						{
							text.visible = false;
							container.addChild(text);
							children.push(text);
							maskDisplayObjects[layer.index].push(text);
						}
					}
					else if ((element is DOMStaticText))
					{
						var text:DisplayObject = Symbols.createStaticText(cast element);
						if (text != null)
						{
							text.name = "xfl_anonymous_" + currentLayer + "_" + frame.index + "_" + (frameAnonymousObjectId++);
							text.visible = false;
							container.addChild(text);
							children.push(text);
							maskDisplayObjects[layer.index].push(text);
						}
					}
					else
					{
						trace("createFrames(): Unhandled frame element of type '" + Type.getClassName(Type.getClass(element)) + '"');
					}
				}
			}
			currentLayer++;
		}
		return maskDisplayObjects;
	}

	public static function createFrames(xfl:XFL, container:DisplayObjectContainer, layers:Array<DOMLayer>, children:Array<DisplayObject>):Void
	{
		var currentLayer:Int = 0;
		var maskDisplayObjects:Array<Array<DisplayObject>> = createMaskDisplayObjects(xfl, container, layers, children);
		var containerMask:Bool = false;
		for (layer in layers)
		{
			// TODO: a.drewke, handle hit area correctly
			if (layer.name == "HitArea" || layer.name == "hitbox") continue;
			if (layer.type == "mask")
			{
				currentLayer++;
				continue;
			}
			// work around for having a layer with multiple objects and one single mask layer for it, which I would place in container then
			// TODO: fix me, make me more abstract
			if (maskDisplayObjects.length > 0 && layers.length == 2 && currentLayer == 0)
			{
				if (layer.parentLayerIndex != -1 && maskDisplayObjects[layer.parentLayerIndex] != null)
				{
					for (maskDisplayObject in maskDisplayObjects[layer.parentLayerIndex])
					{
						container.mask = maskDisplayObject;
						containerMask = true;
					}
				}
			}
			for (i in 0...layer.frames.length)
			{
				var frame:DOMFrame = layer.frames[i];
				var frameAnonymousObjectId:Int = 0;
				for (element in frame.elements)
				{
					if ((element is DOMSymbolInstance))
					{
						var symbol:DisplayObject = element.name != null ? container.getChildByName(element.name) : null;
						if (symbol != null)
						{
							trace("createFrames(): movie clip with name '" + symbol.name + "' already exists");
							continue;
						}
						symbol = Symbols.createSymbol(xfl, cast element);
						if (symbol != null)
						{
							if (containerMask == false
								&& layer.parentLayerIndex != -1
								&& maskDisplayObjects[layer.parentLayerIndex] != null)
							{
								for (maskDisplayObject in maskDisplayObjects[layer.parentLayerIndex])
								{
									symbol.mask = maskDisplayObject;
								}
							}
							symbol.visible = false;
							container.addChild(symbol);
							children.push(symbol);
						}
					}
					else if ((element is DOMBitmapInstance))
					{
						var bitmap:Bitmap = Symbols.createBitmap(xfl, cast element);
						if (bitmap != null)
						{
							if (containerMask == false
								&& layer.parentLayerIndex != -1
								&& maskDisplayObjects[layer.parentLayerIndex] != null)
							{
								for (maskDisplayObject in maskDisplayObjects[layer.parentLayerIndex])
								{
									bitmap.mask = maskDisplayObject;
								}
							}
							bitmap.name = "xfl_anonymous_" + currentLayer + "_" + frame.index + "_" + (frameAnonymousObjectId++);
							bitmap.visible = false;
							container.addChild(bitmap);
							children.push(bitmap);
						}
					}
					else if ((element is DOMComponentInstance))
					{
						var name:String = cast(element, DOMComponentInstance).name;
						var component:DisplayObject = name != null ? container.getChildByName(name) : null;
						if (component != null)
						{
							trace("createFrames(): component with name '" + component.name + "' already exists");
							continue;
						}
						component = Symbols.createComponent(xfl, cast element);
						if (component != null)
						{
							if (containerMask == false
								&& layer.parentLayerIndex != -1
								&& maskDisplayObjects[layer.parentLayerIndex] != null)
							{
								for (maskDisplayObject in maskDisplayObjects[layer.parentLayerIndex])
								{
									component.mask = maskDisplayObject;
								}
							}
							component.name = component.name;
							component.visible = false;
							container.addChild(component);
							children.push(component);
						}
					}
					else if ((element is DOMShape))
					{
						var shape:Shape = Symbols.createShape(xfl, cast element);
						if (containerMask == false && layer.parentLayerIndex != -1 && maskDisplayObjects[layer.parentLayerIndex] != null)
						{
							for (maskDisplayObject in maskDisplayObjects[layer.parentLayerIndex])
							{
								shape.mask = maskDisplayObject;
							}
						}
						shape.name = "xfl_anonymous_" + currentLayer + "_" + frame.index + "_" + (frameAnonymousObjectId++);
						shape.visible = false;
						container.addChild(shape);
						children.push(shape);
					}
					else if ((element is DOMRectangle))
					{
						var rectangle:Rectangle = Symbols.createRectangle(xfl, cast element);
						if (containerMask == false && layer.parentLayerIndex != -1 && maskDisplayObjects[layer.parentLayerIndex] != null)
						{
							for (maskDisplayObject in maskDisplayObjects[layer.parentLayerIndex])
							{
								rectangle.mask = maskDisplayObject;
							}
						}
						rectangle.name = "xfl_anonymous_" + currentLayer + "_" + frame.index + "_" + (frameAnonymousObjectId++);
						rectangle.visible = false;
						container.addChild(rectangle);
						children.push(rectangle);
					}
					else if ((element is DOMDynamicText))
					{
						var text:DisplayObject = element.name != null ? container.getChildByName(element.name) : null;
						if (text != null)
						{
							trace("createFrames(): dynamic text with name '" + text.name + "' already exists");
							continue;
						}
						text = Symbols.createDynamicText(cast element);
						if (text != null)
						{
							if (containerMask == false
								&& layer.parentLayerIndex != -1
								&& maskDisplayObjects[layer.parentLayerIndex] != null)
							{
								for (maskDisplayObject in maskDisplayObjects[layer.parentLayerIndex])
								{
									text.mask = maskDisplayObject;
								}
							}
							text.visible = false;
							container.addChild(text);
							children.push(text);
						}
					}
					else if ((element is DOMStaticText))
					{
						var text = Symbols.createStaticText(cast element);
						if (text != null)
						{
							if (containerMask == false
								&& layer.parentLayerIndex != -1
								&& maskDisplayObjects[layer.parentLayerIndex] != null)
							{
								for (maskDisplayObject in maskDisplayObjects[layer.parentLayerIndex])
								{
									text.mask = maskDisplayObject;
								}
							}
							text.name = "xfl_anonymous_" + currentLayer + "_" + frame.index + "_" + (frameAnonymousObjectId++);
							text.visible = false;
							container.addChild(text);
							children.push(text);
						}
					}
					else
					{
						trace("createFrames(): Unhandled frame element of type '" + Type.getClassName(Type.getClass(element)) + '"');
					}
				}
			}
			currentLayer++;
		}
	}

	public static function disableFrames(xfl:XFL, container:DisplayObjectContainer, layers:Array<DOMLayer>, currentFrame:Int,
			invisibleObjects:Array<DisplayObject>, processedObjects:Array<DisplayObject>)
	{
		var currentLayer:Int = 0;
		for (layer in layers)
		{
			// TODO: a.drewke, handle hit area correctly
			if (layer.name == "HitArea" || layer.name == "hitbox") continue;
			if (layer.type == "mask")
			{
				currentLayer++;
				continue;
			}
			for (frameIdx in 0...layer.frames.length)
			{
				var frameAnonymousObjectId:Int = 0;
				var frame:DOMFrame = layer.frames[frameIdx];
				if (currentFrame - 1 >= frame.index && currentFrame - 1 < frame.index + frame.duration)
				{
					for (element in frame.elements)
					{
						if ((element is DOMSymbolInstance))
						{
							var movieClip:DisplayObject = element.name != null ? container.getChildByName(element.name) : null;
							if (movieClip != null)
							{
								if (processedObjects.indexOf(movieClip) != -1) continue;
								if (movieClip.visible == false)
								{
									invisibleObjects.push(movieClip);
								}
								movieClip.visible = false;
								processedObjects.push(movieClip);
							}
						}
						else if ((element is DOMBitmapInstance))
						{
							var bitmap:DisplayObject = container.getChildByName("xfl_anonymous_" + currentLayer + "_" + frame.index + "_"
								+ (frameAnonymousObjectId++));
							if (bitmap != null)
							{
								if (processedObjects.indexOf(bitmap) != -1) continue;
								if (bitmap.visible == false)
								{
									invisibleObjects.push(bitmap);
								}
								bitmap.visible = false;
								processedObjects.push(bitmap);
							}
						}
						else if ((element is DOMComponentInstance))
						{
							var component:DisplayObject = element.name != null ? container.getChildByName(element.name) : null;
							if (component != null)
							{
								if (processedObjects.indexOf(component) != -1) continue;
								if (component.visible == false)
								{
									invisibleObjects.push(component);
								}
								component.visible = false;
								processedObjects.push(component);
							}
						}
						else if ((element is DOMShape))
						{
							var shape:DisplayObject = container.getChildByName("xfl_anonymous_" + currentLayer + "_" + frame.index + "_"
								+ (frameAnonymousObjectId++));
							if (shape != null)
							{
								if (processedObjects.indexOf(shape) != -1) continue;
								if (shape.visible == false)
								{
									invisibleObjects.push(shape);
								}
								shape.visible = false;
								processedObjects.push(shape);
							}
						}
						else if ((element is DOMRectangle))
						{
							var rectangle:DisplayObject = container.getChildByName("xfl_anonymous_" + currentLayer + "_" + frame.index + "_"
								+ (frameAnonymousObjectId++));
							if (rectangle != null)
							{
								if (processedObjects.indexOf(rectangle) != -1) continue;
								if (rectangle.visible == false)
								{
									invisibleObjects.push(rectangle);
								}
								rectangle.visible = false;
								processedObjects.push(rectangle);
							}
						}
						else if ((element is DOMDynamicText))
						{
							var text:DisplayObject = element.name != null ? container.getChildByName(element.name) : null;
							if (text != null)
							{
								if (processedObjects.indexOf(text) != -1) continue;
								if (text.visible == false)
								{
									invisibleObjects.push(text);
								}
								text.visible = false;
								processedObjects.push(text);
							}
						}
						else if ((element is DOMStaticText))
						{
							var text:DisplayObject = container.getChildByName("xfl_anonymous_" + currentLayer + "_" + frame.index + "_"
								+ (frameAnonymousObjectId++));
							if (text != null)
							{
								if (processedObjects.indexOf(text) != -1) continue;
								if (text.visible == false)
								{
									invisibleObjects.push(text);
								}
								text.visible = false;
								processedObjects.push(text);
							}
						}
						else
						{
							trace("disableFrames(): Unhandled frame element of type '" + Type.getClassName(Type.getClass(element)) + '"');
						}
					}
				}
			}
			currentLayer++;
		}
	}

	public static function enableFrame(xfl:XFL, container:DisplayObjectContainer, layers:Array<DOMLayer>, currentFrame:Int,
			invisibleObjects:Array<DisplayObject>):Void
	{
		var currentLayer:Int = 0;
		for (layer in layers)
		{
			// TODO: a.drewke, handle hit area correctly
			if (layer.name == "HitArea" || layer.name == "hitbox") continue;
			if (layer.type == "mask")
			{
				currentLayer++;
				continue;
			}
			for (frameIdx in 0...layer.frames.length)
			{
				var frameAnonymousObjectId:Int = 0;
				var frame:DOMFrame = layer.frames[frameIdx];
				if (currentFrame - 1 >= frame.index && currentFrame - 1 < frame.index + frame.duration)
				{
					for (element in frame.elements)
					{
						if ((element is DOMSymbolInstance))
						{
							var movieClip:DisplayObject = container.getChildByName(cast(element, DOMSymbolInstance).name);
							if (movieClip != null)
							{
								movieClip.visible = invisibleObjects == null || invisibleObjects.indexOf(movieClip) == -1;
							}
						}
						else if ((element is DOMBitmapInstance))
						{
							var bitmap:DisplayObject = container.getChildByName("xfl_anonymous_" + currentLayer + "_" + frame.index + "_"
								+ (frameAnonymousObjectId++));
							if (bitmap != null)
							{
								bitmap.visible = invisibleObjects == null || invisibleObjects.indexOf(bitmap) == -1;
							}
						}
						else if ((element is DOMComponentInstance))
						{
							var component:DisplayObject = container.getChildByName(cast(element, DOMComponentInstance).name);
							if (component != null)
							{
								component.visible = invisibleObjects == null || invisibleObjects.indexOf(component) == -1;
							}
						}
						else if ((element is DOMShape))
						{
							var shape:DisplayObject = container.getChildByName("xfl_anonymous_" + currentLayer + "_" + frame.index + "_"
								+ (frameAnonymousObjectId++));
							if (shape != null)
							{
								shape.visible = invisibleObjects == null || invisibleObjects.indexOf(shape) == -1;
							}
						}
						else if ((element is DOMRectangle))
						{
							var rectangle:DisplayObject = container.getChildByName("xfl_anonymous_" + currentLayer + "_" + frame.index + "_"
								+ (frameAnonymousObjectId++));
							if (rectangle != null)
							{
								rectangle.visible = invisibleObjects == null || invisibleObjects.indexOf(rectangle) == -1;
							}
						}
						else if ((element is DOMDynamicText))
						{
							var text:DisplayObject = container.getChildByName(cast(element, DOMDynamicText).name);
							if (text != null)
							{
								text.visible = invisibleObjects == null || invisibleObjects.indexOf(text) == -1;
							}
						}
						else if ((element is DOMStaticText))
						{
							var text:DisplayObject = container.getChildByName("xfl_anonymous_" + currentLayer + "_" + frame.index + "_"
								+ (frameAnonymousObjectId++));
							if (text != null)
							{
								text.visible = invisibleObjects == null || invisibleObjects.indexOf(text) == -1;
							}
						}
						else
						{
							trace("enableFrame(): Unhandled frame element of type '" + Type.getClassName(Type.getClass(element)) + '"');
						}
					}
				}
			}
			currentLayer++;
		}
	}

	public static function removeFrames(parent:DisplayObjectContainer)
	{
		while (parent.numChildren > 0)
		{
			var child:DisplayObject = parent.getChildAt(0);
			if ((child is MovieClip))
			{
				cast(child, MovieClip).stop();
			}
			else if ((child is XFLMovieClip))
			{
				cast(child, XFLMovieClip).stop();
			}
			parent.removeChildAt(0);
		}
	}
}
