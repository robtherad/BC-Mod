/* ----------------------------------------------------------------------------
Function: bc_gpsMarkers_addMarker
Description:
    Attempts to add a marker to a unit which will be tracked by the gpsMarkers module.
Parameters:
    _object - the unit <OBJECT>
    _sides - the side(s) the marker will be visible to <SIDE> OR <ARRAY> of <SIDE>s
Examples:
    (begin example)
        [player,west] call bc_gpsMarkers_addMarker;
        [player,[west,east]] call bc_gpsMarkers_addMarker;
    (end)
---------------------------------------------------------------------------- */
#include "script_component.hpp"
params ["_object","_sides"];
private ["_object","_sides","_type","_group","_errorFound"];

// Get type of object to figure out which marker to create
_type = false;
if (_object isKindOf "Man") then {_type = "Man";};
if (_object isKindOf "LandVehicle") then {_type = "LandVehicle";};
if (_object isKindOf "Helicopter") then {_type = "Helicopter";};
if (_object isKindOf "Plane") then {_type = "Plane";};

// Specific stuff for infantry markers
if (_type isEqualTo "Man") then {
    // Convert _object to _group if necessary
    if (_object isEqualTo EGVAR(common,GROUP)) then {
        _group = _object;
        _object = units _group select 0;
    } else {
        _group = group _object;
    };
} else {
    // Type of _object is not infantry, no group needed
    _group = grpNull;
};

// Error handling
_errorFound = false;
if !((_object isEqualType EGVAR(common,OBJECT)) OR (_object isEqualType EGVAR(common,GROUP))) then {
    diag_log format["[bc_gpsMarkers_addMarker] _object: Incorrect Type: %1",_object];
    _errorFound = true;
};

if !((_sides isEqualType EGVAR(common,ARRAY)) OR (_sides isEqualType EGVAR(common,SIDE))) then {
    diag_log format["[bc_gpsMarkers_addMarker] _sides: Incorrect Type: %1",_sides];
    _errorFound = true;
};
if (_sides isEqualType EGVAR(common,ARRAY)) then {
    {
        if !(_x isEqualType EGVAR(common,SIDE)) then {
            diag_log format["[bc_gpsMarkers_addMarker] _sides Array: Incorrect Type: %1 ::: %2",_sides, _x];
            _errorFound = true;
        };
    } forEach _sides;
};

if (_type isEqualType EGVAR(common,BOOL)) then {
    diag_log format["[bc_gpsMarkers_addMarker] _type: Unsupported Type %1",(type _object)];
    _errorFound = true; 
};

// Ensure there are no duplicates
if ((_type isEqualTo "Man") && (group _object in GVAR(trackedGroupsList))) then {
    diag_log format["[bc_gpsMarkers_addMarker] Marker already tracked: %1",_object];
    _errorFound = true;
};

if (!(_type isEqualTo "Man") && (_object in GVAR(trackedVehiclesList))) then {
    diag_log format["[bc_gpsMarkers_addMarker] Marker already tracked: %1",_object];
    _errorFound = true;
};

if (!hasInterface) then {
    diag_log "[bc_gpsMarkers_addMarker] No need to track markers on non-client";
    _errorFound = true;
};
if (_errorFound) exitWith {false};

// Call marker creation function
[_object,_sides,_type, _group] call FUNC(createMarker);
true