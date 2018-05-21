package openfl.display3D {
	
	
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
	// import openfl.Vector;
	
	
	/**
	 * @externs
	 */
	final public class Context3D extends EventDispatcher {
		
		
		public static function get supportsVideoTexture ():Boolean { return false; }
		
		public function get backBufferHeight ():int { return 0; }
		public function get backBufferWidth ():int { return 0; }
		public function get driverInfo ():String { return null; }
		public var enableErrorChecking:Boolean;
		public var maxBackBufferHeight:int;
		public var maxBackBufferWidth:int;
		public function get profile ():String { return null; }
		public function get totalGPUMemory ():int { return 0; }
		
		public function clear (red:Number = 0, green:Number = 0, blue:Number = 0, alpha:Number = 1, depth:Number = 1, stencil:uint = 0, mask:uint = 0xFFFFFFFF):void {}
		public function configureBackBuffer (width:int, height:int, antiAlias:int, enableDepthAndStencil:Boolean = true, wantsBestResolution:Boolean = false, wantsBestResolutionOnBrowserZoom:Boolean = false):void {}
		public function createCubeTexture (size:int, format:String, optimizeForRenderToTexture:Boolean, streamingLevels:int = 0):CubeTexture { return null; }
		public function createIndexBuffer (numIndices:int, bufferUsage:String = null):IndexBuffer3D { return null; }
		public function createProgram ():Program3D { return null; }
		public function createRectangleTexture (width:int, height:int, format:String, optimizeForRenderToTexture:Boolean):RectangleTexture { return null; }
		public function createTexture (width:int, height:int, format:String, optimizeForRenderToTexture:Boolean, streamingLevels:int = 0):Texture { return null; }
		public function createVertexBuffer (numVertices:int, data32PerVertex:int, bufferUsage:String = null):VertexBuffer3D { return null; }
		public function createVideoTexture ():VideoTexture { return null; }
		public function dispose (recreate:Boolean = true):void {}
		public function drawToBitmapData (destination:BitmapData):void {}
		public function drawTriangles (indexBuffer:IndexBuffer3D, firstIndex:int = 0, numTriangles:int = -1):void {}
		public function present ():void {}
		public function setBlendFactors (sourceFactor:String, destinationFactor:String):void {}
		public function setColorMask (red:Boolean, green:Boolean, blue:Boolean, alpha:Boolean):void {}
		public function setCulling (triangleFaceToCull:String):void {}
		public function setDepthTest (depthMask:Boolean, passCompareMode:String):void {}
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash16) public function setFillMode (fillMode:flash.display3D.Context3DFillMode):void {}
		// #end
		
		public function setProgram (program:Program3D):void {}
		public function setProgramConstantsFromByteArray (programType:String, firstRegister:int, numRegisters:int, data:ByteArray, byteArrayOffset:uint):void {}
		public function setProgramConstantsFromMatrix (programType:String, firstRegister:int, matrix:Matrix3D, transposedMatrix:Boolean = false):void {}
		public function setProgramConstantsFromVector (programType:String, firstRegister:int, data:Vector.<Number>, numRegisters:int = -1):void {}
		public function setRenderToBackBuffer ():void {}
		public function setRenderToTexture (texture:TextureBase, enableDepthAndStencil:Boolean = false, antiAlias:int = 0, surfaceSelector:int = 0, colorOutputIndex:int = 0):void {}
		public function setSamplerStateAt (sampler:int, wrap:String, filter:String, mipfilter:String):void {}
		public function setScissorRectangle (rectangle:Rectangle):void {}
		public function setStencilActions (triangleFace:String = null, compareMode:String = null, actionOnBothPass:String = null, actionOnDepthFail:String = null, actionOnDepthPassStencilFail:String = null):void {}
		public function setStencilReferenceValue (referenceValue:uint, readMask:uint = 255, writeMask:uint = 255):void {}
		public function setTextureAt (sampler:int, texture:TextureBase):void {}
		public function setVertexBufferAt (index:int, buffer:VertexBuffer3D, bufferOffset:int = 0, format:String = null):void {}
		
		
	}
	
	
}