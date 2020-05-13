package openfl.media;

import openfl.display.DisplayObject;
import openfl.display._DisplayObject;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom._Point;
import openfl.geom.Rectangle;
import openfl.geom._Rectangle;
import openfl.net.NetStream;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.geom.Matrix)
@:access(openfl.geom.Point)
@:access(openfl.geom.Rectangle)
@:access(openfl.net.NetStream)
@:noCompletion
class _Video extends _DisplayObject
{
	public var deblocking:Int;
	public var smoothing:Bool;
	public var videoHeight(get, never):Int;
	public var videoWidth(get, never):Int;

	public var __active:Bool;
	public var __dirty:Bool;
	public var __height:Float;
	public var __stream:NetStream;
	public var __width:Float;

	public function new(width:Int = 320, height:Int = 240):Void
	{
		super();

		__type = VIDEO;

		__width = width;
		__height = height;

		__renderData.textureTime = -1;

		smoothing = false;
		deblocking = 0;
	}

	public function attachNetStream(netStream:NetStream):Void
	{
		__stream = netStream;

		#if openfl_html5
		if (__stream != null && !__stream._.__closed)
		{
			// @:privateAccess __stream._.__getVideoElement().play();
			__stream.resume();
		}
		#end
	}

	public function clear():Void {}

	public override function __getBounds(rect:Rectangle, matrix:Matrix):Void
	{
		var bounds = _Rectangle.__pool.get();
		bounds.setTo(0, 0, __width, __height);
		bounds._.__transform(bounds, matrix);

		rect._.__expand(bounds.x, bounds.y, bounds.width, bounds.height);

		_Rectangle.__pool.release(bounds);
	}

	public override function __hitTest(x:Float, y:Float, shapeFlag:Bool, stack:Array<DisplayObject>, interactiveOnly:Bool, hitObject:DisplayObject):Bool
	{
		if (!hitObject.visible || __isMask) return false;
		if (mask != null && !mask._.__hitTestMask(x, y)) return false;

		__getRenderTransform();

		var px = __renderTransform._.__transformInverseX(x, y);
		var py = __renderTransform._.__transformInverseY(x, y);

		if (px > 0 && py > 0 && px <= __width && py <= __height)
		{
			if (stack != null && !interactiveOnly)
			{
				stack.push(hitObject);
			}

			return true;
		}

		return false;
	}

	public override function __hitTestMask(x:Float, y:Float):Bool
	{
		var point = _Point.__pool.get();
		point.setTo(x, y);

		__globalToLocal(point, point);

		var hit = (point.x > 0 && point.y > 0 && point.x <= __width && point.y <= __height);

		_Point.__pool.release(point);
		return hit;
	}

	// Get & Set Methods

	public override function get_height():Float
	{
		return __height * scaleY;
	}

	public override function set_height(value:Float):Float
	{
		if (scaleY != 1 || value != __height)
		{
			__setTransformDirty();
			__setParentRenderDirty();
			__dirty = true;
		}

		scaleY = 1;
		return __height = value;
	}

	private function get_videoHeight():Int
	{
		#if openfl_html5
		if (__stream != null)
		{
			var videoElement = __stream._.__getVideoElement();
			if (videoElement != null)
			{
				return Std.int(videoElement.videoHeight);
			}
		}
		#end

		return 0;
	}

	private function get_videoWidth():Int
	{
		#if openfl_html5
		if (__stream != null)
		{
			var videoElement = __stream._.__getVideoElement();
			if (videoElement != null)
			{
				return Std.int(videoElement.videoWidth);
			}
		}
		#end

		return 0;
	}

	public override function get_width():Float
	{
		return __width * __scaleX;
	}

	public override function set_width(value:Float):Float
	{
		if (__scaleX != 1 || __width != value)
		{
			__setTransformDirty();
			__setParentRenderDirty();
			__dirty = true;
		}

		scaleX = 1;
		return __width = value;
	}
}
