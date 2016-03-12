/* ----------------------------------------------------------------------------
Function: bc_vehLock_fnc_removeLocks
Description:
    Stops a vehicle from being tracked by the vehicle locking script.
Parameters:
    _object - the vehicle to remove locks from <OBJECT>
Examples:
    (begin example)
        [truck] call bc_vehLock_fnc_removeLocks;
    (end)
---------------------------------------------------------------------------- */
#include "script_component.hpp"
params ["_object"];
private ["_object","_handles","_errorFound"];

// No need to add markers for non-humans
if (!hasInterface) exitWith {};

_errorFound = false;

// Check object
if !(IS_OBJECT(_object)) exitWith {
    BC_LOGERROR_1("removeLocks: Non-object passed to script: %1",_object);
};
if (_object isKindOf "Man") exitWith {
    BC_LOGERROR_1("removeLocks: Non-vehicle passed to script: %1",_object);
};

_handles = _object getVariable [QGVAR(handlerIDs),nil];

if (isNil "_handles") exitWith {
    BC_LOGERROR_1("removeLocks: Couldn't find handles for vehicle: %1",_object);
};
if !(IS_ARRAY(_handles)) then {
    BC_LOGERROR_2("removeLocks: Bad event handle container: %1 -- %2",_handles,_object);
    _errorFound = true;
} else {
    {
        if !(IS_INT(_x)) then {
            BC_LOGERROR_3("removeLocks: Bad event handle container: %1 -- %2 -- %3",_x,_handles,_object);
            _errorFound = true;
        };
    } forEach _handles;
};

if !(_object in GVAR(lockedList)) exitWith {
    BC_LOGERROR_2("removeLocks: Bad event handle container: OBJ: %1 -- LIST: %2",_object,GVAR(lockedList));
};

if (_errorFound) exitWith {};

// Remove event handlers
_object removeEventHandler ["GetIn",_handles select 0];
_object removeEventHandler ["SeatSwitched",_handles select 1];
// Reset all variables
_object setVariable [QGVAR(handlerIDs),nil];
_object setVariable [QGVAR(sides), nil];
_object setVariable [QGVAR(positions), nil];
_object setVariable [QGVAR(classes), nil];
_object setVariable [QGVAR(players), nil];
_object setVariable [QGVAR(message), nil];

// Remove vehicle from list of locked vehicles
_id = GVAR(lockedList) find _object;
GVAR(lockedList) deleteAt _id;