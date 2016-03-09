// [<OBJ/GROUP>,<SIDE/ARRAY OF SIDES>] call bc_gpsMarkers_addMarker;
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
    diag_log "_type = MAN";
    // Convert _object to _group if necessary
    if (typeName _object isEqualTo "GROUP") then {
        diag_log "_object = GROUP";
        _group = _object;
        _object = units _group select 0;
    } else {
        diag_log "_object = MAN";
        _group = group _object;
    };
} else {
    // Type of _object is not infantry, no group needed
    _group = grpNull;
};

// Error handling
_errorFound = false;
if !((typeName _object isEqualTo "OBJECT") OR (typeName _object isEqualTo "GROUP")) then {
    diag_log format["[bc_gpsMarkers_addMarker] _object: Incorrect Type: %1",_object];
    _errorFound = true;
};

if !((typeName _sides isEqualTo "ARRAY") OR (typeName _sides isEqualTo "SIDE")) then {
    diag_log format["[bc_gpsMarkers_addMarker] _sides: Incorrect Type: %1",_sides];
    _errorFound = true;
};
if (typeName _sides isEqualTo "ARRAY") then {
    {
        if !(typeName _x isEqualTo "SIDE") then {
            diag_log format["[bc_gpsMarkers_addMarker] _sides Array: Incorrect Type: %1 ::: %2",_sides, _x];
            _errorFound = true;
        };
    } forEach _sides;
};

if (typeName _type isEqualTo "BOOL") then {
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
if (_errorFound) exitWith {};

// Call marker creation function
[_object,_sides,_type, _group] call FUNC(createMarker);