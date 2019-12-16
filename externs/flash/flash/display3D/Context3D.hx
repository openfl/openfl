package flash.display3D;

#if flash
import openfl.display.BitmapData;
import openfl.display3D.textures.CubeTexture;
import openfl.display3D.textures.RectangleTexture;
import openfl.display3D.textures.Texture;
import openfl.display3D.textures.TextureBase;
import openfl.display3D.textures.VideoTexture;
import openfl.display3D.Context3DProgramFormat;
import openfl.events.EventDispatcher;
import openfl.geom.Matrix3D;
import openfl.geom.Rectangle;
import openfl.utils.ByteArray;
import openfl.Vector;

@:final extern class Context3D extends EventDispatcher
{
	@:require(flash15) public static var supportsVideoTexture(default, never):Bool;
	@:require(flash15) public var backBufferHeight(default, never):Int;
	@:require(flash15) public var backBufferWidth(default, never):Int;
	public var driverInfo(default, never):String;
	public var enableErrorChecking:Bool;
	@:require(flash15) public var maxBackBufferHeight:Int;
	@:require(flash15) public var maxBackBufferWidth:Int;
	@:require(flash12) public var profile(default, never):String;
	public function clear(red:Float = 0, green:Float = 0, blue:Float = 0, alpha:Float = 1, depth:Float = 1, stencil:UInt = 0, mask:UInt = 0xFFFFFFFF):Void;
	public function configureBackBuffer(width:Int, height:Int, antiAlias:Int, enableDepthAndStencil:Bool = true, wantsBestResolution:Bool = false,
		wantsBestResolutionOnBrowserZoom:Bool = false):Void;
	public function createCubeTexture(size:Int, format:Context3DTextureFormat, optimizeForRenderToTexture:Bool, streamingLevels:Int = 0):CubeTexture;
	public function createIndexBuffer(numIndices:Int, ?bufferUsage:Context3DBufferUsage):IndexBuffer3D;
	@:native("createProgram") @:noCompletion private function __createProgram():Program3D;
	public inline function createProgram(format:Context3DProgramFormat = AGAL):Program3D
	{
		if (format != AGAL) throw new openfl.errors.IllegalOperationError("Invalid program format: " + format);
		return this.__createProgram();
	}
	#if flash
	@:require(flash11_8)
	#end
	public function createRectangleTexture(width:Int, height:Int, format:Context3DTextureFormat, optimizeForRenderToTexture:Bool):RectangleTexture;
	public function createTexture(width:Int, height:Int, format:Context3DTextureFormat, optimizeForRenderToTexture:Bool, streamingLevels:Int = 0):Texture;
	public function createVertexBuffer(numVertices:Int, data32PerVertex:Int, ?bufferUsage:Context3DBufferUsage):VertexBuffer3D;
	@:require(flash15) public function createVideoTexture():VideoTexture;
	public function dispose(recreate:Bool = true):Void;
	public function drawToBitmapData(destination:BitmapData):Void;
	public function drawTriangles(indexBuffer:IndexBuffer3D, firstIndex:Int = 0, numTriangles:Int = -1):Void;
	public function present():Void;
	public function setBlendFactors(sourceFactor:Context3DBlendFactor, destinationFactor:Context3DBlendFactor):Void;
	public function setColorMask(red:Bool, green:Bool, blue:Bool, alpha:Bool):Void;
	public function setCulling(triangleFaceToCull:Context3DTriangleFace):Void;
	public function setDepthTest(depthMask:Bool, passCompareMode:Context3DCompareMode):Void;
	#if air
	@:require(flash16) public function setFillMode(fillMode:flash.display3D.Context3DFillMode):Void;
	#end
	public function setProgram(program:Program3D):Void;
	#if flash
	@:require(flash11_2)
	#end
	public function setProgramConstantsFromByteArray(programType:Context3DProgramType, firstRegister:Int, numRegisters:Int, data:ByteArray,
		byteArrayOffset:UInt):Void;
	public function setProgramConstantsFromMatrix(programType:Context3DProgramType, firstRegister:Int, matrix:Matrix3D, transposedMatrix:Bool = false):Void;
	public function setProgramConstantsFromVector(programType:Context3DProgramType, firstRegister:Int, data:Vector<Float>, numRegisters:Int = -1):Void;
	public function setRenderToBackBuffer():Void;
	public function setRenderToTexture(texture:TextureBase, enableDepthAndStencil:Bool = false, antiAlias:Int = 0, surfaceSelector:Int = 0,
		colorOutputIndex:Int = 0):Void;
	#if flash
	@:require(flash11_6)
	#end
	public function setSamplerStateAt(sampler:Int, wrap:Context3DWrapMode, filter:Context3DTextureFilter, mipfilter:Context3DMipFilter):Void;
	public function setScissorRectangle(rectangle:Rectangle):Void;
	public function setStencilActions(?triangleFace:Context3DTriangleFace, ?compareMode:Context3DCompareMode, ?actionOnBothPass:Context3DStencilAction,
		?actionOnDepthFail:Context3DStencilAction, ?actionOnDepthPassStencilFail:Context3DStencilAction):Void;
	public function setStencilReferenceValue(referenceValue:UInt, readMask:UInt = 255, writeMask:UInt = 255):Void;
	public function setTextureAt(sampler:Int, texture:TextureBase):Void;
	public function setVertexBufferAt(index:Int, buffer:VertexBuffer3D, bufferOffset:Int = 0, ?format:Context3DVertexBufferFormat):Void;
}
#else
typedef Context3D = openfl.display3D.Context3D;
#end
