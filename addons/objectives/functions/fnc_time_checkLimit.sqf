/* ----------------------------------------------------------------------------
Function: bc_objectives_fnc_time_checkLimit
Description:
    Called by a CBA PFH every 5 seconds to check to see if current time exceeds the duration set by the time limit module.
---------------------------------------------------------------------------- */
#include "script_component.hpp"
params ["_args", "_handle"];
_args params ["_logic", "_startingTime", "_missionDuration"];

if (diag_tickTime > (_startingTime + _missionDuration)) then {
    [_handle] call CBA_fnc_removePerFrameHandler;
    
    private _str = _logic getVariable "execution";
    private _code = compile _str;
    [_missionDuration] call _code;
};