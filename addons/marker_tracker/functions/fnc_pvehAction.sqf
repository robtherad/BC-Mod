#include "script_component.hpp"
private["_UIDlist", "_clientID", "_infoArray", "_playerUID", "_str"];

if (!isServer) exitWith {};

// Unpack variables
params ["_action","_name","_playerID","_markerInfoArray"];
_markerInfoArray params ["_type","_pos","_text"];

// Build string
if (_text isEqualTo "") then {
    _str = format["%1 - %2 a %3 marker at %4",_name,_action,_type,_pos];
} else {
    _str = format["%1 - %2 a %3 marker at %4 with text: %5",_name,_action,_type,_pos,_text];
};

// Display string to all players
_str remoteExec ["systemChat",0];

/* WIP
_UIDlist = [];
{ // Display string to only certain players
    _playerUID = getPlayerUID _x;
    if (_playerUID in _UIDlist) then {
        _clientID = owner _x;
        _str remoteExec ["systemChat",_clientID];
    };
} forEach allPlayers;
*/

// Log info in .rpt
diag_log format["[Markers] - %1",_str];