#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"bc_common"};
        author = MOD_TEAM;
        authors[] = {"KillzoneKid","robtherad"};
        authorUrl = "http://bravoco.us";
        VERSION_CONFIG;
    };
};

#include "CfgEventHandlers.hpp"
