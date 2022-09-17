package openfl.display;

import openfl.errors.TypeError;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.events.EventType;
import openfl.filters.BitmapFilter;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.geom.Transform;
import openfl.media.Video;
import openfl.net.NetStream;
import openfl.text._internal.UTF8String;
import openfl.text.AntiAliasType;
import openfl.text.GridFitType;
import openfl.text.StaticText;
import openfl.text.StyleSheet;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFieldType;
import openfl.text.TextFormat;
import openfl.text.TextLineMetrics;

/**
	The ChildAccess abstract simplifies access to nested DisplayObjects. Although
	performance may be somewhat slower than using direct references, this is especially
	useful when setting up a UI or performing non-intensive tasks.

	For example, consider the following hierarchy:

	   movieClip -> sprite -> sprite2 -> textField

	You can use ChildAccess to more easily reference TextField:

	```haxe
	var movieClip:ChildAccess<MovieClip> = movieClip;
	movieClip.sprite.sprite2.textField.text = "Hello World";
	```

	Without ChildAccess, it can be more difficult to access nested objects:

	```haxe
	var sprite:Sprite = cast movieClip.getChildByName("sprite");
	var sprite2:Sprite = cast sprite.getChildByName("sprite2");
	var textField:TextField = cast sprite2.getChildByName("textField");
	textField.text = "Hello World";
	```

	ChildAccess provides most of the benefits of dynamic references, while
	still remaining strongly typed for properties.

	You can use array access to reach child instances as well. This is useful if the child object
	has the name of a DisplayObject property, or if it uses special characters:

	```haxe
	var movieClip:ChildAccess<MovieClip> = movieClip;
	movieClip.sprite["sprite2"].x = 100;
	```
**/
@:access(openfl.display.DisplayObject)
@:transitive
@:forward
abstract ChildAccess<T:DisplayObject>(T) from T to T
{
	/**
		Accesses the `alpha` property.
	**/
	public var alpha(get, set):Float;

	/**
		Accesses the `antiAliasType` property (for TextField instances only).
	**/
	public var antiAliasType(get, set):AntiAliasType;

	/**
		Accesses the `autoSize` property (for TextField instances only).
	**/
	public var autoSize(get, set):TextFieldAutoSize;

	/**
		Accesses the `background` property (for TextField instances only).
	**/
	public var background(get, set):Bool;

	/**
		Accesses the `backgroundColor` property (for TextField instances only).
	**/
	public var backgroundColor(get, set):Int;

	/**
		Accesses the `bitmapData` property (for Bitmap instances only).
	**/
	public var bitmapData(get, set):BitmapData;

	/**
		Accesses the `blendMode` property.
	**/
	public var blendMode(get, set):BlendMode;

	/**
		Accesses the `border` property (for TextField instances only).
	**/
	public var border(get, set):Bool;

	/**
		Accesses the `borderColor` property (for TextField instances only).
	**/
	public var borderColor(get, set):Int;

	/**
		Accesses the `bottomScrollV` property (for TextField instances only).
	**/
	public var bottomScrollV(get, never):Int;

	/**
		Accesses the `buttonMode` property (for Sprite instances only).
	**/
	public var buttonMode(get, set):Bool;

	/**
		Accesses the `cacheAsBitmap` property.
	**/
	public var cacheAsBitmap(get, set):Bool;

	/**
		Accesses the `cacheAsBitmapMatrix` property.
	**/
	public var cacheAsBitmapMatrix(get, set):Matrix;

	/**
		Accesses the `caretIndex` property (for TextField instances only).
	**/
	public var caretIndex(get, never):Int;

	/**
		Accesses the `condenseWhite` property (for TextField instances only).
	**/
	public var condenseWhite(get, set):Bool;

	/**
		Accesses the `currentFrame` property (for MovieClip instances only).
	**/
	public var currentFrame(get, never):Int;

	/**
		Accesses the `currentFrameLabel` property (for MovieClip instances only).
	**/
	public var currentFrameLabel(get, never):String;

	/**
		Accesses the `currentLabel` property (for MovieClip instances only).
	**/
	public var currentLabel(get, never):String;

	/**
		Accesses the `currentLabels` property (for MovieClip instances only).
	**/
	public var currentLabels(get, never):Array<FrameLabel>;

	/**
		Accesses the `currentScene` property (for MovieClip instances only).
	**/
	public var currentScene(get, never):Scene;

	/**
		Accesses the `deblocking` property (for Video instances only).
	**/
	public var deblocking(get, set):Int;

	/**
		Accesses the `defaultTextFormat` property (for TextField instances only).
	**/
	public var defaultTextFormat(get, set):TextFormat;

	/**
		Accesses the `displayAsPassword` property (for TextField instances only).
	**/
	public var displayAsPassword(get, set):Bool;

	/**
		Accesses the `doubleClickEnabled` property (for InteractiveObject instances only).
	**/
	public var doubleClickEnabled(get, set):Bool;

	/**
		Accesses the `dropTarget` property (for Sprite instances only).
	**/
	public var dropTarget(get, never):DisplayObject;

	/**
		Accesses the `embedFonts` property (for TextField instances only).
	**/
	public var embedFonts(get, set):Bool;

	/**
		Accesses the `enabled` property (for MovieClip instances only).
	**/
	public var enabled(get, set):Bool;

	/**
		Accesses the `filters` property.
	**/
	public var filters(get, set):Array<BitmapFilter>;

	/**
		Accesses the `focusRect` property (for InteractiveObject instances only).
	**/
	public var focusRect(get, set):Null<Bool>;

	/**
		Accesses the `framesLoaded` property (for MovieClip instances only).
	**/
	public var framesLoaded(get, never):Int;

	/**
		Accesses the `graphics` property (for Shape or Sprite instances only).
	**/
	public var graphics(get, never):Graphics;

	/**
		Accesses the `gridFitType` property (for TextField instances only).
	**/
	public var gridFitType(get, set):GridFitType;

	/**
		Accesses the `height` property.
	**/
	public var height(get, set):Float;

	/**
		Accesses the `htmlText` property (for TextField instances only).
	**/
	public var htmlText(get, set):UTF8String;

	/**
		Accesses the `hitArea` property (for Sprite instances only).
	**/
	public var hitArea(get, set):Sprite;

	/**
		Accesses the `isPlaying` property (for MovieClip instances only).
	**/
	public var isPlaying(get, never):Bool;

	/**
		Accesses the `length` property (for TextField instances only).
	**/
	public var length(get, never):Int;

	/**
		Accesses the `loaderInfo` property.
	**/
	public var loaderInfo(get, never):LoaderInfo;

	/**
		Accesses the `mask` property.
	**/
	public var mask(get, set):DisplayObject;

	/**
		Accesses the `maxChars` property (for TextField instances only).
	**/
	public var maxChars(get, set):Int;

	/**
		Accesses the `maxScrollH` property (for TextField instances only).
	**/
	public var maxScrollH(get, never):Int;

	/**
		Accesses the `maxScrollV` property (for TextField instances only).
	**/
	public var maxScrollV(get, never):Int;

	/**
		Accesses the `mouseChildren` property (for DisplayObjectContainer instances only).
	**/
	public var mouseChildren(get, set):Bool;

	/**
		Accesses the `mouseEnabled` property (for InteractiveObject instances only).
	**/
	public var mouseEnabled(get, set):Bool;

	/**
		Accesses the `mouseWheelEnabled` property (for TextField instances only).
	**/
	public var mouseWheelEnabled(get, set):Bool;

	/**
		Accesses the `mouseX` property.
	**/
	public var mouseX(get, never):Float;

	/**
		Accesses the `mouseY` property.
	**/
	public var mouseY(get, never):Float;

	/**
		Accesses the `multiline` property (for TextField instances only).
	**/
	public var multiline(get, set):Bool;

	/**
		Accesses the `name` property.
	**/
	public var name(get, set):String;

	/**
		Accesses the `needsSoftKeyboard` property (for InteractiveObject instances only).
	**/
	public var needsSoftKeyboard(get, set):Bool;

	/**
		Accesses the `numChildren` property (for DisplayObjectContainer instances only).
	**/
	public var numChildren(get, never):Int;

	/**
		Accesses the `numLines` property (for TextField instances only).
	**/
	public var numLines(get, never):Int;

	/**
		Accesses the `numTiles` property (for Tilemap instances only).
	**/
	public var numTiles(get, never):Int;

	/**
		Accesses the `opaqueBackground` property.
	**/
	public var opaqueBackground(get, set):Null<Int>;

	/**
		Accesses the `pixelSnapping` property (for Bitmap instances only).
	**/
	public var pixelSnapping(get, set):PixelSnapping;

	/**
		Accesses the `restrict` property (for TextField instances only).
	**/
	public var restrict(get, set):UTF8String;

	/**
		Accesses the `root` property.
	**/
	public var root(get, never):DisplayObject;

	/**
		Accesses the `rotation` property.
	**/
	public var rotation(get, set):Float;

	/**
		Accesses the `scale9Grid` property.
	**/
	public var scale9Grid(get, set):Rectangle;

	/**
		Accesses the `scaleX` property.
	**/
	public var scaleX(get, set):Float;

	/**
		Accesses the `scaleY` property.
	**/
	public var scaleY(get, set):Float;

	/**
		Accesses the `scenes` property (for MovieClip instances only).
	**/
	public var scenes(get, never):Array<Scene>;

	/**
		Accesses the `scrollH` property (for TextField instances only).
	**/
	public var scrollH(get, set):Int;

	/**
		Accesses the `scrollRect` property.
	**/
	public var scrollRect(get, set):Rectangle;

	/**
		Accesses the `scrollV` property (for TextField instances only).
	**/
	public var scrollV(get, set):Int;

	/**
		Accesses the `selectable` property (for TextField instances only).
	**/
	public var selectable(get, set):Bool;

	/**
		Accesses the `selectionBeginIndex` property (for TextField instances only).
	**/
	public var selectionBeginIndex(get, never):Int;

	/**
		Accesses the `selectionEndIndex` property (for TextField instances only).
	**/
	public var selectionEndIndex(get, never):Int;

	/**
		Accesses the `shader` property.
	**/
	public var shader(get, set):Shader;

	/**
		Accesses the `sharpness` property (for TextField instances only).
	**/
	public var sharpness(get, set):Float;

	/**
		Accesses the `smoothing` property (for Video or Bitmap instances only).
	**/
	public var smoothing(get, set):Bool;

	/**
		Accesses the `softKeyboardInputAreaOfInterest` property (for InteractiveObject instances only).
	**/
	public var softKeyboardInputAreaOfInterest(get, set):Rectangle;

	/**
		Accesses the `stage` property.
	**/
	public var stage(get, never):Stage;

	/**
		Accesses the `styleSheet` property (for TextField instances only).
	**/
	public var styleSheet(get, set):StyleSheet;

	/**
		Accesses the `tabChildren` property (for DisplayObjectContainer instances only).
	**/
	public var tabChildren(get, set):Bool;

	/**
		Accesses the `tabEnabled` property (for InteractiveObject instances only).
	**/
	public var tabEnabled(get, set):Bool;

	/**
		Accesses the `tabIndex` property (for InteractiveObject instances only).
	**/
	public var tabIndex(get, set):Int;

	/**
		Accesses the `text` property (for StaticText or TextField instances only).
	**/
	public var text(get, set):UTF8String;

	/**
		Accesses the `textColor` property (for TextField instances only).
	**/
	public var textColor(get, set):Int;

	/**
		Accesses the `textHeight` property (for TextField instances only).
	**/
	public var textHeight(get, never):Float;

	/**
		Accesses the `textWidth` property (for TextField instances only).
	**/
	public var textWidth(get, never):Float;

	/**
		Accesses the `tileAlphaEnabled` property (for Tilemap instances only).
	**/
	public var tileAlphaEnabled(get, set):Bool;

	/**
		Accesses the `tileBlendModeEnabled` property (for Tilemap instances only).
	**/
	public var tileBlendModeEnabled(get, set):Bool;

	/**
		Accesses the `tileColorTransformEnabled` property (for Tilemap instances only).
	**/
	public var tileColorTransformEnabled(get, set):Bool;

	/**
		Accesses the `tileset` property (for Tilemap instances only).
	**/
	public var tileset(get, set):Tileset;

	/**
		Accesses the `totalFrames` property (for MovieClip instances only).
	**/
	public var totalFrames(get, never):Int;

	/**
		Accesses the `transform` property.
	**/
	public var transform(get, set):Transform;

	/**
		Accesses the `type` property (for TextField instances only).
	**/
	public var type(get, set):TextFieldType;

	/**
		Accesses the `useHandCursor` property (for Sprite instances only).
	**/
	public var useHandCursor(get, set):Bool;

	/**
		Accesses the `videoWidth` property (for Video instances only).
	**/
	public var videoWidth(get, never):Int;

	/**
		Accesses the `visible` property.
	**/
	public var visible(get, set):Bool;

	/**
		Accesses the `width` property.
	**/
	public var width(get, set):Float;

	/**
		Accesses the `wordWrap` property (for TextField instances only).
	**/
	public var wordWrap(get, set):Bool;

	/**
		Accesses the `x` property.
	**/
	public var x(get, set):Float;

	/**
		Accesses the `y` property.
	**/
	public var y(get, set):Float;

	/**
		Creates a new ChildAccess abstract.
	**/
	public inline function new(displayObject:T)
	{
		this = displayObject;
	}

	/**
		Accesses the `addChild` method (for DisplayObjectContainer instances only).
	**/
	public function addChild(child:DisplayObject):DisplayObject
	{
		return cast(this, DisplayObjectContainer).addChild(child);
	}

	/**
		Accesses the `addChildAt` method (for DisplayObjectContainer instances only).
	**/
	public function addChildAt(child:DisplayObject, index:Int):DisplayObject
	{
		return cast(this, DisplayObjectContainer).addChildAt(child, index);
	}

	/**
		Accesses the `addEventListener` method.
	**/
	public function addEventListener<T2>(type:EventType<T2>, listener:T2->Void, useCapture:Bool = false, priority:Int = 0, useWeakReference:Bool = false):Void
	{
		this.addEventListener(type, listener, useCapture, priority);
	}

	/**
		Accesses the `addFrameScript` method (for MovieClip instances only).
	**/
	public function addFrameScript(index:Int, method:Void->Void):Void
	{
		cast(this, MovieClip).addFrameScript(index, method);
	}

	/**
		Accesses the `addTile` method (for Tilemap instances only).
	**/
	public function addTile(tile:Tile):Tile
	{
		return cast(this, Tilemap).addTile(tile);
	}

	/**
		Accesses the `addTileAt` method (for Tilemap instances only).
	**/
	public function addTileAt(tile:Tile, index:Int):Tile
	{
		return cast(this, Tilemap).addTileAt(tile, index);
	}

	/**
		Accesses the `addTiles` method (for Tilemap instances only).
	**/
	public function addTiles(tiles:Array<Tile>):Array<Tile>
	{
		return cast(this, Tilemap).addTiles(tiles);
	}

	/**
		Accesses the `appendText` method (for TextField instances only).
	**/
	public function appendText(text:String):Void
	{
		cast(this, TextField).appendText(text);
	}

	/**
		Accesses the `areInaccessibleObjectsUnderPoint` method (for DisplayObjectContainer instances only).
	**/
	public function areInaccessibleObjectsUnderPoint(point:Point):Bool
	{
		return cast(this, DisplayObjectContainer).areInaccessibleObjectsUnderPoint(point);
	}

	/**
		Accesses the `attachNetStream` method (for Video instances only).
	**/
	public function attachNetStream(netStream:NetStream):Void
	{
		cast(this, Video).attachNetStream(netStream);
	}

	/**
		Accesses the `attachTimeline` method (for MovieClip instances only).
	**/
	public function attachTimeline(timeline:Timeline):Void
	{
		#if flash
		cast(this, openfl.display.MovieClip.MovieClip2).attachTimeline(timeline);
		#else
		cast(this, MovieClip).attachTimeline(timeline);
		#end
	}

	/**
		Accesses the `clear` method (for Video instances only).
	**/
	public function clear():Void
	{
		cast(this, Video).clear();
	}

	/**
		Accesses the `contains` method (for Tilemap or DisplayObjectContainer instances only).
	**/
	public function contains(child:Dynamic):Bool
	{
		if (#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (this, Tilemap))
		{
			return cast(this, Tilemap).contains(child);
		}
		else
		{
			return cast(this, DisplayObjectContainer).contains(child);
		}
	}

	/**
		Accesses the `dispatchEvent` method.
	**/
	public function dispatchEvent(event:Event):Bool
	{
		return this.dispatchEvent(event);
	}

	/**
		Accesses the `getBounds` method.
	**/
	public function getBounds(targetCoordinateSpace:DisplayObject):Rectangle
	{
		return this.getBounds(targetCoordinateSpace);
	}

	/**
		Accesses the `getCharBoundaries` method (for TextField instances only).
	**/
	public function getCharBoundaries(charIndex:Int):Rectangle
	{
		return cast(this, TextField).getCharBoundaries(charIndex);
	}

	/**
		Accesses the `getCharIndexAtPoint` method (for TextField instances only).
	**/
	public function getCharIndexAtPoint(x:Float, y:Float):Int
	{
		return cast(this, TextField).getCharIndexAtPoint(x, y);
	}

	/**
		Accesses the `getChildAt` method (for DisplayObjectContainer instances only).
	**/
	public function getChildAt(index:Int):DisplayObject
	{
		return cast(this, DisplayObjectContainer).getChildAt(index);
	}

	/**
		Accesses the `getChildByName` method (for DisplayObjectContainer instances only).
	**/
	public function getChildByName(name:String):DisplayObject
	{
		return cast(this, DisplayObjectContainer).getChildByName(name);
	}

	/**
		Accesses the `getChildIndex` method (for DisplayObjectContainer instances only).
	**/
	public function getChildIndex(child:DisplayObject):Int
	{
		return cast(this, DisplayObjectContainer).getChildIndex(child);
	}

	/**
		Accesses the `getFirstCharInParagraph` method (for TextField instances only).
	**/
	public function getFirstCharInParagraph(charIndex:Int):Int
	{
		return cast(this, TextField).getFirstCharInParagraph(charIndex);
	}

	/**
		Accesses the `getLineIndexAtPoint` method (for TextField instances only).
	**/
	public function getLineIndexAtPoint(x:Float, y:Float):Int
	{
		return cast(this, TextField).getLineIndexAtPoint(x, y);
	}

	/**
		Accesses the `getLineIndexOfChar` method (for TextField instances only).
	**/
	public function getLineIndexOfChar(charIndex:Int):Int
	{
		return cast(this, TextField).getLineIndexOfChar(charIndex);
	}

	/**
		Accesses the `getLineLength` method (for TextField instances only).
	**/
	public function getLineLength(lineIndex:Int):Int
	{
		return cast(this, TextField).getLineLength(lineIndex);
	}

	/**
		Accesses the `getLineMetrics` method (for TextField instances only).
	**/
	public function getLineMetrics(lineIndex:Int):TextLineMetrics
	{
		return cast(this, TextField).getLineMetrics(lineIndex);
	}

	/**
		Accesses the `getLineOffset` method (for TextField instances only).
	**/
	public function getLineOffset(lineIndex:Int):Int
	{
		return cast(this, TextField).getLineOffset(lineIndex);
	}

	/**
		Accesses the `getLineText` method (for TextField instances only).
	**/
	public function getLineText(lineIndex:Int):String
	{
		return cast(this, TextField).getLineText(lineIndex);
	}

	/**
		Accesses the `getObjectsUnderPoint` method (for DisplayObjectContainer instances only).
	**/
	public function getObjectsUnderPoint(point:Point):Array<DisplayObject>
	{
		return cast(this, DisplayObjectContainer).getObjectsUnderPoint(point);
	}

	/**
		Accesses the `getParagraphLength` method (for TextField instances only).
	**/
	public function getParagraphLength(charIndex:Int):Int
	{
		return cast(this, TextField).getParagraphLength(charIndex);
	}

	/**
		Accesses the `getRect` method.
	**/
	public function getRect(targetCoordinateSpace:DisplayObject):Rectangle
	{
		return this.getRect(targetCoordinateSpace);
	}

	/**
		Accesses the `getTextFormat` method (for TextField instances only).
	**/
	public function getTextFormat(beginIndex:Int = -1, endIndex:Int = -1):TextFormat
	{
		return cast(this, TextField).getTextFormat(beginIndex, endIndex);
	}

	/**
		Accesses the `getTileAt` method (for Tilemap instances only).
	**/
	public function getTileAt(index:Int):Tile
	{
		return cast(this, Tilemap).getTileAt(index);
	}

	/**
		Accesses the `getTileIndex` method (for Tilemap instances only).
	**/
	public function getTileIndex(tile:Tile):Int
	{
		return cast(this, Tilemap).getTileIndex(tile);
	}

	/**
		Accesses the `getTiles` method (for Tilemap instances only).
	**/
	public function getTiles():TileContainer
	{
		return cast(this, Tilemap).getTiles();
	}

	/**
		Accesses the `globalToLocal` method.
	**/
	public function globalToLocal(pos:Point):Point
	{
		return this.globalToLocal(pos);
	}

	/**
		Accesses the `gotoAndPlay` method (for MovieClip instances only).
	**/
	public function gotoAndPlay(frame:#if (haxe_ver >= "3.4.2") Any #else Dynamic #end, scene:String = null):Void
	{
		cast(this, MovieClip).gotoAndPlay(frame, scene);
	}

	/**
		Accesses the `gotoAndStop` method (for MovieClip instances only).
	**/
	public function gotoAndStop(frame:#if (haxe_ver >= "3.4.2") Any #else Dynamic #end, scene:String = null):Void
	{
		cast(this, MovieClip).gotoAndStop(frame, scene);
	}

	/**
		Accesses the `hasEventListener` method.
	**/
	public function hasEventListener(type:String):Bool
	{
		return this.hasEventListener(type);
	}

	/**
		Accesses the `hitTestObject` method.
	**/
	public function hitTestObject(obj:DisplayObject):Bool
	{
		return this.hitTestObject(obj);
	}

	/**
		Accesses the `hitTestPoint` method.
	**/
	public function hitTestPoint(x:Float, y:Float, shapeFlag:Bool = false):Bool
	{
		return this.hitTestPoint(x, y, shapeFlag);
	}

	/**
		Accesses the `invalidate` method.
	**/
	public function invalidate():Void
	{
		this.invalidate();
	}

	/**
		Accesses the `localToGlobal` method.
	**/
	public function localToGlobal(point:Point):Point
	{
		return this.localToGlobal(point);
	}

	/**
		Accesses the `nextFrame` method (for MovieClip instances only).
	**/
	public function nextFrame():Void
	{
		cast(this, MovieClip).nextFrame();
	}

	/**
		Accesses the `nextScene` method (for MovieClip instances only).
	**/
	public function nextScene():Void
	{
		cast(this, MovieClip).nextScene();
	}

	/**
		Accesses the `play` method (for MovieClip instances only).
	**/
	public function play():Void
	{
		cast(this, MovieClip).play();
	}

	/**
		Accesses the `prevFrame` method (for MovieClip instances only).
	**/
	public function prevFrame():Void
	{
		cast(this, MovieClip).prevFrame();
	}

	/**
		Accesses the `prevScene` method (for MovieClip instances only).
	**/
	public function prevScene():Void
	{
		cast(this, MovieClip).prevScene();
	}

	/**
		Accesses the `removeChild` method (for DisplayObjectContainer instances only).
	**/
	public function removeChild(child:DisplayObject):DisplayObject
	{
		return cast(this, DisplayObjectContainer).removeChild(child);
	}

	/**
		Accesses the `removeChildAt` method (for DisplayObjectContainer instances only).
	**/
	public function removeChildAt(index:Int):DisplayObject
	{
		return cast(this, DisplayObjectContainer).removeChildAt(index);
	}

	/**
		Accesses the `removeChildren` method (for DisplayObjectContainer instances only).
	**/
	public function removeChildren(beginIndex:Int = 0, endIndex:Int = 0x7FFFFFFF):Void
	{
		cast(this, DisplayObjectContainer).removeChildren(beginIndex, endIndex);
	}

	/**
		Accesses the `removeEventListener` method.
	**/
	public function removeEventListener<T2>(type:EventType<T2>, listener:T2->Void, useCapture:Bool = false):Void
	{
		this.removeEventListener(type, listener, useCapture);
	}

	/**
		Accesses the `removeTile` method (for Tilemap instances only).
	**/
	public function removeTile(tile:Tile):Tile
	{
		return cast(this, Tilemap).removeTile(tile);
	}

	/**
		Accesses the `removeTileAt` method (for Tilemap instances only).
	**/
	public function removeTileAt(index:Int):Tile
	{
		return cast(this, Tilemap).removeTileAt(index);
	}

	/**
		Accesses the `removeTiles` method (for Tilemap instances only).
	**/
	public function removeTiles(beginIndex:Int = 0, endIndex:Int = 0x7fffffff):Void
	{
		cast(this, Tilemap).removeTiles(beginIndex, endIndex);
	}

	/**
		Accesses the `replaceSelectedText` method (for TextField instances only).
	**/
	public function replaceSelectedText(value:String):Void
	{
		cast(this, TextField).replaceSelectedText(value);
	}

	/**
		Accesses the `replaceText` method (for TextField instances only).
	**/
	public function replaceText(beginIndex:Int, endIndex:Int, newText:String):Void
	{
		cast(this, TextField).replaceText(beginIndex, endIndex, newText);
	}

	#if !openfl_strict
	/**
		Accesses the `requestSoftKeyboard` method (for InteractiveObject instances only).
	**/
	public function requestSoftKeyboard():Bool
	{
		return cast(this, InteractiveObject).requestSoftKeyboard();
	}
	#end

	/**
		Resolves a child DisplayObject by name (if this is an instance
		of DisplayObjectContainer) or otherwise will return `null`.
		@param childName The name of the desired child DisplayObject.
		@return The child DisplayObject, if available.
	**/
	@:op(a.b)
	@:arrayAccess
	private function __resolve(childName:String):ChildAccess<DisplayObject>
	{
		#if flash
		if (this != null && #if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (this, DisplayObjectContainer))
		{
			var container:DisplayObjectContainer = cast this;
			return container.getChildByName(childName);
		}
		return null;
		#else
		if (this == null || this.__children == null) return null;
		for (child in this.__children)
		{
			if (child.name == childName) return child;
		}
		return null;
		#end
	}

	/**
		Accesses the `setChildIndex` method (for DisplayObjectContainer instances only).
	**/
	public function setChildIndex(child:DisplayObject, index:Int):Void
	{
		cast(this, DisplayObjectContainer).setChildIndex(child, index);
	}

	/**
		Accesses the `setSelection` method (for TextField instances only).
	**/
	public function setSelection(beginIndex:Int, endIndex:Int):Void
	{
		cast(this, TextField).setSelection(beginIndex, endIndex);
	}

	/**
		Accesses the `setTextFormat` method (for TextField instances only).
	**/
	public function setTextFormat(format:TextFormat, beginIndex:Int = -1, endIndex:Int = -1):Void
	{
		cast(this, TextField).setTextFormat(format, beginIndex, endIndex);
	}

	/**
		Accesses the `setTileIndex` method (for Tilemap instances only).
	**/
	public function setTileIndex(tile:Tile, index:Int):Void
	{
		cast(this, Tilemap).setTileIndex(tile, index);
	}

	/**
		Accesses the `setTiles` method (for Tilemap instances only).
	**/
	public function setTiles(group:TileContainer):Void
	{
		cast(this, Tilemap).setTiles(group);
	}

	/**
		Accesses the `sortTiles` method (for Tilemap instances only).
	**/
	public function sortTiles(compareFunction:Tile->Tile->Int):Void
	{
		cast(this, Tilemap).sortTiles(compareFunction);
	}

	/**
		Accesses the `startDrag` method (for Sprite instances only).
	**/
	public function startDrag(lockCenter:Bool = false, bounds:Rectangle = null):Void
	{
		cast(this, Sprite).startDrag(lockCenter, bounds);
	}

	/**
		Accesses the `stop` method (for MovieClip instances only).
	**/
	public function stop():Void
	{
		cast(this, MovieClip).stop();
	}

	/**
		Accesses the `stopAllMovieClips` method (for DisplayObjectContainer instances only).
	**/
	public function stopAllMovieClips():Void
	{
		cast(this, DisplayObjectContainer).stopAllMovieClips();
	}

	/**
		Accesses the `stopDrag` method (for Sprite instances only).
	**/
	public function stopDrag():Void
	{
		cast(this, Sprite).stopDrag();
	}

	/**
		Accesses the `swapChildren` method (for DisplayObjectContainer instances only).
	**/
	public function swapChildren(child1:DisplayObject, child2:DisplayObject):Void
	{
		cast(this, DisplayObjectContainer).swapChildren(child1, child2);
	}

	/**
		Accesses the `swapChildrenAt` method (for DisplayObjectContainer instances only).
	**/
	public function swapChildrenAt(index1:Int, index2:Int):Void
	{
		cast(this, DisplayObjectContainer).swapChildrenAt(index1, index2);
	}

	/**
		Accesses the `swapTiles` method (for Tilemap instances only).
	**/
	public function swapTiles(tile1:Tile, tile2:Tile):Void
	{
		cast(this, Tilemap).swapTiles(tile1, tile2);
	}

	/**
		Accesses the `swapTilesAt` method (for Tilemap instances only).
	**/
	public function swapTilesAt(index1:Int, index2:Int):Void
	{
		cast(this, Tilemap).swapTilesAt(index1, index2);
	}

	/**
		Accesses the `toString` method.
	**/
	public function toString():String
	{
		if (this == null) return null;
		return this.toString();
	}

	/**
		Accesses the `willTrigger` method.
	**/
	public function willTrigger(type:String):Bool
	{
		return this.willTrigger(type);
	}

	@:to private static inline function __toMovieClip(value:ChildAccess<Dynamic>):MovieClip
	{
		if (value != null && !#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (value, MovieClip))
		{
			throw new TypeError("Cannot cast object reference to MovieClip");
		}

		return cast value;
	}

	@:to private static inline function __toTilemap(value:ChildAccess<Dynamic>):Tilemap
	{
		if (value != null && !#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (value, Tilemap))
		{
			throw new TypeError("Cannot cast object reference to Tilemap");
		}

		return cast value;
	}

	@:to private static inline function __toVideo(value:ChildAccess<Dynamic>):Video
	{
		if (value != null && !#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (value, Video))
		{
			throw new TypeError("Cannot cast object reference to Video");
		}

		return cast value;
	}

	@:to private static inline function __toTextField(value:ChildAccess<Dynamic>):TextField
	{
		if (value != null && !#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (value, TextField))
		{
			throw new TypeError("Cannot cast object reference to TextField");
		}

		return cast value;
	}

	@:to private static inline function __toStaticText(value:ChildAccess<Dynamic>):StaticText
	{
		if (value != null && !#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (value, StaticText))
		{
			throw new TypeError("Cannot cast object reference to StaticText");
		}

		return cast value;
	}

	@:to private static inline function __toShape(value:ChildAccess<Dynamic>):Shape
	{
		if (value != null && !#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (value, Shape))
		{
			throw new TypeError("Cannot cast object reference to Shape");
		}

		return cast value;
	}

	@:to private static inline function __toSprite(value:ChildAccess<Dynamic>):Sprite
	{
		if (value != null && !#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (value, Sprite))
		{
			throw new TypeError("Cannot cast object reference to Sprite");
		}

		return cast value;
	}

	@:to private static inline function __toBitmap(value:ChildAccess<Dynamic>):Bitmap
	{
		if (value != null && !#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (value, Bitmap))
		{
			throw new TypeError("Cannot cast object reference to Bitmap");
		}

		return cast value;
	}

	@:to private static inline function __toDisplayObjectContainer(value:ChildAccess<Dynamic>):DisplayObjectContainer
	{
		if (value != null && !#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (value, DisplayObjectContainer))
		{
			throw new TypeError("Cannot cast object reference to DisplayObjectContainer");
		}

		return cast value;
	}

	// Get & Set Methods

	private inline function get_alpha():Float
	{
		return this.alpha;
	}

	private inline function set_alpha(value:Float):Float
	{
		return this.alpha = value;
	}

	private inline function get_antiAliasType():AntiAliasType
	{
		return cast(this, TextField).antiAliasType;
	}

	private inline function set_antiAliasType(value:AntiAliasType):AntiAliasType
	{
		return cast(this, TextField).antiAliasType = value;
	}

	private inline function get_autoSize():TextFieldAutoSize
	{
		return cast(this, TextField).autoSize;
	}

	private inline function set_autoSize(value:TextFieldAutoSize):TextFieldAutoSize
	{
		return cast(this, TextField).autoSize = value;
	}

	private inline function get_background():Bool
	{
		return cast(this, TextField).background;
	}

	private inline function set_background(value:Bool):Bool
	{
		return cast(this, TextField).background = value;
	}

	private inline function get_backgroundColor():Int
	{
		return cast(this, TextField).backgroundColor;
	}

	private inline function set_backgroundColor(value:Int):Int
	{
		return cast(this, TextField).backgroundColor = value;
	}

	private inline function get_bitmapData():BitmapData
	{
		return cast(this, Bitmap).bitmapData;
	}

	private inline function set_bitmapData(value:BitmapData):BitmapData
	{
		return cast(this, Bitmap).bitmapData = value;
	}

	private inline function get_blendMode():BlendMode
	{
		return this.blendMode;
	}

	private inline function set_blendMode(value:BlendMode):BlendMode
	{
		return this.blendMode = value;
	}

	private inline function get_border():Bool
	{
		return cast(this, TextField).border;
	}

	private inline function set_border(value:Bool):Bool
	{
		return cast(this, TextField).border = value;
	}

	private inline function get_borderColor():Int
	{
		return cast(this, TextField).borderColor;
	}

	private inline function set_borderColor(value:Int):Int
	{
		return cast(this, TextField).borderColor = value;
	}

	private inline function get_bottomScrollV():Int
	{
		return cast(this, TextField).bottomScrollV;
	}

	private inline function get_buttonMode():Bool
	{
		return cast(this, Sprite).buttonMode;
	}

	private inline function set_buttonMode(value:Bool):Bool
	{
		return cast(this, Sprite).buttonMode = value;
	}

	private inline function get_cacheAsBitmap():Bool
	{
		return this.cacheAsBitmap;
	}

	private inline function set_cacheAsBitmap(value:Bool):Bool
	{
		return this.cacheAsBitmap = value;
	}

	private inline function get_cacheAsBitmapMatrix():Matrix
	{
		return this.cacheAsBitmapMatrix;
	}

	private inline function set_cacheAsBitmapMatrix(value:Matrix):Matrix
	{
		return this.cacheAsBitmapMatrix = value;
	}

	private inline function get_caretIndex():Int
	{
		return cast(this, TextField).caretIndex;
	}

	private inline function get_condenseWhite():Bool
	{
		return cast(this, TextField).condenseWhite;
	}

	private inline function set_condenseWhite(value:Bool):Bool
	{
		return cast(this, TextField).condenseWhite = value;
	}

	private inline function get_currentFrame():Int
	{
		return cast(this, MovieClip).currentFrame;
	}

	private inline function get_currentFrameLabel():String
	{
		return cast(this, MovieClip).currentFrameLabel;
	}

	private inline function get_currentLabel():String
	{
		return cast(this, MovieClip).currentLabel;
	}

	private inline function get_currentLabels():Array<FrameLabel>
	{
		return cast(this, MovieClip).currentLabels;
	}

	private inline function get_currentScene():Scene
	{
		return cast(this, MovieClip).currentScene;
	}

	private inline function get_deblocking():Int
	{
		return cast(this, Video).deblocking;
	}

	private inline function set_deblocking(value:Int):Int
	{
		return cast(this, Video).deblocking = value;
	}

	private inline function get_defaultTextFormat():TextFormat
	{
		return cast(this, TextField).defaultTextFormat;
	}

	private inline function set_defaultTextFormat(value:TextFormat):TextFormat
	{
		return cast(this, TextField).defaultTextFormat = value;
	}

	private inline function get_displayAsPassword():Bool
	{
		return cast(this, TextField).displayAsPassword;
	}

	private inline function set_displayAsPassword(value:Bool):Bool
	{
		return cast(this, TextField).displayAsPassword = value;
	}

	private inline function get_doubleClickEnabled():Bool
	{
		return cast(this, InteractiveObject).doubleClickEnabled;
	}

	private inline function set_doubleClickEnabled(value:Bool):Bool
	{
		return cast(this, InteractiveObject).doubleClickEnabled = value;
	}

	private inline function get_dropTarget():DisplayObject
	{
		return cast(this, Sprite).dropTarget;
	}

	private inline function get_embedFonts():Bool
	{
		return cast(this, TextField).embedFonts;
	}

	private inline function set_embedFonts(value:Bool):Bool
	{
		return cast(this, TextField).embedFonts = value;
	}

	private inline function get_enabled():Bool
	{
		return cast(this, MovieClip).enabled;
	}

	private inline function set_enabled(value:Bool):Bool
	{
		return cast(this, MovieClip).enabled = value;
	}

	private inline function get_filters():Array<BitmapFilter>
	{
		return this.filters;
	}

	private inline function set_filters(value:Array<BitmapFilter>):Array<BitmapFilter>
	{
		return this.filters = value;
	}

	private inline function get_focusRect():Null<Bool>
	{
		return cast(this, InteractiveObject).focusRect;
	}

	private inline function set_focusRect(value:Null<Bool>):Null<Bool>
	{
		return cast(this, InteractiveObject).focusRect = value;
	}

	private inline function get_framesLoaded():Int
	{
		return cast(this, MovieClip).framesLoaded;
	}

	private inline function get_graphics():Graphics
	{
		if (#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (this, Sprite))
		{
			return cast(this, Sprite).graphics;
		}
		else
		{
			return cast(this, Shape).graphics;
		}
	}

	private inline function get_gridFitType():GridFitType
	{
		return cast(this, TextField).gridFitType;
	}

	private inline function set_gridFitType(value:GridFitType):GridFitType
	{
		return cast(this, TextField).gridFitType = value;
	}

	private inline function get_height():Float
	{
		return this.height;
	}

	private inline function set_height(value:Float):Float
	{
		return this.height = value;
	}

	private inline function get_htmlText():UTF8String
	{
		return cast(this, TextField).htmlText;
	}

	private inline function set_htmlText(value:UTF8String):UTF8String
	{
		return cast(this, TextField).htmlText = value;
	}

	private inline function get_hitArea():Sprite
	{
		return cast(this, Sprite).hitArea;
	}

	private inline function set_hitArea(value:Sprite):Sprite
	{
		return cast(this, Sprite).hitArea = value;
	}

	private inline function get_isPlaying():Bool
	{
		return cast(this, MovieClip).isPlaying;
	}

	private inline function get_length():Int
	{
		return cast(this, TextField).length;
	}

	private inline function get_loaderInfo():LoaderInfo
	{
		return this.loaderInfo;
	}

	private inline function get_mask():DisplayObject
	{
		return this.mask;
	}

	private inline function set_mask(value:DisplayObject):DisplayObject
	{
		return this.mask = value;
	}

	private inline function get_maxChars():Int
	{
		return cast(this, TextField).maxChars;
	}

	private inline function set_maxChars(value:Int):Int
	{
		return cast(this, TextField).maxChars = value;
	}

	private inline function get_maxScrollH():Int
	{
		return cast(this, TextField).maxScrollH;
	}

	private inline function get_maxScrollV():Int
	{
		return cast(this, TextField).maxScrollV;
	}

	private inline function get_mouseChildren():Bool
	{
		return cast(this, DisplayObjectContainer).mouseChildren;
	}

	private inline function set_mouseChildren(value:Bool):Bool
	{
		return cast(this, DisplayObjectContainer).mouseChildren = value;
	}

	private inline function get_mouseEnabled():Bool
	{
		return cast(this, InteractiveObject).mouseEnabled;
	}

	private inline function set_mouseEnabled(value:Bool):Bool
	{
		return cast(this, InteractiveObject).mouseEnabled = value;
	}

	private inline function get_mouseWheelEnabled():Bool
	{
		return cast(this, TextField).mouseWheelEnabled;
	}

	private inline function set_mouseWheelEnabled(value:Bool):Bool
	{
		return cast(this, TextField).mouseWheelEnabled = value;
	}

	private inline function get_mouseX():Float
	{
		return this.mouseX;
	}

	private inline function get_mouseY():Float
	{
		return this.mouseY;
	}

	private inline function get_multiline():Bool
	{
		return cast(this, TextField).multiline;
	}

	private inline function set_multiline(value:Bool):Bool
	{
		return cast(this, TextField).multiline = value;
	}

	private inline function get_name():String
	{
		return this.name;
	}

	private inline function set_name(value:String):String
	{
		return this.name = value;
	}

	private inline function get_needsSoftKeyboard():Bool
	{
		return cast(this, InteractiveObject).needsSoftKeyboard;
	}

	private inline function set_needsSoftKeyboard(value:Bool):Bool
	{
		return cast(this, InteractiveObject).needsSoftKeyboard = value;
	}

	private inline function get_numChildren():Int
	{
		return cast(this, DisplayObjectContainer).numChildren;
	}

	private inline function get_numLines():Int
	{
		return cast(this, TextField).numLines;
	}

	private inline function get_numTiles():Int
	{
		return cast(this, Tilemap).numTiles;
	}

	private inline function get_opaqueBackground():Null<Int>
	{
		return this.opaqueBackground;
	}

	private inline function set_opaqueBackground(value:Null<Int>):Null<Int>
	{
		return this.opaqueBackground = value;
	}

	private inline function get_parent():DisplayObjectContainer
	{
		return this.parent;
	}

	private inline function get_pixelSnapping():PixelSnapping
	{
		return cast(this, Bitmap).pixelSnapping;
	}

	private inline function set_pixelSnapping(value:PixelSnapping):PixelSnapping
	{
		return cast(this, Bitmap).pixelSnapping = value;
	}

	private inline function get_restrict():UTF8String
	{
		return cast(this, TextField).restrict;
	}

	private inline function set_restrict(value:UTF8String):UTF8String
	{
		return cast(this, TextField).restrict = value;
	}

	private inline function get_root():DisplayObject
	{
		return this.root;
	}

	private inline function get_rotation():Float
	{
		return this.rotation;
	}

	private inline function set_rotation(value:Float):Float
	{
		return this.rotation = value;
	}

	private inline function get_scale9Grid():Rectangle
	{
		return this.scale9Grid;
	}

	private inline function set_scale9Grid(value:Rectangle):Rectangle
	{
		return this.scale9Grid = value;
	}

	private inline function get_scaleX():Float
	{
		return this.scaleX;
	}

	private inline function set_scaleX(value:Float):Float
	{
		return this.scaleX = value;
	}

	private inline function get_scaleY():Float
	{
		return this.scaleY;
	}

	private inline function set_scaleY(value:Float):Float
	{
		return this.scaleY = value;
	}

	private inline function get_scenes():Array<Scene>
	{
		return cast(this, MovieClip).scenes;
	}

	private inline function get_scrollH():Int
	{
		return cast(this, TextField).scrollH;
	}

	private inline function set_scrollH(value:Int):Int
	{
		return cast(this, TextField).scrollH = value;
	}

	private inline function get_scrollRect():Rectangle
	{
		return this.scrollRect;
	}

	private inline function set_scrollRect(value:Rectangle):Rectangle
	{
		return this.scrollRect = value;
	}

	private inline function get_scrollV():Int
	{
		return cast(this, TextField).scrollV;
	}

	private inline function set_scrollV(value:Int):Int
	{
		return cast(this, TextField).scrollV = value;
	}

	private inline function get_selectable():Bool
	{
		return cast(this, TextField).selectable;
	}

	private inline function set_selectable(value:Bool):Bool
	{
		return cast(this, TextField).selectable = value;
	}

	private inline function get_selectionBeginIndex():Int
	{
		return cast(this, TextField).selectionBeginIndex;
	}

	private inline function get_selectionEndIndex():Int
	{
		return cast(this, TextField).selectionEndIndex;
	}

	private inline function get_shader():Shader
	{
		return this.shader;
	}

	private inline function set_shader(value:Shader):Shader
	{
		return this.shader = value;
	}

	private inline function get_sharpness():Float
	{
		return cast(this, TextField).sharpness;
	}

	private inline function set_sharpness(value:Float):Float
	{
		return cast(this, TextField).sharpness = value;
	}

	private inline function get_smoothing():Bool
	{
		if (#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (this, Bitmap))
		{
			return cast(this, Bitmap).smoothing;
		}
		else
		{
			return cast(this, Video).smoothing;
		}
	}

	private inline function set_smoothing(value:Bool):Bool
	{
		if (#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (this, Bitmap))
		{
			return cast(this, Bitmap).smoothing = value;
		}
		else
		{
			return cast(this, Video).smoothing = value;
		}
	}

	private inline function get_softKeyboardInputAreaOfInterest():Rectangle
	{
		return cast(this, InteractiveObject).softKeyboardInputAreaOfInterest;
	}

	private inline function set_softKeyboardInputAreaOfInterest(value:Rectangle):Rectangle
	{
		return cast(this, InteractiveObject).softKeyboardInputAreaOfInterest = value;
	}

	private inline function get_stage():Stage
	{
		return this.stage;
	}

	private inline function get_styleSheet():StyleSheet
	{
		return cast(this, TextField).styleSheet;
	}

	private inline function set_styleSheet(value:StyleSheet):StyleSheet
	{
		return cast(this, TextField).styleSheet = value;
	}

	private inline function get_tabChildren():Bool
	{
		return cast(this, DisplayObjectContainer).tabChildren;
	}

	private inline function set_tabChildren(value:Bool):Bool
	{
		return cast(this, DisplayObjectContainer).tabChildren = value;
	}

	private inline function get_tabEnabled():Bool
	{
		return cast(this, InteractiveObject).tabEnabled;
	}

	private inline function set_tabEnabled(value:Bool):Bool
	{
		return cast(this, InteractiveObject).tabEnabled = value;
	}

	private inline function get_tabIndex():Int
	{
		return cast(this, InteractiveObject).tabIndex;
	}

	private inline function set_tabIndex(value:Int):Int
	{
		return cast(this, InteractiveObject).tabIndex = value;
	}

	private inline function get_text():UTF8String
	{
		if (#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (this, TextField))
		{
			return cast(this, TextField).text;
		}
		else
		{
			return cast(this, StaticText).text;
		}
	}

	private inline function set_text(value:UTF8String):UTF8String
	{
		return cast(this, TextField).text = value;
	}

	private inline function get_textColor():Int
	{
		return cast(this, TextField).textColor;
	}

	private inline function set_textColor(value:Int):Int
	{
		return cast(this, TextField).textColor = value;
	}

	private inline function get_textHeight():Float
	{
		return cast(this, TextField).textHeight;
	}

	private inline function get_textWidth():Float
	{
		return cast(this, TextField).textWidth;
	}

	private inline function get_tileAlphaEnabled():Bool
	{
		return cast(this, Tilemap).tileAlphaEnabled;
	}

	private inline function set_tileAlphaEnabled(value:Bool):Bool
	{
		return cast(this, Tilemap).tileAlphaEnabled = value;
	}

	private inline function get_tileBlendModeEnabled():Bool
	{
		return cast(this, Tilemap).tileBlendModeEnabled;
	}

	private inline function set_tileBlendModeEnabled(value:Bool):Bool
	{
		return cast(this, Tilemap).tileBlendModeEnabled = value;
	}

	private inline function get_tileColorTransformEnabled():Bool
	{
		return cast(this, Tilemap).tileColorTransformEnabled;
	}

	private inline function set_tileColorTransformEnabled(value:Bool):Bool
	{
		return cast(this, Tilemap).tileColorTransformEnabled = value;
	}

	private inline function get_tileset():Tileset
	{
		return cast(this, Tilemap).tileset;
	}

	private inline function set_tileset(value:Tileset):Tileset
	{
		return cast(this, Tilemap).tileset = value;
	}

	private inline function get_totalFrames():Int
	{
		return cast(this, MovieClip).totalFrames;
	}

	private inline function get_transform():Transform
	{
		return this.transform;
	}

	private inline function set_transform(value:Transform):Transform
	{
		return this.transform = value;
	}

	private inline function get_type():TextFieldType
	{
		return cast(this, TextField).type;
	}

	private inline function set_type(value:TextFieldType):TextFieldType
	{
		return cast(this, TextField).type = value;
	}

	private inline function get_useHandCursor():Bool
	{
		return cast(this, Sprite).useHandCursor;
	}

	private inline function set_useHandCursor(value:Bool):Bool
	{
		return cast(this, Sprite).useHandCursor = value;
	}

	private inline function get_videoHeight():Int
	{
		return cast(this, Video).videoHeight;
	}

	private inline function get_videoWidth():Int
	{
		return cast(this, Video).videoWidth;
	}

	private inline function get_visible():Bool
	{
		return this.visible;
	}

	private inline function set_visible(value:Bool):Bool
	{
		return this.visible = value;
	}

	private inline function get_width():Float
	{
		return this.width;
	}

	private inline function set_width(value:Float):Float
	{
		return this.width = value;
	}

	private inline function get_wordWrap():Bool
	{
		return cast(this, TextField).wordWrap;
	}

	private inline function set_wordWrap(value:Bool):Bool
	{
		return cast(this, TextField).wordWrap = value;
	}

	private inline function get_x():Float
	{
		return this.x;
	}

	private inline function set_x(value:Float):Float
	{
		return this.x = value;
	}

	private inline function get_y():Float
	{
		return this.y;
	}

	private inline function set_y(value:Float):Float
	{
		return this.y = value;
	}
}
