import Sprite from "./../display/Sprite";
import Rectangle from "./../geom/Rectangle";
import PrintJobOptions from "./PrintJobOptions";
import PrintJobOrientation from "./PrintJobOrientation";


declare namespace openfl.printing {
	
	
	export class PrintJob {
		
		static readonly isSupported:boolean;
		
		orientation:PrintJobOrientation;
		readonly pageHeight:number;
		readonly pageWidth:number;
		readonly paperHeight:number;
		readonly paperWidth:number;
		
		constructor ();
		
		addPage (sprite:Sprite, printArea?:Rectangle, options?:PrintJobOptions, frameNum?:number):void;
		send ():void;
		start ():boolean;
		
	}
	
	
}


export default openfl.printing.PrintJob;