package platforms;


interface IPlatformTool {
	
	
	public function build (project:NMEProject):Void;
	public function clean (project:NMEProject):Void;
	public function display (project:NMEProject):Void;
	public function install (project:NMEProject):Void;
	public function run (project:NMEProject, arguments:Array <String>):Void;
	public function trace (project:NMEProject):Void;
	public function uninstall (project:NMEProject):Void;
	public function update (project:NMEProject):Void;
	
	
}
