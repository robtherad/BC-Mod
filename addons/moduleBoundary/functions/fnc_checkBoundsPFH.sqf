/* ----------------------------------------------------------------------------
Function: bc_areaBoundary_fnc_multiPosCheck
Description:
    Internal function. Called by checkBoundsPFH when area type is 3.
---------------------------------------------------------------------------- */
#include "script_component.hpp"
params ["_args", "_handle"];
_args params ["_logic","_units","_positions","_isInclusive","_allowAirVeh","_allowLandVeh","_customVariables","_customDelay","_customMessage","_execution"];

private _unitList = missionNamespace getVariable [QGVAR(unitList),nil];
if (isNil "_unitList") then {
    _unitList = _units;
    missionNamespace setVariable [QGVAR(unitList),_unitList];
};
private _deadUnits = [];
{
    [_logic,_x,_positions,_isInclusive,_allowAirVeh,_allowLandVeh,_customVariables,_customDelay,_customMessage,_execution] call FUNC(checkUnitBounds);
} forEach _unitList;

if (count _deadUnits > 0) then {
    _unitList = (_unitList - _deadUnits);
    missionNamespace setVariable [QGVAR(unitList),_unitList];
};