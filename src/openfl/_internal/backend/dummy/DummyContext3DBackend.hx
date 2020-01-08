package openfl._internal.backend.dummy;

import openfl.display3D.Context3D;
import openfl.display3D.Context3DClearMask;
import openfl.display3D.IndexBuffer3D;
import openfl.display.BitmapData;
import openfl.geom.Point;
import openfl.geom.Rectangle;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class DummyContext3DBackend
{
	public function new(parent:Context3D) {}

	public function clear(red:Float = 0, green:Float = 0, blue:Float = 0, alpha:Float = 1, depth:Float = 1, stencil:UInt = 0,
		mask:UInt = Context3DClearMask.ALL):Void {}

	public function configureBackBuffer(width:Int, height:Int, antiAlias:Int, enableDepthAndStencil:Bool = true, wantsBestResolution:Bool = false,
		wantsBestResolutionOnBrowserZoom:Bool = false):Void {}

	public function dispose(recreate:Bool = true):Void {}

	public function drawToBitmapData(destination:BitmapData, srcRect:Rectangle = null, destPoint:Point = null):Void {}

	public function drawTriangles(indexBuffer:IndexBuffer3D, firstIndex:Int = 0, numTriangles:Int = -1):Void {}

	public function present():Void {}

	public function getTotalGPUMemory():Int
	{
		return 0;
	}
}
