class Keystore {
	
	public var alias:String;
	public var aliasPassword:String;
	public var password:String;
	public var path:String;
	public var type:String;
	
	public function new (path:String, password:String = null, alias:String = null, aliasPassword:String = null) {
		
		this.path = path;
		this.password = password;
		this.alias = alias;
		this.aliasPassword = aliasPassword;
		
	}
	
	public function clone ():Keystore {
		
		return new Keystore (path, password, alias, aliasPassword);
		
	}
	
}