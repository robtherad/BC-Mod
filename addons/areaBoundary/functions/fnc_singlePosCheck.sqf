/* ----------------------------------------------------------------------------
Function: bc_areaBoundary_fnc_singlePosCheck
Description:
    Internal function. Gets called by checkBoundsPFH for boundaries where type is 1 or 2.
---------------------------------------------------------------------------- */
#include "script_component.hpp"
params ["_name","_sides","_positions","_isInclusive","_allowAirVeh","_allowLandVeh","_customVariables","_customDelay","_customMessage","_warnCount"];
private["_checkOutEarly", "_value", "_playerInBounds"];

// Check to see if player is on correct side
if (!((side group player) in _sides) && !(_sides isEqualTo [])) exitWith {
    5005 cutText ["","PLAIN",0,true];
    if (_warnCount > 0) then {[_name,0] call FUNC(modifyWarnCount);};
}; 

// Check player type and see if it's not counted
if ((vehicle player) isKindOf "LandVehicle" && _allowLandVeh) exitWith {
    5005 cutText ["","PLAIN",0,true];
    if (_warnCount > 0) then {[_name,0] call FUNC(modifyWarnCount);};
};
if ((vehicle player) isKindOf "Air" && _allowAirVeh) exitWith {
    5005 cutText ["","PLAIN",0,true];
    if (_warnCount > 0) then {[_name,0] call FUNC(modifyWarnCount);};
};

// Check custom variables - Each one should be a string
_checkOutEarly = false;
if (count  _customVariables > 0) then {
    {
        _value = missionNamespace getVariable [_x,true];
        if !(IS_BOOL(_value)) then {
            _customVariables set [_forEachIndex,true];
        } else {
            if !(_value) then {
                _checkOutEarly = true;
            };
        };
    } forEach _customVariables;
};
if (_checkOutEarly) exitWith {
    5005 cutText ["","PLAIN",0,true];
    if (_warnCount > 0) then {[_name,0] call FUNC(modifyWarnCount);};
};

// Make sure player is alive, could have died from other boundary in the same loop through.
if !(alive player) exitWith{};

// Check area for player
// TODO: Replace BIS_fnc_inTrigger with inArea? v1.57
_playerInBounds = [_positions, player] call BIS_fnc_inTrigger;
if !(_isInclusive) then {
    // If player is supposed to be outside of the trigger, invert the BOOL result of BIS_fnc_inTrigger
    _playerInBounds = !_playerInBounds;
};
if (_playerInBounds) exitWith {
    5005 cutText ["","PLAIN",0,true];
    if (_warnCount > 0) then {[_name,0] call FUNC(modifyWarnCount);};
};
    
// Player is not where he's supposed to be
if !(_playerInBounds) then {
    // TODO: Change cutText layer number to layer name. Arma 3 v1.57
    5005 cutText [_customMessage,"PLAIN",0,true];
    5005 cutFadeOut 200;
    INC(_warnCount);
    [_name,_warnCount] call FUNC(modifyWarnCount);
    
    // Player has been warned enough times, kill them
    if (_warnCount > _customDelay) then {
        player setDamage 1;
        5005 cutText ["","PLAIN",0,true];
        BC_LOGDEBUG_2("multiPosCheck: Player was killed by boundary with settings:: %1 -- %2",_name,_this);
    };
};