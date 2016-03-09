#include "script_component.hpp"

if (isServer) then {[] call FUNC(addPVEH);};

if (hasInterface) then {
    0 = 12 spawn FUNC(addMarkerEHs);
    0 = 53 spawn FUNC(addMarkerEHs);
};