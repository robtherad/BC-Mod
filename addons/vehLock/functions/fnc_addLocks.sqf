/* ----------------------------------------------------------------------------
Function: bc_vehLock_fnc_addLocks
Description:
    Attempts to add a marker to a unit which will be tracked by the gpsMarkers module.
Parameters:
    _object - the vehicle to add locks to <OBJECT>
    _positions - the positions that will be locked by class in the order of: [driver, commander, gunner, cargo]. takes 1 for locked, 0 for unlocked <ARRAY>
    _classes - unit class names that can enter the locked _positions <ARRAY>
Optional Parameters:
    _sides - the side(s) that will be able to enter the vehicle. leave empty to allow all sides <SIDE> or <ARRAY>
    _players - unit names that can enter locked positions of the vehicle. ignores class and side restrictions. <ARRAY>
    _message - message to display when a player isnt able to enter a locked vehicle or switch seats to a locked position
Examples:
    (begin example)
    (e1) // Locks APC so only BLUFOR players can get in it. Only BLUFOR crewmen can drive, gun, or command. Anyone on BLUFOR can get in as a passenger. OPFOR, etc, can't get in at all.
        [APC,west,[1,1,1,0],["b_crew_F"]] call bc_vehLock_fnc_addLocks;
    (e2)
        [truck,[]] call bc_vehLock_fnc_addLocks;
    (end)
---------------------------------------------------------------------------- */
#include "script_component.hpp"
params ["_object","_sides","_positions","_classes","_players","_message"];
private ["_object","_sides","_type","_group","_errorFound"];

// No need to add markers for non-humans
if (!hasInterface) exitWith {};

_errorFound = false;

// Check object
if !(IS_OBJECT(_object)) exitWith {
    BC_LOGERROR_1("addLocks: Non-object passed to script: %1",_object);
};
if (_object isKindOf "Man") exitWith {
    BC_LOGERROR_1("addLocks: Non-vehicle passed to script: %1",_object);
};

// Check positions
if (IS_ARRAY(_positions)) then {
    {
        if !(_x == 0 || _x == 1) then {
            _errorFound = true;
            BC_LOGERROR_2("addLocks: _positions array has variable other than 0 or 1: %1 -- %2",_positions,_object);
        };
    } forEach _positions;
    if (count _positions != 4) then {
        _errorFound = true;
        BC_LOGERROR_2("addLocks: _positions array is wrong size: %1 -- %2",_positions,_object);
    };
} else {
    _errorFound = true;
    BC_LOGERROR_2("addLocks: _positions is not an array: %1 -- %2",_positions,_object);
};
if (_errorFound) exitWith {};

// ---
// OPTIONALS
// ---

// Check classes
if !(IS_ARRAY(_classes)) then {
    _classes = [];
    BC_LOGERROR_2("addLocks: _classes is not an array. Not filtering by class: %1 -- %2",_classes,_object);
};

// Check sides
if !(IS_SIDE(_sides)) then {
    if (IS_ARRAY(_sides)) then {
        if (count _sides > 0) then {
            // Empty sides array is fine
            {
                if !(IS_SIDE(_sides)) then {
                    _errorFound = true;
                    BC_LOGERROR_3("addLocks: _sides Array has non-side: %1 -- %2 -- %3",_x,_sides,_object);
                };
            } forEach _sides;
        };
    } else {
        _sides = [];
        BC_LOGERROR_2("addLocks: _sides is not ARRAY or SIDE. Allowing all sides: %1 -- %2",_sides,_object);
    };
};
if (_errorFound) exitWith {};

// Check _players
if (isNil "_players") then {
    _players = [];
};
if !(IS_ARRAY(_players)) then {
    BC_LOGERROR_2("addLocks: _players is not an array: %1 -- %2",_players,_object);
} else {
    if (count _players > 0) then {
        {
            if !(IS_OBJECT(_x)) then {
               BC_LOGERROR_2("addLocks: Non player in _players array: %1 -- %2",_players,_object); 
            };
        } forEach _players;
    };
};

if (_errorFound) exitWith {};

// Check _message
if (isNil "_message") then {
    _message = "Your class/side isn't able to access this vehicle/role.";
};
if !(IS_STRING(_message)) then {
    BC_LOGERROR_1("addLocks: Using default message. Custom _message is not a string: %1",_object);
    _message = "Your class/side isn't able to access this vehicle/role.";
};

// Make sure it's not already locked
if (_object in GVAR(lockedList)) exitWith {
    BC_LOGERROR_1("addLocks: Vehicle already locked: %1",_object);
};

[_object, _positions, _classes, _sides, _players, _message] call FUNC(createLock);