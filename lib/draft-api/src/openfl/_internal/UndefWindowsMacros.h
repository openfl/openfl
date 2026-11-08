/*
 * windows.h (via wincontypes.h and wingdi.h) defines these as integer
 * constants. The draft-api .cpp files are #included into a Haxe translation
 * unit, which then parses OpenFL headers that declare fields of the same
 * names (MouseEvent.DOUBLE_CLICK, ErrorEvent.ERROR).
 */
#ifdef DOUBLE_CLICK
#undef DOUBLE_CLICK
#endif
#ifdef MOUSE_MOVED
#undef MOUSE_MOVED
#endif
#ifdef MOUSE_WHEELED
#undef MOUSE_WHEELED
#endif
#ifdef MOUSE_HWHEELED
#undef MOUSE_HWHEELED
#endif
#ifdef ERROR
#undef ERROR
#endif
