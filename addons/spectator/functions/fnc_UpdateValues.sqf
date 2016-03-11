// F3 - Spectator Script
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)
// ==================================================================
private["_groupArr", "_index", "_listBox", "_tempArr", "_text", "_val"];
_listBox =  2100;
// updaes values for the units listbox.
bc_spectator_checkIndex =
{
    {
        _x SetVariable ["bc_spectator_listBoxIndex",_forEachIndex];
    } foreach bc_spectator_listUnits;
};

// ====================================================================================
while {true} do
{
    // ====================================================================================
    // make the mini map track the player.

    ctrlMapAnimClear ((findDisplay 9228) displayCtrl 1350);
    ((findDisplay 9228) displayCtrl 1350) ctrlMapAnimAdd [0.3, bc_spectator_map_zoom,visiblePosition (camTarget bc_spectator_camera)];
    ctrlMapAnimCommit ((findDisplay 9228) displayCtrl 1350);
    ctrlSetFocus ((findDisplay 9228) displayCtrl 1315);
    // ====================================================================================
    // update string.
    if(alive bc_spectator_curTarget) then
    {
        ctrlSetText [1000,format ["Spectating:%1", name bc_spectator_curTarget]];
    }
    else
    {
        ctrlSetText [1000,format ["Spectating:%1", "Dead"]];
    };
    // ====================================================================================
    // fetch units
    _groupArr = call bc_spectator_fnc_GetPlayers;
    bc_spectator_units = ((_groupArr select 0) + (_groupArr select 1));
    bc_spectator_players = _groupArr select 0;
    // ====================================================================================
    // get the list for players or players/ai
    _tempArr = [];
    if(bc_spectator_playersOnly) then
    {
        _tempArr = bc_spectator_players;
    }
    else
    {
        _tempArr = bc_spectator_units;
    };

    // ====================================================================================
    // Check it and see if they have been added already
    {
        if(!(_x in bc_spectator_listUnits) && ({alive _x} count units _x) > 0 ) then
        {
            _text = toString(toArray(groupID _x) - [45]);
            _index = lbAdd [_listBox,_text];
            _x SetVariable ["bc_spectator_listBoxIndex",_index];
            bc_spectator_listUnits pushBack _x;
            lbSetColor [_listBox,_index,[side _x,false] call BIS_fnc_sideColor];
            {
                if(alive _x) then
                    {
                        if(!(_x in bc_spectator_listUnits) && !(_x iskindof "VirtualMan_F")) then
                        {
                             bc_spectator_listUnits pushBack _x;
                            _text = "    " + name _x;
        //                    if(!isPlayer _x) then
        //                    {
        //                        _text = "    "+ "*AI*";
        //                    };
                            _index = lbAdd [_listBox,_text];
                            _x SetVariable ["bc_spectator_listBoxIndex",_index];
                        };
                    };
            } foreach units _x;
        };
    } foreach _tempArr;

    // ====================================================================================
    // Check if they died etc.

    {
        _index = _x GetVariable ["bc_spectator_listBoxIndex",-1];
        if(typeName _x == "GROUP") then
        {
            if(_index >= 0 && ({alive _x} count units _x) > 0 && {lbText [_listBox,_index] != (toString(toArray(groupID _x) - [45]))}) then
            {
                // there is no lbSetText, so just punt it out of the list and fix it up there..
                lbDelete [_listBox,_index];
                bc_spectator_listUnits = bc_spectator_listUnits - [_x];
                [] call bc_spectator_checkIndex;
            };
            if(({alive _x} count units _x) <= 0  && _index >= 0) then
            {
                lbDelete [_listBox,_index];
                bc_spectator_listUnits = bc_spectator_listUnits - [_x];
                [] call bc_spectator_checkIndex;
            };
        }
        else
        {
            _val = lbText [_listBox,_index] != "    " + name _x;
        //    if(!isPlayer _x) then
        //    {
        //        _val = lbText [_listBox,_index] != "    "+ "*AI*";
        //    };
            if(_index >= 0 && alive _x && _val ) then
            {
                // there is no lbSetText, so just punt it out of the list and fix it up there..
                lbDelete [_listBox,_index];
                bc_spectator_listUnits = bc_spectator_listUnits - [_x];
                [] call bc_spectator_checkIndex;
            };
            if(!alive _x) then
            {
                if(_index >= 0) then
                {
                    lbDelete [_listBox,_index];
                    bc_spectator_listUnits = bc_spectator_listUnits - [_x];
                    [] call bc_spectator_checkIndex;
                };
            };
        };
    } foreach bc_spectator_listUnits;
    sleep 1;
};