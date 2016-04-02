/* ----------------------------------------------------------------------------
Function: bc_objectives_fnc_destroy
Description:
    Activated by the Mission Time Limit module ingame. Runs on the server and makes sure the mission doesn't last any longer than the given time limit.
---------------------------------------------------------------------------- */
#include "script_component.hpp"
params ["_args","_handle"];

if (count GVAR(destroy_checkList) > 0) then {
    {
        if (!alive _x) then {
            _event = _x getVariable QGVAR(eventID);
            [_event,[_event]] call CBA_fnc_serverEvent;
        };
    } forEach GVAR(destroy_checkList);
    
    
} else {
    GVAR(destroy_checkList) = nil;
    [_handle] call CBA_fnc_removePerFrameHandler;
};