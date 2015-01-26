package openfl._v2.filesystem; #if lime_legacy


class StorageVolume {
	
	
	public var drive (default, null):String;
	public var fileSystemType (default, null):String;
	public var isRemovable (default, null):Bool;
	public var isWritable (default, null):Bool;
	public var name (default, null):String;
	public var rootDirectory (default, null):File;
	
	
	public function new (rootDirectory:File, name:String, isWritable:Bool, isRemovable:Bool, fileSystemType:String, drive:String) {
		
		this.rootDirectory = rootDirectory;
		this.name = name;
		this.fileSystemType = fileSystemType;
		this.isRemovable = isRemovable;
		this.isWritable = isWritable;
		this.drive = drive;
		
		if (drive == "") drive = null;
		
	}
	
	
}


#end