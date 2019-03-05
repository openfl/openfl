package flash.display;

#if flash
import openfl.events.EventDispatcher;
import openfl.filters.BitmapFilter;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.geom.Transform;
import openfl.geom.Vector3D;

extern class DisplayObject extends EventDispatcher implements IBitmapDrawable
{
	#if flash
	public var accessibilityProperties:flash.accessibility.AccessibilityProperties;
	#end
	public var alpha:Float;
	public var blendMode:BlendMode;
	#if flash
	@:require(flash10) public var blendShader(null, never):Shader;
	#end
	public var cacheAsBitmap:Bool;
	#if (air || !flash)
	public var cacheAsBitmapMatrix:Matrix;
	#else
	public var cacheAsBitmapMatrix(get, set):Matrix;
	@:noCompletion private inline function get_cacheAsBitmapMatrix():Matrix
	{
		return transform.concatenatedMatrix;
	}
	@:noCompletion private inline function set_cacheAsBitmapMatrix(value:Matrix):Matrix
	{
		return value;
	}
	#end
	public var filters:Array<BitmapFilter>;
	public var height:Float;
	public var loaderInfo(default, never):LoaderInfo;
	public var mask:DisplayObject;
	public var mouseX(default, never):Float;
	public var mouseY(default, never):Float;
	public var name:String;
	public var opaqueBackground:Null<UInt>;
	public var parent(default, never):DisplayObjectContainer;
	public var root(default, never):DisplayObject;
	public var rotation:Float;
	#if flash
	@:require(flash10) public var rotationX:Float;
	#end
	#if flash
	@:require(flash10) public var rotationY:Float;
	#end
	#if flash
	@:require(flash10) public var rotationZ:Float;
	#end
	public var scale9Grid:Rectangle;
	public var scaleX:Float;
	public var scaleY:Float;
	#if flash
	@:require(flash10) public var scaleZ:Float;
	#end
	public var scrollRect:Rectangle;
	public var stage(default, never):Stage;
	public var transform:Transform;
	public var visible:Bool;
	public var width:Float;
	public var x:Float;
	public var y:Float;
	#if flash
	@:require(flash10) var z:Float;
	#end
	public function getBounds(targetCoordinateSpace:DisplayObject):Rectangle;
	public function getRect(targetCoordinateSpace:DisplayObject):Rectangle;
	public function globalToLocal(pos:Point):Point;
	#if flash
	@:require(flash10) public function globalToLocal3D(point:Point):Vector3D;
	#end
	public function hitTestObject(obj:DisplayObject):Bool;
	public function hitTestPoint(x:Float, y:Float, shapeFlag:Bool = false):Bool;
	public function localToGlobal(point:Point):Point;
	#if flash
	@:require(flash10) public function local3DToGlobal(point3d:Vector3D):Point;
	#end
}
#else
typedef DisplayObject = openfl.display.DisplayObject;
#end
