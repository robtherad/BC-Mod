/* ----------------------------------------------------------------------------
Function: bc_objectives_fnc_createTask
Description:
    Remotely called by the server onto clients to handle creation of tasks.
---------------------------------------------------------------------------- */
#include "script_component.hpp"
params ["_unit", "_shortString", "_longString", "_position"];

if (!hasInterface) exitWith {};

private _taskVar = player createSimpleTask [_shortString];
_taskVar setSimpleTaskDescription [_longString, _shortString, _shortString];
if (!isNil "_position") then {
    _taskVar setSimpleTaskDestination _position;
    // TODO: Add a waitUntilAndExecute for (time < 5 seconds) to make sure the object position is still correct?
};
_taskVar setTaskState "Created";

_unit setVariable [QGVAR(taskID),_taskVar];