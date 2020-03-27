namespace openfl._internal.backend.html5;

#if openfl_html5
import haxe.io.Bytes;
import haxe.Serializer;
import haxe.Unserializer;
import js.Browser;
import openfl.net.SharedObject;
import openfl.net.SharedObjectFlushStatus;

@: access(openfl.net.SharedObject)
class HTML5SharedObjectBackend
{
	private localPath: string;
	private name: string;
	private parent: SharedObject;

	public constructor(parent: SharedObject)
	{
		this.parent = parent;
	}

	public clear(): void
	{
		try
		{
			var storage = Browser.getLocalStorage();

			if (storage != null)
			{
				storage.removeItem(localPath + ":" + name);
			}
		}
		catch (e: Dynamic) { }
	}

	public flush(minDiskSpace: number = 0): SharedObjectFlushStatus
	{
		var encodedData = Serializer.run(parent.data);

		try
		{
			var storage = Browser.getLocalStorage();

			if (storage != null)
			{
				storage.removeItem(localPath + ":" + name);
				storage.setItem(localPath + ":" + name, encodedData);
			}
		}
		catch (e: Dynamic)
		{
			return SharedObjectFlushStatus.PENDING;
		}

		return SharedObjectFlushStatus.FLUSHED;
	}

	public getLocal(name: string, localPath: string = null, secure: boolean = false /* note: unsupported**/): SharedObject
	{
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
		catch (e: Dynamic) { }

		this.localPath = localPath;
		this.name = name;

		if (encodedData != null && encodedData != "")
		{
			try
			{
				var unserializer = new Unserializer(encodedData);
				unserializer.setResolver(cast { resolveEnum: Type.resolveEnum, resolveClass: resolveClass });
				@: privateAccess parent.data = unserializer.unserialize();
			}
			catch (e: Dynamic) { }
		}
	}

	public getSize(): number
	{
		try
		{
			var d = Serializer.run(parent.data);
			return Bytes.ofString(d).length;
		}
		catch (e: Dynamic)
		{
			return 0;
		}
	}

	private static resolveClass(name: string): Class<Dynamic>
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
}
#end
