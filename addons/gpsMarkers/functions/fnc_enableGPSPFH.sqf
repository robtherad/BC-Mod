/* ----------------------------------------------------------------------------
Function: bc_gpsMarkers_enableGPSPFH
Description:
    Internal function. Function called every second in a CBA perFrameHandler. Gets added by bc_gpsMarkers_enableGPS
---------------------------------------------------------------------------- */
#include "script_component.hpp"
private ["_args","_handle","_removeTime"];
params ["_args","_handle"];
_args params ["_removeTime"];

if (diag_tickTime >= _removeTime) then {
    [_handle] call CBA_fnc_removePerFrameHandler;
    GVAR(disableGPS) = false;
    [FUNC(updatePFH), 2.5, []] call CBA_fnc_addPerFrameHandler;
} else {
    GVAR(disableGPS) = true;
};
