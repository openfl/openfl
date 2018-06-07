import URLRequest from "./URLRequest";


declare namespace openfl.net {
	
	export function navigateToURL (request:URLRequest, window?:string):void;
	
}


export default openfl.net.navigateToURL;