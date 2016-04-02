/* ----------------------------------------------------------------------------
Function: bc_objectives_fnc_timeLimit
Description:
    Function for BC time limit module. Runs given code after the mission has been running for the given time. 
    
    Adds a self-removing CBA PFH that waits until the mission starts. Once mission starts adds another CBA PFH that waits until the mission has been running for the given amount of time, then excutes the given code.
Module Options:
    - Duration: time in seconds from start of mission to end of mission
    - Execution: code to execute after given duration
---------------------------------------------------------------------------- */
#include "script_component.hpp"
params [
    ["_logic", objNull, [objNull] ],
    ["_units", [], [[]] ],
    ["_activated", true, [true] ]
];

if (!isServer) exitWith {};

if (_activated && {!GVAR(time_limitActive)}) then {
    GVAR(time_limitActive) = true;
    [FUNC(time_waitForStart), 0.1, [_logic]] call CBA_fnc_addPerFrameHandler;
} else {
    BC_LOGERROR("objectives: Multiple time limit modules placed. Warn mission author.");
};