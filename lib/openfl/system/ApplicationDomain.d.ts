declare namespace openfl.system {
	
	
	/*@:final*/ export class ApplicationDomain {
		
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10) public static var MIN_DOMAIN_MEMORY_LENGTH (default, null):UInt;
		// #end
		
		public static readonly currentDomain:ApplicationDomain;
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash10) public var domainMemory:ByteArray;
		// #end
		
		public readonly parentDomain:ApplicationDomain;
		
		
		public constructor (parentDomain?:ApplicationDomain);
		public getDefinition (name:string):any;
		
		// #if flash
		// @:noCompletion @:dox(hide) @:require(flash11_3) getQualifiedDefinitionNames() : flash.Vector<String>;
		// #end
		
		public hasDefinition (name:string):boolean;
		
		
	}
	
	
}


export default openfl.system.ApplicationDomain;