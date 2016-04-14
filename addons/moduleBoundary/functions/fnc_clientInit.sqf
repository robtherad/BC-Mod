/* ----------------------------------------------------------------------------
Function: bc_objectives_fnc_clientInit
Description:
    Activated from module init. Determines which area thing to use and adds it to the client.
---------------------------------------------------------------------------- */
[{
#include "script_component.hpp"
_args params ["_logic","_units","_positions","_isInclusive","_allowAirVeh","_allowLandVeh","_customVariables","_customDelay","_customMessage","_execution","_warnCount"];



if (count _positions > 1) then {
    // Do multiposcheck
} else {
    // Do singleposcheck
};

}, _this] call CBA_fnc_directCall;