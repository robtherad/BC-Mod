/*
 * Name: TMF_common_fnc_sideToNum
 * Author: Snippers
 *
 * Arguments:
 * side
 *
 * Return:
 * scalar
 *
 * Description:
 * Will return the number associated to a side as used by the BI configs. This allows lookup interaction with the side property for factions in factionclasses.
 */

if (_this == east) exitWith {0};
if (_this == west) exitWith {1};
if (_this == independent) exitWith {2};
if (_this == civilian) exitWith {3};
if (_this == sideLogic) exitWith {7};
-1