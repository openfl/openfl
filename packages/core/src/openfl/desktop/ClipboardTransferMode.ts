/**
	The ClipboardTransferMode class defines constants for the modes used as
	values of the `transferMode` parameter of the `Clipboard.getData()`
	method.
	The transfer mode provides a hint about whether to return a reference or a
	copy when accessing an object contained on a clipboard.
**/
export enum ClipboardTransferMode
{
	/**
		The Clipboard object should only return a copy.
	**/
	CLONE_ONLY = "cloneOnly",

	/**
		The Clipboard object should return a copy if available and a reference if not.
	**/
	CLONE_PREFERRED = "clonePreferred",

	/**
		The Clipboard object should only return a reference.
	**/
	ORIGINAL_ONLY = "originalOnly",

	/**
		The Clipboard object should return a reference if available and a copy if not.
	**/
	ORIGINAL_PREFERRED = "originalPreferred"
}

export default ClipboardTransferMode;
