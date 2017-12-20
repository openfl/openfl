import InteractiveObject from "./InteractiveObject";

declare namespace openfl.display {

export class SimpleButton extends InteractiveObject {

	constructor(upState?:any, overState?:any, downState?:any, hitTestState?:any);
	downState:any;
	enabled:any;
	hitTestState:any;
	overState:any;
	soundTransform:any;
	trackAsMenu:any;
	upState:any;
	useHandCursor:any;
	__currentState:any;
	__downState:any;
	__hitTestState:any;
	__ignoreEvent:any;
	__overState:any;
	__previousStates:any;
	__soundTransform:any;
	__symbol:any;
	__upState:any;
	__fromSymbol(swf:any, symbol:any):any;
	__getBounds(rect:any, matrix:any):any;
	__getRenderBounds(rect:any, matrix:any):any;
	__getCursor():any;
	__hitTest(x:any, y:any, shapeFlag:any, stack:any, interactiveOnly:any, hitObject:any):any;
	__hitTestMask(x:any, y:any):any;
	__renderCairo(renderSession:any):any;
	__renderCairoMask(renderSession:any):any;
	__renderCanvas(renderSession:any):any;
	__renderCanvasMask(renderSession:any):any;
	__renderDOM(renderSession:any):any;
	__renderGL(renderSession:any):any;
	__renderGLMask(renderSession:any):any;
	__setStageReference(stage:any):any;
	__setTransformDirty():any;
	__update(transformOnly:any, updateChildren:any, maskGraphics?:any):any;
	__updateChildren(transformOnly:any):any;
	__updateTransforms(overrideTransform?:any):any;
	get_downState():any;
	set_downState(downState:any):any;
	get_hitTestState():any;
	set_hitTestState(hitTestState:any):any;
	get_overState():any;
	set_overState(overState:any):any;
	get_soundTransform():any;
	set_soundTransform(value:any):any;
	get_upState():any;
	set_upState(upState:any):any;
	set___currentState(value:any):any;
	__this_onMouseDown(event:any):any;
	__this_onMouseOut(event:any):any;
	__this_onMouseOver(event:any):any;
	__this_onMouseUp(event:any):any;
	static __initSWF:any;
	static __initSymbol:any;


}

}

export default openfl.display.SimpleButton;