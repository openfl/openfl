#if (!macro || !haxe3)
#if nme

import ::APP_MAIN_PACKAGE::::APP_MAIN_CLASS::;
import flash.display.DisplayObject;
import nme.Assets;
import nme.events.Event;

class ApplicationMain {

	static var mPreloader:::PRELOADER_NAME::;

	public static function main() {
		var call_real = true;
		
		nme.Lib.setPackage("::APP_COMPANY::", "::APP_FILE::", "::APP_PACKAGE::", "::APP_VERSION::");
		
		::if (PRELOADER_NAME!="")::
		var loaded:Int = nme.Lib.current.loaderInfo.bytesLoaded;
		var total:Int = nme.Lib.current.loaderInfo.bytesTotal;
		
		nme.Lib.current.stage.align = nme.display.StageAlign.TOP_LEFT;
		nme.Lib.current.stage.scaleMode = nme.display.StageScaleMode.NO_SCALE;
		
		if (loaded < total || true) /* Always wait for event */ {
			call_real = false;
			mPreloader = new ::PRELOADER_NAME::();
			nme.Lib.current.addChild(mPreloader);
			mPreloader.onInit();
			mPreloader.onUpdate(loaded,total);
			nme.Lib.current.addEventListener(nme.events.Event.ENTER_FRAME, onEnter);
		}
		::end::
		
		#if !fdb
		haxe.Log.trace = flashTrace;
		#end
		
		if (call_real)
			begin();
	}

	#if !fdb
	private static function flashTrace( v : Dynamic, ?pos : haxe.PosInfos ) {
		var className = pos.className.substr(pos.className.lastIndexOf('.') + 1);
		var message = className+"::"+pos.methodName+":"+pos.lineNumber+": " + v;
		
		if (flash.external.ExternalInterface.available)
			flash.external.ExternalInterface.call("console.log", message);
		else untyped flash.Boot.__trace(v, pos);
    }
	#end

	private static function begin() {
		var hasMain = false;
		for (methodName in Type.getClassFields(::APP_MAIN::))
		{
			if (methodName == "main")
			{
				hasMain = true;
				break;
			}
		}

		if (hasMain)
		{
			Reflect.callMethod (::APP_MAIN::, Reflect.field (::APP_MAIN::, "main"), []);
		}
		else
		{
			var instance = Type.createInstance(::APP_MAIN::, []);
			if (Std.is(instance, nme.display.DisplayObject)) {
				nme.Lib.current.addChild(cast instance);
			}
		}
	}

	static function onEnter(_) {
		var loaded = nme.Lib.current.loaderInfo.bytesLoaded;
		var total = nme.Lib.current.loaderInfo.bytesTotal;
		mPreloader.onUpdate(loaded,total);
		
		if (loaded >= total) {
			nme.Lib.current.removeEventListener(nme.events.Event.ENTER_FRAME, onEnter);
			mPreloader.addEventListener (Event.COMPLETE, preloader_onComplete);
			mPreloader.onLoaded();
		}
	}

	private static function preloader_onComplete(event:Event):Void {
		mPreloader.removeEventListener (Event.COMPLETE, preloader_onComplete);
		nme.Lib.current.removeChild(mPreloader);
		mPreloader = null;
		begin();
	}
}

#else

import ::APP_MAIN_PACKAGE::::APP_MAIN_CLASS::;

class ApplicationMain {
	
	public static function main() {
		
		var hasMain = false;
		
		for (methodName in Type.getClassFields(::APP_MAIN::))
		{
			if (methodName == "main")
			{
				hasMain = true;
				break;
			}
		}
		
		if (hasMain)
		{
			Reflect.callMethod(::APP_MAIN::, Reflect.field (::APP_MAIN::, "main"), []);
		}
		else
		{
			var instance = Type.createInstance(DocumentClass, []);
			if (Std.is(instance, flash.display.DisplayObject)) {
				flash.Lib.current.addChild(cast instance);
			}
		}
	}
}

#end

#if haxe3 @:build(DocumentClass.build()) #end
class DocumentClass extends ::APP_MAIN:: { }

#else

import haxe.macro.Context;
import haxe.macro.Expr;

class DocumentClass {
	
	macro public static function build ():Array<Field> {
		var classType = Context.getLocalClass().get();
		var searchTypes = classType;
		while (searchTypes.superClass != null) {
			if (searchTypes.pack.length == 2 && searchTypes.pack[1] == "display" && searchTypes.name == "DisplayObject") {
				var fields = Context.getBuildFields();
				var method = macro {
					return flash.Lib.current.stage;
				}
				fields.push ({ name: "get_stage", access: [ APrivate ], meta: [ { name: ":getter", params: [ macro stage ], pos: Context.currentPos() } ], kind: FFun({ args: [], expr: method, params: [], ret: macro :flash.display.Stage }), pos: Context.currentPos() });
				return fields;
			}
			searchTypes = searchTypes.superClass.t.get();
		}
		return null;
	}
	
}
#end