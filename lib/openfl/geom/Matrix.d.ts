
declare namespace openfl.geom {

export class Matrix {

	constructor(a?:any, b?:any, c?:any, d?:any, tx?:any, ty?:any);
	a:any;
	b:any;
	c:any;
	d:any;
	tx:any;
	ty:any;
	__array:any;
	clone():any;
	concat(m:any):any;
	copyColumnFrom(column:any, vector3D:any):any;
	copyColumnTo(column:any, vector3D:any):any;
	copyFrom(sourceMatrix:any):any;
	copyRowFrom(row:any, vector3D:any):any;
	copyRowTo(row:any, vector3D:any):any;
	createBox(scaleX:any, scaleY:any, rotation?:any, tx?:any, ty?:any):any;
	createGradientBox(width:any, height:any, rotation?:any, tx?:any, ty?:any):any;
	deltaTransformPoint(point:any):any;
	equals(matrix:any):any;
	identity():any;
	invert():any;
	rotate(theta:any):any;
	scale(sx:any, sy:any):any;
	setRotation(theta:any, scale?:any):any;
	setTo(a:any, b:any, c:any, d:any, tx:any, ty:any):any;
	to3DString(roundPixels?:any):any;
	toMozString():any;
	toString():any;
	transformPoint(pos:any):any;
	translate(dx:any, dy:any):any;
	toArray(transpose?:any):any;
	__cleanValues():any;
	__toMatrix3():any;
	__transformInversePoint(point:any):any;
	__transformInverseX(px:any, py:any):any;
	__transformInverseY(px:any, py:any):any;
	__transformPoint(point:any):any;
	__transformX(px:any, py:any):any;
	__transformY(px:any, py:any):any;
	__translateTransformed(px:any, py:any):any;
	static __identity:any;
	static __matrix3:any;
	static __pool:any;


}

}

export default openfl.geom.Matrix;