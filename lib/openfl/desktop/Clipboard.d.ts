declare namespace openfl.desktop {

export class Clipboard {

	constructor();
	formats:any;
	__htmlText:any;
	__richText:any;
	__systemClipboard:any;
	__text:any;
	clear():any;
	clearData(format:any):any;
	getData(format:any, transferMode?:any):any;
	hasFormat(format:any):any;
	setData(format:any, data:any, serializable?:any):any;
	setDataHandler(format:any, handler:any, serializable?:any):any;
	get_formats():any;
	static generalClipboard:any;
	static __generalClipboard:any;
	static get_generalClipboard():any;


}

}

export default openfl.desktop.Clipboard;