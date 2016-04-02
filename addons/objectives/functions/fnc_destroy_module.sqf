/* ----------------------------------------------------------------------------
Function: bc_objectives_fnc_destroy
Description:
    Activated by the Mission Time Limit module ingame. Runs on the server and makes sure the mission doesn't last any longer than the given time limit.
---------------------------------------------------------------------------- */
#include "script_component.hpp"
params [
    ["_logic", objNull, [objNull] ],
    ["_units", [], [[]] ],
    ["_activated", true, [true] ]
];

if (!isServer) exitWith {};

if (_activated && {count _units isEqualTo 1}) then {
    _name = _logic getVariable "objectiveName";
    _blufor = _logic getVariable "bluforStatus";
    _opfor = _logic getVariable "opforStatus";
    _indfor = _logic getVariable "indforStatus";
    _teamArray = [[_blufor, west], [_opfor, east], [_indfor, independent]];
    _createDefenderTasks = _logic getVariable "defenderTasks";
    
    // Create tasks and markers, etc.
    { // forEach _teamArray
        // Add tasks and stuff, 
        
    } forEach _teamArray;
    
    
    // Add event for object destruction - Sets tasks to complete/failed
    _id = [QGVAR(destroyed), {
        params ["_eventName"];
        
        
        // Remove event
        [_eventName] call CBA_fnc_removeEventHandler;
    }] call CBA_fnc_addEventHandler;
    
    
    // Initialize server status check loop
    if (isNil QGVAR(destroy_checkList)) then {
        GVAR(destroy_checkList) = [];
        [FUNC(destroy_checkStatus), 5, []] call CBA_fnc_addPerFrameHandler;
    };
    
    // Add synced object to list of objectives to check status of
    GVAR(destroy_checkList) pushBack _units;
};