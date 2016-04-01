#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"bc_main"};
        author[] = {"robtherad"};
        authorUrl = "http://bravoco.us";
        VERSION_CONFIG;
    };
};

#include "CfgFunctions.hpp"
#include "CfgEventHandlers.hpp"
#include "Cfg3DEN.hpp"
#include "display3DEN.hpp"
