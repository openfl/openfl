package;

import openfl.events.FileListEvent;
import openfl.events.Event;
#if (haxe4 && (sys || air))
import openfl.filesystem.File;
import openfl.filesystem.FileStream;
#end
import utest.Assert;
import utest.Async;
import utest.Test;

class FileTest extends Test
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

	public function test_lineEnding()
	{
		#if air
		Assert.equals(StringTools.startsWith(openfl.system.Capabilities.version, "WIN ") ? "\r\n" : "\n", File.lineEnding);
		#elseif windows
		Assert.equals("\r\n", File.lineEnding);
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

	#if !air
	// not all AIR versions support this API
	public function test_workingDirectory()
	{
		var cwd = new File(Sys.getCwd());
		cwd.canonicalize();
		var workingDirectory = File.workingDirectory;
		workingDirectory.canonicalize();
		Assert.equals(cwd.nativePath, workingDirectory.nativePath);
	}
	#end

	public function test_createDirectory()
	{
		var createdDirectory = writableDirectory.resolvePath("createDirectory-test");

		Assert.isFalse(createdDirectory.exists);
		Assert.isFalse(createdDirectory.isDirectory);

		createdDirectory.createDirectory();

		Assert.isTrue(createdDirectory.exists);
		Assert.isTrue(createdDirectory.isDirectory);
	}

	public function test_deleteDirectory()
	{
		var directoryToDelete = writableDirectory.resolvePath("deleteDirectory-test");

		Assert.isFalse(directoryToDelete.exists);
		Assert.isFalse(directoryToDelete.isDirectory);

		directoryToDelete.createDirectory();

		Assert.isTrue(directoryToDelete.exists);
		Assert.isTrue(directoryToDelete.isDirectory);

		directoryToDelete.deleteDirectory();

		Assert.isFalse(directoryToDelete.exists);
		Assert.isFalse(directoryToDelete.isDirectory);
	}

	public function test_deleteDirectoryWithContents()
	{
		var directoryToDelete = writableDirectory.resolvePath("deleteDirectory-test");

		Assert.isFalse(directoryToDelete.exists);
		Assert.isFalse(directoryToDelete.isDirectory);

		directoryToDelete.createDirectory();

		Assert.isTrue(directoryToDelete.exists);
		Assert.isTrue(directoryToDelete.isDirectory);

		var sourceFile = assetsDirectory.resolvePath("asset.txt");
		var destFile = directoryToDelete.resolvePath("asset.txt");
		sourceFile.copyTo(destFile, false);
		Assert.isTrue(destFile.exists);

		Assert.isTrue(directoryToDelete.getDirectoryListing().length == 1);

		directoryToDelete.deleteDirectory(true);

		Assert.isFalse(directoryToDelete.exists);
		Assert.isFalse(directoryToDelete.isDirectory);
	}

	@:timeout(1000)
	public function test_deleteDirectoryAsync(async:Async)
	{
		var directoryToDelete = writableDirectory.resolvePath("deleteDirectoryAsync-test");

		Assert.isFalse(directoryToDelete.exists);
		Assert.isFalse(directoryToDelete.isDirectory);

		directoryToDelete.createDirectory();

		Assert.isTrue(directoryToDelete.exists);
		Assert.isTrue(directoryToDelete.isDirectory);

		directoryToDelete.addEventListener(Event.COMPLETE, function(event:Event):Void
		{
			if (async.timedOut)
			{
				return;
			}
			Assert.isFalse(directoryToDelete.exists);
			Assert.isFalse(directoryToDelete.isDirectory);
			async.done();
		});
		directoryToDelete.deleteDirectoryAsync();
	}

	public function test_deleteFile()
	{
		var sourceFile = assetsDirectory.resolvePath("asset.txt");
		var fileToDelete = writableDirectory.resolvePath("asset.txt");
		sourceFile.copyTo(fileToDelete, false);
		Assert.isTrue(fileToDelete.exists);

		fileToDelete.deleteFile();

		Assert.isFalse(fileToDelete.exists);
	}

	@:timeout(1000)
	public function test_deleteFileAsync(async:Async)
	{
		var sourceFile = assetsDirectory.resolvePath("asset.txt");
		var fileToDelete = writableDirectory.resolvePath("asset.txt");
		sourceFile.copyTo(fileToDelete, false);
		Assert.isTrue(fileToDelete.exists);

		fileToDelete.addEventListener(Event.COMPLETE, function(event:Event):Void
		{
			if (async.timedOut)
			{
				return;
			}
			Assert.isFalse(fileToDelete.exists);
			async.done();
		});
		fileToDelete.deleteFileAsync();
	}

	public function test_getDirectoryListing()
	{
		Assert.isTrue(assetsDirectory.exists);
		Assert.isTrue(assetsDirectory.isDirectory);

		var files = assetsDirectory.getDirectoryListing();
		Assert.notNull(files);
		// we may add more files for future tests, so don't do an equals check
		Assert.isTrue(files.length > 0);
		var assetFile = Lambda.find(files, file -> file.name == "asset.txt");

		Assert.notNull(assetFile);
	}

	@:timeout(1000)
	public function test_getDirectoryListingAsync(async:Async)
	{
		Assert.isTrue(assetsDirectory.exists);
		Assert.isTrue(assetsDirectory.isDirectory);

		assetsDirectory.addEventListener(FileListEvent.DIRECTORY_LISTING, function(event:FileListEvent):Void
		{
			if (async.timedOut)
			{
				return;
			}
			var files = event.files;
			Assert.notNull(files);
			// we may add more files for future tests, so don't do an equals check
			Assert.isTrue(files.length > 0);
			var assetFile = Lambda.find(files, file -> file.name == "asset.txt");

			Assert.notNull(assetFile);
			async.done();
		});
		assetsDirectory.getDirectoryListingAsync();
	}

	public function test_copyTo()
	{
		var sourceFile = assetsDirectory.resolvePath("asset.txt");
		var destFile = writableDirectory.resolvePath("copyTo-test.txt");

		Assert.isTrue(sourceFile.exists);
		Assert.isFalse(destFile.exists);

		sourceFile.copyTo(destFile, false);

		Assert.isTrue(destFile.exists);

		var readStream = new FileStream();
		readStream.open(destFile, READ);
		var contentsRead = readStream.readUTFBytes(readStream.bytesAvailable);
		readStream.close();

		Assert.equals("this is a text file", contentsRead);
	}

	@:timeout(1000)
	public function test_copyToAsync(async:Async)
	{
		var sourceFile = assetsDirectory.resolvePath("asset.txt");
		var destFile = writableDirectory.resolvePath("copyToAsync-test");

		Assert.isTrue(sourceFile.exists);
		Assert.isFalse(destFile.exists);

		sourceFile.addEventListener(Event.COMPLETE, function(event:Event):Void
		{
			if (async.timedOut)
			{
				return;
			}
			Assert.isTrue(destFile.exists);
			var readStream = new FileStream();
			readStream.open(destFile, READ);
			var contentsRead = readStream.readUTFBytes(readStream.bytesAvailable);
			readStream.close();
			Assert.equals("this is a text file", contentsRead);
			async.done();
		});
		sourceFile.copyToAsync(destFile, false);
	}

	public function test_moveTo()
	{
		var sourceFile = writableDirectory.resolvePath("sourceFile.txt");
		var destFile = writableDirectory.resolvePath("moveTo-test.txt");

		var contents = "I am a file to move";

		var writeStream = new FileStream();
		writeStream.open(sourceFile, WRITE);
		writeStream.writeUTFBytes(contents);
		writeStream.close();

		Assert.isTrue(sourceFile.exists);
		Assert.isFalse(destFile.exists);

		sourceFile.moveTo(destFile, false);

		Assert.isFalse(sourceFile.exists);
		Assert.isTrue(destFile.exists);

		var readStream = new FileStream();
		readStream.open(destFile, READ);
		var contentsRead = readStream.readUTFBytes(readStream.bytesAvailable);
		readStream.close();

		Assert.equals(contents, contentsRead);
	}

	@:timeout(1000)
	public function test_moveToAsync(async:Async)
	{
		var sourceFile = writableDirectory.resolvePath("sourceFile.txt");
		var destFile = writableDirectory.resolvePath("moveToAsync-test.txt");

		var contents = "I am a file to move";

		var writeStream = new FileStream();
		writeStream.open(sourceFile, WRITE);
		writeStream.writeUTFBytes(contents);
		writeStream.close();

		Assert.isTrue(sourceFile.exists);
		Assert.isFalse(destFile.exists);

		sourceFile.addEventListener(Event.COMPLETE, function(event:Event):Void
		{
			if (async.timedOut)
			{
				return;
			}

			Assert.isFalse(sourceFile.exists);
			Assert.isTrue(destFile.exists);

			var readStream = new FileStream();
			readStream.open(destFile, READ);
			var contentsRead = readStream.readUTFBytes(readStream.bytesAvailable);
			readStream.close();

			Assert.equals(contents, contentsRead);
			async.done();
		});
		sourceFile.moveToAsync(destFile, false);
	}
	#else
	public function test_test()
	{
		Assert.pass();
	}
	#end
}
