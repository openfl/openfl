package openfl.display3D; #if (display || !flash)


import openfl.display.BitmapData;
import openfl.display3D.textures.CubeTexture;
import openfl.display3D.textures.RectangleTexture;
import openfl.display3D.textures.Texture;
import openfl.display3D.textures.TextureBase;
import openfl.display3D.textures.VideoTexture;
import openfl.events.EventDispatcher;
import openfl.geom.Matrix3D;
import openfl.geom.Rectangle;
import openfl.utils.ByteArray;
import openfl.Vector;

@:jsRequire("openfl/display3D/Context3D", "default")


@:final extern class Context3D extends EventDispatcher {
	
	
	public static var supportsVideoTexture (default, null):Bool;
	
	public var backBufferHeight (default, null):Int;
	public var backBufferWidth (default, null):Int;
	public var driverInfo (default, null):String;
	public var enableErrorChecking:Bool;
	public var maxBackBufferHeight:Int;
	public var maxBackBufferWidth:Int;
	public var profile (default, null):String;
	public var totalGPUMemory (default, null):Int;
	
	public function clear (red:Float = 0, green:Float = 0, blue:Float = 0, alpha:Float = 1, depth:Float = 1, stencil:UInt = 0, mask:UInt = 0xFFFFFFFF):Void;
	public function configureBackBuffer (width:Int, height:Int, antiAlias:Int, enableDepthAndStencil:Bool = true, wantsBestResolution:Bool = false, wantsBestResolutionOnBrowserZoom:Bool = false):Void;
	public function createCubeTexture (size:Int, format:Context3DTextureFormat, optimizeForRenderToTexture:Bool, streamingLevels:Int = 0):CubeTexture;
	public function createIndexBuffer (numIndices:Int, ?bufferUsage:Context3DBufferUsage):IndexBuffer3D;
	public function createProgram ():Program3D;
	public function createRectangleTexture (width:Int, height:Int, format:Context3DTextureFormat, optimizeForRenderToTexture:Bool):RectangleTexture;
	public function createTexture (width:Int, height:Int, format:Context3DTextureFormat, optimizeForRenderToTexture:Bool, streamingLevels:Int = 0):Texture;
	public function createVertexBuffer (numVertices:Int, data32PerVertex:Int, ?bufferUsage:Context3DBufferUsage):VertexBuffer3D;
	public function createVideoTexture ():VideoTexture;
	public function dispose (recreate:Bool = true):Void;
	public function drawToBitmapData (destination:BitmapData):Void;
	public function drawTriangles (indexBuffer:IndexBuffer3D, firstIndex:Int = 0, numTriangles:Int = -1):Void;
	public function present ():Void;
	public function setBlendFactors (sourceFactor:Context3DBlendFactor, destinationFactor:Context3DBlendFactor):Void;
	public function setColorMask (red:Bool, green:Bool, blue:Bool, alpha:Bool):Void;
	public function setCulling (triangleFaceToCull:Context3DTriangleFace):Void;
	public function setDepthTest (depthMask:Bool, passCompareMode:Context3DCompareMode):Void;
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash16) public function setFillMode (fillMode:flash.display3D.Context3DFillMode):Void;
	#end
	
	public function setProgram (program:Program3D):Void;
	public function setProgramConstantsFromByteArray (programType:Context3DProgramType, firstRegister:Int, numRegisters:Int, data:ByteArray, byteArrayOffset:UInt):Void;
	public function setProgramConstantsFromMatrix (programType:Context3DProgramType, firstRegister:Int, matrix:Matrix3D, transposedMatrix:Bool = false):Void;
	public function setProgramConstantsFromVector (programType:Context3DProgramType, firstRegister:Int, data:Vector<Float>, numRegisters:Int = -1):Void;
	public function setRenderToBackBuffer ():Void;
	public function setRenderToTexture (texture:TextureBase, enableDepthAndStencil:Bool = false, antiAlias:Int = 0, surfaceSelector:Int = 0, colorOutputIndex:Int = 0):Void;
	public function setSamplerStateAt (sampler:Int, wrap:Context3DWrapMode, filter:Context3DTextureFilter, mipfilter:Context3DMipFilter):Void;
	public function setScissorRectangle (rectangle:Rectangle):Void;
	public function setStencilActions (?triangleFace:Context3DTriangleFace, ?compareMode:Context3DCompareMode, ?actionOnBothPass:Context3DStencilAction, ?actionOnDepthFail:Context3DStencilAction, ?actionOnDepthPassStencilFail:Context3DStencilAction):Void;
	public function setStencilReferenceValue (referenceValue:UInt, readMask:UInt = 255, writeMask:UInt = 255):Void;
	public function setTextureAt (sampler:Int, texture:TextureBase):Void;
	public function setVertexBufferAt (index:Int, buffer:VertexBuffer3D, bufferOffset:Int = 0, ?format:Context3DVertexBufferFormat):Void;
	
	
}


#else
typedef Context3D = flash.display3D.Context3D;
#end