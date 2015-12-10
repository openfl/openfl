package flash.display;


import openfl.display.IBitmapDrawable;
import openfl.events.EventDispatcher;
import openfl.filters.BitmapFilter;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.geom.Transform;
import openfl.geom.Vector3D;


@:noCompletion extern class DisplayObject extends EventDispatcher implements IBitmapDrawable implements #if flash Dynamic #else Dynamic<DisplayObject> #end {
	
	
	#if flash
	@:noCompletion @:dox(hide) public var accessibilityProperties:flash.accessibility.AccessibilityProperties;
	#end
	
	#if (flash && !display)
	public var alpha:Float;
	#else
	public var alpha (get, set):Float;
	#end
	
	#if (flash && !display)
	public var blendMode:BlendMode;
	#else
	public var blendMode (default, set):BlendMode;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10) public var blendShader (null, default):Shader;
	#end
	
	#if (flash && !display)
	public var cacheAsBitmap:Bool;
	#else
	public var cacheAsBitmap (get, set):Bool;
	#end
	
	#if (flash && !display)
	public var filters:Array<BitmapFilter>;
	#else
	public var filters (get, set):Array<BitmapFilter>;
	#end
	
	#if (flash && !display)
	public var height:Float;
	#else
	public var height (get, set):Float;
	#end
	
	public var loaderInfo (default, null):LoaderInfo;
	
	#if (flash && !display)
	public var mask:DisplayObject;
	#else
	public var mask (get, set):DisplayObject;
	#end
	
	#if (flash && !display)
	public var mouseX (default, null):Float;
	#else
	public var mouseX (get, null):Float;
	#end
	
	#if (flash && !display)
	public var mouseY (default, null):Float;
	#else
	public var mouseY (get, null):Float;
	#end
	
	#if (flash && !display)
	public var name:String;
	#else
	public var name (get, set):String;
	#end
	
	public var opaqueBackground:Null<UInt>;
	
	public var parent (default, null):DisplayObjectContainer;
	
	#if (flash && !display)
	public var root (default, null):DisplayObject;
	#else
	public var root (get, null):DisplayObject;
	#end
	
	#if (flash && !display)
	public var rotation:Float;
	#else
	public var rotation (get, set):Float;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10) public var rotationX:Float;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10) public var rotationY:Float;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10) public var rotationZ:Float;
	#end
	
	public var scale9Grid:Rectangle;
	
	#if (flash && !display)
	public var scaleX:Float;
	#else
	public var scaleX (get, set):Float;
	#end
	
	#if (flash && !display)
	public var scaleY:Float;
	#else
	public var scaleY (get, set):Float;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10) public var scaleZ:Float;
	#end
	
	#if (flash && !display)
	public var scrollRect:Rectangle;
	#else
	public var scrollRect (get, set):Rectangle;
	#end
	
	public var stage (default, null):Stage;
	
	#if (flash && !display)
	public var transform:Transform;
	#else
	public var transform (get, set):Transform;
	#end
	
	#if (flash && !display)
	public var visible:Bool;
	#else
	public var visible (get, set):Bool;
	#end
	
	#if (flash && !display)
	public var width:Float;
	#else
	public var width (get, set):Float;
	#end
	
	#if (flash && !display)
	public var x:Float;
	#else
	public var x (get, set):Float;
	#end
	
	#if (flash && !display)
	public var y:Float;
	#else
	public var y (get, set):Float;
	#end
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10) var z:Float;
	#end
	
	public function getBounds (targetCoordinateSpace:DisplayObject):Rectangle;
	public function getRect (targetCoordinateSpace:DisplayObject):Rectangle;
	public function globalToLocal (pos:Point):Point;
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10) public function globalToLocal3D (point:Point):Vector3D;
	#end
	
	public function hitTestObject (obj:DisplayObject):Bool;
	public function hitTestPoint (x:Float, y:Float, shapeFlag:Bool = false):Bool;
	public function localToGlobal (point:Point):Point;
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10) public function local3DToGlobal (point3d:Vector3D):Point;
	#end
	
	
}