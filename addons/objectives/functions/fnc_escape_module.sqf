/* ----------------------------------------------------------------------------
Function: bc_objectives_fnc_escape_module
Description:
    Activated by the Objective - Escape module ingame. Adds a PFH on the server that checks every 10 seconds to see if all the synced units are inside/outside of the synced trigger.
---------------------------------------------------------------------------- */
#include "script_component.hpp"
params [
    ["_logic", objNull, [objNull] ],
    ["_units", [], [[]] ],
    ["_activated", true, [true] ]
];

if (!isServer) exitWith {};

// TODO: Test on dedicated server

private _triggerList = [];
{
    if (_x isKindOf "EmptyDetector") then {
        _triggerList pushBack _x;
    };
} forEach (synchronizedObjects _logic);

if !(count _triggerList isEqualTo 1) exitWith {BC_LOGERROR("escape_module: Less than or more than 1 synced trigger - Exiting.");};
if (count _units < 1) exitWith {BC_LOGERROR("escape_module: No synced units - Exiting.");};

if (_activated) then {
    private _trigger = (_triggerList select 0);

    private _escapeType = _logic getVariable "escape";
    _logic setVariable [QGVAR(unitArray),_units];
    _logic setVariable [QGVAR(trigger), _trigger];
    
    private _percentage = _logic getVariable "percentage";
    if (_percentage > 1 || _percentage isEqualTo 0) then {_logic setVariable ["percentage",1];};
    
    private _createMarker = _logic getVariable "createMarker";
    if (_createMarker) then {
        private _triggerArray = triggerArea _trigger;
        
        private _mkr = createMarker [format["%1_%2_%3",QGVAR(marker),"escape",random(50000)], getPos _trigger];
        systemChat format["%1",_mkr];
        if (_triggerArray select 3) then {
            _mkr setMarkerShape "RECTANGLE";
        } else {
            _mkr setMarkerShape "ELLIPSE";
        };
        _mkr setMarkerColor "ColorBlack";
        _mkr setMarkerDir (_triggerArray select 2);
        _mkr setMarkerSize [_triggerArray select 0, _triggerArray select 1];
        
        _logic setVariable [QGVAR(markerName),_mkr];
    };
    
    private ["_escapeStr", "_escapeStr2"];
    // TODO: Make sure variables don't get overwritten if a mission maker uses the same trigger for two escape objectives and happens to sync them to the same unit.
    if (_escapeType isEqualTo 1) then {
        _escapeStr = "To";
        _escapeSTr2 = "into";
        [FUNC(escape_toPFH), 10, [_logic]] call CBA_fnc_addPerFrameHandler;
    } else {
        _escapeStr = "From";
        _escapeStr2 = "out of";
        [FUNC(escape_fromPFH), 10, [_logic]] call CBA_fnc_addPerFrameHandler;
    };
    
    // Create objectives on clients
    private _shortString = format["Escape %1",_escapeStr];
    private _longString = format["Get at least %1 percent of your surviving forces %2 the area.",(_percentage*100),_escapeStr2];
    private _ownerList = [];
    {
        private _ownerID = owner _x;
        if !(_ownerID in _ownerList) then {
            _ownerList pushBack _ownerId;
            private _position = getPos _trigger;
            [_trigger, _shortString, _longString, _position] remoteExec [QFUNC(createTask), _ownerID];
        };
    } forEach _units;
    
};