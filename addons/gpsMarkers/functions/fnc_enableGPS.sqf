/* ----------------------------------------------------------------------------
Function: bc_gpsMarkers_enableGPS
Description:
    After 5 seconds, starts a new PFH that runs bc_gpsMarkers_updatePFH every 2.5 seconds. During the 5 seconds, forces bc_gpsMarkers_disableGPS to TRUE to ensure that no other PFHs are running that function.
Examples:
    (begin example)
        call bc_gpsMarkers_enableGPS;
    (end)
---------------------------------------------------------------------------- */
#include "script_component.hpp"

// Get delayedRemove
_delayedRemove = diag_tickTime + 5;

// Remove any running PFHs
GVAR(disableGPS) = true;

// PFH
[FUNC(enableGPSPFH), 1, [_removeTime]] call CBA_fnc_addPerFrameHandler;
