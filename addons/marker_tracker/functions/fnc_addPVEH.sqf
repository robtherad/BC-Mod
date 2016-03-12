/* ----------------------------------------------------------------------------
Function: bc_marker_tracker_fnc_addMarkerEHs
Description:
    Adds event handler to server that listens for client input.
Author:
    KillzoneKid - http://killzonekid.com/arma-scripting-tutorials-whos-placingdeleting-markers/
---------------------------------------------------------------------------- */
#include "script_component.hpp"

if (!isServer) exitWith {};

"MrkOpPV" addPublicVariableEventHandler {
    (_this select 1) spawn FUNC(pvehAction)
};