/* ----------------------------------------------------------------------------
Function: bc_areaBoundary_fnc_checkBoundsPFH
Description:
    Internal function. Function called every 5 seconds in a CBA perFrameHandler. Checks to see if the player is out of bounds. Added in postInit.
---------------------------------------------------------------------------- */
#include "script_component.hpp"
params ["_args","_handle"];
private ["_args","_handle"];

// Prevent bounds from being checked during briefing, no point
if !(time > 0) exitWith {};

// Remove PFH if a non-client happens to get here
if (!hasInterface) then {[_handle] call CBA_fnc_removePerFrameHandler;};

// Make sure disableBoundaries is always boolean
if (IS_BOOL(GVAR(disableBoundaries))) then {
    // If mission maker sets 'bc_areaBoundary_disableBoundaries' to true then exit the PFH.
    if (GVAR(disableBoundaries)) then {
        // Remove cutText in case the module gets disabled while somebody is out of bounds
        5005 cutText ["","PLAIN",0,true];
        5005 cutFadeOut 1;
        [_handle] call CBA_fnc_removePerFrameHandler;
    };
} else {
    GVAR(disableBoundaries) = false;
};

// Check bounds only if there are boundaries created
if (count GVAR(areaList) > 0) then {
    {
        _x params ["_name","_sides","_positions","_isInclusive","_allowAirVeh","_allowLandVeh","_customVariables","_customDelay","_customMessage","_type","_warnCount"];
        switch (_type) do {
            // Trigger
            case 1: {[_name,_sides,_positions,_isInclusive,_allowAirVeh,_allowLandVeh,_customVariables,_customDelay,_customMessage,_warnCount] call FUNC(singlePosCheck);};
            // Marker
            case 2: {[_name,_sides,_positions,_isInclusive,_allowAirVeh,_allowLandVeh,_customVariables,_customDelay,_customMessage,_warnCount] call FUNC(singlePosCheck);};
            // Position Array
            case 3: {[_name,_sides,_positions,_isInclusive,_allowAirVeh,_allowLandVeh,_customVariables,_customDelay,_customMessage,_warnCount] call FUNC(multiPosCheck);};
        };
    } forEach GVAR(areaListFull);
};
