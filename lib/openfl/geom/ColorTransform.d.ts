
declare namespace openfl.geom {

export class ColorTransform {

	constructor(redMultiplier?:any, greenMultiplier?:any, blueMultiplier?:any, alphaMultiplier?:any, redOffset?:any, greenOffset?:any, blueOffset?:any, alphaOffset?:any);
	alphaMultiplier:any;
	alphaOffset:any;
	blueMultiplier:any;
	blueOffset:any;
	color:any;
	greenMultiplier:any;
	greenOffset:any;
	redMultiplier:any;
	redOffset:any;
	concat(second:any):any;
	toString():any;
	__clone():any;
	__copyFrom(ct:any):any;
	__combine(ct:any):any;
	__identity():any;
	__equals(ct:any, skipAlphaMultiplier?:any):any;
	__isDefault():any;
	get_color():any;
	set_color(value:any):any;
	__toLimeColorMatrix():any;
	static __limeColorMatrix:any;


}

}

export default openfl.geom.ColorTransform;