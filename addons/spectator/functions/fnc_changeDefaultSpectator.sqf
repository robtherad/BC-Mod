// 0 = F3, 1 = EG
#include "script_component.hpp"
private ["_mode"];

_mode = profileNamespace getVariable [QGVAR(defaultSpectatorMode), 0];

INC(_mode);
if (_mode > 1) then {
    _mode = 0;
};

switch (_mode) do {
    case 0: {systemChat "You will now use the F3 spectator script when you die."};
    case 1: {systemChat "You will now use the EG spectator script when you die."};
};

profileNamespace setVariable [QGVAR(defaultSpectatorMode),_mode];
saveProfileNamespace;