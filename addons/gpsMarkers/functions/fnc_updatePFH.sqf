#include "script_component.hpp"
params ["_args","_handle"];

// Prevent markers from being drawn during briefing
if !(time > 0) exitWith {};

// Remove PFH if a non-client happens to get here
if (!hasInterface) then {[_handle] call CBA_fnc_removePerFrameHandler;};

// If mission maker sets 'bc_gpsMarkers_disableGPS' to true then exit the PFH.
if (GVAR(disableGPS)) then {[_handle] call CBA_fnc_removePerFrameHandler;};

// Call functions to update marker positions only if there is something for them to update
// Make sure there are markers to update
if (count GVAR(trackedGroupsList) > 0) then {call FUNC(updateInfMarkers);diag_log "[updatePFH] - Called infMarkers";};
if (count GVAR(trackedVehiclesList) > 0) then {call FUNC(updateVehMarkers);diag_log "[updatePFH] - Called vehMarkers";};
