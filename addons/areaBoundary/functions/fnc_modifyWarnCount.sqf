/* ----------------------------------------------------------------------------
Function: bc_areaBoundary_fnc_modifyWarnCount
Description:
    Internal Function. Modifies the warning count for a particular area.
---------------------------------------------------------------------------- */
#include "script_component.hpp"
params ["_name","_warnCount"];
private["_index", "_indexFull"];

if (!hasInterface) exitWith {};

// Find supplied name in list.
_index = GVAR(areaList) find _name;

if (_index isEqualTo -1) exitWith {
    BC_LOGERROR_2("modifyWarnCount: Couldn't find _name in areaList - %1",_name,GVAR(areaList));
};

if ( ((GVAR(areaListFull) select _index) select 0) isEqualTo _name ) then {
    // Reset warning count
    (GVAR(areaListFull) select _index) set [9,_warnCount];
} else {
    // Name wasnt at same index in both containers, manually search 2nd container
    _indexFull = {
        if (_name isEqualTo _x select 0) exitWith {_forEachIndex};
    } forEach GVAR(areaListFull);
    
    if (!isNil "_indexFull") then {
        // Reset warning count
        (GVAR(areaListFull) select _indexFull) set [9,_warnCount];
    } else {
        // Couldn't find it.
        BC_LOGERROR_2("clearWarnCount: Unable to find name in areaListFull - %1 -- full: %2",_name,GVAR(areaListFull));
    };
};