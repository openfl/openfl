
declare namespace openfl.display3D {

export class Program3D {

	constructor(context3D:any);
	__alphaSamplerUniforms:any;
	__context:any;
	
	__fragmentSource:any;
	__fragmentUniformMap:any;
	__memUsage:any;
	__positionScale:any;
	
	__samplerStates:any;
	__samplerUniforms:any;
	__samplerUsageMask:any;
	__uniforms:any;
	
	__vertexSource:any;
	__vertexUniformMap:any;
	dispose():any;
	upload(vertexProgram:any, fragmentProgram:any):any;
	__flush():any;
	__getSamplerState(sampler:any):any;
	__markDirty(isVertex:any, index:any, count:any):any;
	__setPositionScale(positionScale:any):any;
	__setSamplerState(sampler:any, state:any):any;
	__use():any;


}

}

export default openfl.display3D.Program3D;