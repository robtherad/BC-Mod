# BC Addon (WIP)

An addon containing small tweaks and fixes for use in Bravo Company's Fight Nights.


**** 

### Current Features
```
akm_tracers
* Fixes RHS 7.62x39 Tracer mag. Actually has a magazine full of tracer rounds now.

common
* Contains some functions that were part of the mission template in the `misc` folder.

gpsMarkers
* A recreation of the gpsmarkers module from BC mission template. A simple framework for creating markers that follow units and or vehicles.

main
* The root of the addon. Contains macros and other stuff used throughout the rest of the addon.

marker_tracker (WIP)
* Allows admins to see who is placing and deleting markers during the briefing phase.

spectator
* A port of the F3 spectator script. Allows for centralized updates to all missions that utilize it.
```
### Plans
In no particular order.

* Document everything.
* Create module system that can be used instead of/alongside `setGroupID`
* Create nicer looking map markers
* Rewrite Radio system for use in non Fight Night missions as well?
* Upload mod to workshop after it's more useful?


****


### Credits

* [CBA Team](https://github.com/CBATeam/CBA_A3)
* [ACE Team](https://github.com/acemod/ACE3)

The structure and workflow of this addon is heavily based on the ACE 3 addon for Arma 3.
