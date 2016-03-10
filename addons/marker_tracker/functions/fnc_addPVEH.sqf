#include "script_component.hpp"

if (!isServer) exitWith {};

"MrkOpPV" addPublicVariableEventHandler {
    (_this select 1) spawn FUNC(pvehAction)
};