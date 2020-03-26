namespace openfl._internal.backend.dummy;

import Context3D from "openfl/display3D/Context3D";
import openfl.display3D.Context3DClearMask;
import openfl.display3D.IndexBuffer3D;
import openfl.display.BitmapData;
import Point from "openfl/geom/Point";
import Rectangle from "openfl/geom/Rectangle";

#if!openfl_debug
@: fileXml('tags="haxe,release"')
@: noDebug
#end
class DummyContext3DBackend
{
	public new(parent: Context3D) { }

	public clear(red: number = 0, green: number = 0, blue: number = 0, alpha: number = 1, depth: number = 1, stencil: number = 0,
		mask: number = Context3DClearMask.ALL): void { }

	public configureBackBuffer(width: number, height: number, antiAlias: number, enableDepthAndStencil: boolean = true, wantsBestResolution: boolean = false,
		wantsBestResolutionOnBrowserZoom: boolean = false): void { }

	public dispose(recreate: boolean = true): void { }

	public drawToBitmapData(destination: BitmapData, srcRect: Rectangle = null, destPoint: Point = null): void { }

	public drawTriangles(indexBuffer: IndexBuffer3D, firstIndex: number = 0, numTriangles: number = -1): void { }

	public present(): void { }

	public getTotalGPUMemory(): number
	{
		return 0;
	}
}
