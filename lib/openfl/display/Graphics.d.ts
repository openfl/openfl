
declare namespace openfl.display {

export class Graphics {

	constructor(owner:any);
	__bounds:any;
	__commands:any;
	__dirty:any;
	__height:any;
	__managed:any;
	__positionX:any;
	__positionY:any;
	__renderTransform:any;
	__strokePadding:any;
	__transformDirty:any;
	__visible:any;
	__owner:any;
	__width:any;
	__worldTransform:any;
	__canvas:any;
	__context:any;
	__bitmap:any;
	beginBitmapFill(bitmap:any, matrix?:any, repeat?:any, smooth?:any):any;
	beginFill(color?:any, alpha?:any):any;
	beginGradientFill(type:any, colors:any, alphas:any, ratios:any, matrix?:any, spreadMethod?:any, interpolationMethod?:any, focalPointRatio?:any):any;
	clear():any;
	copyFrom(sourceGraphics:any):any;
	cubicCurveTo(controlX1:any, controlY1:any, controlX2:any, controlY2:any, anchorX:any, anchorY:any):any;
	curveTo(controlX:any, controlY:any, anchorX:any, anchorY:any):any;
	drawCircle(x:any, y:any, radius:any):any;
	drawEllipse(x:any, y:any, width:any, height:any):any;
	drawGraphicsData(graphicsData:any):any;
	drawPath(commands:any, data:any, winding?:any):any;
	drawRect(x:any, y:any, width:any, height:any):any;
	drawRoundRect(x:any, y:any, width:any, height:any, ellipseWidth:any, ellipseHeight?:any):any;
	drawRoundRectComplex(x:any, y:any, width:any, height:any, topLeftRadius:any, topRightRadius:any, bottomLeftRadius:any, bottomRightRadius:any):any;
	drawTriangles(vertices:any, indices?:any, uvtData?:any, culling?:any):any;
	endFill():any;
	lineBitmapStyle(bitmap:any, matrix?:any, repeat?:any, smooth?:any):any;
	lineGradientStyle(type:any, colors:any, alphas:any, ratios:any, matrix?:any, spreadMethod?:any, interpolationMethod?:any, focalPointRatio?:any):any;
	lineStyle(thickness?:any, color?:any, alpha?:any, pixelHinting?:any, scaleMode?:any, caps?:any, joints?:any, miterLimit?:any):any;
	lineTo(x:any, y:any):any;
	moveTo(x:any, y:any):any;
	readGraphicsData(recurse?:any):any;
	__calculateBezierCubicPoint(t:any, p1:any, p2:any, p3:any, p4:any):any;
	__calculateBezierQuadPoint(t:any, p1:any, p2:any, p3:any):any;
	__cleanup():any;
	__getBounds(rect:any, matrix:any):any;
	__hitTest(x:any, y:any, shapeFlag:any, matrix:any):any;
	__inflateBounds(x:any, y:any):any;
	__readGraphicsData(graphicsData:any):any;
	__update():any;
	set___dirty(value:any):any;
	
	


}

}

export default openfl.display.Graphics;