import EventDispatcher from "./../events/EventDispatcher";


declare namespace openfl.net {
	
	
	export class XMLSocket extends EventDispatcher {
		
		
		public readonly connected:boolean;
		public timeout:number;
		
		public constructor (host?:string, port?:number);
		public close ():void;
		public connect (host:string, port:number):void;
		public send (object:any):void;
		
		
	}
	
	
}


export default openfl.net.XMLSocket;