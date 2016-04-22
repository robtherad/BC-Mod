/* ----------------------------------------------------------------------------
Function: bc_areaBoundary_fnc_evalMulti
Description:
    Internal function. Called by checkBoundsPFH when area type is 3.
---------------------------------------------------------------------------- */
#include "script_component.hpp"
params ["_logic","_unit","_positions","_isInclusive","_allowAirVeh","_allowLandVeh","_customVariables","_customDelay","_customMessage","_execution"];

private _warnCount = player getVariable [QGVAR(warnCount),0];

// Check _unit type and see if it's not counted
if ((vehicle _unit) isKindOf "LandVehicle" && _allowLandVeh) exitWith {
    if (_unit isEqualTo player) then {QGVAR(textLayer) cutText ["","PLAIN",0,true];};
    if (_warnCount > 0) then {_unit setVariable [QGVAR(warnCount),0];};
};
if ((vehicle _unit) isKindOf "Air" && _allowAirVeh) exitWith {
    if (_unit isEqualTo player) then {QGVAR(textLayer) cutText ["","PLAIN",0,true];};
    if (_warnCount > 0) then {_unit setVariable [QGVAR(warnCount),0];};
};

// Check custom variables - Each one should be a string
private _checkOutEarly = false;
if (count _customVariables > 0) then {
    {
        private _value = missionNamespace getVariable [_x,true];
        if !(IS_BOOL(_value)) then {
            _customVariables set [_forEachIndex,true];
        } else {
            if !(_value) then {
                _checkOutEarly = true;
            };
        };
        if (_checkOutEarly) exitWith {};
    } forEach _customVariables;
};
if (_checkOutEarly) exitWith {
    if (_unit isEqualTo player) then {QGVAR(textLayer) cutText ["","PLAIN",0,true];};
    if (_warnCount > 0) then {_unit setVariable [QGVAR(warnCount),0];};
};

// Make sure _unit is alive, could have died from other boundary in the same loop through.
if !(alive _unit) exitWith{_deadUnits pushBack [_unit,_forEachIndex];};

private _playerInBounds = false;
if (count _positions > 1) then {
    _playerInBounds = (getPos _unit) inPolygon _positions;
} else {
    _playerInBounds = _unit inArea (_positions select 0);
};
if !(_isInclusive) then {
    // If _unit is supposed to be outside of the trigger, invert value
    _playerInBounds = !_playerInBounds;
};
if (_playerInBounds) exitWith {
    if (_unit isEqualTo player) then {QGVAR(textLayer) cutText ["","PLAIN",0,true];};
    if (_warnCount > 0) then {_unit setVariable [QGVAR(warnCount),0];};
};

// _unit is not where he's supposed to be
if !(_playerInBounds) then {
    if (_unit isEqualTo player) then {
        QGVAR(textLayer) cutText [_customMessage,"PLAIN",0,true];
        QGVAR(textLayer) cutFadeOut 200;
    };
    INC(_warnCount);
    _unit setVariable [QGVAR(warnCount),_warnCount];
    
    // _unit has been warned enough times, kill them
    if (_warnCount > _customDelay) then {
        if (_unit isEqualTo player) then {QGVAR(textLayer) cutText ["","PLAIN",0,true];};
        
        private _code = compile _execution;
        [_unit] call _code;
    };
};