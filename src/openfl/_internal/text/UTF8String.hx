package openfl._internal.text;

#if (haxe_ver >= "4.0.0")
typedef UTF8String = String;
#elseif lime
typedef UTF8String = lime.text.UTF8String;
#else
typedef UTF8String = UnicodeString;
#end