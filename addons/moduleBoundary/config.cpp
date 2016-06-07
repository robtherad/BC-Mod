#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        units[] = {QGVAR(timeLimit), QGVAR(destroy), QGVAR(escape)};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"bc_common"};
        author = MOD_TEAM;
        authors[] = {"robtherad"};
        authorUrl = "http://bravoco.us";
        VERSION_CONFIG;
    };
};

#include "CfgVehicles.cpp"
#include "CfgEventHandlers.hpp"
