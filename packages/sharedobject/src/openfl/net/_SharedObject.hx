package openfl.net;

#if lime
import haxe.io.Bytes;
import haxe.io.Path;
import haxe.Serializer;
import haxe.Unserializer;
import lime.app.Application;
import lime.system.System;
import openfl.net.SharedObject;
import openfl.net.SharedObjectFlushStatus;
#if openfl_html5
import js.Browser;
#end
#if sys
import sys.io.File;
import sys.FileSystem;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.net.SharedObject)
@:noCompletion
class _SharedObject
{
	private static var sharedObjects:Map<String, SharedObject>;

	private var localPath:String;
	private var name:String;
	private var parent:SharedObject;

	public function new(parent:SharedObject)
	{
		this.parent = parent;
	}

	public function clear():Void
	{
		#if sys
		try
		{
			var path = getPath(localPath, name);

			if (FileSystem.exists(path))
			{
				FileSystem.deleteFile(path);
			}
		}
		catch (e:Dynamic) {}
		#elseif openfl_html5
		try
		{
			var storage = Browser.getLocalStorage();

			if (storage != null)
			{
				storage.removeItem(localPath + ":" + name);
			}
		}
		catch (e:Dynamic) {}
		#end
	}

	public function flush(minDiskSpace:Int = 0):SharedObjectFlushStatus
	{
		if (Reflect.fields(parent.data).length == 0)
		{
			return SharedObjectFlushStatus.FLUSHED;
		}

		var encodedData = Serializer.run(parent.data);

		try
		{
			#if sys
			var path = getPath(localPath, name);
			var directory = Path.directory(path);

			if (!FileSystem.exists(directory))
			{
				mkdir(directory);
			}

			var output = File.write(path, false);
			output.writeString(encodedData);
			output.close();
			#elseif openfl_html5
			var storage = Browser.getLocalStorage();

			if (storage != null)
			{
				storage.removeItem(localPath + ":" + name);
				storage.setItem(localPath + ":" + name, encodedData);
			}
			#end
		}
		catch (e:Dynamic)
		{
			return SharedObjectFlushStatus.PENDING;
		}

		return SharedObjectFlushStatus.FLUSHED;
	}

	public function getLocal(name:String, localPath:String = null, secure:Bool = false /* note: unsupported**/):Void
	{
		#if sys
		if (SharedObject.__sharedObjects == null)
		{
			if (Application.current != null)
			{
				Application.current.onExit.add(application_onExit);
			}
		}

		var encodedData = null;

		try
		{
			if (localPath == null) localPath = "";

			var path = getPath(localPath, name);

			if (FileSystem.exists(path))
			{
				encodedData = File.getContent(path);
			}
		}
		catch (e:Dynamic) {}

		this.localPath = localPath;
		this.name = name;

		if (encodedData != null && encodedData != "")
		{
			try
			{
				var unserializer = new Unserializer(encodedData);
				unserializer.setResolver(cast {resolveEnum: Type.resolveEnum, resolveClass: resolveClass});
				@:privateAccess parent.data = unserializer.unserialize();
			}
			catch (e:Dynamic) {}
		}
		#elseif openfl_html5
		var encodedData = null;

		try
		{
			var storage = Browser.getLocalStorage();

			if (localPath == null)
			{
				// Check old default path, first
				if (storage != null)
				{
					encodedData = storage.getItem(Browser.window.location.href + ":" + name);
					storage.removeItem(Browser.window.location.href + ":" + name);
				}

				localPath = Browser.window.location.pathname;
			}

			if (storage != null && encodedData == null)
			{
				encodedData = storage.getItem(localPath + ":" + name);
			}
		}
		catch (e:Dynamic) {}

		this.localPath = localPath;
		this.name = name;

		if (encodedData != null && encodedData != "")
		{
			try
			{
				var unserializer = new Unserializer(encodedData);
				unserializer.setResolver(cast {resolveEnum: Type.resolveEnum, resolveClass: resolveClass});
				@:privateAccess parent.data = unserializer.unserialize();
			}
			catch (e:Dynamic) {}
		}
		#end
	}

	private function getPath(localPath:String, name:String):String
	{
		var path = System.applicationStorageDirectory + "/" + localPath + "/";

		name = StringTools.replace(name, "//", "/");
		name = StringTools.replace(name, "//", "/");

		if (StringTools.startsWith(name, "/"))
		{
			name = name.substr(1);
		}

		if (StringTools.endsWith(name, "/"))
		{
			name = name.substring(0, name.length - 1);
		}

		if (name.indexOf("/") > -1)
		{
			var split = name.split("/");
			name = "";

			for (i in 0...(split.length - 1))
			{
				name += "#" + split[i] + "/";
			}

			name += split[split.length - 1];
		}

		return path + name + ".sol";
	}

	public function getSize():Int
	{
		try
		{
			var d = Serializer.run(parent.data);
			return Bytes.ofString(d).length;
		}
		catch (e:Dynamic)
		{
			return 0;
		}
	}

	private static function mkdir(directory:String):Void
	{
		// TODO: Move this to Lime somewhere?

		#if sys
		directory = StringTools.replace(directory, "\\", "/");
		var total = "";

		if (directory.substr(0, 1) == "/")
		{
			total = "/";
		}

		var parts = directory.split("/");
		var oldPath = "";

		if (parts.length > 0 && parts[0].indexOf(":") > -1)
		{
			oldPath = Sys.getCwd();
			Sys.setCwd(parts[0] + "\\");
			parts.shift();
		}

		for (part in parts)
		{
			if (part != "." && part != "")
			{
				if (total != "" && total != "/")
				{
					total += "/";
				}

				total += part;

				if (!FileSystem.exists(total))
				{
					FileSystem.createDirectory(total);
				}
			}
		}

		if (oldPath != "")
		{
			Sys.setCwd(oldPath);
		}
		#end
	}

	private static function resolveClass(name:String):Class<Dynamic>
	{
		if (name != null)
		{
			if (StringTools.startsWith(name, "neash."))
			{
				name = StringTools.replace(name, "neash.", "openfl.");
			}

			if (StringTools.startsWith(name, "native."))
			{
				name = StringTools.replace(name, "native.", "openfl.");
			}

			if (StringTools.startsWith(name, "flash."))
			{
				name = StringTools.replace(name, "flash.", "openfl.");
			}

			if (StringTools.startsWith(name, "openfl._v2."))
			{
				name = StringTools.replace(name, "openfl._v2.", "openfl.");
			}

			if (StringTools.startsWith(name, "openfl._legacy."))
			{
				name = StringTools.replace(name, "openfl._legacy.", "openfl.");
			}

			return Type.resolveClass(name);
		}

		return null;
	}

	// Event Handlers
	private static function application_onExit(_):Void
	{
		for (sharedObject in SharedObject.__sharedObjects)
		{
			sharedObject.flush();
		}
	}
}
#end
