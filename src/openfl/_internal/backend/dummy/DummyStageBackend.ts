namespace openfl._internal.backend.dummy;

import openfl.display.Stage;
import openfl.display.StageDisplayState;

#if!openfl_debug
@: fileXml('tags="haxe,release"')
@: noDebug
#end
class DummyStageBackend
{
	public constructor(parent: Stage) { }

	public cancelRender(): void { }

	public getFrameRate(): number
	{
		return 0;
	}

	public getFullScreenHeight(): number
	{
		return 0;
	}

	public getFullScreenWidth(): number
	{
		return 0;
	}

	public getWindowFullscreen(): boolean
	{
		return false;
	}

	public getWindowHeight(): number
	{
		return 0;
	}

	public getWindowWidth(): number
	{
		return 0;
	}

	public setFrameRate(value: number): void { }

	public setDisplayState(value: StageDisplayState): void { }
}
