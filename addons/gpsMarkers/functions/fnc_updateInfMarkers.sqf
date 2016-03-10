/* ----------------------------------------------------------------------------
Function: bc_gpsMarkers_updateInfMarkers
Description:
    Internal function. Updates the state of markers attached to infantry.
Examples:
    (begin example)
        call bc_gpsMarkers_updateInfMarkers;
    (end)
---------------------------------------------------------------------------- */
#include "script_component.hpp"

{ //forEach GVAR(trackedGroups)
    _x params ["_group","_markerName","_sides"];
    private["_group","_markerName","_sides","_lastInside", "_markerName2", "_senior", "_string", "_unit", "_unitInside"];
    _markerName2 = _markerName + "Size";
    if ("ItemGPS" in (assignedItems player)) then { //Check if player has GPS
        if ((side group player) in _sides) then { //Check if player is supposed to be able to see this group
            _markerName setMarkerAlphaLocal 1; //If player has GPS and same side, show marker
            _markerName2 setMarkerAlphaLocal 1;
            
            { //forEach allUnits in _group
                //Check members in group for GPS and update the marker to the position of the most senior member in the group who has GPS
                _unit = _x;
                _senior = _group getVariable [QGVAR(seniorGPS),objNull];
                if (!("ItemGPS" in (assignedItems _senior)) || (!alive _senior)) then { //Make sure most senior unit still has GPS and is alive
                    _group setVariable [QGVAR(seniorGPS),objNull];
                    _senior = objNull;
                };
                
                //If _senior isn't group leader make sure group leader has no gps.
                if (_senior != leader _group) then {
                    if ("ItemGPS" in (assignedItems (leader _group))) then {
                        _senior = leader _group;
                        _group setVariable [QGVAR(seniorGPS),(leader _group)];
                    };
                };
                
                //_senior = _group getVariable [QGVAR(seniorGPS),objNull]; // put this here or _senior won't update for the below code block
                if (("ItemGPS" in (assignedItems _unit)) && ((isNull _senior) || (_senior == _unit))) then { //no reason to run this stuff if _unit isn't the most senior member
                    if (isNull _senior) then {
                        _group setVariable [QGVAR(seniorGPS),_unit]; //no better match than _unit
                    };
                    if (vehicle _unit != _unit) then { //If unit isn't on foot and vehicle doesn't have a marker
                        _unitInside = (vehicle _unit) getVariable QGVAR(unitInsideVeh);
                        _lastInside = (vehicle _unit) getVariable QGVAR(lastInsideVeh);
                        if (isNil "_lastInside") then {_lastInside = "Nobody"};
                        if ((!isNil "_unitInside") && (_lastInside != groupID _group)) then {
                            _string = ((vehicle _unit) getVariable QGVAR(unitInsideVeh)) + " | " + (groupID _group);
                            (vehicle _unit) setVariable [QGVAR(unitInsideVeh),_string];
                            (vehicle _unit) setVariable [QGVAR(lastInsideVeh),groupID _group];
                        } else {
                            (vehicle _unit) setVariable [QGVAR(unitInsideVeh),groupID _group];
                            (vehicle _unit) setVariable [QGVAR(lastInsideVeh),groupID _group];
                        };
                        if (count GVAR(trackedVehicles) > 0) then {
                            if (vehicle _unit in GVAR(trackedVehiclesList)) then {
                                _markerName setMarkerAlphaLocal 0; //Hide marker when unit is in a vehicle that has a marker
                                _markerName2 setMarkerAlphaLocal 0;
                            } else {
                                _markerName setMarkerAlphaLocal 1; //Vehicle doesn't have a marker, show unit's marker instead
                                _markerName2 setMarkerAlphaLocal 1;
                            };
                        };
                    } else {
                        _markerName setMarkerAlphaLocal 1; //Show marker when unit is not in a vehicle with a marker
                        _markerName2 setMarkerAlphaLocal 1;
                    };
                    _markerName setMarkerPosLocal (getPos _unit);
                    _markerName2 setMarkerPosLocal (getPos _unit);
                };
            } forEach units _group;
        };
    } else {
        _markerName setMarkerAlphaLocal 0; // Player has no GPS
        _markerName2 setMarkerAlphaLocal 0;
    };
} forEach GVAR(trackedGroups);