/* ----------------------------------------------------------------------------
Function: bc_areaBoundary_fnc_removeArea
Description:
    Attempts to remove an area boundary.
Parameters:
    _name - the name of the boundary to remove <STRING>
Examples:
    (begin example)
        ["My First Area"] call bc_areaBoundary_fnc_removeArea;
    (end)
---------------------------------------------------------------------------- */
#include "script_component.hpp"
params [
    ["_name", nil, [""]]
];
private["_index", "_indexFull"];

if (!hasInterface) exitWith {};

// Get type of object to figure out which marker to create
if !(IS_STRING(_name)) exitWith {
    BC_LOGERROR_1("removeArea: Given value not a string - %1",_name);
};

// Find supplied name in list.
_index = GVAR(areaList) find _name;

if (_index isEqualTo -1) exitWith {
    BC_LOGERROR_2("removeArea: Couldn't find _name in areaList - %1",_name,GVAR(areaList));
};

if ( ((GVAR(areaListFull) select _index) select 0) isEqualTo _name ) then {
    GVAR(areaList) deleteAt _index;
    GVAR(areaListFull) deleteAt _index;
} else {
    // Name wasnt at same index in both containers, manually search 2nd container
    _indexFull = {
        if (_name isEqualTo _x select 0) exitWith {_forEachIndex};
    } forEach GVAR(areaListFull);
    
    if (!isNil "_indexFull") then {
        // Found it!
        GVAR(areaList) deleteAt _index;
        GVAR(areaListFull) deleteAt _indexFull;
    } else {
        // Couldn't find it.
        BC_LOGERROR_2("removeArea: Unable to find name in areaListFull - %1 -- full: %2",_name,GVAR(areaListFull));
    };
};