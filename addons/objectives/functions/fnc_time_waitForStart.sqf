/* ----------------------------------------------------------------------------
Function: bc_objectives_fnc_time_waitForStart
Description:
    Waits for mission start then adds a CBA PFH that executes bc_objectives_fnc_time_checkLimit
---------------------------------------------------------------------------- */
#include "script_component.hpp"
params ["_args", "_handle"];
_args params ["_logic"];

if (time > 0) then {
    [_handle] call CBA_fnc_removePerFrameHandler;
    
    _missionDuration = _logic getVariable "duration";
    _startingTime = diag_tickTime;
    
    [FUNC(time_checkLimit), 5, [_logic, _startingTime,_missionDuration]] call CBA_fnc_addPerFrameHandler;
};