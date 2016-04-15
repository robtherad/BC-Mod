/* ----------------------------------------------------------------------------
Function: bc_objectives_fnc_clientInit
Description:
    Activated from module init. Adds a CBA PFH to clients that handles the boundary scripts.
---------------------------------------------------------------------------- */
#include "script_component.hpp"

[FUNC(checkBoundsPFH), 5, _this] call CBA_fnc_addPerFrameHandler;