/* ----------------------------------------------------------------------------
Function: bc_objectives_fnc_destroy_killedEH
Description:
    Activated by the Killed event handler attached to objects synced to the Objective - Destroy module.
---------------------------------------------------------------------------- */
#include "script_component.hpp"
params ["_unit", "_killer"];

// Change status of objectives to destroyed/failed depending on team
private _teamArray = _unit getVariable QGVAR(teamArray);
private _defenderTasks = _unit getVariable QGVAR(defenderTasks);

{
    if ((_x select 0) isEqualTo 1) then {
        [_unit, "Succeeded"] remoteExec [QFUNC(updateTask), (_x select 1)];
    } else {
        if (_defenderTasks) then {
            [_unit, "Failed"] remoteExec [QFUNC(updateTask), (_x select 1)];
        };
    };
} forEach _teamArray;

// Run module's custom execution code
private _str = _unit getVariable QGVAR(execution);
private _code = compile _str;
[_unit, _killer, _name] call _code;