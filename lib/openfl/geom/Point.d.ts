
declare namespace openfl.geom {

export class Point {

	constructor(x?:any, y?:any);
	length:any;
	x:any;
	y:any;
	add(v:any):any;
	clone():any;
	copyFrom(sourcePoint:any):any;
	equals(toCompare:any):any;
	normalize(thickness:any):any;
	offset(dx:any, dy:any):any;
	setTo(xa:any, ya:any):any;
	subtract(v:any):any;
	toString():any;
	__toLimeVector2():any;
	get_length():any;
	static __limeVector2:any;
	static __pool:any;
	static distance(pt1:any, pt2:any):any;
	static interpolate(pt1:any, pt2:any, f:any):any;
	static polar(len:any, angle:any):any;


}

}

export default openfl.geom.Point;