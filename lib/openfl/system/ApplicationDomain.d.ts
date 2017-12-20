
declare namespace openfl.system {

export class ApplicationDomain {

	constructor(parentDomain?:any);
	parentDomain:any;
	getDefinition(name:any):any;
	hasDefinition(name:any):any;
	static currentDomain:any;


}

}

export default openfl.system.ApplicationDomain;