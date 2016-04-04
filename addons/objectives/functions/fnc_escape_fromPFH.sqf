/* ----------------------------------------------------------------------------
Function: bc_objectives_fnc_escape_fromPFH
Description:
    Activated by the Objective - Escape module. PFH that runs every 10 seconds to check to see if all synced units are outside the synced trigger.
---------------------------------------------------------------------------- */
#include "script_component.hpp"
params ["_args", "_handle"];
_args params ["_logic"];

private _units = _logic getVariable QGVAR(unitArray);
private _percentage = _logic getVariable "percentage";
private _failPercentage = abs(1 - _percentage);
private _trigger = _logic getVariable QGVAR(trigger);

private _unitsInside = [];
private _unitCount = count _units;

{
    if (alive _x) then {
        private _inArea = [_trigger, _x] call BIS_fnc_inTrigger;
        if (_inArea) then {
            _unitsInside pushBack _x;
        };
    } else {
        private _id = _units find _x;
        _units deleteAt _id;
        _logic setVariable [QGVAR(unitArray),_units];
    };
    if ((count _unitsInside)/_unitCount > _failPercentage) exitWith {};
} forEach _units;

if ((count _unitsInside)/_unitCount <= _failPercentage) then {
    [_handle] call CBA_fnc_removePerFrameHandler;
    
    [_trigger, "Succeeded"] remoteExec [QFUNC(updateTask), 0];
    
    _logic getVariable "execution";
    
    // Run module's custom execution code
    private _str = _logic getVariable "execution";
    private _code = compile _str;
    [_percentage] call _code;
};