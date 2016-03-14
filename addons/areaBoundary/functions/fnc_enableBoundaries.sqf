/* ----------------------------------------------------------------------------
Function: bc_areaBoundary_fnc_enableBoundaries
Description:
    Re-enables the boundaries function after 10 seconds to ensure that the module is only running once.
Examples:
    (begin example)
        call bc_areaBoundary_fnc_enableBoundaries;
    (end)
---------------------------------------------------------------------------- */
#include "script_component.hpp"
private ["_removeTime"];

if (!hasInterface) exitWith {};

// Get delayedRemove
_removeTime = diag_tickTime + 10;

// Remove any running PFHs
GVAR(disableBoundaries) = true;

// PFH
[FUNC(enableBoundariesPFH), 1, [_removeTime]] call CBA_fnc_addPerFrameHandler;
