
declare namespace openfl.display {

export class Shader {

	constructor(code?:any);
	byteCode:any;
	data:any;
	glFragmentSource:any;
	
	glVertexSource:any;
	precisionHint:any;
	
	__data:any;
	__glFragmentSource:any;
	__glSourceDirty:any;
	__glVertexSource:any;
	__isUniform:any;
	__inputBitmapData:any;
	__numPasses:any;
	__paramBool:any;
	__paramFloat:any;
	__paramInt:any;
	__uniformMatrix2:any;
	__uniformMatrix3:any;
	__uniformMatrix4:any;
	__disable():any;
	__disableGL():any;
	__enable():any;
	__enableGL():any;
	__init():any;
	__initGL():any;
	__processGLData(source:any, storageType:any):any;
	__update():any;
	__updateGL():any;
	get_data():any;
	set_data(value:any):any;
	get_glFragmentSource():any;
	set_glFragmentSource(value:any):any;
	get_glVertexSource():any;
	set_glVertexSource(value:any):any;


}

}

export default openfl.display.Shader;