#include <Windows.h>
#include <iostream>

WNDPROC gCurrentWndProc = nullptr;
Dynamic gMenuSelectCallback = nullptr;

LRESULT CALLBACK MenuWndProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
{
	switch (message)
	{
		case WM_COMMAND:
			// Handle system tray icon events
			 if (HIWORD(wParam) == 0) {
                // Low word of wParam contains the menu item ID
                UINT menuItemID = LOWORD(wParam); 
				gMenuSelectCallback(menuItemID);
            }
			break;
		// Handle other messages as needed
		default:
			return CallWindowProc(gCurrentWndProc, hWnd, message, wParam, lParam);
	}
	return 0;
}

extern "C" HWND intToHWND(int value)
{
	return reinterpret_cast<HWND>(static_cast<intptr_t>(value));
}

void setupPopupMenu(HMENU hMenu, hx::ObjectPtr<hx::Object> menuData)
{
	Dynamic data = menuData;

	std::cout << "function start" << (data == nullptr) << std::endl;

	Array<hx::ObjectPtr<hx::Object>> items = menuData->__Field(HX_CSTRING("items"), hx::paccAlways);

	std::cout << "before null pointer check" << std::endl;
	if (items != null())
	{
		int length = items->__Field(HX_CSTRING("length"), hx::paccAlways);

		std::cout << "before the loop" << std::endl;
		
		for (int i = 0; i < length; ++i)
		{
			hx::ObjectPtr<hx::Object> menuItemData = items[i];
			
			UINT menuItemID = menuItemData->__Field(HX_CSTRING("_id"), hx::paccAlways);
			String itemLabel = menuItemData->__Field(HX_CSTRING("label"), hx::paccAlways);
			bool checked = menuItemData->__Field(HX_CSTRING("checked"), hx::paccAlways);
			bool enabled = menuItemData->__Field(HX_CSTRING("enabled"), hx::paccAlways);
			bool isSeparator = menuItemData->__Field(HX_CSTRING("isSeparator"), hx::paccAlways);
			Dynamic keyEquivalent = menuItemData->__Field(HX_CSTRING("keyEquivalent"), hx::paccAlways);
			int mnemonicIndex = menuItemData->__Field(HX_CSTRING("mnemonicIndex"), hx::paccAlways);
			Dynamic submenu = menuItemData->__Field(HX_CSTRING("submenu"), hx::paccAlways);
	
			String l1 = itemLabel.substring(0, mnemonicIndex);
			String l2 = itemLabel.substring(mnemonicIndex, itemLabel.length);
			String amp = "&";
			
			String label = l1 + amp + l2;

			// Ensure a unique identifier for each menu item			

			if (isSeparator)
			{
				// Add a separator
				AppendMenu(hMenu, MF_SEPARATOR, 0, nullptr);
			}
			else
			{
				// Add a regular menu item
				UINT uFlags = MF_STRING;

				if (checked)
				{
					uFlags |= MF_CHECKED;
				}

				if (!enabled)
				{
					uFlags |= MF_GRAYED;
				}

				if (keyEquivalent != null())
				{
					String sKeyEquivalent = keyEquivalent;
					
					if (sKeyEquivalent.length != 0)
					{
						
						// Append the keyboard shortcut to the label
						String modifier = "\tCtrl+";
						label += modifier + sKeyEquivalent;
					}
				}

				if (submenu != null())
				{
					uFlags |= MF_POPUP;

					std::cout << label << "gotosubmenu" << label << std::endl;
					// If a submenu is specified, recursively add it
					HMENU hSubMenu = CreateMenu();
					setupPopupMenu(hSubMenu, submenu);

					AppendMenu(hMenu, uFlags, (UINT_PTR)hSubMenu, label.c_str());

				}
				else
				{
					// Attach the menu item ID as the last parameter
					AppendMenu(hMenu, uFlags, menuItemID, label.c_str());					
				}
			}
		}
	}
}

