/* ----------------------------------------------------------------------------
Function: bc_gpsMarkers_updatePFH
Description:
    Internal function. Function called every 2.5 seconds in a CBA perFrameHandler. Gets added by bc_gpsMarkers_enableGPSPFH at the end of it's PFH
Examples:
    (begin example)
        call bc_gpsMarkers_updatePFH;
    (end)
---------------------------------------------------------------------------- */
#include "script_component.hpp"
params ["_args","_handle"];
private ["_args","_handle"];

// Prevent markers from being drawn during briefing
if !(time > 0) exitWith {};

// Remove PFH if a non-client happens to get here
if (!hasInterface) then {[_handle] call CBA_fnc_removePerFrameHandler;};

// Make sure disableGPS is always boolean
if (GVAR(disableGPS) isEqualType EGVAR(common,BOOL)) then {
    // If mission maker sets 'bc_gpsMarkers_disableGPS' to true then exit the PFH.
    if (GVAR(disableGPS)) then {[_handle] call CBA_fnc_removePerFrameHandler;};
} else {
    GVAR(disableGPS) = false;
};

// Call functions to update marker positions only if there is something for them to update
// Make sure there are markers to update
if (count GVAR(trackedGroupsList) > 0) then {call FUNC(updateInfMarkers);};
if (count GVAR(trackedVehiclesList) > 0) then {call FUNC(updateVehMarkers);};
