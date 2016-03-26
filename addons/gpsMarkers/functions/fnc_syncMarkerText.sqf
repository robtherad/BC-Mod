/* ----------------------------------------------------------------------------
Function: bc_gpsMarkers_fnc_syncMarkerText
Description:
    Updates the marker text for groups or vehicles from their attached variables after the markers have already been created.
Parameters:
    _object - a unit, group, or array containing units and/or groups whose marker text's should be updated to refelect their new values <OBJECT> or <GROUP> or <ARRAY>
Examples:
    (begin example)
        [player] call bc_gpsMarkers_fnc_syncMarkerText;
        [group player,allGroups select 5] call bc_gpsMarkers_fnc_syncMarkerText;
    (end)
---------------------------------------------------------------------------- */
#include "script_component.hpp"
params [
    ["_object", nil, [objNull, grpNull, []], []]
];
private ["_marker", "_markerText", "_objectArray"];

if (!hasInterface) exitWith {};

if (IS_ARRAY(_object)) then {
    _objectArray = _object;
} else {
    _objectArray = [_object];
};

fnc_setMarkerText = {
    if (IS_GROUP(_x)) then {
        _marker = _x getVariable [QGVAR(markerName), nil];
        if (!isNil "_marker") then {
            _markerText = _x getVariable [QGVAR(markerText), (markerText _marker)];
            _marker setMarkerTextLocal _markerText;
        };
    } else {
        if (_x isKindOf "Man") then {
            _group = group _x;
            _marker = _group getVariable [QGVAR(markerName), nil];
            if (!isNil "_marker") then {
                _markerText = _group getVariable [QGVAR(markerText), (markerText _marker)];
                _marker setMarkerTextLocal _markerText;
            };
        } else {
            _marker = _group getVariable [QGVAR(markerName), nil];
            if (!isNil "_marker") then {
                _markerText = _group getVariable [QGVAR(vehMarkerText), (markerText _marker)];
                _marker setMarkerTextLocal _markerText;
            };
        };
    };
};

{   
    if (IS_GROUP(_x)) then {
        {
            _x call fnc_setMarkerText;
        } forEach _x;
    } else {
        _x call fnc_setMarkerText;
    };
} forEach _objectArray;