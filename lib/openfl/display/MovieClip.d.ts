import Sprite from "./Sprite";

declare namespace openfl.display {

export class MovieClip extends Sprite {

	constructor();
	currentFrame:any;
	currentFrameLabel:any;
	currentLabel:any;
	currentLabels:any;
	enabled:any;
	framesLoaded:any;
	isPlaying:any;
	totalFrames:any;
	__activeInstances:any;
	__activeInstancesByFrameObjectID:any;
	__currentFrame:any;
	__currentFrameLabel:any;
	__currentLabel:any;
	__currentLabels:any;
	__frameScripts:any;
	__frameTime:any;
	__lastFrameScriptEval:any;
	__lastFrameUpdate:any;
	__playing:any;
	__swf:any;
	__symbol:any;
	__timeElapsed:any;
	__totalFrames:any;
	addFrameScript(index:any, method:any):any;
	gotoAndPlay(frame:any, scene?:any):any;
	gotoAndStop(frame:any, scene?:any):any;
	nextFrame():any;
	play():any;
	prevFrame():any;
	stop():any;
	__enterFrame(deltaTime:any):any;
	__evaluateFrameScripts(advanceToFrame:any):any;
	__fromSymbol(swf:any, symbol:any):any;
	__getNextFrame(deltaTime:any):any;
	__goto(frame:any):any;
	__resolveFrameReference(frame:any):any;
	__sortDepths(a:any, b:any):any;
	__stopAllMovieClips():any;
	__updateDisplayObject(displayObject:any, frameObject:any):any;
	__updateFrameLabel():any;
	get_currentFrame():any;
	get_currentFrameLabel():any;
	get_currentLabel():any;
	get_currentLabels():any;
	get_framesLoaded():any;
	get_isPlaying():any;
	get_totalFrames():any;
	static __initSWF:any;
	static __initSymbol:any;


}

}

export default openfl.display.MovieClip;