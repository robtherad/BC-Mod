/* ----------------------------------------------------------------------------
Function: bc_objectives_fnc_destroy_module
Description:
    Activated by the Objective - Destroy module ingame. Adds a killed EH to the synced object and creates tasks for specified teams.
---------------------------------------------------------------------------- */
#include "script_component.hpp"
params ["_logic", "_logicList"];

private _count = count _logicList;
private _logicToSearch = _logicList select (_count - 1);
// BC_LOGDEBUG_1("searchConnections - _logicToSearch: %1",_logicToSearch);
private _searchList = (synchronizedObjects _logicToSearch);
private _searchCount = count _searchList;
if (_searchCount isEqualTo 2 || _searchCount isEqualTo 3 && {_logic in _searchList}) then {
    if ((_logicToSearch isEqualTo (_logicList select 0)) && {_count > 1}) then {
        // BC_LOGDEBUG("searchConnections - Count equal to 3 - Boundary Complete");
        _logic setVariable [QGVAR(boundaryComplete), true];
    } else {
        // BC_LOGDEBUG("searchConnections - Count equal to 2");
        private _pushedBack = false;
        {
            if (!(_x in _logicList) && {_x isKindOf "LocationArea_F"} && {!_pushedBack}) then {
                _logicList pushBack _x;
                _pushedBack = true;
            };
        } forEach _searchList;
        if ((count _logicList) isEqualTo _count) then {
            _searchLogics = false;
            // BC_LOGDEBUG("searchConnections - Inside count didn't change");
            _logic setVariable [QGVAR(logicList), _logicList];
        } else {
            _logic setVariable [QGVAR(logicList), _logicList];
            // BC_LOGDEBUG_1("searchConnections - Setting _logicList: %1",_logicList);
            [_logic, _logicList] call FUNC(searchConnections);
        };
    };
} else {
    _logic setVariable [QGVAR(logicList), []];
    BC_LOGERROR("searchConnections - Area logics not synced properly. See documentation for more info.");
};