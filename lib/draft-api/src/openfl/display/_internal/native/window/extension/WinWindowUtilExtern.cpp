#include <Windows.h>
#include <iostream>
#include <dwmapi.h>
#include <functional>
#include <shellapi.h>
#include <tchar.h>

#pragma comment(lib, "shell32.lib")
#pragma comment(lib, "dwmapi.lib")

std::function<void(void)> gSystemTrayCallback = nullptr;
WNDPROC gOriginalWndProc = nullptr;
WNDPROC gSubWndProc = nullptr;
NOTIFYICONDATA nid;

COLORREF integerToCOLORREF(int colorInteger)
{
	// Extract individual color components
	int red = (colorInteger >> 16) & 0xFF;
	int green = (colorInteger >> 8) & 0xFF;
	int blue = colorInteger & 0xFF;

	// Create a COLORREF using RGB macro
	return RGB(red, green, blue);
}

HWND intToHWND(int value)
{
	return reinterpret_cast<HWND>(static_cast<intptr_t>(value));
}

extern "C" int windowUtil_getHWNDByName(String value)
{
	HWND hWnd = FindWindowA(nullptr, value);

	if (hWnd == nullptr)
	{
		return -1;
	}

	return reinterpret_cast<intptr_t>(hWnd);
}

extern "C" bool windowUtil_setTransparencyMask(int hWndID, int colorMask)
{

	HWND hWnd = intToHWND(hWndID);

	if (hWnd == nullptr)
	{
		return false;
	}

	LONG style = GetWindowLong(hWnd, GWL_STYLE);

	SetWindowLong(hWnd, GWL_STYLE, style | WS_OVERLAPPEDWINDOW);

	SetWindowLong(hWnd, GWL_EXSTYLE, GetWindowLong(hWnd, GWL_EXSTYLE) | WS_EX_LAYERED);

	COLORREF colorKey = integerToCOLORREF(colorMask);

	// Make the window transparent using the color key
	SetLayeredWindowAttributes(hWnd, colorKey, 0, LWA_COLORKEY);

	/*DWM_BLURBEHIND bb = { 0 };
	bb.dwFlags = DWM_BB_ENABLE;
	bb.fEnable = FALSE;
	DwmEnableBlurBehindWindow(hWnd, &bb);*/

	return true;
}

extern "C" bool windowUtil_removeTransparencyMask(int hWndID)
{
	HWND hWnd = intToHWND(hWndID);

	if (hWnd == nullptr)
	{
		return false;
	}

	SetWindowLong(hWnd, GWL_EXSTYLE, GetWindowLong(hWnd, GWL_EXSTYLE) & ~WS_EX_LAYERED);
	return true;
}

extern "C" bool windowUtil_setBlurBehindWindow(int hWndID, bool value)
{
	HWND hWnd = intToHWND(hWndID);

	if (hWnd == nullptr)
	{
		return false;
	}

	DWM_BLURBEHIND bb = { 0 };
	bb.dwFlags = DWM_BB_ENABLE;

	if (value)
	{
		bb.fEnable = TRUE;
	}
	else
	{
		bb.fEnable = FALSE;
	}

	DwmEnableBlurBehindWindow(hWnd, &bb);

	return false;
}

extern "C" bool windowUtil_setWindowOverlapped(int hWndID, bool value)
{
	HWND hWnd = intToHWND(hWndID);

	if (hWnd == nullptr)
	{
		return false;
	}

	LONG style = GetWindowLong(hWnd, GWL_STYLE);

	if ((style & WS_OVERLAPPEDWINDOW) == WS_OVERLAPPEDWINDOW)
	{
		if (!value)
		{
			SetWindowLong(hWnd, GWL_STYLE, style | WS_OVERLAPPEDWINDOW);
		}
	}
	else
	{
		if (value)
		{
			SetWindowLong(hWnd, GWL_STYLE, style & ~WS_OVERLAPPEDWINDOW);
			std::cout << "REMOVE!" << std::endl;
		}
	}

	return true;
}

LRESULT CALLBACK CustomWndProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
{
	switch (message)
	{
		case WM_USER + 1:
			// Handle system tray icon events
			switch (LOWORD(lParam))
			{
				case WM_RBUTTONDOWN:
					// Invoke the callback function when the right button is clicked
					if (gSystemTrayCallback)
					{
						gSystemTrayCallback();
					}
					break;
					// Handle other events as needed
			}
			break;
		// Handle other messages as needed
		default:
			return CallWindowProc(gOriginalWndProc, hWnd, message, wParam, lParam);
	}
}

void setupSystemTray(HWND hWnd, String name)
{

	HICON hIcon = LoadIcon(GetModuleHandle(NULL), MAKEINTRESOURCE(1)); // Replace IDI_MYICON with your icon resource

	nid.cbSize = sizeof(NOTIFYICONDATA);
	nid.hWnd = hWnd;  // Replace hWnd with your window handle
	nid.uID = 1;       // Unique identifier for the tray icon
	nid.uFlags = NIF_ICON | NIF_MESSAGE | NIF_TIP;
	nid.uCallbackMessage = WM_USER + 1;  // Custom message for tray icon events
	nid.hIcon = hIcon;
	_tcscpy_s(nid.szTip, _T(name));

	Shell_NotifyIcon(NIM_ADD, &nid);

	gOriginalWndProc = (WNDPROC)GetWindowLongPtr(hWnd, GWLP_WNDPROC);
	gSubWndProc = CustomWndProc;
	// Set the new window procedure
	SetWindowLongPtr(hWnd, GWLP_WNDPROC, (LONG_PTR)gSubWndProc);
}

extern "C" bool windowUtil_createSystemTray(int hWndID, Dynamic callback, String name)
{
	HWND hWnd = intToHWND(hWndID);

	if (hWnd == nullptr)
	{
		return false;
	}

	gSystemTrayCallback = callback;

	setupSystemTray(hWnd, name);

	return true;

}

extern "C" bool windowUtil_removeSystemTray(int hWndID)
{
	HWND hWnd = intToHWND(hWndID);

	if (hWnd == nullptr)
	{
		return false;
	}

	if (hWnd != nullptr)
	{
		NOTIFYICONDATA nid;
		nid.cbSize = sizeof(NOTIFYICONDATA);
		nid.hWnd = hWnd;
		nid.uID = 1; // The same identifier used when adding the icon

		// Remove the system tray icon
		Shell_NotifyIcon(NIM_DELETE, &nid);

		SetWindowLongPtr(hWnd, GWLP_WNDPROC, (LONG_PTR)gOriginalWndProc);

		gSystemTrayCallback = nullptr;
		gOriginalWndProc = nullptr;
	}
	
	return true;
}
//std::cout << "123Success!" << std::endl;