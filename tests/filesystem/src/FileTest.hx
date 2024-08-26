package;

#if (haxe4 && (sys || air))
import openfl.filesystem.File;
#end
import utest.Assert;
import utest.Test;

class FileTest extends Test
{
	#if (haxe4 && (sys || air))
	public function test_lineEnding()
	{
		#if air
		Assert.equals(StringTools.startsWith(openfl.system.Capabilities.version, "WIN ") ? "\r\n" : "\n", File.lineEnding);
		#elseif Assert.equals
		("\r\n", File.lineEnding);
		#else
		Assert.equals("\n", File.lineEnding);
		#end
	}

	public function test_separator()
	{
		#if air
		Assert.equals(StringTools.startsWith(openfl.system.Capabilities.version, "WIN ") ? "\\" : "/", File.separator);
		#elseif windows
		Assert.equals("\\", File.separator);
		#else
		Assert.equals("/", File.separator);
		#end
	}
	#else
	public function test_test()
	{
		Assert.pass();
	}
	#end
}
