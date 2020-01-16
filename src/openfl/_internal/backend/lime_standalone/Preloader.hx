package openfl._internal.backend.lime_standalone;

#if (false && openfl_html5)
import haxe.io.Bytes;
import haxe.io.Path;
import haxe.macro.Compiler;
import haxe.Timer;
import js.html.Image;
import js.html.SpanElement;
import js.Browser;
import openfl._internal.utils.Log;

@:access(openfl._internal.backend.lime_standalone.AssetLibrary)
class Preloader
{
	public var complete(default, null):Bool;
	public var onComplete = new LimeEvent<Void->Void>();
	public var onProgress = new LimeEvent<Int->Int->Void>();

	@:noCompletion private var bytesLoaded:Int;
	@:noCompletion private var bytesLoadedCache = new Map<AssetLibrary, Int>();
	@:noCompletion private var bytesLoadedCache2 = new Map<String, Int>();
	@:noCompletion private var bytesTotal:Int;
	@:noCompletion private var bytesTotalCache = new Map<String, Int>();
	@:noCompletion private var initLibraryNames:Bool;
	@:noCompletion private var libraries:Array<AssetLibrary>;
	@:noCompletion private var libraryNames:Array<String>;
	@:noCompletion private var loadedLibraries:Int;
	@:noCompletion private var loadedStage:Bool;
	@:noCompletion private var preloadComplete:Bool;
	@:noCompletion private var preloadStarted:Bool;
	@:noCompletion private var simulateProgress:Bool;

	public function new()
	{
		// TODO: Split out core preloader support from generic Preloader type

		bytesLoaded = 0;
		bytesTotal = 0;
		libraries = new Array<AssetLibrary>();
		libraryNames = new Array<String>();

		onProgress.add(update);

		#if simulate_preloader
		var preloadTime = Std.parseInt(Compiler.getDefine("simulate_preloader"));

		if (preloadTime == 1)
		{
			preloadTime = 3000;
		}

		var startTime = System.getTimer();
		var currentTime = 0;
		var timeStep = Std.int(1000 / 60);
		var timer = new Timer(timeStep);

		simulateProgress = true;

		timer.run = function()
		{
			currentTime = System.getTimer() - startTime;
			if (currentTime > preloadTime) currentTime = preloadTime;
			onProgress.dispatch(currentTime, preloadTime);

			if (currentTime >= preloadTime)
			{
				timer.stop();

				simulateProgress = false;
				start();
			}
		};
		#end
	}

	public function addLibrary(library:AssetLibrary):Void
	{
		libraries.push(library);
	}

	public function addLibraryName(name:String):Void
	{
		if (libraryNames.indexOf(name) == -1)
		{
			libraryNames.push(name);
		}
	}

	public function load():Void
	{
		for (library in libraries)
		{
			bytesTotal += library.bytesTotal;
		}

		loadedLibraries = -1;
		preloadStarted = false;

		for (library in libraries)
		{
			Log.verbose("Preloading asset library");

			library.load()
				.onProgress(function(loaded, total)
				{
					if (!bytesLoadedCache.exists(library))
					{
						bytesLoaded += loaded;
					}
					else
					{
						bytesLoaded += loaded - bytesLoadedCache.get(library);
					}

					bytesLoadedCache.set(library, loaded);

					if (!simulateProgress)
					{
						onProgress.dispatch(bytesLoaded, bytesTotal);
					}
				})
				.onComplete(function(_)
				{
					if (!bytesLoadedCache.exists(library))
					{
						bytesLoaded += library.bytesTotal;
					}
					else
					{
						bytesLoaded += library.bytesTotal - bytesLoadedCache.get(library);
					}

					loadedAssetLibrary();
				})
				.onError(function(e)
				{
					Log.error(e);
				});
		}

		// TODO: Handle bytes total better

		for (name in libraryNames)
		{
			bytesTotal += 200;
		}

		loadedLibraries++;
		preloadStarted = true;
		updateProgress();
	}

	@:noCompletion private function loadedAssetLibrary(name:String = null):Void
	{
		loadedLibraries++;

		var current = loadedLibraries;
		if (!preloadStarted) current++;

		var totalLibraries = libraries.length + libraryNames.length;

		if (name != null)
		{
			Log.verbose("Loaded asset library: " + name + " [" + current + "/" + totalLibraries + "]");
		}
		else
		{
			Log.verbose("Loaded asset library [" + current + "/" + totalLibraries + "]");
		}

		updateProgress();
	}

	@:noCompletion private function start():Void
	{
		if (complete || simulateProgress || !preloadComplete) return;

		complete = true;

		onComplete.dispatch();
	}

	@:noCompletion private function update(loaded:Int, total:Int):Void {}

	@:noCompletion private function updateProgress():Void
	{
		if (!simulateProgress)
		{
			onProgress.dispatch(bytesLoaded, bytesTotal);
		}

		if (loadedLibraries == libraries.length && !initLibraryNames)
		{
			initLibraryNames = true;

			for (name in libraryNames)
			{
				Log.verbose("Preloading asset library: " + name);

				Assets.loadLibrary(name)
					.onProgress(function(loaded, total)
					{
						if (total > 0)
						{
							if (!bytesTotalCache.exists(name))
							{
								bytesTotalCache.set(name, total);
								bytesTotal += (total - 200);
							}

							if (loaded > total) loaded = total;

							if (!bytesLoadedCache2.exists(name))
							{
								bytesLoaded += loaded;
							}
							else
							{
								bytesLoaded += loaded - bytesLoadedCache2.get(name);
							}

							bytesLoadedCache2.set(name, loaded);

							if (!simulateProgress)
							{
								onProgress.dispatch(bytesLoaded, bytesTotal);
							}
						}
					})
					.onComplete(function(library)
					{
						var total = 200;

						if (bytesTotalCache.exists(name))
						{
							total = bytesTotalCache.get(name);
						}

						if (!bytesLoadedCache2.exists(name))
						{
							bytesLoaded += total;
						}
						else
						{
							bytesLoaded += total - bytesLoadedCache2.get(name);
						}

						loadedAssetLibrary(name);
					})
					.onError(function(e)
					{
						Log.error(e);
					});
			}
		}

		if (!simulateProgress && loadedLibraries == (libraries.length + libraryNames.length))
		{
			if (!preloadComplete)
			{
				preloadComplete = true;

				Log.verbose("Preload complete");
			}

			start();
		}
	}
}
#end
