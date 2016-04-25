package openfl._internal.renderer;

import openfl.display.BlendMode;

interface BlendModeManager {

	public var currentBlendMode:BlendMode;

	public function destroy ():Void;
	public function setBlendMode (blendMode:BlendMode, ?force:Bool = false):Bool;

}
