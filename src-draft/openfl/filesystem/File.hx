package openfl.filesystem;

using StringTools;

class File extends openfl.net.FileReference
{
	// public
	public var absolutePath(get, null):String;
	public var exists(get, null):Bool;
	public var isDirectory(get, null):Bool;
	public var nativePath(get, null):String;
	public var url(get, null):String;

	public function new(?path:String)
	{
		super();
		this.__path = path;
		normalize();

		var fileInfo = sys.FileSystem.stat(__path);
		if (fileInfo != null)
		{
			creationDate = fileInfo.ctime;
			modificationDate = fileInfo.mtime;
			size = fileInfo.size;
			type = "." + haxe.io.Path.extension(__path);
		}
	}

	function normalize()
	{
		if (__path == null) return;

		if (sep == "/") __path = __path.replace("\\", sep);
		if (sep == "\\") __path = __path.replace("/", sep);

		if (isDirectory)
		{
			if (__path.charCodeAt(__path.length - 1) != sep.charCodeAt(0)) __path = __path + sep;
		}
	}

	public function createDirectory()
	{
		sys.FileSystem.createDirectory(nativePath);
	}

	public function deleteDirectory(deleteDirectoryContents:Bool = false)
	{
		if (deleteDirectoryContents)
		{
			for (f in getDirectoryListing())
				f.deleteDirectory(deleteDirectoryContents);
		}
		sys.FileSystem.deleteDirectory(nativePath);
	}

	public function getDirectoryListing():Array<File>
	{
		if (__path == null)
		{
			// #if debug trace("path is empy"); #end
			return [];
		}
		if (!isDirectory)
		{
			// #if debug trace("not a dir"); #end
			return [];
		}
		var dirs = sys.FileSystem.readDirectory(nativePath);
		if (dirs == null) return [];
		return dirs.map(function(path) return resolvePath(path));
	}

	public function get_absolutePath():String
	{
		return sys.FileSystem.absolutePath(nativePath);
	}

	// todo test
	public function deleteFile()
	{
		sys.FileSystem.deleteFile(nativePath);
	}

	// todo test
	public function deleteFileAsync()
	{
		#if !cpp
		sys.FileSystem.deleteFile(nativePath);
		#else
		var path = nativePath;
		cpp.vm.Thread.create(function()
		{
			sys.FileSystem.deleteFile(path);
		});
		#end
	}

	public function resolvePath(path:String):File
	{
		// if native path is a dir, it has a trailing slash
		return new File(nativePath + path);
	}

	/**
	 * Could setup a handler ?
	 */
	public function openWithDefaultApplication()
	{
		throw "[openWithDefaultApplication]not implemented";
	}

	//////////////////////////////public statics
	public static var applicationDirectory:File = new File(lime.system.System.applicationDirectory);
	public static var applicationStorageDirectory:File = new File(lime.system.System.applicationStorageDirectory);

	public function browseForOpen(hint:String, filters:Array<Dynamic>)
	{
		throw "[browseForOpen]not implemented";
	}

	public function browseForDirectory(hint:String)
	{
		throw "[browseForDirectory]not implemented";
	}

	//////////////////////////////private
	function get_nativePath()
		return __path;

	function get_url()
		return "file:///" + nativePath;

	function get_exists():Bool
	{
		return sys.FileSystem.exists(__path);
	}

	function get_isDirectory()
	{
		return sys.FileSystem.isDirectory(nativePath);
	}

	function __update()
	{
		var fileInfo = sys.FileSystem.stat(__path);
		if (fileInfo != null)
		{
			creationDate = fileInfo.ctime;
			modificationDate = fileInfo.mtime;
			size = fileInfo.size;
			type = "." + haxe.io.Path.extension(__path);
		}
	}

	public static inline var sep = {
		#if windows
		"\\";
		#else
		"/";
		#end
	}

	override function toString()
	{
		return "[Object File __path:" + __path + "]";
	}
}