extern "C" bool menuUtil_showPopupMenu(int hWndID, hx::ObjectPtr<hx::Object> menuData, int x, int y)
{
	HWND hWnd = intToHWND(hWndID);

	if (hWnd == nullptr)
	{
		return false;
	}

	HMENU hMenu = CreatePopupMenu();

	setupPopupMenu(hMenu, menuData);
	
	TrackPopupMenu(hMenu, TPM_LEFTALIGN | TPM_TOPALIGN, x, y, 0, hWnd, nullptr);
	
	DestroyMenu(hMenu);
	
	
	return true;
	
	/*HWND hWnd = intToHWND(hWndID);

	if (hWnd == nullptr)
	{
		return false;
	}

	HMENU hPopupMenu = CreatePopupMenu();

	Array<hx::ObjectPtr<hx::Object>> items = menuData->__Field(HX_CSTRING("items"), hx::paccAlways);

	int length = items->__Field(HX_CSTRING("length"), hx::paccAlways);
	//std::cout << length << "ok" << std::endl;
	for (int i = 0; i < length; ++i)
	{
		hx::ObjectPtr<hx::Object> menuItemData = items[i];

		String label = menuItemData->__Field(HX_CSTRING("label"), hx::paccAlways);
		bool checked = menuItemData->__Field(HX_CSTRING("checked"), hx::paccAlways);
		bool enabled = menuItemData->__Field(HX_CSTRING("enabled"), hx::paccAlways);
		bool isSeparator = menuItemData->__Field(HX_CSTRING("isSeparator"), hx::paccAlways);

		LPSTR lpstr = new char[label.length + 1];
		strcpy(lpstr, label.c_str());

		MENUITEMINFO menuItemInfo = { sizeof(MENUITEMINFO) };
		menuItemInfo.fMask = MIIM_ID | MIIM_STRING | MIIM_STATE | MIIM_SUBMENU;
		menuItemInfo.wID = i + 1;  // Use a unique identifier (add 1 to avoid 0 conflict)
		menuItemInfo.dwTypeData = lpstr;

		if (isSeparator)
		{
			menuItemInfo.fType = MFT_SEPARATOR;
		}
		else
		{
			menuItemInfo.fType = MFT_STRING;
			
			if (checked)
			{
				menuItemInfo.fState |= MFS_CHECKED;
			}

			if (enabled)
			{
				menuItemInfo.fState |= MFS_ENABLED;
			}
		}

		// Add the menu item to the popup menu
		InsertMenuItem(hPopupMenu, i, TRUE, &menuItemInfo);

		// Free the allocated memory for the label
		delete[] lpstr;*/
	//}

// Show the popup menu
	/*TrackPopupMenu(hPopupMenu, TPM_LEFTALIGN | TPM_TOPALIGN, x, y, 0, hWnd, nullptr);

	DestroyMenu(hPopupMenu);
	SetMenu(hWnd, hPopupMenu);
	return true;*/
}

extern "C" bool menuUtil_showPopupMenuAtCursorPos(int hWndID, hx::ObjectPtr<hx::Object> menuData)
{

	HWND hWnd = intToHWND(hWndID);

	if (hWnd == nullptr)
	{
		return false;
	}

	POINT cursorPos;
	if (!GetCursorPos(&cursorPos))
	{
		return false;
	}

	int x = cursorPos.x;
	int y = cursorPos.y;

	menuUtil_showPopupMenu(hWndID, menuData, x, y);

	return true;
}

