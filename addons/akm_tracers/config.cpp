#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"bc_common", "rhs_c_weapons"};
        author[] = {"Bravo Company"};
        authorUrl = "http://bravoco.us";
        magazines[] = {"rhs_30Rnd_762x39mm_tracer"};
        VERSION_CONFIG;
    };
};
class CfgMagazines {

    class rhs_30Rnd_762x39mm;

    class rhs_30Rnd_762x39mm_tracer: rhs_30Rnd_762x39mm {
        tracersEvery = 1;
    };
};
