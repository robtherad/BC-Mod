// F3 - Spectator Script
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)
// ==================================================================
// draw tags
if(!bc_spectator_toggleTags || bc_spectator_mapMode == 2 ) exitWith{};
{
    _drawUnits = [];
    _drawGroup = false;
    _isPlayerGroup = false;
    {
        _distToCam = (call bc_spectator_GetCurrentCam) distance _x;
        if(isPlayer _x) then {_isPlayerGroup = true};
        if(_distToCam < 250) then {
            _drawUnits pushBack _x;
            if (_distToCam > 200) then {
                _drawGroup = true;
            };
        }
        else
        {
            _drawGroup = true;
        };
    } foreach units _x;
    _color = switch (side _x) do {
        case blufor: {bc_spectator_blufor_color};
        case opfor: {bc_spectator_opfor_color};
        case independent: {bc_spectator_indep_color};
        case civilian: {bc_spectator_civ_color};
        default {bc_spectator_empty_color};
    };
    if(_drawGroup) then {
        _visPos = getPosATLVisual leader _x;
        if(surfaceIsWater _visPos) then  {_visPos = getPosASLVisual leader _x;};
        if(_isPlayerGroup) then {
            _color set [3,0.7];
        }
        else {
            _color set [3,0.4];
        };
        _str = _x getVariable ["bc_spectator_nicename",""];
        if(_str == "") then {
            _str = (toString(toArray(_x getVariable ["BC_LongName",(groupID _x)]) - [45]));
            _x setVariable ["bc_spectator_nicename",_str];
        };
        drawIcon3D ["\A3\ui_f\data\map\markers\nato\b_inf.paa", _color,[_visPos select 0,_visPos select 1,(_visPos select 2) +30], 1, 1, 0,_str, 2, 0.025, "TahomaB"];
    };

    {
        if(vehicle _x == _x && alive _x || vehicle _x != _x && (crew vehicle _x) select 0 == _x && alive _x) then {
            _visPos = getPosATLVisual _x;
            if(surfaceIsWater _visPos) then  {_visPos = getPosASLVisual _x;};
            _color set [3,0.9];
            _str = "";
            _icon = "\A3\ui_f\data\map\markers\military\dot_CA.paa";
            if(isPlayer _x) then
            {
                _str = name _x;
            };
            drawIcon3D [_icon, _color,[_visPos select 0,_visPos select 1,(_visPos select 2) +3],0.7,0.7, 0,_str, 2,bc_spectator_tagTextSize, "TahomaB"];
        };
    } foreach _drawUnits;


} forEach allGroups;

sectorControl = missionNamespace getVariable "bc_sectorControlActive";
if (!isNil "sectorControl") then {
    if (sectorControl) then {
        _iconSize = 0.5;
        _textSize = 0.03;
        { //forEach bc_triggerArray;
            _distToCam = (call bc_spectator_GetCurrentCam) distance _x;
            _owner = _x getVariable "bc_sec_lastOwner";
            _color = switch (_owner) do {
                case 0: {bc_spectator_blufor_color};
                case 1: {bc_spectator_opfor_color};
                case 2: {bc_spectator_gray_color};
                case 3: {bc_spectator_gray_color};
                default {bc_spectator_gray_color};
            };
            _color set [3,1];
            iconName = triggerText _x;
            switch (_owner) do {
                case 0: {iconName = str(iconName) + " - BLUFOR";};
                case 1: {iconName = str(iconName) + " - OPFOR";};
                case 2: {iconName = str(iconName) + " - CONTESTED";};
                case 3: {iconName = str(iconName) + " - Neutral";};
                default {iconName = str(iconName) + " - ERROR";};
            };
            //SECTOR TAG SCALING - GET BIGGER THE FURTHER AWAY THE CAMERA IS FROM THE TAG
            _maxDist = 700;
            _minDist = 200;
            if (((_distToCam - _minDist)/(_maxDist-_minDist)) >= .5) then {
                if (((_distToCam - _minDist)/(_maxDist-_minDist)) <= .75) then {
                    _iconSize = ((_distToCam - _minDist)/(_maxDist-_minDist));
                } else {
                    _iconSize = .75;
                };
            } else {
                _iconSize = .5;
            };
            if (((_distToCam - _minDist)/(_maxDist-_minDist))*.025 >= .02) then {
                if (((_distToCam - _minDist)/(_maxDist-_minDist))*.025 <= .025) then {
                    _textSize = ((_distToCam - _minDist)/(_maxDist-_minDist))*.025;
                } else {
                    _textSize = .025;
                };
            } else {
                _textSize = .02;
            };
            //hint format ["_distToCam = %3\n_iconSize = %1\n_textSize = %2",_iconSize,_textSize,_distToCam];
            if (_distToCam > _maxDist) then {
                drawIcon3D ["\A3\ui_f\data\map\markers\military\flag_ca.paa",_color,getpos _x,.75,.75,0,iconName,2,0.025,"TahomaB"];
            };
            if (_distToCam < _maxDist) then {
                drawIcon3D ["\A3\ui_f\data\map\markers\military\flag_ca.paa",_color,getpos _x ,_iconSize,_iconSize,0,iconName,2,_textSize,"TahomaB"];
            };
        } forEach bc_triggerArray;
    };
};
