/* ----------------------------------------------------------------------------
Function: bc_gpsMarkers_fnc_removeMarker
Description:
    Attempts to remove a marker from a unit which is being tracked by the gpsMarkers module.
Parameters:
    _object - the object to stop tracking a marker for <OBJECT>
Examples:
    (begin example)
        [player] call bc_gpsMarkers_fnc_removeMarker;
    (end)
---------------------------------------------------------------------------- */
#include "script_component.hpp"
params [["_object", nil, [objNull,grpNull]]];
private ["_object","_type","_group","_errorFound","_indexList","_index","_markerName"];

if (!hasInterface) exitWith {};
if (isNil "_object") exitWith {};

// Get type of object to figure out which marker to create
_type = false;
if (_object isKindOf "Man") then {_type = "Man";};
if (_object isKindOf "LandVehicle") then {_type = "LandVehicle";};
if (_object isKindOf "Helicopter") then {_type = "Helicopter";};
if (_object isKindOf "Plane") then {_type = "Plane";};

// Specific stuff for infantry markers
if (_type isEqualTo "Man") then {
    // Convert _object to _group if necessary
    if (IS_GROUP(_object)) then {
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
if !((IS_OBJECT(_object)) OR (IS_GROUP(_object))) then {
    BC_LOGERROR_1("removeMarker: Incorrect Type for _object: %1",_object);
    _errorFound = true;
};

if (IS_BOOL(_type)) then {
    BC_LOGERROR_2("removeMarker: Unsupported Type for _object: OBJ(%1) - TYPE(%2)",_object, (type _object));
    _errorFound = true; 
};

// Ensure the values exist in the marker arrays
if ((_type isEqualTo "Man") && !(group _object in GVAR(trackedGroupsList))) then {
    BC_LOGERROR_1("removeMarker: Infantry marker not already tracked: %1",_object);
    _errorFound = true;
};

if (!(_type isEqualTo "Man") && !(_object in GVAR(trackedVehiclesList))) then {
    BC_LOGERROR_1("removeMarker: Vehicle marker not already tracked: %1",_object);
    _errorFound = true;
};

if (_errorFound) exitWith {};

// Use find command on List array and then use the same index to get the values out of the other array. If the values in the other array don't match up then send them back and run the find command on that array as well.
if ((_type isEqualTo "Man") && (group _object in GVAR(trackedGroupsList))) then {
    _indexList = GVAR(trackedGroupsList) find (group _object);
    
    // Make sure object is the same as the first value and the array sides is the same as the 3rd value
    if ( ((GVAR(trackedGroups) select _indexList) select 0) == (group _object) ) then {
        _markerName = ((GVAR(trackedGroups) select _indexList) select 1);
        deleteMarkerLocal _markerName;
        deleteMarkerLocal (_markerName + "Size");
        GVAR(trackedGroupsList) deleteAt _indexList;
        GVAR(trackedGroups) deleteAt _indexList;
        true
    } else {
        _index = { // forEach trackedGroups
            if ((group _object) == _x select 0) exitWith {_forEachIndex};
        } forEach GVAR(trackedGroups);
        
        if (!isNil "_index") then {
            _markerName = ((GVAR(trackedGroups) select _index) select 1);
            deleteMarkerLocal _markerName;
            deleteMarkerLocal (_markerName + "Size");
            GVAR(trackedGroupsList) deleteAt _indexList;
            GVAR(trackedGroups) deleteAt _index;
            true
        } else {
            BC_LOGERROR_1("removeMarker: Unable to find object in trackedGroups array - %1",_object);
            false
        };
    };
};

if (!(_type isEqualTo "Man") && !(_object in GVAR(trackedVehiclesList))) then {
    _indexList = GVAR(trackedVehiclesList) find _object;
    
    // Make sure object is the same as the first value and the array sides is the same as the 3rd value
    if ( ((GVAR(trackedVehicles) select _indexList) select 0) isEqualTo _object ) then {
        deleteMarkerLocal ((GVAR(trackedVehicles) select _indexList) select 1);
        deleteMarkerLocal (((GVAR(trackedVehicles) select _index) select 1) + "Size");
        GVAR(trackedVehiclesList) deleteAt _indexList;
        GVAR(trackedVehicles) deleteAt _indexList;
        true
    } else {
        _index = { // forEach trackedVehicles
            if (_object == _x select 0) exitWith {_forEachIndex};
        } forEach GVAR(trackedVehicles);
        
        if (!isNil "_index") then {
            deleteMarkerLocal ((GVAR(trackedVehicles) select _index) select 1);
            deleteMarkerLocal (((GVAR(trackedVehicles) select _index) select 1) + "Size");
            GVAR(trackedVehiclesList) deleteAt _indexList;
            GVAR(trackedVehicles) deleteAt _index;
            true
        } else {
            BC_LOGERROR_1("removeMarker: Unable to find object in trackedVehicles array - %1",_object);
            false
        };
    };
};