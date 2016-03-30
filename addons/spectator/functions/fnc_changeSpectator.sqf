// 0 = F3, 1 = EG
#include "script_component.hpp"
params [
    ["_newMode", nil, [1]]
];

if (!hasInterface) exitWith {};
if (isNil "_newMode") exitWith {};
if (isNil QGVAR(currentSpectateMode)) exitWith {};

switch (_newMode) do {
    case 0: {
        [GVAR(currentSpectateMode)] call FUNC(exitSpectator);
        [this,objNull,0,0,true, 0] call FUNC(enterSpectator);
        GVAR(currentSpectateMode) = 0;
    };
    case 1: {
        [GVAR(currentSpectateMode)] call FUNC(exitSpectator);
        [this,objNull,0,0,true, 1] call FUNC(enterSpectator);
        GVAR(currentSpectateMode) = 1;
    };
    default {}; // Incorrect mode given
};