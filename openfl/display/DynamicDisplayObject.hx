package openfl.display;

import lime.graphics.cairo.Cairo;

#if (js && html5)
import js.html.CSSStyleDeclaration;
import js.html.CanvasRenderingContext2D;
import js.html.CanvasElement;
#end

import openfl._internal.renderer.RenderSession;
import openfl.events.Event;
import openfl.events.IEventDispatcher;
import openfl.filters.BitmapFilter;
import openfl.geom.Rectangle;
import openfl.geom.Matrix;
import openfl.geom.ColorTransform;
import openfl.geom.Transform;
import openfl.geom.Point;
import openfl.media.SoundTransform;
import openfl.text.TextFieldAutoSize;
import openfl.text.GridFitType;
import openfl.text.AntiAliasType;
import openfl.text.TextFieldType;
import openfl.text.TextLineMetrics;
import openfl.text.TextFormat;
import openfl.ui.MouseCursor;


extern class DynamicDisplayObject implements IEventDispatcher implements IBitmapDrawable implements Dynamic<DynamicDisplayObject>
{

	// IBitmapDrawable Members
	private var __blendMode:BlendMode;
	private var __transform:Matrix;
	private var __worldTransform:Matrix;
	private var __worldColorTransform:ColorTransform;
	private function __getBounds (rect:Rectangle, matrix:Matrix):Void;
	private function __renderCairo (renderSession:RenderSession):Void;
	private function __renderCairoMask (renderSession:RenderSession):Void;
	private function __renderCanvas (renderSession:RenderSession):Void;
	private function __renderCanvasMask (renderSession:RenderSession):Void;
	private function __renderGL (renderSession:RenderSession):Void;
	private function __updateChildren (transformOnly:Bool):Void;
	private function __updateTransforms (?overrideTransform:Matrix = null):Void;
	private function __updateMask (maskGraphics:Graphics):Void;


	// IEventDispatcher Members
	public function addEventListener (type:String, listener:Dynamic->Void, useCapture:Bool = false, priority:Int = 0, useWeakReference:Bool = false):Void;
	public function dispatchEvent (event:Event):Bool;
	public function hasEventListener (type:String):Bool;
	public function removeEventListener (type:String, listener:Dynamic->Void, useCapture:Bool = false):Void;
	public function willTrigger (type:String):Bool;


	// DisplayObject Members
	@:keep public var alpha (get, set):Float;
	public var blendMode (get, set):BlendMode;
	public var cacheAsBitmap (get, set):Bool;
	public var cacheAsBitmapMatrix (get, set):Matrix;
	public var filters (get, set):Array<BitmapFilter>;
	@:keep public var height (get, set):Float;
	public var loaderInfo (get, never):LoaderInfo;
	public var mask (get, set):DisplayObject;
	public var mouseX (get, never):Float;
	public var mouseY (get, never):Float;
	public var name (get, set):String;
	public var opaqueBackground:Null <Int>;
	public var parent (default, null):DisplayObjectContainer;
	public var root (get, never):DisplayObject;
	@:keep public var rotation (get, set):Float;
	public var scale9Grid:Rectangle;
	@:keep public var scaleX (get, set):Float;
	@:keep public var scaleY (get, set):Float;
	public var scrollRect (get, set):Rectangle;
	public var stage (default, null):Stage;
	@:keep public var transform (get, set):Transform;
	public var visible (get, set):Bool;
	@:keep public var width (get, set):Float;
	@:keep public var x (get, set):Float;
	@:keep public var y (get, set):Float;

	private var __alpha:Float;
	private var __cacheAsBitmap:Bool;
	private var __cacheAsBitmapMatrix:Matrix;
	private var __cacheBitmap:Bitmap;
	private var __cacheBitmapBackground:Null<Int>;
	private var __cacheBitmapColorTransform:ColorTransform;
	private var __cacheBitmapData:BitmapData;
	private var __cacheBitmapRender:Bool;
	private var __cairo:Cairo;
	private var __children:Array<DisplayObject>;
	private var __filters:Array<BitmapFilter>;
	private var __graphics:Graphics;
	private var __interactive:Bool;
	private var __isMask:Bool;
	private var __loaderInfo:LoaderInfo;
	private var __mask:DisplayObject;
	private var __name:String;
	private var __objectTransform:Transform;
	private var __renderable:Bool;
	private var __renderDirty:Bool;
	private var __renderParent:DisplayObject;
	private var __renderTransform:Matrix;
	private var __renderTransformCache:Matrix;
	private var __renderTransformChanged:Bool;
	private var __rotation:Float;
	private var __rotationCosine:Float;
	private var __rotationSine:Float;
	private var __scaleX:Float;
	private var __scaleY:Float;
	private var __scrollRect:Rectangle;
	private var __transformDirty:Bool;
	private var __visible:Bool;
	private var __worldAlpha:Float;
	private var __worldAlphaChanged:Bool;
	private var __worldBlendMode:BlendMode;
	private var __worldClip:Rectangle;
	private var __worldClipChanged:Bool;
	private var __worldVisible:Bool;
	private var __worldVisibleChanged:Bool;
	private var __worldTransformInvalid:Bool;
	private var __worldZ:Int;

	#if (js && html5)
	private var __canvas:CanvasElement;
	private var __context:CanvasRenderingContext2D;
	private var __style:CSSStyleDeclaration;
	#end

	public function getBounds (targetCoordinateSpace:DisplayObject):Rectangle;
	public function getRect (targetCoordinateSpace:DisplayObject):Rectangle;
	public function globalToLocal (pos:Point):Point;
	public function hitTestObject (obj:DisplayObject):Bool;
	public function hitTestPoint (x:Float, y:Float, shapeFlag:Bool = false):Bool;
	public function localToGlobal (point:Point):Point;

	private function get_alpha ():Float;
	private function set_alpha (value:Float):Float;
	private function get_blendMode ():BlendMode;
	private function set_blendMode (value:BlendMode):BlendMode;
	private function get_cacheAsBitmap ():Bool;
	private function set_cacheAsBitmap (value:Bool):Bool;
	private function get_cacheAsBitmapMatrix ():Matrix;
	private function set_cacheAsBitmapMatrix (value:Matrix):Matrix;
	private function get_filters ():Array<BitmapFilter>;
	private function set_filters (value:Array<BitmapFilter>):Array<BitmapFilter>;
	private function get_height ():Float;
	private function set_height (value:Float):Float;
	private function get_loaderInfo ():LoaderInfo;
	private function get_mask ():DisplayObject;
	private function set_mask (value:DisplayObject):DisplayObject;
	private function get_mouseX ():Float;
	private function get_mouseY ():Float;
	private function get_name ():String;
	private function set_name (value:String):String;
	private function get_root ():DisplayObject;
	private function get_rotation ():Float;
	private function set_rotation (value:Float):Float;
	@:keep private function get_scaleX ():Float;
	@:keep private function set_scaleX (value:Float):Float;
	@:keep private function get_scaleY ():Float;
	@:keep private function set_scaleY (value:Float):Float;
	private function get_scrollRect ():Rectangle;
	private function set_scrollRect (value:Rectangle):Rectangle;
	private function get_transform ():Transform;
	private function set_transform (value:Transform):Transform;
	private function get_visible ():Bool;
	private function set_visible (value:Bool):Bool;
	private function get_width ():Float;
	private function set_width (value:Float):Float;
	private function get_x ():Float;
	private function set_x (value:Float):Float;
	private function get_y ():Float;
	private function set_y (value:Float):Float;


	// InteractiveObject Members

	public var doubleClickEnabled:Bool;
	public var focusRect:Null<Bool>;
	public var mouseEnabled:Bool;
	public var needsSoftKeyboard:Bool;
	public var softKeyboardInputAreaOfInterest:Rectangle;
	public var tabEnabled:Bool;
	public var tabIndex:Int;
	public function requestSoftKeyboard ():Bool;


	// DisplayObjectContainer Members
	public var mouseChildren:Bool;
	public var numChildren (get, never):Int;
	public var tabChildren:Bool;
	public function addChild (child:DisplayObject):DisplayObject;
	public function addChildAt (child:DisplayObject, index:Int):DisplayObject;
	public function areInaccessibleObjectsUnderPoint (point:Point):Bool;
	public function contains (child:DisplayObject):Bool;
	public function getChildAt (index:Int):DisplayObject;
	public function getChildByName (name:String):DisplayObject;
	public function getChildIndex (child:DisplayObject):Int;
	public function getObjectsUnderPoint (point:Point):Array<DisplayObject>;
	public function removeChild (child:DisplayObject):DisplayObject;
	public function removeChildAt (index:Int):DisplayObject;
	public function removeChildren (beginIndex:Int = 0, endIndex:Int = 0x7FFFFFFF):Void;
	public function setChildIndex (child:DisplayObject, index:Int):Void;
	public function stopAllMovieClips ():Void;
	public function swapChildren (child1:DisplayObject, child2:DisplayObject):Void;
	public function swapChildrenAt (index1:Int, index2:Int):Void;
	private function get_numChildren ():Int;


	// Sprite Members
	public function startDrag (lockCenter:Bool = false, bounds:Rectangle = null):Void;
	public function stopDrag ():Void;
	private function __getCursor ():MouseCursor;
	private function __hitTest (x:Float, y:Float, shapeFlag:Bool, stack:Array<DisplayObject>, interactiveOnly:Bool, hitObject:DisplayObject):Bool;
	private function __hitTestHitArea (x:Float, y:Float, shapeFlag:Bool, stack:Array<DisplayObject>, interactiveOnly:Bool, hitObject:DisplayObject):Bool;
	private function __hitTestMask (x:Float, y:Float):Bool;
	private function get_graphics ():Graphics;
	private function get_tabEnabled ():Bool;


	// SimpleButton Members
	public var downState:DisplayObject;
	public var enabled:Bool;
	public var hitTestState:DisplayObject;
	public var overState:DisplayObject;
	public var soundTransform:SoundTransform;
	public var trackAsMenu:Bool;
	public var upState:DisplayObject;
	public var useHandCursor:Bool;


	// TextField Members
	public var antiAliasType (get, set):AntiAliasType;
	public var autoSize (get, set):TextFieldAutoSize;
	public var background (get, set):Bool;
	public var backgroundColor (get, set):Int;
	public var border (get, set):Bool;
	public var borderColor (get, set):Int;
	public var bottomScrollV (get, never):Int;
	public var caretIndex (get, never):Int;
	public var defaultTextFormat (get, set):TextFormat;
	public var displayAsPassword (get, set):Bool;
	public var embedFonts (get, set):Bool;
	public var gridFitType (get, set):GridFitType;
	public var htmlText (get, set):String;
	public var length (get, never):Int;
	public var maxChars (get, set):Int;
	public var maxScrollH (get, never):Int;
	public var maxScrollV (get, never):Int;
	public var mouseWheelEnabled (get, set):Bool;
	public var multiline (get, set):Bool;
	public var numLines (get, never):Int;
	public var restrict (get, set):String;
	public var scrollH (get, set):Int;
	public var scrollV (get, set):Int;
	public var selectable (get, set):Bool;
	public var selectionBeginIndex (get, never):Int;
	public var selectionEndIndex (get, never):Int;
	public var sharpness (get, set):Float;
	public var text (get, set):String;
	public var textColor (get, set):Int;
	public var textHeight (get, never):Float;
	public var textWidth (get, never):Float;
	public var type (get, set):TextFieldType;
	public var wordWrap (get, set):Bool;

	public function appendText (text:String):Void;
	public function getCharBoundaries (charIndex:Int):Rectangle;
	public function getCharIndexAtPoint (x:Float, y:Float):Int;
	public function getFirstCharInParagraph (charIndex:Int):Int;
	public function getLineIndexAtPoint (x:Float, y:Float):Int;
	public function getLineIndexOfChar (charIndex:Int):Int;
	public function getLineLength (lineIndex:Int):Int;
	public function getLineMetrics (lineIndex:Int):TextLineMetrics;
	public function getLineOffset (lineIndex:Int):Int;
	public function getLineText (lineIndex:Int):String;
	public function getParagraphLength (charIndex:Int):Int;
	public function getTextFormat (beginIndex:Int = 0, endIndex:Int = 0):TextFormat;
	public function replaceSelectedText (value:String):Void;
	public function replaceText (beginIndex:Int, endIndex:Int, newText:String):Void;
	public function setSelection (beginIndex:Int, endIndex:Int):Void;
	public function setTextFormat (format:TextFormat, beginIndex:Int = 0, endIndex:Int = 0):Void;

	private function get_antiAliasType ():AntiAliasType;
	private function set_antiAliasType (value:AntiAliasType):AntiAliasType;
	private function get_autoSize ():TextFieldAutoSize;
	private function set_autoSize (value:TextFieldAutoSize):TextFieldAutoSize;
	private function get_background ():Bool;
	private function set_background (value:Bool):Bool;
	private function get_backgroundColor ():Int;
	private function set_backgroundColor (value:Int):Int;
	private function get_border ():Bool;
	private function set_border (value:Bool):Bool;
	private function get_borderColor ():Int;
	private function set_borderColor (value:Int):Int;
	private function get_bottomScrollV ():Int;
	private function get_caretIndex ():Int;
	private function get_defaultTextFormat ():TextFormat;
	private function set_defaultTextFormat (value:TextFormat):TextFormat;
	private function get_displayAsPassword ():Bool;
	private function set_displayAsPassword (value:Bool):Bool;
	private function get_embedFonts ():Bool;
	private function set_embedFonts (value:Bool):Bool;
	private function get_gridFitType ():GridFitType;
	private function set_gridFitType (value:GridFitType):GridFitType;
	private function get_htmlText ():String;
	private function set_htmlText (value:String):String;
	private function get_length ():Int;
	private function get_maxChars ():Int;
	private function set_maxChars (value:Int):Int;
	private function get_maxScrollH ():Int;
	private function get_maxScrollV ():Int;
	private function get_mouseWheelEnabled ():Bool;
	private function set_mouseWheelEnabled (value:Bool):Bool;
	private function get_multiline ():Bool;
	private function set_multiline (value:Bool):Bool;
	private function get_numLines ():Int;
	private function get_restrict ():String;
	private function set_restrict (value:String):String;
	private function get_scrollH ():Int;
	private function set_scrollH (value:Int):Int;
	private function get_scrollV ():Int;
	private function set_scrollV (value:Int):Int;
	private function get_selectable ():Bool;
	private function set_selectable (value:Bool):Bool;
	private function get_selectionBeginIndex ():Int;
	private function get_selectionEndIndex ():Int;
	private function get_sharpness ():Float;
	private function set_sharpness (value:Float):Float;
	private function get_text ():String;
	private function set_text (value:String):String;
	private function get_textColor ():Int;
	private function set_textColor (value:Int):Int;
	private function get_textWidth ():Float;
	private function get_textHeight ():Float;
	private function get_type ():TextFieldType;
	private function set_type (value:TextFieldType):TextFieldType;
	private function get_wordWrap ():Bool;
	private function set_wordWrap (value:Bool):Bool;


	// MovieClip Members
	public function addFrameScript( index:Int, method:Void->Void):Void;
	public function gotoAndPlay (frame:Dynamic, scene:String = null):Void;
	public function gotoAndStop (frame:Dynamic, scene:String = null):Void;
	public function nextFrame ():Void;
	public function play ():Void;
	public function prevFrame ():Void;
	public function stop ():Void;
	public function __enterFrame (deltaTime:Int):Void;
}
