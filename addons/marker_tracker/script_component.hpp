#define COMPONENT marker_tracker
#include "\y\bc\addons\main\script_mod.hpp"

// #define DEBUG_MODE_FULL
// #define DISABLE_COMPILE_CACHE
// #define CBA_DEBUG_SYNCHRONOUS
// #define ENABLE_PERFORMANCE_COUNTERS

#ifdef DEBUG_ENABLED_MARKERS
    #define DEBUG_MODE_FULL
#endif

#ifdef DEBUG_SETTINGS_MARKERS
    #define DEBUG_SETTINGS DEBUG_SETTINGS_MARKERS
#endif

#include "\y\bc\addons\main\script_macros.hpp"