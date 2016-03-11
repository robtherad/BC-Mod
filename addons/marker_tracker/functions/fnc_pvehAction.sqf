/* ----------------------------------------------------------------------------
Function: bc_marker_tracker_fnc_pvehAction
Description:
    Internal function. Function called when clients trigger the public variable event handler.
---------------------------------------------------------------------------- */
#include "script_component.hpp"
private ["_action","_name", "_markerInfoArray", "_type","_pos","_text", "_str", "_playerUID", "_clientID"];
params ["_action","_name","_playerUID","_markerInfoArray"];
_markerInfoArray params ["_type","_pos","_text"];

if (!isServer) exitWith {};

// Build string
if (_text isEqualTo "") then {
    if (_action isEqualTo "Placed") then {
        _str = format["%1 - %2 a %3 marker at %4",_name,_action,_type,_pos];
    } else {
        _str = format["%1 - %2 a %3 marker from %4",_name,_action,_type,_pos];
    };
} else {
    if (_action isEqualTo "Placed") then {
        _str = format["%1 - %2 a %3 marker at %4 with text: %5",_name,_action,_type,_pos,_text];
    } else {
        _str = format["%1 - %2 a %3 marker from %4 with text: %5",_name,_action,_type,_pos,_text];
    };
};

// Log info in .rpt
if (GVAR(logMarker)) then {
    BC_LOGINFO_2('Marker Log',_str,_playerUID);
};

// Turn off logging display once mission starts, but only if it's not forced on
if !(IS_BOOL(GVAR(forceDisplay))) then {GVAR(forceDisplay) = false;};
if (!GVAR(forceDisplay)) then {
    if (time>0) exitWith {};
};
// Display string to all players
{
    if ( (getPlayerUID _x) in GVAR(UIDList) ) then {
        _clientID = owner _x;
        _str remoteExec ["systemChat",_clientID];
    };
} forEach playableUnits;