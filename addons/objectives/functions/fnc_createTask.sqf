/* ----------------------------------------------------------------------------
Function: bc_objectives_fnc_createTask
Description:
    Remotely called by the server onto clients to handle creation of tasks.
---------------------------------------------------------------------------- */
#include "script_component.hpp"
params ["_unit", "_shortString", "_longString", "_name", "_showPosition"];

if (!hasInterface) exitWith {};

private _taskVar = player createSimpleTask [format["%1 %2",_shortString,_name]];
_taskVar setSimpleTaskDescription [_longString, _shortString, _shortString];
if (_showPosition) then {
    _taskVar setSimpleTaskDestination (getPos _unit);
    // TODO: Add a waitUntilAndExecute for (time < 5 seconds) to make sure the object position is still correct?
};
_taskVar setTaskState "Created";

_unit setVariable [QGVAR(taskID),_taskVar];