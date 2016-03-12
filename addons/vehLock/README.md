## vehLock.pbo

A framework for mission makers to manage access to vehicles in their missions.

****

### Usage:

#### - Enabling locks for vehicle
As a mission maker, the vehLock module gives you multiple options for limiting access to vehicles in your mission. You can limit access by player side, player class, or player unit. 

When adding locks to a vehicle you will need to supply the vehicle as well as the array of positions. After that you will want to supply at least one of the optional parameters. If you want to limit 

```
[_vehicle,[driver,commander,gunner,passenger],[sides],[classes],[units],"Message"] call bc_vehLock_fnc_addLocks;

Parameters:
    _vehicle - the vehicle to add locks to <OBJECT>
    _positions - the positions that will be locked by class in the order of: [driver, commander, gunner, cargo]. takes 1 for locked, 0 for unlocked <ARRAY>
Optional Parameters:
    _sides - the side(s) that will be able to enter the vehicle. set to [] to allow all sides. set to sideUnknown to allow none. <SIDE> or <ARRAY>
    _classes - unit class names that can enter the locked _positions. must abide by side restrictions. set to [] if you don't want to limit by class. <ARRAY>
    _units - unit names that can enter locked positions of the vehicle. ignores class and side restrictions. set to [] if  you don't want to limit by unit names <ARRAY>
    _message - message to display when a player isnt able to enter a locked vehicle or switch seats to a locked position. <STRING>
Examples:
    (begin example)
    (ex1) // Simplest locking system. Only BLUFOR players can enter Helicopter. Any player can enter any slot.
        [Helicopter,[0,0,0,0],west] call bc_vehLock_fnc_addLocks;
    (ex2) // Locks APC so only BLUFOR players can get in it. Only BLUFOR crewmen can drive, gun, or command. Anyone on BLUFOR can get in as a passenger. OPFOR, etc, can't get in at all.
        [APC,[1,1,1,0],west,["B_crew_F"]] call bc_vehLock_fnc_addLocks;
    (ex3) // Allows nobody to enter truck except for the unit named truckDriver. Displays a custom message.
        [truck,[1,0,0,0],sideUnknown,[],[truckDriver],"Only the truck driver can drive this."] call bc_vehLock_fnc_addLocks;
    (ex4) // Anyone from any side can enter APC as a passenger but only crewmen from BLUFOR, OPFOR, and INDFOR can drive, command, and gun the APCs.
        [APC,[1,1,1,0],[],["B_crew_F","O_crew_F","I_crew_F"]] call bc_vehLock_fnc_addLocks;
    (end)```

#### - Disabling locks for locked vehicle

If you want to disable the locks added by this module use the following command, replacing `VEHICLE` with the name of the vehicle you want to remove the locks from.

```[VEHICLE] call bc_vehLock_fnc_removeLocks;```
