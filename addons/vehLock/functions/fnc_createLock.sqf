/* ----------------------------------------------------------------------------
Function: bc_vehLock_fnc_createLock
Description:
    Internal function. Handles the 
---------------------------------------------------------------------------- */
#include "script_component.hpp"
params ["_vehicle","_lockedPositions","_lockedClasses","_lockedSides","_lockedPlayers","_lockedMessage"];
private ["_getInEHID", "_seatSwitchedEHID"];

if (!hasInterface) exitWith {};

// Convert position array to text
switch (_lockedPositions) do {
    //DRIVER, GUNNER, COMMANDER, CARGO
    case [0,0,0,0]: { _lockedPositions = []; };
    // 1
    case [1,0,0,0]: { _lockedPositions = ["driver"]; };
    case [0,1,0,0]: { _lockedPositions = ["gunner"]; };
    case [0,0,1,0]: { _lockedPositions = ["commander"]; };
    case [0,0,0,1]: { _lockedPositions = ["cargo"]; };
    // 2
    case [1,1,0,0]: { _lockedPositions = ["driver","gunner"]; };
    case [0,1,1,0]: { _lockedPositions = ["gunner","commander"]; };
    case [0,0,1,1]: { _lockedPositions = ["commander","cargo"]; };
    case [1,0,0,1]: { _lockedPositions = ["driver","cargo"]; };
    case [0,1,0,1]: { _lockedPositions = ["gunner","cargo"]; };
    case [1,0,1,0]: { _lockedPositions = ["driver","commander"]; };
    // 3
    case [1,1,1,0]: { _lockedPositions = ["driver","gunner","commander"]; };
    case [1,1,0,1]: { _lockedPositions = ["driver","gunner","cargo"]; };
    case [1,0,1,1]: { _lockedPositions = ["driver","commander","cargo"]; };
    case [0,1,1,1]: { _lockedPositions = ["gunner","commander","cargo"]; };
    //4
    case [1,1,1,1]: { _lockedPositions = ["driver","gunner","commander","cargo"]; };
};

// Set variables to vehicle
_vehicle setVariable [QGVAR(sides), _lockedSides];
_vehicle setVariable [QGVAR(positions), _lockedPositions];
_vehicle setVariable [QGVAR(classes), _lockedClasses];
_vehicle setVariable [QGVAR(players), _lockedPlayers];
_vehicle setVariable [QGVAR(message), _lockedMessage];

// Add EventHandlers to vehicle
_getInEHID = _vehicle addEventHandler ["GetIn", FUNC(getIn)];
_seatSwitchedEHID = _vehicle addEventHandler ["SeatSwitched", FUNC(seatSwitched)];

_vehicle setVariable [QGVAR(handlerIDs),[_getInEHID,_seatSwitchedEHID]];

GVAR(lockedList) pushBack _vehicle;