if(bc_spectator_mapMode == 0) exitWith {};
disableSerialization;
_fullmapWindow = _this select 0;
_camera = ([] call bc_spectator_GetCurrentCam);
_fullmapWindow drawIcon ["\A3\ui_f\data\GUI\Rsc\RscDisplayMissionEditor\iconCamera_ca.paa", [0,0,0,1],getpos _camera ,20,20,getDir _camera,"",0];
{
    if(alive _x) then {
        _name = "";
        _color = switch (side _x) do {
            case blufor: {bc_spectator_blufor_color};
            case opfor: {bc_spectator_opfor_color};
            case independent: {bc_spectator_indep_color};
            case civilian: {bc_spectator_civ_color};
            default {bc_spectator_empty_color};
        };
        if(isPlayer _x) then {_name = name _x};
        if(leader _x == _x && {isPlayer _x} count units _x > 0) then {_name = format["%1 - %2",toString(toArray(groupID (group _x)) - [45]),_name]};
        if(vehicle _x != _x && crew (vehicle _x) select 0 == _x || vehicle _x == _x) then {
            _icon = (vehicle _x getVariable ["bc_spectator_icon",""]);
            if(_icon == "") then {_icon = gettext (configfile >> "CfgVehicles" >> typeOf (vehicle _x) >> "icon");vehicle _x setVariable ["bc_spectator_icon",_icon]};
            _fullmapWindow drawIcon [_icon,_color,getpos _x,19,19,getDir (vehicle _x),_name,1,0.04,"TahomaB"];
        };
    };

} foreach allunits;

bc_spectator_fired = bc_spectator_fired - [objNull];
if(bc_spectator_tracerOn) then {
    {
        if(!isNull  _x) then {
            _pos = getpos _x;
            _newPos = [(_pos select 0) + (3 * sin(getdir _x)), (_pos select 1) + (3 * cos(getdir _x)), _pos select 2];
            _fullmapWindow drawLine [_pos,_newPos,[1,0,0,1]];
        };
    } foreach bc_spectator_fired;
};
