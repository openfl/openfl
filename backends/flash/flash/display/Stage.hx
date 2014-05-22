package flash.display;

/*
 It was not possible to override flash.Vector with a smarter abstract type, since this is 
 baked into genswf9.ml. Instead, we'll set classes that use flash.Vector to reference
 openfl.Vector instead.
*/

extern class Stage extends DisplayObjectContainer {
	var align : StageAlign;
	@:require(flash10_2) var allowsFullScreen(default,null) : Bool;
	@:require(flash11_3) var allowsFullScreenInteractive(default,null) : Bool;
	@:require(flash10_2) var color : UInt;
	@:require(flash10) var colorCorrection : ColorCorrection;
	@:require(flash10) var colorCorrectionSupport(default,null) : ColorCorrectionSupport;
	@:require(flash11_4) var contentsScaleFactor(default,null) : Float;
	@:require(flash11) var displayContextInfo(default,null) : String;
	var displayState : StageDisplayState;
	var focus : InteractiveObject;
	var frameRate : Float;
	var fullScreenHeight(default,null) : UInt;
	var fullScreenSourceRect : flash.geom.Rectangle;
	var fullScreenWidth(default,null) : UInt;
	@:require(flash11_2) var mouseLock : Bool;
	var quality : StageQuality;
	var scaleMode : StageScaleMode;
	var showDefaultContextMenu : Bool;
	@:require(flash11) var softKeyboardRect(default,null) : flash.geom.Rectangle;
	@:require(flash11) var stage3Ds(default,null) : openfl.Vector<Stage3D>;
	var stageFocusRect : Bool;
	var stageHeight : Int;
	@:require(flash10_2) var stageVideos(default,null) : openfl.Vector<flash.media.StageVideo>;
	var stageWidth : Int;
	@:require(flash10_1) var wmodeGPU(default,null) : Bool;
	function invalidate() : Void;
	function isFocusInaccessible() : Bool;
}
