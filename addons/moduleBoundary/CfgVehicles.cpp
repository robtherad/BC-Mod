// TODO: Add ability to use scaling widget to configure boundary area instead of having to sync to a trigger or multiple logics
class CfgVehicles {
    class Logic;
    class Module_F: Logic {
        class ArgumentsBaseUnits {
            class Units;
        };
        class ModuleDescription {
            class AnyBrain;
        };
    };
    class GVAR(boundary): Module_F {
        scope = 2; // Editor visibility; 2 will show it in the menu, 1 will hide it.
        displayName = "Player Mission Boundary"; // Name displayed in the menu
        icon = "\y\bc\addons\objectives\ui\icon.paa"; // Map icon. Delete this entry to use the default icon
        category = "Multiplayer";
        function = QFUNC(moduleInit); // Name of function triggered once conditions are met
        functionPriority = 1; // Execution priority, modules with lower number are executed first. 0 is used when the attribute is undefined
        isGlobal = 0; // 0 for server only execution, 1 for global execution, 2 for persistent global execution
        isTriggerActivated = 0; // 1 for module waiting until all synced triggers are activated
        isDisposable = 0; // 1 if modules is to be disabled once it's activated (i.e., repeated trigger activation won't work)

        class Arguments: ArgumentsBaseUnits {
            class TMFUnits {
                description = "Units that should be limited by this module's boundary.";
                displayName = "Apply to";
                typeName = "NUMBER";
                class values {
                    class Everyone {name = "All units"; value = -1; default = 1;};
                    class Objects {name = "Synchronized units only"; value = 0;};
                    class ObjectsAndGroups {name = "Groups of synchronized units"; value = 1;}
                    class Side {name = "Every unit on the units side"; value = 2;};
                };
            };
            class condition {
                displayName = "Additional Conditions"; // Argument label
                description = "Additional variables that must be true, along with the unit being out of bounds, for the code in the module's execution box to be called. Separate the variables by commas."; // Tooltip description
                typeName = "STRING"; // Value type, can be "NUMBER", "STRING" or "BOOL"
                defaultValue = "";
            };
            class isInclusive {
                displayName = "Is Area Inclusive";
                description = "Should the module call the code in the execution box when players are inside the area (false) or when players are outside the area (true)";
                typeName = "BOOL";
                defaultValue = "true";
            };
            class allowAir {
                displayName = "Allow Air";
                description = "Let players in Air vehicles (helicopters, planes) leave the boundary without risking consequences.";
                typeName = "BOOL";
                defaultValue = "false";
            };
            class allowLandVeh {
                displayName = "Allow Land Vehicles";
                description = "Let players in Land vehicles (apcs, cars, tanks, etc) leave the boundary without risking consequences.";
                typeName = "BOOL";
                defaultValue = "false";
            };
            class message {
                displayName = "Warning Message";
                description = "A message that is displayed to the player, using cutText, every 5 seconds once they leave the module's boundary. Passed parameters: [_remainingTime]";
                typeName = "STRING";
                defaultValue = "Warning!\n You are outside of the mission boundary, turn back now!";
            };
            class delay {
                displayName = "Delay before execution";
                description = "The time in seconds before the code in the execution box will be run once a unit is outside of the module's boundary. Delays should be multiples of 5.";
                typeName = "NUMBER";
                defaultValue = "30";
            };
            class execution {
                displayName = "Execution";
                description = "Code to call on the server once a unit leaves the boundary. Code runs only on the server. Passed parameters: [_unit]";
                typeName = "STRING";
                defaultValue = "(_this select 0) setDamage 1;";
            };
            class createMarkers {
                displayName = "Create Markers";
                description = "Automatically creates markers representing the module's boundary. Choose 'No Markers' to disable, otherwise choose a color for the markers to be. Markers are visible to all sides.";
                typeName = "STRING";
                class values {
                    class none {name = "No Markers"; value = "None"; default = 1;};
                    class red {name = "Red Markers";    value = "ColorRed";};
                    class blue {name = "Blue Markers"; value = "ColorBlue";};
                    class green {name = "Green Markers";    value = "ColorGreen";};
                    class yellow {name = "Yellow Markers"; value = "ColorYellow";};
                    class orange {name = "Orange Markers";    value = "ColorOrange";};
                    class brown {name = "Brown Markers"; value = "ColorBrown";};
                    class blufor {name = "BLUFOR Color Markers";    value = "ColorWEST";};
                    class opfor {name = "OPFOR Color Markers"; value = "ColorEAST";};
                    class resistance {name = "INDFOR Color Markers";    value = "ColorGUER";};
                    class civillian {name = "Civillian Color Markers"; value = "ColorCIV";};
                };
            };
        };
    };
};
