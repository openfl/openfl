declare namespace openfl.geom {

export class Rectangle {

	constructor(x?:any, y?:any, width?:any, height?:any);
	bottom:any;
	bottomRight:any;
	height:any;
	left:any;
	right:any;
	size:any;
	top:any;
	topLeft:any;
	width:any;
	x:any;
	y:any;
	clone():any;
	contains(x:any, y:any):any;
	containsPoint(point:any):any;
	containsRect(rect:any):any;
	copyFrom(sourceRect:any):any;
	equals(toCompare:any):any;
	inflate(dx:any, dy:any):any;
	inflatePoint(point:any):any;
	intersection(toIntersect:any):any;
	intersects(toIntersect:any):any;
	isEmpty():any;
	offset(dx:any, dy:any):any;
	offsetPoint(point:any):any;
	setEmpty():any;
	setTo(xa:any, ya:any, widtha:any, heighta:any):any;
	toString():any;
	union(toUnion:any):any;
	__contract(x:any, y:any, width:any, height:any):any;
	__expand(x:any, y:any, width:any, height:any):any;
	__toLimeRectangle():any;
	__transform(rect:any, m:any):any;
	get_bottom():any;
	set_bottom(b:any):any;
	get_bottomRight():any;
	set_bottomRight(p:any):any;
	get_left():any;
	set_left(l:any):any;
	get_right():any;
	set_right(r:any):any;
	get_size():any;
	set_size(p:any):any;
	get_top():any;
	set_top(t:any):any;
	get_topLeft():any;
	set_topLeft(p:any):any;
	
	static __pool:any;


}

}

export default openfl.geom.Rectangle;