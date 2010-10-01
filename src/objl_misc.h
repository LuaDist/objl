/* objl_misc.h
 * Miscellaneous functions for coding Lua and ObjL C API packages.
 * (c) 2006 John Ohno
 * Licensed under the GNU LGPL
 *
 * A part of the ObjL package
 *
 */

void setuserdata(lua_State *L, void x) {
	void *y=lua_newuserdata(L, sizeof(x));
	y=x;
}

void loadlibs(lua_State *L, static struct luaL_reg** libs, const char** names, int count) {
	int i;
	for (i=0; i<count; i++) {
		luaL_openlib(L, names[i], libs[i]);
		lua_setfield(L, -2, names[i]);
	}
}


