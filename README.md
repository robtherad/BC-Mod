<p align="center">
 <img src="https://raw.githubusercontent.com/robtherad/BC-Mod/master/BC_logo.png" width="256">
</p>
<h1 align="center">Bravo Company Mod</h2>
<p align="center">
  <a href="https://travis-ci.org/robtherad/BC-Mod">
    <img src="https://travis-ci.org/robtherad/BC-Mod.svg?branch=master" alt="Build Status">
  </a>
  <a href="https://discord.gg/0Z9C1w0hrI8qqYSD">
    <img src="https://img.shields.io/badge/discord-Bravo%20Company-blue.svg" alt="BC Discord">
  </a>
  <a href="https://github.com/robtherad/BCArma">
    <img src="https://img.shields.io/badge/mission-Template-red.svg" alt="BC Mission Template">
  </a>
</p>


An addon designed for use during Bravo Company's Fight Nights.

**** 

### Current Features
| **MODULE** | **DESCRIPTION** |
|---|---|
| **akm_tracers** | Fixes RHS 7.62x39 AK Tracer mag. It actually has tracers now. |
| **common** | A module which will contain useful general functions for use in BC missions and other modules in the addon. |
| **gpsMarkers** | A simple framework for managing markers that follow units and or vehicles. |
| **main** | The root of the addon. Contains macros and other stuff used throughout the rest of the addon. |
| **marker_tracker** | Shows information about marker creation/deletion during the briefing. |
| **spectator** | F3 Spectator in addon form. |
| **vehLock** | A framework mission makers can use to control access to vehicles in their missions. |

For more information about specific modules go to their folders within the addon folder. If you want more information about a specific function within an addon, take a look at the function's file within the module's functions folder.

****

### Credits

* [CBA Team](https://github.com/CBATeam/CBA_A3)
* [ACE Team](https://github.com/acemod/ACE3)
* [F3 Team](https://github.com/ferstaberinde/F3)

The structure and workflow of this addon is heavily based on the [ACE 3](https://github.com/acemod/ACE3) addon for Arma 3.

****

### Plans
In no particular order.

* Document everything.
* Create module system that can be used instead of/alongside `setGroupID`
* Create nicer looking map markers
* Rewrite Radio system for use in non Fight Night missions as well?
* Upload mod to workshop after it's actually used


