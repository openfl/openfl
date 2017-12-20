
declare namespace openfl.display3D {

export class IndexBuffer3D {

	constructor(context3D:any, numIndices:any, bufferUsage:any);
	__context:any;
	__elementType:any;
	
	__memoryUsage:any;
	__numIndices:any;
	__tempInt16Array:any;
	__usage:any;
	dispose():any;
	uploadFromByteArray(data:any, byteArrayOffset:any, startOffset:any, count:any):any;
	uploadFromTypedArray(data:any, byteLength?:any):any;
	uploadFromVector(data:any, startOffset:any, count:any):any;


}

}

export default openfl.display3D.IndexBuffer3D;