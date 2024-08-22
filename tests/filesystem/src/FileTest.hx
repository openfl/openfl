package;

#if (sys || air)
import openfl.filesystem.File;
#end
import utest.Assert;
import utest.Test;

class FileTest extends Test
{
	#if (sys || air)
	public function test_lineEnding()
	{
		#if windows
		Assert.equals("\r\n", File.lineEnding);
		#else
		Assert.equals("\n", File.lineEnding);
		#end
	}

	public function test_separator()
	{
		#if windows
		Assert.equals("\\", File.separator);
		#else
		Assert.equals("/", File.separator);
		#end
	}
	#end
}
