package;

#if (haxe4 && (sys || air))
import openfl.filesystem.FileMode;
#end
import utest.Assert;
import utest.Test;

class FileModeTest extends Test
{
	#if (haxe4 && (sys || air))
	public function test_test()
	{
		switch (FileMode.READ)
		{
			case FileMode.READ, FileMode.WRITE, FileMode.APPEND, FileMode.UPDATE:
				Assert.isTrue(true);
		}
	}
	#else
	public function test_test()
	{
		Assert.pass();
	}
	#end
}
