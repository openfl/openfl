import ApplicationDomain from "./ApplicationDomain";
import SecurityDomain from "./SecurityDomain";


declare namespace openfl.system {
	
	
	export class LoaderContext {
		
		
		public allowCodeImport:boolean;
		public allowLoadBytesCodeExecution:boolean;
		public applicationDomain:ApplicationDomain;
		public checkPolicyFile:boolean;
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash11) public imageDecodingPolicy:flash.system.ImageDecodingPolicy;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash11) public parameters:Dynamic;
		// #end
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash11) public requestedContentParent:DisplayObjectContainer;
		// #end
		
		public securityDomain:SecurityDomain;
		
		
		public constructor (checkPolicyFile?:boolean, applicationDomain?:ApplicationDomain, securityDomain?:SecurityDomain);
		
		
	}
	
	
}


export default openfl.system.LoaderContext;