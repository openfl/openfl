namespace openfl._internal.backend.lime_standalone;

@: enum abstract HTTPRequestMethod(String) from String to String
{
	public DELETE = "DELETE";
	public GET = "GET";
	public HEAD = "HEAD";
	public OPTIONS = "OPTIONS";
	public POST = "POST";
	public PUT = "PUT";
}
