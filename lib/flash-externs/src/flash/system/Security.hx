package flash.system;

#if flash
extern class Security
{
	#if (haxe_ver < 4.3)
	@:require(flash10_1) public static var APPLICATION(default, never):String;
	public static var LOCAL_TRUSTED(default, never):String;
	public static var LOCAL_WITH_FILE(default, never):String;
	public static var LOCAL_WITH_NETWORK(default, never):String;
	public static var REMOTE(default, never):String;
	public static var disableAVM1Loading:Bool;
	public static var exactSettings:Bool;
	@:require(flash11) public static var pageDomain(default, never):String;
	public static var sandboxType(default, never):String;
	#else
	@:require(flash10_1) static final APPLICATION:String;
	static final LOCAL_TRUSTED:String;
	static final LOCAL_WITH_FILE:String;
	static final LOCAL_WITH_NETWORK:String;
	static final REMOTE:String;
	@:flash.property static var disableAVM1Loading(get, set):Bool;
	@:flash.property static var exactSettings(get, set):Bool;
	@:flash.property @:require(flash11) static var pageDomain(get, never):String;
	@:flash.property static var sandboxType(get, never):String;
	#end

	public static function allowDomain(?p1:Dynamic, ?p2:Dynamic, ?p3:Dynamic, ?p4:Dynamic, ?p5:Dynamic):Void;
	public static function allowInsecureDomain(?p1:Dynamic, ?p2:Dynamic, ?p3:Dynamic, ?p4:Dynamic, ?p5:Dynamic):Void;
	#if (haxe_ver < 4.3)
	@:require(flash10_1) public static function duplicateSandboxBridgeInputArguments(toplevel:Dynamic, args:Array<Dynamic>):Array<Dynamic>;
	@:require(flash10_1) public static function duplicateSandboxBridgeOutputArgument(toplevel:Dynamic, arg:Dynamic):Dynamic;
	#else
	@:ns("flash.system", internal) @:require(flash10_1) static function duplicateSandboxBridgeInputArguments(toplevel:Dynamic,
		args:Array<Dynamic>):Array<Dynamic>;
	@:ns("flash.system", internal) @:require(flash10_1) static function duplicateSandboxBridgeOutputArgument(toplevel:Dynamic, arg:Dynamic):Dynamic;
	#end
	public static function loadPolicyFile(url:String):Void;
	public static function showSettings(panel:flash.system.SecurityPanel = null):Void;

	#if (haxe_ver >= 4.3)
	private static function get_disableAVM1Loading():Bool;
	private static function get_exactSettings():Bool;
	private static function get_pageDomain():String;
	private static function get_sandboxType():String;
	private static function set_disableAVM1Loading(value:Bool):Bool;
	private static function set_exactSettings(value:Bool):Bool;
	#end
}
#else
typedef Security = openfl.system.Security;
#end
