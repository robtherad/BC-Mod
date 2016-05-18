/* ----------------------------------------------------------------------------
Function: bc_areaBoundary_fnc_multiPosCheck
Description:
    Internal function. Called by checkBoundsPFH when area type is 3.
---------------------------------------------------------------------------- */
#include "script_component.hpp"
params ["_args", "_handle"];
_args params ["_logic","_units","_positions","_isInclusive","_allowAirVeh","_allowLandVeh","_customVariables","_customDelay","_customMessage","_execution"];

private _unitList = _logic getVariable [QGVAR(unitList),nil];
private _unitListCount = count _unitList;
if (isNil "_unitList") then {
    _unitList = _units;
    _logic setVariable [QGVAR(unitList),_unitList];
};
private _deadUnits = [];
{
    if (local _x) then {
        [_logic,_x,_positions,_isInclusive,_allowAirVeh,_allowLandVeh,_customVariables,_customDelay,_customMessage,_execution] call FUNC(checkUnitBounds);
    } else {
        // TODO: Write a function to transfer ownership of script to unit's new locality
        // [_logic, _x, _positions, _isInclusive, _allowAirVeh, _allowLandVeh, _customVariables, _customDelay, _customMessage, _execution] call FUNC(changeOwner);
        // _unitList = _unitList - _x;
    };
} forEach _unitList;

if ( !(_unitListCount isEqualTo (count _unitList)) || {count _deadUnits > 0} ) then {
    _unitList = (_unitList - _deadUnits);
    _logic setVariable [QGVAR(unitList),_unitList];
};