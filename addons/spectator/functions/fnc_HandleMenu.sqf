// Modified F3 - Spectator Script
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)
// ====================================================================================
private["_button", "_control"];
_control = _this select 0;
_button = _this select 1;
switch (_button) do {
    case 0: { // Toggle AI BUTTON
        bc_spectator_playersOnly = !bc_spectator_playersOnly;
        bc_spectator_listUnits = [];
        lbClear 2100;
        if(bc_spectator_playersOnly) then { _control ctrlSetText "Players only";}
        else { _control ctrlSetText "All units";};
    };
    case 1: { // Side Filter
            // 0 = ALL, 1 = BLUFOR , 2 = OPFOR, 3 = INDFOR , 4 = Civ
            bc_spectator_sideButton = bc_spectator_sideButton +1;
            if(bc_spectator_sideButton > 4) then {bc_spectator_sideButton = 0};
            bc_spectator_side = switch (bc_spectator_sideButton) do {
                case 0: {nil};
                case 1: {west};
                case 2: {east};
                case 3: {independent};
                case 4: {civilian};
            };
            _control ctrlSetText (bc_spectator_sideNames select bc_spectator_sideButton);
            bc_spectator_listUnits = [];
            lbClear 2100;
    };
    case 2: {
        bc_spectator_toggleTags = !bc_spectator_toggleTags;
    };
    case 3: { // Third/First Person Button
        [] call bc_spectator_ToggleFPCamera;
        if(bc_spectator_toggleCamera) then
        {
            _control ctrlSetText "Third Person";
        }
        else
        {
            _control ctrlSetText "First Person";
        }
    }
};