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

// TODO: Add support for syncing multiple objects to the module to use them all as 1 objective.
if (_activated && {count _units isEqualTo 1}) then {
    _name = _logic getVariable "objectiveName";
    _blufor = _logic getVariable "bluforStatus";
    _opfor = _logic getVariable "opforStatus";
    _indfor = _logic getVariable "indforStatus";
    _teamArray = [[_blufor, west], [_opfor, east], [_indfor, independent]];
    _createDefenderTasks = _logic getVariable "defenderTasks";
    _showPosition = _logic getVariable "showObjectPosition";
    _str = _logic getVariable "execution";
    
    // Add variables to unit so the EH can extract them later.
    (_units select 0) setVariable [QGVAR(teamArray), _teamArray];
    (_units select 0) setVariable [QGVAR(defenderTasks),_createDefenderTasks];
    (_units select 0) setVariable [QGVAR(execution),_str];

    // Create tasks and markers, etc.
    { // forEach _teamArray
        if ((_x select 0) isEqualTo 1) then {
            _shortString = "Destroy";
            _longString = format["Destroy %1"];
            [(_units select 0), _shortString, _longString, _name, _showPosition] remoteExec [QFUNC(createTask), (_x select 1)];
        } else {
            if (_createDefenderTasks) then {
                // Create matching tasks for defenders
                _shortString = "Defend";
                _longString = format["Defend %1 from being destroyed",_name];
                [(_units select 0), _shortString, _longString, _name, _showPosition] remoteExec [QFUNC(createTask), (_x select 1)];
            };
        };
    } forEach _teamArray;
    
    
    // Add EH
    _ehID = (_units select 0) addEventHandler ["Killed", {_this call FUNC(destroy_killedEH);}];
    (_units select 0) setVariable [QGVAR(killedEHID), _ehID];
};