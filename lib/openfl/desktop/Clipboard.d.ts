// import Object from "openfl/utils/Object";
import ClipboardFormats from "./ClipboardFormats";
import ClipboardTransferMode from "./ClipboardTransferMode";


declare namespace openfl.desktop {
	
	
	export class Clipboard {
		
		
		public static readonly generalClipboard:Clipboard;
		
		public readonly formats:Array<ClipboardFormats>;
		
		public clear ():void;
		public clearData (format:ClipboardFormats):void;
		public getData (format:ClipboardFormats, transferMode?:ClipboardTransferMode):any;
		public hasFormat (format:ClipboardFormats):boolean;
		public setData (format:ClipboardFormats, data:any, serializable?:boolean):boolean;
		public setDataHandler (format:ClipboardFormats, handler:()=>any, serializable?:boolean):boolean;
		
		
	}
	
	
}


export default openfl.desktop.Clipboard;