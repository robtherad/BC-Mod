#include "script_component.hpp"

// [this,objNull,0,0,true] call bc_spectator_fnc_enterSpectator;
params [
    "_newUnit", 
    "_oldUnit", 
    "_respawn", 
    "_respawnDelay", 
    ["_forced", false, [false]],
    ["_mode", nil, [1]]
];

BC_LOGDEBUG_1("enterSpectator: _this = %1 ",_this);

GVAR(isSpectator) = true;

if (isNil "_mode") then {
    _mode = profileNamespace getVariable [QGVAR(defaultSpectatorMode), 0];
};
switch (_mode) do {
    case 0: {
        BC_LOGDEBUG("enterSpectator: F3 Spect call");
        [_newUnit, _oldUnit, _respawn, _respawnDelay, _forced] call FUNC(CamInit);
    };
    case 1: {
        BC_LOGDEBUG("enterSpectator: EG Spect call");
        ["Initialize", [player, [], true]] call BIS_fnc_EGSpectator;
        deleteVehicle player;
    };
    default {
        BC_LOGERROR("enterSpectator: Tried to enter non-existent spectator mode, defaulting to F3");
        [_newUnit, _oldUnit, _respawn, _respawnDelay, _forced] call FUNC(CamInit);
    };
};