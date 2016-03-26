/* ----------------------------------------------------------------------------
Function: bc_common_fnc_displayDifficulty
Description:
    Displays the mission's current difficulty level in the chat at the start of the mission.
Parameters:
    _unit - the unit <OBJECT>
Examples:
    (begin example)
        call bc_common_fnc_displayDifficulty;
    (end)
---------------------------------------------------------------------------- */
#include "script_component.hpp"

if (!isServer) exitWith {};
    
[{
    params ["_args", "_handle"];
    private ["_diff", "_diffStr"];
    if (!GVAR(displayDifficulty)) then {
        [_handle] call CBA_fnc_removePerFrameHandler;
    };
    if (time > 1) then {
        _diff = "Undefined";
        switch(difficulty) do {
            case 0: {_diff = "Recruit";};
            case 1: {_diff = "Regular";};
            case 2: {_diff = "Veteran";};
            case 3: {_diff = "Elite";};
        };
        _diffStr = "Mission Difficulty: " + _diff;
        _diffStr remoteExecCall ["systemChat", 0];
        
        [_handle] call CBA_fnc_removePerFrameHandler;
    };
}, 1, []] call CBA_fnc_addPerFrameHandler;