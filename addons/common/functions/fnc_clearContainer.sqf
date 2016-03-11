/* ----------------------------------------------------------------------------
Function: bc_common_fnc_clearContainer
Description:
    Remotely (from server) remove all items from an object
Parameters:
    _object - the object <OBJECT>
Examples:
    (begin example)
        [crate] call bc_common_fnc_clearContainer;
    (end)
---------------------------------------------------------------------------- */
params ["_object"];
if (!isServer) exitWith {};

clearWeaponCargoGlobal _object;
clearMagazineCargoGlobal _object;
clearBackpackCargoGlobal _object;
clearItemCargoGlobal _object;