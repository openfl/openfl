package filesystem;

#if ((flash && air) || draft)
import openfl.filesystem.File;

class FileSystemTest
{
	@Test public function absolutePath()
	{
		// TODO: Confirm functionality

		var file = new File();
		var absolutePath = file.absolutePath;
		Assert.isNotNull(absolutePath);
	}
}
#else
class FileSystemTest {}
#end
