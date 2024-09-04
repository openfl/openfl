package;

import openfl.events.Event;
#if (haxe4 && (sys || air))
import openfl.filesystem.File;
import openfl.filesystem.FileStream;
#end
import utest.Assert;
import utest.Async;
import utest.Test;

class FileStreamTest extends Test
{
	#if (haxe4 && (sys || air))
	private var assetsDirectory:File;
	private var writableDirectory:File;

	public function setup():Void
	{
		#if (tools || air)
		assetsDirectory = File.applicationDirectory.resolvePath("assets");
		writableDirectory = File.applicationStorageDirectory.resolvePath("writable");
		#else
		assetsDirectory = File.workingDirectory.resolvePath("assets");
		writableDirectory = File.workingDirectory.resolvePath("writable");
		#end
		if (!writableDirectory.exists)
		{
			writableDirectory.createDirectory();
		}
		Assert.isTrue(assetsDirectory.exists);
		Assert.isTrue(assetsDirectory.isDirectory);
		Assert.isTrue(writableDirectory.exists);
		Assert.isTrue(writableDirectory.isDirectory);

		for (file in writableDirectory.getDirectoryListing())
		{
			if (file.exists)
			{
				try
				{
					if (file.isDirectory)
					{
						file.deleteDirectory(true);
					}
					else
					{
						file.deleteFile();
					}
				}
				catch (e:Dynamic) {}
			}
		}
	}

	public function teardown()
	{
		assetsDirectory = null;
		writableDirectory.deleteDirectory(true);
		writableDirectory = null;
	}

	public function test_readText()
	{
		var file = assetsDirectory.resolvePath("asset.txt");
		Assert.isTrue(file.exists);

		var readStream = new FileStream();
		readStream.open(file, READ);
		var contentsRead = readStream.readUTFBytes(readStream.bytesAvailable);
		readStream.close();

		Assert.equals("this is a text file", contentsRead);
	}

	@:timeout(1000)
	public function test_readText_async(async:Async)
	{
		var file = assetsDirectory.resolvePath("asset.txt");
		Assert.isTrue(file.exists);

		var readStream = new FileStream();
		readStream.addEventListener(Event.COMPLETE, function(event:Event):Void
		{
			if (async.timedOut)
			{
				readStream.close();
				return;
			}
			var contentsRead = readStream.readUTFBytes(readStream.bytesAvailable);
			Assert.equals("this is a text file", contentsRead);
			readStream.close();
			async.done();
		});
		readStream.openAsync(file, READ);
	}

	public function test_writeText()
	{
		var file = writableDirectory.resolvePath("write-test.txt");

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
	#else
	public function test_test()
	{
		Assert.pass();
	}
	#end
}
