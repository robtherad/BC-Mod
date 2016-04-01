#include "\y\bc\addons\common\script_component.hpp"

// Setting a group variable to true on init doesn't syncrhonize in MP. Here we delay by a frame.

params ["_entity", "_str", "_val"];

_entity setVariable [_str, _val]; // for Eden

[{
    params["_entity", "_str", "_val"];
    _entity setVariable [_str, _val, true];
}, [_entity,_str,_val], 0] call EFUNC(common,waitAndExecute);