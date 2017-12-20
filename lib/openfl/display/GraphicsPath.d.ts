
declare namespace openfl.display {

export class GraphicsPath {

	constructor(commands?:any, data?:any, winding?:any);
	commands:any;
	data:any;
	winding:any;
	
	cubicCurveTo(controlX1:any, controlY1:any, controlX2:any, controlY2:any, anchorX:any, anchorY:any):any;
	curveTo(controlX:any, controlY:any, anchorX:any, anchorY:any):any;
	lineTo(x:any, y:any):any;
	moveTo(x:any, y:any):any;
	wideLineTo(x:any, y:any):any;
	wideMoveTo(x:any, y:any):any;
	__drawCircle(x:any, y:any, radius:any):any;
	__drawEllipse(x:any, y:any, width:any, height:any):any;
	__drawRect(x:any, y:any, width:any, height:any):any;
	__drawRoundRect(x:any, y:any, width:any, height:any, ellipseWidth:any, ellipseHeight:any):any;
	static SIN45:any;
	static TAN22:any;


}

}

export default openfl.display.GraphicsPath;