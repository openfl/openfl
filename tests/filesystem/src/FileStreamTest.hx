package;

#if (sys || air)
import openfl.filesystem.File;
import openfl.filesystem.FileStream;
#end
import utest.Assert;
import utest.Test;

class FileStreamTest extends Test
{
	#if (sys || air)
	private var fileToDelete:File;

	public function teardown()
	{
		if (fileToDelete != null && fileToDelete.exists)
		{
			try
			{
				fileToDelete.deleteFile();
			}
			catch (e:Dynamic) {}
		}
	}

	public function test_readText()
	{
		#if (tools || air)
		var file = File.applicationDirectory.resolvePath("assets/asset.txt");
		#else
		var file = File.workingDirectory.resolvePath("assets/asset.txt");
		#end
		Assert.isTrue(file.exists);

		var readStream = new FileStream();
		readStream.open(file, READ);
		var contentsRead = readStream.readUTFBytes(readStream.bytesAvailable);
		readStream.close();

		Assert.equals("this is a text file", contentsRead);
	}

	public function test_writeText()
	{
		#if (tools || air)
		var file = File.applicationStorageDirectory.resolvePath("write-test.txt");
		#else
		var file = File.workingDirectory.resolvePath("write-test.txt");
		#end
		fileToDelete = file;

		var contentsToWrite = "hello world";

		var writeStream = new FileStream();
		writeStream.open(file, WRITE);
		writeStream.writeUTFBytes(contentsToWrite);
		writeStream.close();

		Assert.isTrue(file.exists);

		var readStream = new FileStream();
		readStream.open(file, READ);
		var contentsRead = readStream.readUTFBytes(contentsToWrite.length);
		readStream.close();

		Assert.equals(contentsToWrite, contentsRead);
	}
	#end
}
