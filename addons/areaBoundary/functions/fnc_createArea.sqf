/* ----------------------------------------------------------------------------
Function: bc_gpsMarkers_fnc_createMarker
Description:
    Internal function. Handles creating an area for the boundary script.
---------------------------------------------------------------------------- */
#include "script_component.hpp"
params ["_name","_sides","_positions","_isInclusive","_allowAirVeh","_allowLandVeh","_customVariables","_customDelay","_customMessage","_type"];

// Convert _positions ARRAY to use all coordinates instead of mix
if (_type isEqualTo 3) then {
    {
        if (IS_STRING(_x)) then {
            _positions set [_forEachIndex,getMarkerPos _x];
        };
    } forEach _positions;
};

GVAR(areaList) pushBackUnique _name;
GVAR(areaListFull) pushBackUnique [_name,_sides,_positions,_isInclusive,_allowAirVeh,_allowLandVeh,_customVariables,_customDelay,_customMessage,_type,0];