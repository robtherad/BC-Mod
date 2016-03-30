/*
 * Name: TMF_common_fnc_numToSide
 * Author: Snippers
 *
 * Arguments:
 * scalar
 *
 * Return:
 * side
 *
 * Description:
 * Will return the side associated with the number as used by the BI configs. This allows lookup interaction with the side property for factions in factionclasses.
 */

if (_this == 0) exitWith {east};
if (_this == 1) exitWith {west};
if (_this == 2) exitWith {independent};
if (_this == 3) exitWith {civilian};
if (_this == 7) exitWith {sideLogic};
sideUnknown