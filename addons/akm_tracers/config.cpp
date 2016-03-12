#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"bc_common", "rhs_c_weapons"};
        author[] = {"Bravo Company"};
        authorUrl = "http://bravoco.us";
        magazines[] = {"rhs_30Rnd_762x39mm_tracer"};
        VERSION_CONFIG;
    };
};

#include "CfgMagazines.hpp"