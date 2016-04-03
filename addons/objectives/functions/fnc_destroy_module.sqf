/* ----------------------------------------------------------------------------
Function: bc_objectives_fnc_destroy_module
Description:
    Activated by the Objective - Destroy module ingame. Adds a killed EH to the synced object and creates tasks for specified teams.
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
    private _name = _logic getVariable "objectiveName";
    private _blufor = _logic getVariable "bluforStatus";
    private _opfor = _logic getVariable "opforStatus";
    private _indfor = _logic getVariable "indforStatus";
    private _teamArray = [[_blufor, west], [_opfor, east], [_indfor, independent]];
    private _createDefenderTasks = _logic getVariable "defenderTasks";
    private _showPosition = _logic getVariable "showObjectPosition";
    private _str = _logic getVariable "execution";
    
    // Add variables to unit so the EH can extract them later.
    (_units select 0) setVariable [QGVAR(teamArray), _teamArray];
    (_units select 0) setVariable [QGVAR(defenderTasks),_createDefenderTasks];
    (_units select 0) setVariable [QGVAR(execution),_str];

    // Create tasks and markers, etc.
    { // forEach _teamArray
        private ["_longString", "_shortString"];
        if ((_x select 0) isEqualTo 1) then {
            _shortString = "Destroy";
            _longString = format["Destroy %1"];
            [(_units select 0), _shortString, _longString, _name, _showPosition] remoteExec [QFUNC(createTask), (_x select 1)];
        } else {
            if (_createDefenderTasks && {(_x select 0) isEqualTo 2}) then {
                // Create matching tasks for defenders
                _shortString = "Defend";
                if (_units select 0 isKindOf "Man") then {
                    _longString = format["Defend %1 from being killed.",_name];
                } else {
                    _longString = format["Defend %1 from being destroyed.",_name];
                };
                [(_units select 0), _shortString, _longString, _name, _showPosition] remoteExec [QFUNC(createTask), (_x select 1)];
            };
        };
    } forEach _teamArray;
    
    
    // Add EH
    private _ehID = (_units select 0) addEventHandler ["Killed", {_this call FUNC(destroy_killedEH);}];
    (_units select 0) setVariable [QGVAR(killedEHID), _ehID];
};