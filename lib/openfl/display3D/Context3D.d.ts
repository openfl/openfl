import CubeTexture from "./textures/CubeTexture";
import RectangleTexture from "./textures/RectangleTexture";
import Texture from "./textures/Texture";
import TextureBase from "./textures/TextureBase";
import VideoTexture from "./textures/VideoTexture";
import Context3DBlendFactor from "./Context3DBlendFactor";
import Context3DBufferUsage from "./Context3DBufferUsage";
import Context3DCompareMode from "./Context3DCompareMode";
import Context3DMipFilter from "./Context3DMipFilter";
import Context3DProgramType from "./Context3DProgramType";
import Context3DStencilAction from "./Context3DStencilAction";
import Context3DTextureFilter from "./Context3DTextureFilter";
import Context3DTextureFormat from "./Context3DTextureFormat";
import Context3DTriangleFace from "./Context3DTriangleFace";
import Context3DVertexBufferFormat from "./Context3DVertexBufferFormat";
import Context3DWrapMode from "./Context3DWrapMode";
import IndexBuffer3D from "./IndexBuffer3D";
import Program3D from "./Program3D";
import VertexBuffer3D from "./VertexBuffer3D";
import BitmapData from "./../display/BitmapData";
import EventDispatcher from "./../events/EventDispatcher";
import Matrix3D from "./../geom/Matrix3D";
import Rectangle from "./../geom/Rectangle";
import ByteArray from "./../utils/ByteArray";

type Vector<T> = any;


declare namespace openfl.display3D {
	
	
	/*@:final*/ export class Context3D extends EventDispatcher {
		
		
		public static readonly supportsVideoTexture:boolean;
		
		public readonly backBufferHeight:number;
		public readonly backBufferWidth:number;
		public readonly driverInfo:string;
		public enableErrorChecking:boolean;
		public maxBackBufferHeight:number;
		public maxBackBufferWidth:number;
		public readonly profile:string;
		public readonly totalGPUMemory:number;
		
		public clear (red?:number, green?:number, blue?:number, alpha?:number, depth?:number, stencil?:number, mask?:number):void;
		public configureBackBuffer (width:number, height:number, antiAlias:number, enableDepthAndStencil?:boolean, wantsBestResolution?:boolean, wantsBestResolutionOnBrowserZoom?:boolean):void;
		public createCubeTexture (size:number, format:Context3DTextureFormat, optimizeForRenderToTexture:boolean, streamingLevels?:number):CubeTexture;
		public createIndexBuffer (numIndices:number, bufferUsage?:Context3DBufferUsage):IndexBuffer3D;
		public createProgram ():Program3D;
		public createRectangleTexture (width:number, height:number, format:Context3DTextureFormat, optimizeForRenderToTexture:boolean):RectangleTexture;
		public createTexture (width:number, height:number, format:Context3DTextureFormat, optimizeForRenderToTexture:boolean, streamingLevels?:number):Texture;
		public createVertexBuffer (numVertices:number, data32PerVertex:number, bufferUsage?:Context3DBufferUsage):VertexBuffer3D;
		public createVideoTexture ():VideoTexture;
		public dispose (recreate?:boolean):void;
		public drawToBitmapData (destination:BitmapData):void;
		public drawTriangles (indexBuffer:IndexBuffer3D, firstIndex?:number, numTriangles?:number):void;
		public present ():void;
		public setBlendFactors (sourceFactor:Context3DBlendFactor, destinationFactor:Context3DBlendFactor):void;
		public setColorMask (red:boolean, green:boolean, blue:boolean, alpha:boolean):void;
		public setCulling (triangleFaceToCull:Context3DTriangleFace):void;
		public setDepthTest (depthMask:boolean, passCompareMode:Context3DCompareMode):void;
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash16) public setFillMode (fillMode:flash.display3D.Context3DFillMode):void;
		// #end
		
		public setProgram (program:Program3D):void;
		public setProgramConstantsFromByteArray (programType:Context3DProgramType, firstRegister:number, numRegisters:number, data:ByteArray, byteArrayOffset:number):void;
		public setProgramConstantsFromMatrix (programType:Context3DProgramType, firstRegister:number, matrix:Matrix3D, transposedMatrix?:boolean):void;
		public setProgramConstantsFromVector (programType:Context3DProgramType, firstRegister:number, data:Vector<number>, numRegisters?:number):void;
		public setRenderToBackBuffer ():void;
		public setRenderToTexture (texture:TextureBase, enableDepthAndStencil?:boolean, antiAlias?:number, surfaceSelector?:number, colorOutputIndex?:number):void;
		public setSamplerStateAt (sampler:number, wrap:Context3DWrapMode, filter:Context3DTextureFilter, mipfilter:Context3DMipFilter):void;
		public setScissorRectangle (rectangle:Rectangle):void;
		public setStencilActions (triangleFace?:Context3DTriangleFace, compareMode?:Context3DCompareMode, actionOnBothPass?:Context3DStencilAction, actionOnDepthFail?:Context3DStencilAction, actionOnDepthPassStencilFail?:Context3DStencilAction):void;
		public setStencilReferenceValue (referenceValue:number, readMask?:number, writeMask?:number):void;
		public setTextureAt (sampler:number, texture:TextureBase):void;
		public setVertexBufferAt (index:number, buffer:VertexBuffer3D, bufferOffset?:number, format?:Context3DVertexBufferFormat):void;
		
		
	}
	
	
}


export default openfl.display3D.Context3D;