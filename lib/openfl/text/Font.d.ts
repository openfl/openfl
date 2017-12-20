
declare namespace openfl.text {

export class Font /*extends lime_text_Font*/ {

	constructor(name?:any);
	fontName:any;
	fontStyle:any;
	fontType:any;
	__initialized:any;
	__initialize():any;
	get_fontName():any;
	set_fontName(value:any):any;
	static __fontByName:any;
	static __registeredFonts:any;
	static enumerateFonts(enumerateDeviceFonts?:any):any;
	static fromBytes(bytes:any):any;
	static fromFile(path:any):any;
	static loadFromBytes (bytes:any):any;
	static loadFromFile (path:any):any;
	static loadFromName (path:any):any;
	static registerFont(font:any):any;
	static __fromLimeFont(value:any):any;


}

}

export default openfl.text.Font;