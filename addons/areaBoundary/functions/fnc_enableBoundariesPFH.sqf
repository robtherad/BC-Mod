/* ----------------------------------------------------------------------------
Function: bc_areaBoundary_fnc_enableBoundariesPFH
Description:
    Internal function. Function called every second in a CBA perFrameHandler. Gets added by enableBoundaries.
---------------------------------------------------------------------------- */
#include "script_component.hpp"
private ["_args","_handle","_removeTime"];
params ["_args","_handle"];
_args params ["_removeTime"];

if (diag_tickTime >= _removeTime) then {
    [_handle] call CBA_fnc_removePerFrameHandler;
    GVAR(disableBoundaries) = false;
    if (hasInterface) then {[FUNC(checkBoundsPFH), 5, []] call CBA_fnc_addPerFrameHandler;};
} else {
    GVAR(disableBoundaries) = true;
};
