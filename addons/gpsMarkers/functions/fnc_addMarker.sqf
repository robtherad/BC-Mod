/* ----------------------------------------------------------------------------
Function: bc_gpsMarkers_fnc_addMarker
Description:
    Attempts to add a marker to a group which will be tracked by the gpsMarkers module.
Parameters:
    _object - a unit or a group <OBJECT> or <GROUP>
    _sides - the side(s) the marker will be visible to <SIDE> OR <ARRAY> of <SIDE>s
Optional Parameters:
    _name - the name used for the group's gps marker on the map <STRING>
Examples:
    (begin example)
        [player,west] call bc_gpsMarkers_fnc_addMarker;
        [group player,[west,east]] call bc_gpsMarkers_fnc_addMarker;
        [player, west, "A1"] call bc_gpsMarkers_fnc_addMarker;
    (end)
---------------------------------------------------------------------------- */
#include "script_component.hpp"
params [
    ["_object", nil, [objNull, grpNull]],
    ["_sides", nil, [sideUnknown, []], []],
    ["_name", nil, [""]]
];
private ["_object","_sides","_type","_group","_errorFound"];

// No need to add markers for non-humans
if (!hasInterface) exitWith {};

if (isNil "_object") exitWith {BC_LOGERROR("addMarker: nil Object");};
if (isNil "_sides") exitWith {BC_LOGERROR("addMarker: nil sides");};

// Make sure object is an object not a group
if (IS_GROUP(_object)) then {
    _group = _object;
    _object = units _group select 0;
};

// Get type of object to figure out which marker to create
_type = false;
if (_object isKindOf "Man") then {_type = "Man";};
if (_object isKindOf "LandVehicle") then {_type = "LandVehicle";};
if (_object isKindOf "Helicopter") then {_type = "Helicopter";};
if (_object isKindOf "Plane") then {_type = "Plane";};

// Define group variable.
if (_type isEqualTo "Man") then {
    if (isNil "_group") then {
        _group = group _object;
    };
} else {
    // Type of _object is not infantry, no group needed
    _group = grpNull;
};

// Error handling
_errorFound = false;
if !((IS_OBJECT(_object)) OR (IS_GROUP(_object))) then {
    BC_LOGERROR_1("addMarker: Incorrect Type for _object: %1",_object);
    _errorFound = true;
};

if !((IS_ARRAY(_sides)) OR (IS_SIDE(_sides))) then {
    BC_LOGERROR_1("addMarker: Incorrect Type for _sides: %1",_sides);
    _errorFound = true;
};
if (IS_ARRAY(_sides)) then {
    {
        if !(IS_SIDE(_x)) then {
            BC_LOGERROR_2("addMarker: Incorrect Type in _sides Array: %1 - %2",_sides, _x);
            _errorFound = true;
        };
    } forEach _sides;
};

if (IS_BOOL(_type)) then {
    BC_LOGERROR_1("addMarker: Unsupported Type for _type: %1",type _object);
    _errorFound = true; 
};

// Ensure there are no duplicates
if ((_type isEqualTo "Man") && (group _object in GVAR(trackedGroupsList))) then {
    BC_LOGERROR_1("addMarker: Infantry marker already tracked: %1",_object);
    _errorFound = true;
};

if (!(_type isEqualTo "Man") && (_object in GVAR(trackedVehiclesList))) then {
    BC_LOGERROR_1("addMarker: Vehicle marker already tracked: %1",_object);
    _errorFound = true;
};

if (_errorFound) exitWith {false};

// Call marker creation function
[_object,_sides,_type, _group, _name] call FUNC(createMarker);
true