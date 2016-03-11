/* ----------------------------------------------------------------------------
Function: bc_marker_tracker_fnc_addMarkerEHs
Description:
    Adds event handler to server that listens for client input.
---------------------------------------------------------------------------- */
#include "script_component.hpp"

if (!isServer) exitWith {};

"MrkOpPV" addPublicVariableEventHandler {
    (_this select 1) spawn FUNC(pvehAction)
};