#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"bc_common"};
        author = "Bravo Company";
        VERSION_CONFIG;
    };
};

#include "CfgEventHandlers.hpp"
