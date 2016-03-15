/* ----------------------------------------------------------------------------
Function: bc_nametags_fnc_hideTags
Description:
    Call this function to stop showing nametags.
Examples:
    (begin example)
        call bc_nametags_fnc_hideTags;
    (end)
---------------------------------------------------------------------------- */
#include "script_component.hpp"

if (!hasInterface) exitWith {};

if (isNil QGVAR(tagHandle)) exitWith {BC_LOGERROR("hideTags: Script not running or PFH handle not saved");};

// Remove PFH
[GVAR(tagHandle)] call CBA_fnc_removePerFrameHandler;
GVAR(tagHandle) = nil;
