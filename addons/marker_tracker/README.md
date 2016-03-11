## marker_tracker.pbo
A module that allows for admins to see who is creating/deleting markers during the briefing phase of a mission.

****

### Usage:

#### - Enabling outside of briefing
By default the module will only show information about marker creation and deletion to the admins during the briefing phase. To enable information for admins outside of the briefing phase (during the mission), set the variable `bc_marker_tracker_forceDisplay` to `true`. If you want to turn it off again, set the same variable to `false`.

#### - Disable server logging
By default the module will log all marker creation and deletion to the server's .rpt file. To disable this behavior, set the variable `bc_marker_tracker_logMarker` to `false` on the server. If you want to turn it off again, set the same variable to `true`.

#### - Modifying the admin list
For now, the module only shows information to specific players who have their UID's set within the module itself. It does not show the information to a player logged in as an admin ingame unless they have their UID in the list in which case they'd be able to see the information without being logged in as admin. There are two ways to modify the admin list. 

The first way, done during a mission, is to edit the global variable `bc_marker_tracker_UIDList` on the server and add or remove whichever UIDs you want. Upon loading another mission the variable will be reset to the version contained within the addon.

The second, and more permanant way, is to edit the file `XEH_postInit.sqf` in the module folder and add or remove any UIDs that you'd like.
