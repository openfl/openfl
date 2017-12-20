
declare namespace openfl.display3D {

export class VertexBuffer3D {

	constructor(context3D:any, numVertices:any, dataPerVertex:any, bufferUsage:any);
	__context:any;
	__data:any;
	
	__memoryUsage:any;
	__numVertices:any;
	__stride:any;
	__tempFloat32Array:any;
	__usage:any;
	__vertexSize:any;
	dispose():any;
	uploadFromByteArray(data:any, byteArrayOffset:any, startVertex:any, numVertices:any):any;
	uploadFromTypedArray(data:any, byteLength?:any):any;
	uploadFromVector(data:any, startVertex:any, numVertices:any):any;


}

}

export default openfl.display3D.VertexBuffer3D;