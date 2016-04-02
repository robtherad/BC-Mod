/* ----------------------------------------------------------------------------
Function: bc_objectives_fnc_destroy_killedEH
Description:
    Activated by the Killed event handler attached to objects synced to the Objective - Destroy module.
---------------------------------------------------------------------------- */
#include "script_component.hpp"
params ["_unit", "_killer"];

// Change status of objectives to destroyed/failed depending on team
_unit getVariable "teamArray";
_unit getVariable "defenderTasks";

{
    if ((_x select 0) isEqualTo 1) then {
        [_unit, "Succeeded"] remoteExec [QFUNC(updateTask), _x];
    } else {
        if (_defenderTasks) then {
            [_unit, "Failed"] remoteExec [QFUNC(updateTask), _x];
        };
    };
} forEach _teamArray;

// Run module's custom execution code
_str = _unit getVariable "ExecCode";
_code = compile _str;
[_unit, _killer, _name] call _code;