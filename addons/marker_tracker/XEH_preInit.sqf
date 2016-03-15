#include "script_component.hpp"

ADDON = false;

#include "XEH_PREP.hpp"

GVAR(UIDList) = [
    "76561198045454995", // Stardog
    "76561198024016943", // Derisotre
    "76561197984984312" // robtherad
];
GVAR(forceDisplay) = false; // When true, admins can see info about markers placed after briefing
GVAR(logMarker) = true; // When true, server logs the info about markers placed
GVAR(showOtherSide) = false; // When true, admins can see info about markers placed by players on other teams

ADDON = true;