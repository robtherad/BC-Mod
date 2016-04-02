/* ----------------------------------------------------------------------------
Function: bc_objectives_fnc_timeLimit
Description:
    Function for BC time limit module. Runs given code after the mission has been running for the given time. 
    
    Adds a self-removing CBA PFH that waits until the mission starts. Once mission starts adds another CBA PFH that waits until the mission has been running for the given amount of time, then excutes the given code.
---------------------------------------------------------------------------- */
#include "script_component.hpp"
params ["_args", "_handle"];
_args params ["_logic", "_startingTime", "_missionDuration"];

if (diag_tickTime > (_startingTime + _missionDuration)) then {
    [_handle] call CBA_fnc_removePerFrameHandler;
    
    _str = _logic getVariable "Execution";
    _code = compile _str;
    call _code;
};