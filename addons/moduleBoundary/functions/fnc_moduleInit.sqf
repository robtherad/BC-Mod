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
private _usingTrigger = true;
private _moduleSize = _logic getVariable ["objectArea",nil];
{
    if (_x isKindOf "EmptyDetector") then {
        _triggerList pushBack _x;
    } else {
        if (_x isKindOf "LocationArea_F") then {
            _logicList pushBack _x;
        };
    };
} forEach (synchronizedObjects _logic);

// No triggers or area logics found, create a trigger using module size
if ( ((count _triggerList + count _logicList) isEqualTo 0) && !isNil "_moduleSize" ) then {
    private _trigger = createTrigger ["EmptyDetector", (getPos _logic), true];
    _trigger setTriggerArea _moduleSize;
    _triggerList pushBack _trigger;
};

if !((count _triggerList + count _logicList) isEqualTo 1) exitWith {BC_LOGERROR("moduleInit_module: Less than or more than 1 synced trigger or logic - Exiting.");};

// Follow the chain of Area logics to try to complete the moduleInit
private _count = count _logicList;
private _logicListError = false;
if (_count > 0) then {
    [_logic, _logicList] call FUNC(searchConnections);
    _logicList = _logic getVariable [QGVAR(logicList),[]];
    _usingTrigger = false;
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
    private _locations = [];
    if (_usingTrigger) then {
        _locations = _triggerList;
    } else {
        {
            _locations pushBack (getPos _x);
        } forEach _logicList;
    };
    
    // Evaluate Conditions to make sure it's correct
    private _conditions = _logic getVariable ["condition",[]];
    if !(count _conditions isEqualTo 0) then {
        _conditions = _conditions splitString ",";
        // Check conditions input
        private _characterList = "_,abcdefghijklmnopqrstuvwxyz1234567890";
        _characterList = toArray _characterList; // 32 is a space
        private _newConditions = [];
        
        { // forEach _conditions
            private _string = toLower _x;
            private _stringArray = toArray _string;
            private _newStringArray = [];
            private _safeDropCharacters = toArray " "; // Characters that might appear at the start/end of condition inputs that should be able to be safely dropped
            
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
    };
    
    // Unpack module variables
    private _inclusive = _logic getVariable "isInclusive";
    private _allowAir = _logic getVariable "allowAir";
    private _allowLandVeh = _logic getVariable "allowLandVeh";
    private _customDelay = _logic getVariable "delay";
    _customDelay = abs(ceil(_customDelay / 5));
    private _customMessage = _logic getVariable "message";
    private _execution = _logic getVariable "execution";
    
    // Generate a list of playerIDs to remoteExec the clientInit onto
    private _ownerIDList = [];
    private _unitList = [];
    {
        private _owner = (owner _x);
        private _id = _ownerIDList pushBackUnique _owner;
        if (_id isEqualTo -1) then {_id = _ownerIDList find _owner;};
        if (isNil {_unitList select _id}) then {_unitList set [_id,[]];};
        (_unitList select _id) pushBack _x;
    } forEach _units;
    
    {
        _ownerUnits = _unitList select _forEachIndex;
        
        private _args = [_logic, _ownerUnits, _locations, _inclusive,_allowAir,_allowLandVeh,_conditions,_customDelay,_customMessage,_execution, 0];
        _args remoteExecCall [QFUNC(clientInit), _x];
    } forEach _ownerIDList;
    
    // Create markers to show boundary
    private _createMarkers = _logic getVariable "createMarkers";
    if !(_createMarkers isEqualTo "None") then {[_locations,_createMarkers] call FUNC(createMarkers);};
};

}, _this] call CBA_fnc_directCall;