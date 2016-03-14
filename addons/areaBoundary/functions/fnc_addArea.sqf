/* ----------------------------------------------------------------------------
Function: bc_areaBoundary_fnc_addArea
Description:
    Attempts to add an area boundary. Validates inputs then passes them off to another function for the actual creation.
Parameters:
    _name - the name you want to give to the area <OBJECT>
    _sides - the side(s) that will be affected by the area boundary <SIDE> or <ARRAY>
    _positions - can either be a trigger, a marker, or an array of markers and/or positions. <ARRAY>
Optional Parameters:
    _isInclusive - if true, players on affected sides cannot leave the boundary. if false, players on affected sides cannot enter it. default true. <BOOLEAN>
    _allowAirVeh - if true, exempt players in land vehicles from being affected by the boundary. if players leave the land vehicle outside of the boundary they will be affected. default false. <BOOLEAN>
    _allowLandVeh - if true, exempt players in land vehicles from being affected by the boundary. if players leave the land vehicle outside of the boundary they will be affected. default false. <BOOLEAN>
    _customVariables - an array filled with variable names. variables should be boolean and saved in the missionNamespace. to leave empty set to []. default: [] <ARRAY>
    _customDelay - delay in seconds before killing the player. must be a multiple of 5. if not a multiple of 5, will round up to next nearest multiple of 5. default 25. <SCALAR>
    _customMessage - message that gets displayed when player leaves the boundary. <STRING>
Examples:
    (begin example)
    (ex1) // Add an area that nobody can leave. Based on a trigger's position and size.
        ["Albany", [], AlbanyTrigger] call bc_areaBoundary_fnc_addArea;
    
    (ex2) // Add an area that nobody can enter based on a marker's position and size. 
        ["Area51", [], "area_51", false] call bc_areaBoundary_fnc_addArea;
        
    (ex3) // Add an area that the 3 major teams can't enter on foot or in land vehicles. Based on a marker.
        ["Detroit", [east,west,independent], "Detroit Marker", false, true, false] call bc_areaBoundary_fnc_addArea;
        
    (ex4) // Add an area that OPFOR can't leave based on an array of positions and markers. Remember not to put the positions out of order or the points will be connected in a weird way.
        ["DefensiveZone", east, ["DefensivePoint1", "DefensivePoint2", [0,0,0], [10000,10000,10000], "DefensivePoint3", "DefensivePoint4"]] call bc_areaBoundary_fnc_addArea;
        
    (ex5) // Add an area that nobody can leave based on a trigger's position and size. Also use the value of variable playerIsNotAPimp to determine if player should be affected by boundaries.
        ["Newark", [], NewarkTrigger, true, false, false, ["playerIsNotAPimp"] call bc_areaBoundary_fnc_addArea;
        // If playerIsNotAPimp is true, allow player to be killed by going out of bounds. If playerIsNotAPimp is false, player cannot be killed by being out of bounds. Useful if you want some custom limitations for your area boundaries.
    (end)
    
TODO:
    Add a debug function that can be run to show polygon areas on the ingame map. A3 v1.57
---------------------------------------------------------------------------- */
#include "script_component.hpp"
params ["_name","_sides","_positions","_isInclusive","_allowAirVeh","_allowLandVeh","_customVariables","_customDelay","_customMessage"];
private["_errorFound", "_posSub", "_type"];

// No need to add boundary for non-humans
if (!hasInterface) exitWith {};

_errorFound = false;

// Check name
if !(IS_STRING(_name)) exitWith {
    BC_LOGERROR_1("addArea: _name not string: %1",_name);
};
if (_name in GVAR(areaList)) exitWith {
    BC_LOGERROR_1("addArea: _name already used: %1",_name);
};

// Check sides
if !((IS_ARRAY(_sides)) OR (IS_SIDE(_sides))) then {
    BC_LOGERROR_1("addArea: Incorrect Type for _sides: %1",_sides);
    _errorFound = true;
};
if (IS_ARRAY(_sides)) then {
    {
        if !(IS_SIDE(_x)) then {
            BC_LOGERROR_2("addArea: Incorrect Type in _sides Array: %1 - %2",_sides, _x);
            _errorFound = true;
        };
    } forEach _sides;
};

if (_errorFound) exitWith {};

