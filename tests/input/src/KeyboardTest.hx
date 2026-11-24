package;

#if (lime && !flash)
import lime.ui.KeyCode;
#end
import openfl.ui.Keyboard;
import utest.Assert;
import utest.Test;

class KeyboardTest extends Test
{
	public function test_test()
	{
		var exists = Keyboard.A;

		Assert.notNull(exists);
	}

	#if (!lime || flash)
	@Ignored
	#end
	public function test_convertKeyCode()
	{
		#if (lime && !flash)
		// keys that have a Flash key code keep it
		Assert.equals(Keyboard.A, convert(KeyCode.A));
		Assert.equals(Keyboard.F15, convert(KeyCode.F15));

		// keys that Flash has no constant for get their Windows virtual-key code, as in desktop AIR
		Assert.equals(0x7F, convert(KeyCode.F16));
		Assert.equals(0x87, convert(KeyCode.F24));
		Assert.equals(0xAF, convert(KeyCode.VOLUME_UP));
		Assert.equals(0xB3, convert(KeyCode.AUDIO_PLAY));

		// the others give 0 rather than a code past Flash's 0-255 range
		Assert.equals(0, convert(KeyCode.BRIGHTNESS_DOWN));
		Assert.equals(0, convert(cast 0x40000200));
		Assert.equals(0, convert(cast 339));
		#end
	}

	#if (lime && !flash)
	private static function convert(key:KeyCode):Int
	{
		return @:privateAccess Keyboard.__convertKeyCode(key);
	}
	#end
}
