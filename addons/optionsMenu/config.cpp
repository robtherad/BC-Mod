#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"bc_common"};
        author[] = {"Glowbal", "PabstMirror"};
        authorUrl = "http://github.com/Glowbal";
        VERSION_CONFIG;
    };
};

class CfgAddons {
    class PreloadAddons {
        class ADDON {
            list[] = {QUOTE(ADDON)};
        };
    };
};


#include "CfgEventHandlers.hpp"
#include "gui\define.hpp"
#include "gui\settingsMenu.hpp"
#include "gui\pauseMenu.hpp"

//#include "CfgVehicles.hpp"
#include "ACE_Settings.hpp"


class CfgCommands {
    allowedHTMLLoadURIs[] += {
        "http://ace3mod.com/version.html"
    };
};
