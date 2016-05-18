/* ----------------------------------------------------------------------------
Function: bc_objectives_fnc_changeOwner
Description:
    Called from clients. Changes the owner of a unit.
---------------------------------------------------------------------------- */
#include "script_component.hpp"
private _unit = param [1, nil, objNull];

if (!isServer) exitWith {};
if (isNil "_unit") exitWith {};

private _owner = owner _unit;
_this remoteExecCall [QFUNC(addUnit), _owner];