// Check positions
if (IS_ARRAY(_positions)) then {
    _type = 3;
    if (count _positions >= 3) then {
        // Make sure there are at least 3 points given in the array or else it can't form a polygon
        {
            _posSub = _x;
            // Check position array
            if (IS_ARRAY(_posSub)) then {
                // Found sub array in _positions, should be coordinates, type check all values inside it
                {
                    if !(IS_SCALAR(_x)) then {
                        _errorFound = true;
                        BC_LOGERROR_4("addArea: Found non number in sub array in _positions: %1 -- %2  >  %3  >  %4",_name, _positions, _posSub, _x);
                    };
                } forEach _posSub;
            } else {
                // Not an array of positions, check to see if it's a string
                if (IS_STRING(_posSub)) then {
                    // Make sure the string is a marker
                    if (getMarkerColor _posSub isEqualTo "") then {
                        _errorFound = true;
                        BC_LOGERROR_3("addArea: Found non-existent marker in _positions: %1 -- %2  >  %3",_name, _positions, _posSub);
                    };
                } else {
                    _errorFound = true;
                    BC_LOGERROR_3("addArea: Found invalid type in _positions: %1 -- %2  >  %3",_name, _positions, _posSub);
                };
            };
        } forEach _positions;
    } else {
        // Less than 3 positions found.
        _errorFound = true;
        BC_LOGERROR_2("addArea: _positions has less than 3 values, can't form polygon: %1 -- %2",_name, _positions);
    };
};
if (IS_STRING(_positions)) then {
    _type = 2;
    if (getMarkerColor _posSub isEqualTo "") then {
        _errorFound = true;
        BC_LOGERROR_2("addArea: _positions is a non-existent marker: %1 -- %2",_name, _positions);
    };
};
// Exhausted other types, check for trigger
if (isNil "_type") then {
    _type = 1;
    // Check against trigger
    if (isNil QGVAR(triggerHandle)) then {
        // Test trigger doesn't already exist, create one
        GVAR(triggerHandle) = createTrigger ["EmptyDetector", [0,0,0], false];
        GVAR(triggerHandle) enableSimulation false;
    };
    if !(_positions isEqualType GVAR(triggerHandle)) then {
        _errorFound = true;
        BC_LOGERROR_2("addArea: Invalid type for _positions: %1 -- %2",_name, _positions);
    };
};

if (_errorFound) exitWith {};

// =====
// Optionals
// =====

/*
Optional Parameters:
    _isInclusive - if true, players on affected sides cannot leave the boundary. if false, players on affected sides cannot enter it. default true. <BOOLEAN>
    _allowAirVeh - if true, exempt players in land vehicles from being affected by the boundary. if players leave the land vehicle outside of the boundary they will be affected. default false. <BOOLEAN>
    _allowLandVeh - if true, exempt players in land vehicles from being affected by the boundary. if players leave the land vehicle outside of the boundary they will be affected. default false. <BOOLEAN>
    _customDelay - set a custom delay before killing the player. must be a multiple of 5. if not a multiple of 5, will round up to next nearest multiple of 5. default 25. <SCALAR>
    _customMessage - set a custom message that gets displayed when player leaves the boundary. <STRING>
*/

// Check isEnclusive
if (!isNil "_isInclusive") then {
    if !(IS_BOOL(_isInclusive)) then {
        BC_LOGERROR_2("addArea: _isInclusive: Defaulting to true. Supplied value wasn't boolean: %1 -- %2",_name, _isInclusive);
        _isInclusive = true;
    };
} else {
    // Value not supplied at all, defaulting to true.
    _isInclusive = true;
};

// Check allowAirVeh
if (!isNil "_allowAirVeh") then {
    if !(IS_BOOL(_allowAirVeh)) then {
        BC_LOGERROR_2("addArea: _allowAirVeh: Defaulting to true. Supplied value wasn't boolean: %1 -- %2",_name, _allowAirVeh);
        _allowAirVeh = true;
    };
} else {
    // Value not supplied at all, defaulting to true.
    _allowAirVeh = true;
};

// Check allowLandVeh
if (!isNil "_allowLandVeh") then {
    if !(IS_BOOL(_allowLandVeh)) then {
        BC_LOGERROR_2("addArea: _allowLandVeh: Defaulting to true. Supplied value wasn't boolean: %1 -- %2",_name, _allowLandVeh);
        _allowLandVeh = true;
    };
} else {
    // Value not supplied at all, defaulting to true.
    _allowLandVeh = true;
};

// Check customVariables
if (!isNil "_customVariables") then {
    if !(IS_ARRAY(_customVariables)) then {
        BC_LOGERROR_2("addArea: _customVariables: Defaulting to true. Supplied value wasn't array: %1 -- %2",_name, _customVariables);
        _customVariables = [!bc_spectator_VirtualCreated];
    } else {
        // Make sure it's an array filled with strings
        {
            if !(IS_STRING(_x)) then {
                BC_LOGERROR_2("addArea: Non-string in _customVariables Array, using default empty array: %1 - %2",_sides, _x);
                _errorFound = true;
            };
        } forEach _customVariables;
    };
} else {
    _customVariables = [!bc_spectator_VirtualCreated];
};
if (_errorFound) then {_customVariables = [];};

// Check customDelay
if (!isNil "_customDelay") then {
    if !(IS_SCALAR(_customDelay)) then {
        BC_LOGERROR_2("addArea: _customDelay: Defaulting to 25 seconds. Supplied value wasn't scalar: %1 -- %2",_name, _customDelay);
        _customDelay = 25;
    };
} else {
    // Value not supplied at all, defaulting to true.
    _customDelay = 25;
};
// Ensure delay is multiple of 5
_customDelay = ceil(_customDelay/5);

// Check customMessage
if (!isNil "_customMessage") then {
    if !(IS_STRING(_customMessage)) then {
        BC_LOGERROR_2("addArea: _customMessage: Using default message. Supplied value wasn't string: %1 -- %2",_name, _customMessage);
        _customMessage = "WARNING!\n\nYou are outside of your allowed area. Return immediately or YOU WILL BE KILLED!";
    };
} else {
    // Value not supplied at all, defaulting to true.
    _customMessage = "WARNING!\n\nYou are outside of your allowed area. Return immediately or YOU WILL BE KILLED!";
};

[_name,_sides,_positions,_isInclusive,_allowAirVeh,_allowLandVeh,_customVariables,_customDelay,_customMessage,_type] call FUNC(createArea);