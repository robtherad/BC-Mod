// F3 - Spectator Script
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)
// ====================================================================================
// gets all the player groups and filter out the AI.
private ["_arr"];
_players = [];
_ai = [];
{
    if(isNil "bc_spectator_side" || {side _x == bc_spectator_side}) then
    {
        if({isPlayer _x} count (units _x) > 0) then {_players pushBack _x}
        else {_ai pushBack _x};
    };

} foreach allGroups;
[_players,_ai]
