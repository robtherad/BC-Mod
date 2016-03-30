
#include "script_component.hpp"
params [
    ["_currentMode", nil, [1]]
];

if (isNil "_currentMode") exitWith {};

BC_LOGDEBUG_1("exitSpectator: Trying to exit: %1",_currentMode);

switch (_currentMode) do {
    case 0: {
        call FUNC(ForceExit);
    };
    case 1: {
        ["Terminate"] call BIS_fnc_EGSpectator;
    };
    default {BC_LOGERROR("exitSpectator: Tried to exit non-existent spectator mode.");};
};

GVAR(isSpectator) = false;