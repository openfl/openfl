package nme;


import openfl.Assets;


class AssetData {

	
	public static var className = new #if haxe3 Map <String, #else Hash <#end Dynamic> ();
	public static var library = new #if haxe3 Map <String, #else Hash <#end LibraryType> ();
	public static var type = new #if haxe3 Map <String, #else Hash <#end AssetType> ();
	
	private static var initialized:Bool = false;
	
	
	public static function initialize ():Void {
		
		if (!initialized) {
			
			::if (assets != null)::::foreach assets::::if (embed)::className.set ("::id::", nme.NME_::flatName::);
			type.set ("::id::", Reflect.field (AssetType, "::type::".toUpperCase ()));
			::end::::end::::end::
			::if (libraries != null)::::foreach libraries::library.set ("::name::", Reflect.field (LibraryType, "::type::".toUpperCase ()));
			::end::::end::
			initialized = true;
			
		}
		
	}
	
	
}


::foreach assets::::if (embed)::::if (type == "image")::class NME_::flatName:: extends flash.display.BitmapData { public function new () { super (0, 0); } }::else::class NME_::flatName:: extends ::flashClass:: { }::end::::end::
::end::