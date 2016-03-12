/* ----------------------------------------------------------------------------
Function: bc_vehLock_fnc_addLocks
Description:
    Attempts to add a marker to a unit which will be tracked by the gpsMarkers module.
Parameters:
    _vehicle - the vehicle to add locks to <OBJECT>
    _positions - the positions that will be locked by class in the order of: [driver, commander, gunner, cargo]. takes 1 for locked, 0 for unlocked <ARRAY>
Optional Parameters:
    _sides - the side(s) that will be able to enter the vehicle. set to [] to allow all sides. set to sideUnknown to allow none. <SIDE> or <ARRAY>
    _classes - unit class names that can enter the locked _positions. must abide by side restrictions. set to [] if you don't want to limit by class. <ARRAY>
    _units - unit names that can enter locked positions of the vehicle. ignores class and side restrictions. set to [] if  you don't want to limit by unit names <ARRAY>
    _message - message to display when a player isnt able to enter a locked vehicle or switch seats to a locked position. <STRING>
Examples:
    (begin example)
    (ex1) // Simplest locking system. Only BLUFOR players can enter Helicopter. Any player can enter any slot.
        [Helicopter,[0,0,0,0],west] call bc_vehLock_fnc_addLocks;
    (ex2) // Locks APC so only BLUFOR players can get in it. Only BLUFOR crewmen can drive, gun, or command. Anyone on BLUFOR can get in as a passenger. OPFOR, etc, can't get in at all.
        [APC,[1,1,1,0],west,["B_crew_F"]] call bc_vehLock_fnc_addLocks;
    (ex3) // Allows nobody to enter truck except for the unit named truckDriver. Displays a custom message.
        [truck,[1,0,0,0],sideUnknown,[],[truckDriver],"Only the truck driver can drive this."] call bc_vehLock_fnc_addLocks;
    (ex4) // Anyone from any side can enter APC as a passenger but only crewmen from BLUFOR, OPFOR, and INDFOR can drive, command, and gun the APCs.
        [APC,[1,1,1,0],[],["B_crew_F","O_crew_F","I_crew_F"]] call bc_vehLock_fnc_addLocks;
    (end)
---------------------------------------------------------------------------- */
#include "script_component.hpp"
params ["_vehicle","_positions","_sides","_classes","_units","_message"];
private ["_vehicle","_positions","_sides","_classes","_units","_message","_errorFound"];

// No need to add markers for non-humans
if (!hasInterface) exitWith {};

_errorFound = false;

// Check object
if !(IS_OBJECT(_vehicle)) exitWith {
    BC_LOGERROR_1("addLocks: Non-object passed to script: %1",_vehicle);
};
if (_vehicle isKindOf "Man") exitWith {
    BC_LOGERROR_1("addLocks: Non-vehicle passed to script: %1",_vehicle);
};

// Check positions
if (IS_ARRAY(_positions)) then {
    {
        if !(_x == 0 || _x == 1) then {
            _errorFound = true;
            BC_LOGERROR_2("addLocks: _positions array has variable other than 0 or 1: %1 -- %2",_positions,_vehicle);
        };
    } forEach _positions;
    if (count _positions != 4) then {
        _errorFound = true;
        BC_LOGERROR_2("addLocks: _positions array is wrong size: %1 -- %2",_positions,_vehicle);
    };
} else {
    _errorFound = true;
    BC_LOGERROR_2("addLocks: _positions is not an array: %1 -- %2",_positions,_vehicle);
};
if (_errorFound) exitWith {};

// ---
// OPTIONALS
// ---

// Check sides
if !(IS_SIDE(_sides)) then {
    if (IS_ARRAY(_sides)) then {
        if (count _sides > 0) then {
            // Empty sides array is fine
            {
                if !(IS_SIDE(_x)) then {
                    _errorFound = true;
                    BC_LOGERROR_3("addLocks: _sides Array has non-side: %1 -- %2 -- %3",_x,_sides,_vehicle);
                };
            } forEach _sides;
        };
    } else {
        _sides = [];
        BC_LOGERROR_2("addLocks: _sides is not ARRAY or SIDE. Allowing all sides: %1 -- %2",_sides,_vehicle);
    };
} else {
    _sides = [_sides];
};
if (_errorFound) exitWith {};

// Check classes
if (isNil "_classes") then {
    _classes = [];
};
if !(IS_ARRAY(_classes)) then {
    _classes = [];
    BC_LOGERROR_2("addLocks: _classes is not an array. Not filtering by class: %1 -- %2",_classes,_vehicle);
};

// Check units
if (isNil "_units") then {
    _units = [];
};
if !(IS_ARRAY(_units)) then {
    BC_LOGERROR_2("addLocks: _units is not an array: %1 -- %2",_units,_vehicle);
} else {
    if (count _units > 0) then {
        {
            if !(IS_OBJECT(_x)) then {
               BC_LOGERROR_2("addLocks: Non object in _units array: %1 -- %2",_units,_vehicle); 
            };
        } forEach _units;
    };
};
if (_errorFound) exitWith {};

// Check _message
if (isNil "_message") then {
    _message = "Your class/side isn't able to access this vehicle/role.";
};
if !(IS_STRING(_message)) then {
    BC_LOGERROR_1("addLocks: Using default message. Custom _message is not a string: %1",_vehicle);
    _message = "Your class/side isn't able to access this vehicle/role.";
};

// Make sure it's not already locked
if (_vehicle in GVAR(lockedList)) exitWith {
    BC_LOGERROR_1("addLocks: Vehicle already locked: %1",_vehicle);
};

[_vehicle, _positions, _classes, _sides, _units, _message] call FUNC(createLock);