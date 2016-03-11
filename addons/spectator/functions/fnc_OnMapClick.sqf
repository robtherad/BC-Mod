private["_chosen", "_dist", "_ents", "_pos", "_y"];
_pos = (_this select 0) ctrlMapScreenToWorld [(_this select 2), (_this select 3)];
if(bc_spectator_mapMode == 2) then
{
    if(bc_spectator_mode == 0 || bc_spectator_mode == 1) then
    {
        _chosen = nil;
        _dist = 99999;
        _ents = _pos nearEntities [["CAManBase","AllVehicles"],10];
        {
            {
                if(_pos distance _x <= _dist && _x in bc_spectator_listUnits) then
                {

                    _chosen = _x;
                    _dist = _pos distance _x;
                };
            } foreach crew _x;
        } foreach _ents;
        if(!isNil "_chosen") then
        {
            bc_spectator_curTarget = _chosen;
            if(bc_spectator_toggleCamera) then
            {
              bc_spectator_curTarget switchCamera "INTERNAL";
            };

            // hide map
            bc_spectator_mapMode = 0;
            ctrlShow [2110,true];
            ctrlShow [2010,true];
            ctrlShow [1350,false];
            ctrlShow [1360,false];


            ctrlSetText [1000,format ["Spectating:%1", name bc_spectator_curTarget]];
        };
    };
    if(bc_spectator_mode == 3) then
    {
        _x = _pos select 0;
        _y = _pos select 1;
        bc_spectator_freecamera setPosASL [_x,_y,((getposASL bc_spectator_freecamera) select 2 ) max ((getTerrainHeightASL [_x,_y])+1)];
        // hide map
        bc_spectator_mapMode = 0;
        ctrlShow [2110,true];
        ctrlShow [2010,true];
        ctrlShow [1350,false];
        ctrlShow [1360,false];

    };
};
true