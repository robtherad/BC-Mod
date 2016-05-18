/* ----------------------------------------------------------------------------
Function: bc_objectives_fnc_addUnit
Description:
    Adds the passed unit to the unit list of the logic.
---------------------------------------------------------------------------- */
#include "script_component.hpp"
params ["_logic","_unit"];

_unitList = _logic getVariable "QGVAR(unitList)";

if (!isNil "_unitList") then {
    _unitList pushBackUnique _unit;
    _logic setVariable [QGVAR(unitList),_unitList];
};