// TODO: Add some easier to use options besides code execution on module completion? Select ending maybe with code execution as an option?
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
    class GVAR(timeLimit): Module_F {
        scope = 2; // Editor visibility; 2 will show it in the menu, 1 will hide it.
        displayName = "Mission Timelimit"; // Name displayed in the menu
        icon = "\y\bc\addons\objectives\ui\icon.paa"; // Map icon. Delete this entry to use the default icon
        category = "Multiplayer";
        function = QFUNC(time_module); // Name of function triggered once conditions are met
        functionPriority = 1; // Execution priority, modules with lower number are executed first. 0 is used when the attribute is undefined
        isGlobal = 0; // 0 for server only execution, 1 for global execution, 2 for persistent global execution
        isTriggerActivated = 0; // 1 for module waiting until all synced triggers are activated
        isDisposable = 0; // 1 if modules is to be disabled once it's activated (i.e., repeated trigger activation won't work)

        class Arguments: ArgumentsBaseUnits {
            class duration {
                displayName = "Mission Duration (seconds)"; // Argument label
                description = "The time in seconds that the mission will last."; // Tooltip description
                typeName = "NUMBER"; // Value type, can be "NUMBER", "STRING" or "BOOL"
                defaultValue = "2700";
            };
            class execution {
                displayName = "Ending Code Execution";
                description = "Code to call once the mission duration has been reached. Code runs only on the server. Passed parameters: [_missionDuration]";
                typeName = "STRING";
                defaultValue = "";
            };
        };
        class ModuleDescription: ModuleDescription {
            description = "Tracks time since ";
        };
    };
    class GVAR(destroy): Module_F {
        scope = 2;
        displayName = "Objective - Destroy";
        icon = "\y\bc\addons\objectives\ui\icon.paa";
        category = "Multiplayer";
        function = QFUNC(destroy_module);
        functionPriority = 1;
        isGlobal = 0;
        isTriggerActivated = 0;
        isDisposable = 0;

        class Arguments: ArgumentsBaseUnits {
            class objectiveName {
                displayName = "Objective Name";
                description = "The name of the objective which will be shown to players in tasks, markers, etc.";
                typeName = "STRING";
                defaultValue = "";
            };
            class showObjectPosition {
                displayName = "Show objective position";
                description = "Should the module create a task at the location of the synced object? Warning: If you move the object after the module executes the task marker may not be synced until 5 seconds after the mission starts. The module will not have the task marker follow the object as it moves during the mission.";
                typeName = "BOOL";
                defaultValue = "false";
            };
            class bluforStatus {
                displayName = "Assign Objective to BLUFOR";
                description = "";
                typeName = "NUMBER";
                class values {
                    class neutral {name = "Neutral"; value = 1; default = 1;};
                    class attacker    {name = "Attacker";    value = 2;};
                    class defender    {name = "Defender"; value = 3;};
                };
            };
            class opforStatus {
                displayName = "Assign Objective to OPFOR";
                description = "";
                typeName = "NUMBER";
                class values {
                    class neutral {name = "Neutral"; value = 1; default = 1;};
                    class attacker    {name = "Attacker";    value = 2;};
                    class defender    {name = "Defender"; value = 3;};
                };
            };
            class indforStatus {
                displayName = "Assign Objective to INDFOR";
                description = "";
                typeName = "NUMBER";
                class values {
                    class neutral {name = "Neutral"; value = 1; default = 1;};
                    class attacker    {name = "Attacker";    value = 2;};
                    class defender    {name = "Defender"; value = 3;};
                };
            };
            class defenderTasks {
                displayName = "Create defender tasks";
                description = "Creates defend task for teams set to defend the synced object. Neutral teams will not have any tasks created for them.";
                typeName = "BOOL";
                defaultValue = "true";
            };
            class execution {
                displayName = "Ending Code Execution";
                description = "Code to call once the objective has been destroyed. Code runs only on the server. Passed parameters: [_unit, _killer, _name]. _name is the Objective Name set in the module.";
                typeName = "STRING";
                defaultValue = "";
            };
        };
        class ModuleDescription: ModuleDescription {
            description = "Sync the module to an object. If the module is synced to more than one object or no objects it will not activate.";
            sync[] = {"Anything"};
            class unit {
                description = "Any unit";
                displayName = "Any unit";
                icon = "iconMan";
                side = 1;
            };
        };
    };
    class GVAR(escape): Module_F {
        scope = 2;
        displayName = "Objective - Escape (To/From)";
        icon = "\y\bc\addons\objectives\ui\icon.paa";
        category = "Multiplayer";
        function = QFUNC(escape_module);
        functionPriority = 1;
        isGlobal = 0;
        isTriggerActivated = 0;
        isDisposable = 0;

        class Arguments: ArgumentsBaseUnits {
            //class Units: Units {};
            class escape {
                displayName = "Escape Type";
                description = "Should the synced units be trying to get into or out of the synced trigger's area?";
                typeName = "NUMBER"
                class values {
                    class escapeFrom {name = "To Area"; value = 1; default = 1;};
                    class escapeTo {name = "From Area"; value = 2;};
                };
            };
            class percentage {
                displayName = "Required Percentage to Complete";
                description = "The percentage of alive units synced to the module that need to be present/not present in the trigger's area to complete this objective. From 1 to 0.";
                typeName = "NUMBER";
                defaultValue = "1";
            };
            class createMarker {
                displayName = "Automatically Create Area Marker";
                description = "If enabled the module will automatically create a black border type marker with the same size and shape as the synced trigger.";
                typeName = "BOOL";
                defaultValue = "true";
            };
            class execution {
                displayName = "Ending Code Execution";
                description = "Code to call once the mission duration has been reached. Code runs only on the server. Passed parameters: [_units]";
                typeName = "STRING";
                defaultValue = "";
            };
        };

        class ModuleDescription: ModuleDescription {
            description = "Tracks time since ";
        };
    };
};