void setupSystemMenu(HMENU hSystemMenu, hx::ObjectPtr<hx::Object> menuData)
{
	Dynamic data = menuData;

	std::cout << "function start" << (data == nullptr) << std::endl;

	Array<hx::ObjectPtr<hx::Object>> items = menuData->__Field(HX_CSTRING("items"), hx::paccAlways);

	std::cout << "before null pointer check" << std::endl;
	if (items != null())
	{
		int length = items->__Field(HX_CSTRING("length"), hx::paccAlways);

		std::cout << "before the loop" << std::endl;
		
		for (int i = 0; i < length; ++i)
		{
			hx::ObjectPtr<hx::Object> menuItemData = items[i];
			
			UINT menuItemID = menuItemData->__Field(HX_CSTRING("_id"), hx::paccAlways);
			String itemLabel = menuItemData->__Field(HX_CSTRING("label"), hx::paccAlways);
			bool checked = menuItemData->__Field(HX_CSTRING("checked"), hx::paccAlways);
			bool enabled = menuItemData->__Field(HX_CSTRING("enabled"), hx::paccAlways);
			bool isSeparator = menuItemData->__Field(HX_CSTRING("isSeparator"), hx::paccAlways);
			Dynamic keyEquivalent = menuItemData->__Field(HX_CSTRING("keyEquivalent"), hx::paccAlways);
			int mnemonicIndex = menuItemData->__Field(HX_CSTRING("mnemonicIndex"), hx::paccAlways);
			Dynamic submenu = menuItemData->__Field(HX_CSTRING("submenu"), hx::paccAlways);
	
			String l1 = itemLabel.substring(0, mnemonicIndex);
			String l2 = itemLabel.substring(mnemonicIndex, itemLabel.length);
			String amp = "&";
			
			String label = l1 + amp + l2;

			// Ensure a unique identifier for each menu item			

			if (isSeparator)
			{
				// Add a separator
				AppendMenu(hSystemMenu, MF_SEPARATOR, 0, nullptr);
			}
			else
			{
				// Add a regular menu item
				UINT uFlags = MF_STRING;

				if (checked)
				{
					uFlags |= MF_CHECKED;
				}

				if (!enabled)
				{
					uFlags |= MF_GRAYED;
				}

				if (keyEquivalent != null())
				{
					String sKeyEquivalent = keyEquivalent;
					
					if (sKeyEquivalent.length != 0)
					{
						
						// Append the keyboard shortcut to the label
						String modifier = "\tCtrl+";
						label += modifier + sKeyEquivalent;
					}
				}

				if (submenu != null())
				{
					uFlags |= MF_POPUP;

					std::cout << label << "gotosubmenu" << label << std::endl;
					// If a submenu is specified, recursively add it
					HMENU hSubMenu = CreateMenu();
					setupSystemMenu(hSubMenu, submenu);

					AppendMenu(hSystemMenu, uFlags, (UINT_PTR)hSubMenu, label.c_str());

				}
				else
				{
					// Attach the menu item ID as the last parameter
					AppendMenu(hSystemMenu, uFlags, menuItemID, label.c_str());					
				}
			}
		}
	}

}

extern "C" bool menuUtil_addSystemMenu(int hWndID, hx::ObjectPtr<hx::Object> menuData)
{
	HWND hWnd = intToHWND(hWndID);

	if (hWnd == nullptr)
	{
		return false;
	}

	HMENU hSystemMenu = GetSystemMenu(hWnd, FALSE);

	if (hSystemMenu != nullptr)
	{
		DestroyMenu(hSystemMenu);
	}

	hSystemMenu = CreateMenu();

	setupSystemMenu(hSystemMenu, menuData);

	SetMenu(hWnd, hSystemMenu);

	return true;
}

extern "C" bool menuUtil_addContextMenuListener(int hWndID, Dynamic callback)
{
	HWND hWnd = intToHWND(hWndID);

	if (hWnd == nullptr)
	{
		return false;
	}
	
	gMenuSelectCallback = callback;
	
	gCurrentWndProc = (WNDPROC)GetWindowLongPtr(hWnd, GWLP_WNDPROC);
	// Set the new window procedure
	SetWindowLongPtr(hWnd, GWLP_WNDPROC, (LONG_PTR)MenuWndProc);
	
	return true;
}