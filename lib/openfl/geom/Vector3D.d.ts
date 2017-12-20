
declare namespace openfl.geom {

export class Vector3D {

	constructor(x?:any, y?:any, z?:any, w?:any);
	length:any;
	lengthSquared:any;
	w:any;
	x:any;
	y:any;
	z:any;
	add(a:any):any;
	clone():any;
	copyFrom(sourceVector3D:any):any;
	crossProduct(a:any):any;
	decrementBy(a:any):any;
	dotProduct(a:any):any;
	equals(toCompare:any, allFour?:any):any;
	incrementBy(a:any):any;
	nearEquals(toCompare:any, tolerance:any, allFour?:any):any;
	negate():any;
	normalize():any;
	project():any;
	scaleBy(s:any):any;
	setTo(xa:any, ya:any, za:any):any;
	subtract(a:any):any;
	toString():any;
	get_length():any;
	get_lengthSquared():any;
	static X_AXIS:any;
	static Y_AXIS:any;
	static Z_AXIS:any;
	static angleBetween(a:any, b:any):any;
	static distance(pt1:any, pt2:any):any;
	static get_X_AXIS():any;
	static get_Y_AXIS():any;
	static get_Z_AXIS():any;


}

}

export default openfl.geom.Vector3D;