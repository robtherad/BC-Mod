/* ----------------------------------------------------------------------------
Function: bc_objectives_fnc_updateTask
Description:
    Remotely called by the server onto clients to handle update of already created tasks.
---------------------------------------------------------------------------- */
#include "script_component.hpp"
params ["_unit", "_status"];

if (!hasInterface) exitWith {};

private _taskVar = _unit getVariable QGVAR(taskID);
_taskVar setTaskState _status;