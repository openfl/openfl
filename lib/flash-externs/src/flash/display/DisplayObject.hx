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
	#if (haxe_ver < 4.3)
	public var accessibilityProperties:flash.accessibility.AccessibilityProperties;
	public var alpha:Float;
	public var blendMode:BlendMode;
	@:require(flash10) public var blendShader(never, default):Shader;
	public var cacheAsBitmap:Bool;
	#if air
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
	@:require(flash10) public var rotationX:Float;
	@:require(flash10) public var rotationY:Float;
	@:require(flash10) public var rotationZ:Float;
	public var scale9Grid:Rectangle;
	public var scaleX:Float;
	public var scaleY:Float;
	@:require(flash10) public var scaleZ:Float;
	public var scrollRect:Rectangle;
	public var shader(get, set):Shader;
	@:noCompletion private inline function get_shader():Shader
	{
		return null;
	}
	@:noCompletion private inline function set_shader(value:Shader):Shader
	{
		return null;
	}
	public var stage(default, never):Stage;
	public var transform:Transform;
	public var visible:Bool;
	public var width:Float;
	public var x:Float;
	public var y:Float;
	@:require(flash10) var z:Float;
	#else
	@:flash.property var accessibilityProperties(get, set):flash.accessibility.AccessibilityProperties;
	@:flash.property var alpha(get, set):Float;
	@:flash.property var blendMode(get, set):BlendMode;
	@:flash.property @:require(flash10) var blendShader(never, set):Shader;
	@:flash.property var cacheAsBitmap(get, set):Bool;
	@:flash.property var cacheAsBitmapMatrix(get, set):Matrix;
	#if !air
	@:noCompletion private inline function get_cacheAsBitmapMatrix():Matrix
	{
		return transform.concatenatedMatrix;
	}
	@:noCompletion private inline function set_cacheAsBitmapMatrix(value:Matrix):Matrix
	{
		return value;
	}
	#end
	@:flash.property var filters(get, set):Array<BitmapFilter>;
	@:flash.property var height(get, set):Float;
	@:flash.property var loaderInfo(get, never):LoaderInfo;
	@:flash.property var mask(get, set):DisplayObject;
	@:flash.property var mouseX(get, never):Float;
	@:flash.property var mouseY(get, never):Float;
	@:flash.property var name(get, set):String;
	@:flash.property var opaqueBackground(get, set):Null<UInt>;
	@:flash.property var parent(get, never):DisplayObjectContainer;
	@:flash.property var root(get, never):DisplayObject;
	@:flash.property var rotation(get, set):Float;
	@:flash.property @:require(flash10) var rotationX(get, set):Float;
	@:flash.property @:require(flash10) var rotationY(get, set):Float;
	@:flash.property @:require(flash10) var rotationZ(get, set):Float;
	@:flash.property var scale9Grid(get, set):Rectangle;
	@:flash.property var scaleX(get, set):Float;
	@:flash.property var scaleY(get, set):Float;
	@:flash.property @:require(flash10) var scaleZ(get, set):Float;
	@:flash.property var scrollRect(get, set):Rectangle;
	@:flash.property public var shader(get, set):Shader;
	@:noCompletion private inline function get_shader():Shader
	{
		return null;
	}
	@:noCompletion private inline function set_shader(value:Shader):Shader
	{
		return null;
	}
	@:flash.property var stage(get, never):Stage;
	@:flash.property var transform(get, set):Transform;
	@:flash.property var visible(get, set):Bool;
	@:flash.property var width(get, set):Float;
	@:flash.property var x(get, set):Float;
	@:flash.property var y(get, set):Float;
	@:flash.property @:require(flash10) var z(get, set):Float;
	#end

	public function getBounds(targetCoordinateSpace:DisplayObject):Rectangle;
	public function getRect(targetCoordinateSpace:DisplayObject):Rectangle;
	public function globalToLocal(pos:Point):Point;
	@:require(flash10) public function globalToLocal3D(point:Point):Vector3D;
	public function hitTestObject(obj:DisplayObject):Bool;
	public function hitTestPoint(x:Float, y:Float, shapeFlag:Bool = false):Bool;
	public inline function invalidate():Void
	{
		if (#if (haxe_ver >= 4.2) Std.isOfType #else Std.is #end (this, Stage))
		{
			var method = Reflect.field(this, "invalidate");
			Reflect.callMethod(method, method, []);
		}
	}
	public function localToGlobal(point:Point):Point;
	@:require(flash10) public function local3DToGlobal(point3d:Vector3D):Point;

	#if (haxe_ver >= 4.3)
	private function get_accessibilityProperties():flash.accessibility.AccessibilityProperties;
	private function get_alpha():Float;
	private function get_blendMode():BlendMode;
	private function get_cacheAsBitmap():Bool;
	private function get_filters():Array<BitmapFilter>;
	private function get_height():Float;
	private function get_loaderInfo():LoaderInfo;
	private function get_mask():DisplayObject;
	private function get_metaData():Dynamic;
	private function get_mouseX():Float;
	private function get_mouseY():Float;
	private function get_name():String;
	private function get_opaqueBackground():Null<UInt>;
	private function get_parent():DisplayObjectContainer;
	private function get_root():DisplayObject;
	private function get_rotation():Float;
	private function get_rotationX():Float;
	private function get_rotationY():Float;
	private function get_rotationZ():Float;
	private function get_scale9Grid():Rectangle;
	private function get_scaleX():Float;
	private function get_scaleY():Float;
	private function get_scaleZ():Float;
	private function get_scrollRect():Rectangle;
	private function get_stage():Stage;
	private function get_transform():Transform;
	private function get_visible():Bool;
	private function get_width():Float;
	private function get_x():Float;
	private function get_y():Float;
	private function get_z():Float;
	#if air
	private function get_cacheAsBitmapMatrix():Matrix;
	#end
	private function set_accessibilityProperties(value:flash.accessibility.AccessibilityProperties):flash.accessibility.AccessibilityProperties;
	private function set_alpha(value:Float):Float;
	private function set_blendMode(value:BlendMode):BlendMode;
	private function set_blendShader(value:Shader):Shader;
	private function set_cacheAsBitmap(value:Bool):Bool;
	private function set_filters(value:Array<BitmapFilter>):Array<BitmapFilter>;
	private function set_height(value:Float):Float;
	private function set_mask(value:DisplayObject):DisplayObject;
	private function set_metaData(value:Dynamic):Dynamic;
	private function set_name(value:String):String;
	private function set_opaqueBackground(value:Null<UInt>):Null<UInt>;
	private function set_rotation(value:Float):Float;
	private function set_rotationX(value:Float):Float;
	private function set_rotationY(value:Float):Float;
	private function set_rotationZ(value:Float):Float;
	private function set_scale9Grid(value:Rectangle):Rectangle;
	private function set_scaleX(value:Float):Float;
	private function set_scaleY(value:Float):Float;
	private function set_scaleZ(value:Float):Float;
	private function set_scrollRect(value:Rectangle):Rectangle;
	private function set_transform(value:Transform):Transform;
	private function set_visible(value:Bool):Bool;
	private function set_width(value:Float):Float;
	private function set_x(value:Float):Float;
	private function set_y(value:Float):Float;
	private function set_z(value:Float):Float;
	#if air
	private function set_cacheAsBitmapMatrix(value:Matrix):Matrix;
	#end
	#end
}
#else
typedef DisplayObject = openfl.display.DisplayObject;
#end
