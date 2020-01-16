package openfl.display;

#if !flash
#if (!openfl_doc_gen || flash_doc_gen)
import haxe.Constraints.Function;
import openfl.errors.ArgumentError;

/**
	AVM1Movie is a simple class that represents AVM1 movie clips, which use
	ActionScript 1.0 or 2.0. (AVM1 is the ActionScript virtual machine used
	to run ActionScript 1.0 and 2.0. AVM2 is the ActionScript virtual machine
	used to run ActionScript 3.0.) When a Flash Player 8, or older, SWF file
	is loaded by a Loader object, an AVM1Movie object is created. The AVM1Movie
	object can use methods and properties inherited from the DisplayObject
	class (such as `x`, `y`, `width`, and so on). However, no interoperability
	(such as calling methods or using parameters) between the AVM1Movie object
	and AVM2 objects is allowed.

	There are several restrictions on an AVM1 SWF file loaded by an AVM2 SWF file:

	* The loaded AVM1Movie object operates as a psuedo-root object for the
	 AVM1 SWF file and all AVM1 SWF files loaded by it (as if the ActionScript
	 1.0 `lockroot` property were set to `true`). The AVM1 movie is always the top
	 of any ActionScript 1.0 or 2.0 code execution in any children. The `_root`
	 property for loaded children is always this AVM1 SWF file, unless the
	 lockroot property is set in a loaded AVM1 SWF file.
	* The AVM1 content cannot load files into levels. For example, it cannot load
	files by calling `loadMovieNum("url", levelNum)`.
	* The AVM1 SWF file that is loaded by an AVM2 SWF file cannot load another
	SWF file into this. That is, it cannot load another SWF file over itself.
	However, child Sprite objects, MovieClip objects, or other AVM1 SWF files
	loaded by this SWF file can load into this.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@SuppressWarnings("checkstyle:Dynamic")
class AVM1Movie extends DisplayObject
{
	@:noCompletion private function new()
	{
		super();
		throw new ArgumentError("Error #2012: AVM1Movie$ class cannot be instantiated.");
	}

	/**
		Undocumented method
	**/
	@:noCompletion @:dox(hide) public function addCallback(functionName:String, closure:Function):Void {}

	/**
		Undocumented method
	**/
	@:noCompletion @:dox(hide)
	public function call(functionName:String, p1:Dynamic = null, p2:Dynamic = null, p3:Dynamic = null, p4:Dynamic = null, p5:Dynamic = null):Dynamic
	{
		return null;
	}
}
#end
#else
typedef AVM1Movie = flash.display.AVM1Movie;
#end
