/**
	The URLLoaderDataFormat class provides values that specify how downloaded
	data is received.
**/
export enum URLLoaderDataFormat
{
	/**
		Specifies that downloaded data is received as raw binary data.
	**/
	BINARY = "binary",

	/**
		Specifies that downloaded data is received as text.
	**/
	TEXT = "text",

	/**
		Specifies that downloaded data is received as URL-encoded variables.
	**/
	VARIABLES = "variables"
}

export default URLLoaderDataFormat;
