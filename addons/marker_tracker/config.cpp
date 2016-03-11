#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"bc_common"};
        author[] = {"KillzoneKid","Bravo Company"};
        authorUrl = "http://bravoco.us";
        VERSION_CONFIG;
    };
};

#include "CfgEventHandlers.hpp"
