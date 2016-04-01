/* ----------------------------------------------------------------------------
Function: bc_gpsMarkers_fnc_syncMarkerText
Description:
    Updates the marker text for groups or vehicles from their attached variables after the markers have already been created.
Parameters:
    _object - a unit or a group or array of units and/or groups <OBJECT> or <GROUP> or <ARRAY>
    _sides - the side(s) the marker will be visible to <SIDE> OR <ARRAY> of <SIDE>s
Optional Parameters:
    _name - the name used for the group's gps marker on the map <STRING>
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

{   
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
} forEach _objectArray;