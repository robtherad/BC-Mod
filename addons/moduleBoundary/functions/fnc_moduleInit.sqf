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
    private _conditions = _logic getVariable ["condition",[]];
    
    if !(count _conditions isEqualTo 0) then {
        _conditions = _conditions splitString ",";
        BC_LOGDEBUG_1("moduleInit: _conditions: %1",_conditions);
        // Check conditions input
        private _characterList = "_,abcdefghijklmnopqrstuvwxyz1234567890";
        _characterList = toArray _characterList; // 32 is a space
        private _newConditions = [];
        
        { // forEach _conditions
            private _string = toLower _x;
            private _stringArray = toArray _string;
            private _newStringArray = [];
            private _safeDropCharacters = toArray " "; // Characters that might appear at the start/end of condition inputs that should be able to be safely dropped
            BC_LOGDEBUG_1("moduleInit: _string: %1",_string);
            BC_LOGDEBUG_1("moduleInit: _stringArray: %1",_stringArray);
            
            { // forEach _stringArray
                private _throwAway = false;
                
                // Check for leading underscore
                if (_forEachIndex isEqualTo 0 && {((_stringArray select 0) isEqualTo (_characterList select 0))} ) then {
                    _throwAway = true;
                    BC_LOGERROR_1("moduleInit: Can't use local variables in condition box, throwing away: %1",_string);
                };
                
                // Check for illegal characters
                if (_x in _characterList) then {
                    _newStringArray pushBack _x;
                } else {
                    if !(_forEachIndex isEqualTo 0 || {_forEachIndex isEqualTo ((count _stringArray) - 1)} ) then {
                        _throwAway = true;
                        BC_LOGERROR_1("moduleInit: Illegal character in condition, throwing away variable: %1",_string);
                    } else {
                        // Bad character is first or last character
                        if !(_x in _safeDropCharacters) then {
                            BC_LOGERROR_2("moduleInit: Dropping illegal character from start/end of variable: char: %2 var: %1",_string, toString[_x]);
                        };
                    };
                };
                if (_throwAway) exitWith {_newStringArray = [];};
                
            } forEach _stringArray;
            
            if (count _newStringArray > 0) then {
                _newStringArray = toString _newStringArray;
                _newConditions pushBack _newStringArray;
            };
            
        } forEach _conditions;
        
        _conditions = _newConditions;
        BC_LOGDEBUG_1("moduleInit: _newConditions: %1",_newConditions);
    };
    
    private _inclusive = _logic getVariable "isInclusive";
    private _allowAir = _logic getVariable "allowAir";
    private _allowLandVeh = _logic getVariable "allowLandVeh";
    private _customDelay = _logic getVariable "delay";
    private _customMessage = _logic getVariable "message";
    private _execution = _logic getVariable "execution";
    
    private _ownerIDList = [];
    private _unitList = [];
    {
        private _owner = (owner _x);
        private _id = _ownerIDList pushBackUnique _owner;
        if (_id isEqualTo -1) then {_id = _ownerIDList find _owner;};
        if (isNil {_unitList select _id}) then {_unitList set [_id,[]];};
        (_unitList select _id) pushBack _x;
    } forEach _units;
    
    BC_LOGDEBUG_1("moduleInit: _ownerIDList: %1",_ownerIDList);
    BC_LOGDEBUG_1("moduleInit: _unitList: %1",_unitList);
    
    {
        _ownerUnits = _unitList select _forEachIndex;
        
        BC_LOGDEBUG_1("moduleInit: _ownerUnits: %1",_ownerUnits);
        
        private _args = [_logic, _ownerUnits, _locations, _isInclusive,_allowAir,_allowLandVeh,_conditions,_customDelay,_customMessage,_execution];
        _args remoteExecCall [QFUNC(clientInit), _x];
    } forEach _ownerIDList;
    
    private _createMarkers = _logic getVariable "createMarkers";
    if !(_createMarkers isEqualTo "None") then {[_locations] call FUNC(createMarkers);};
};

}, _this] call CBA_fnc_directCall;