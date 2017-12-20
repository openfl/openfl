
declare namespace openfl.geom {

export class Matrix3D {

	constructor(v?:any);
	determinant:any;
	position:any;
	rawData:any;
	append(lhs:any):any;
	appendRotation(degrees:any, axis:any, pivotPoint?:any):any;
	appendScale(xScale:any, yScale:any, zScale:any):any;
	appendTranslation(x:any, y:any, z:any):any;
	clone():any;
	copyColumnFrom(column:any, vector3D:any):any;
	copyColumnTo(column:any, vector3D:any):any;
	copyFrom(other:any):any;
	copyRawDataFrom(vector:any, index?:any, transpose?:any):any;
	copyRawDataTo(vector:any, index?:any, transpose?:any):any;
	copyRowFrom(row:any, vector3D:any):any;
	copyRowTo(row:any, vector3D:any):any;
	copyToMatrix3D(other:any):any;
	decompose(orientationStyle?:any):any;
	deltaTransformVector(v:any):any;
	identity():any;
	interpolateTo(toMat:any, percent:any):any;
	invert():any;
	pointAt(pos:any, at?:any, up?:any):any;
	prepend(rhs:any):any;
	prependRotation(degrees:any, axis:any, pivotPoint?:any):any;
	prependScale(xScale:any, yScale:any, zScale:any):any;
	prependTranslation(x:any, y:any, z:any):any;
	recompose(components:any, orientationStyle?:any):any;
	transformVector(v:any):any;
	transformVectors(vin:any, vout:any):any;
	transpose():any;
	get_determinant():any;
	get_position():any;
	set_position(val:any):any;
	static create2D(x:any, y:any, scale?:any, rotation?:any):any;
	static createABCD(a:any, b:any, c:any, d:any, tx:any, ty:any):any;
	static createOrtho(x0:any, x1:any, y0:any, y1:any, zNear:any, zFar:any):any;
	static interpolate(thisMat:any, toMat:any, percent:any):any;
	static __getAxisRotation(x:any, y:any, z:any, degrees:any):any;


}

}

export default openfl.geom.Matrix3D;