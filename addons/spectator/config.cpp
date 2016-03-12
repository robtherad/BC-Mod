#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"bc_common"};
        author[] = {"F3", "Head"};
        authorUrl = "http://bravoco.us";
        VERSION_CONFIG;
    };
};

#include "CfgEventHandlers.hpp"
#include "interface.hpp"