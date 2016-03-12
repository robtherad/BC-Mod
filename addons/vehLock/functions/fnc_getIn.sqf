/* ----------------------------------------------------------------------------
Function: bc_vehLock_fnc_getIn
Description:
    Internal Function. Called every time the getIn event happens.
---------------------------------------------------------------------------- */
#include "script_component.hpp"

// TODO: Replace cutText display number with cutText layerName - Arma 3 v1.57

if (!hasInterface) exitWith {};

_unit = _this select 2;
if (_unit == player) then {

    _veh = _this select 0;
    _pos = _this select 1;

    _lckClss = _veh getVariable [QGVAR(classes), []]; // array
    _lckSide = _veh getVariable [QGVAR(sides),[]]; // array
    _lckPosn = _veh getVariable [QGVAR(positions),[]]; // array
    _lckPlyr = _veh getVariable [QGVAR(players),[]];
    _lckMsgs = _veh getVariable [QGVAR(message),""]; // string

    if (count _lckSide > 0) then {
        // LOCK BY SIDE
        if !(side _unit in _lckSide) then {
            // Wrong side
            if !(_unit in _lckPlyr) then {
                // Player not whitelisted
                moveOut _unit;
                5000 cutText [_lckMsgs,"PLAIN DOWN",0.5];
            };
        } else {
            if !(_unit in _lckPlyr) then {
                if ((!(typeOf _unit in _lckClss)) && (_pos in _lckPosn)) then {
                    //systemChat "Player not in list of players!";
                    moveOut _unit;
                    5000 cutText [_lckMsgs,"PLAIN DOWN",0.5];
                };
            };
        };
    } else {
        // LOCK BY CLASS/PLAYER ONLY
        if !(_unit in _lckPlyr) then {
            if (!(typeOf _unit in _lckClss) && (_pos in _lckPosn)) then {
                moveOut _unit;
                5000 cutText [_lckMsgs,"PLAIN DOWN",0.5];
            };
        };
    };
};