/* ----------------------------------------------------------------------------
Function: bc_objectives_fnc_destroy_module
Description:
    Activated by the Objective - Destroy module ingame. Adds a killed EH to the synced object and creates tasks for specified teams.
---------------------------------------------------------------------------- */
[{
#include "script_component.hpp"
params [
    ["_logic", objNull, [objNull] ],
    ["_units", [], [[]] ],
    ["_activated", true, [true] ]
];

if (!isServer) exitWith {};

// Make sure module is synced correctly
private _triggerList = [];
private _logicList = [];
{
    if (_x isKindOf "EmptyDetector") then {
        _triggerList pushBack _x;
    } else {
        if (_x isKindOf "LocationArea_F") then {
            _logicList pushBack _x;
        };
    };
} forEach (synchronizedObjects _logic);
if !((count _triggerList + count _logicList) isEqualTo 1) exitWith {BC_LOGERROR("moduleInit_module: Less than or more than 1 synced trigger or logic - Exiting.");};

// Follow the chain of Area logics to try to complete the moduleInit
private _count = count _logicList;
private _logicListError = false;
if (_count > 0) then {
    [_logic, _logicList] call FUNC(searchConnections);
    _logicList = _logic getVariable [QGVAR(logicList),[]];
    if (count _logicList < 3) then {_logicListError = true};
};

if (_logicListError) exitWith {BC_LOGERROR("moduleInit: Less than 3 area logics synced to module, unable to make a shape.");};

// Get list of units to apply boundary to
switch (_logic getVariable ["TMFUnits",-1]) do {
    case (-1): {
        {
            _units pushBackUnique _x;
        } forEach allUnits;
        _logic setVariable [QGVAR(unitArray), _units];
    };
    case (0): {
        _logic setVariable [QGVAR(unitArray), _units];
    };
    case (1): {
        {
            private _grpUnits = units (group _x);
            {
                _units pushBackUnique _x;
            } forEach _grpUnits;
        } forEach _units;  
        _logic setVariable [QGVAR(unitArray), _units];
    };
    case (2): {
        private _sideList = [];
        {
            _sideList pushBackUnique (side _x);
        } forEach _units;
        {
            if((side _x) in _sideList) then {
                _units pushBackUnique _x
            };
        } forEach allUnits;
        _logic setVariable [QGVAR(unitArray), _units];
    };
};

if (count _units < 1) exitWith {BC_LOGERROR("moduleInit: No synced units - Exiting.");};

if (_activated) then {
    _locations = [];
    {
        _locations pushBack (getPos _x);
    } forEach _logicList;
    
    // Evaluate Conditions to make sure it's correct
    _conditions = _logic getVariable ["condition",[]];
    
    _inclusive = _logic getVariable "isInclusive";
    _allowAir = _logic getVariable "allowAir";
    _allowLandVeh = _logic getVariable "allowLandVeh";
    _customDelay = _logic getVariable "delay";
    _customMessage = _logic getVariable "message";
    _execution = _logic getVariable "execution";
    
    [FUNC(multiPosCheck), 5, [_logic,_units,_locations, _isInclusive,_allowAir,_allowLandVeh,_conditions,_customDelay,_customMessage,_execution]] call CBA_fnc_addPerFrameHandler;
    
    _createMarkers = _logic getVariable "createMarkers";
    
    if !(_createMarkers isEqualTo "None") then {
        [_locations] call FUNC(createMarkers);
    };
    
};

}, _this] call CBA_fnc_directCall;