#include <Windows.h>
#include <iostream>
#include <shellapi.h>

#pragma comment(lib, "shell32.lib")

// Function to get the current mouse position in screen coordinates
Dynamic desktopUtil_getCursorPos()
{
	POINT cursorPos;

	// Get the current mouse position in screen coordinates
	if (GetCursorPos(&cursorPos))
	{
		Dynamic haxeArray = Array_obj<int>::__new();
		haxeArray->__Field(HX_CSTRING("push"), hx::paccDynamic)(cursorPos.x);
		haxeArray->__Field(HX_CSTRING("push"), hx::paccDynamic)(cursorPos.y);

		return haxeArray;
	}

	return nullptr;
}