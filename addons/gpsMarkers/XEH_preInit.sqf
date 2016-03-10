#include "script_component.hpp"

ADDON = false;

#include "XEH_PREP.hpp"

GVAR(disableGPS) = false;

GVAR(gpsIterator) = 0;

GVAR(trackedVehicles) = [];
GVAR(trackedVehiclesList) = [];

GVAR(trackedGroups) = [];
GVAR(trackedGroupsList) = [];


ADDON = true;