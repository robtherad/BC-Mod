#include "script_component.hpp"

if (isServer) then {[] call FUNC(getMGRSdata);};

if (hasInterface) then {
    [12] call FUNC(getMGRSdata)
    [53] call FUNC(getMGRSdata)
};