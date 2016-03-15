<p align="center">
 <img src="https://raw.githubusercontent.com/robtherad/BC-Mod/master/BC_logo.png" width="256">
</p>
<h1 align="center">Bravo Company Mod</h2>
<p align="center">
  <a href="https://travis-ci.org/robtherad/BC-Mod">
    <img src="https://travis-ci.org/robtherad/BC-Mod.svg?branch=master" alt="Build Status">
  </a>
  <a href="https://github.com/robtherad/BC-Mod/wiki">
    <img src="https://img.shields.io/badge/wiki-BC%20Mod-orange.svg" alt="BC Mod Wiki">
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

### About

This addon was originally created to help centralize aspects of the [Bravo Company Mission Template](https://github.com/robtherad/BCArma) to allow for easier updates to older missions. 

The goal of the addon is to provide tools to mission makers that they can use at their will. Any tools they choose not to use shouldn't hamper their efforts at making quality missions. This means that the modules in this addon should have a minimal or non-existent impact on performance for players in missions where they are not active. Since this addon might be used outside of Bravo Company Fight Nights, modules must also be able to work in both COOP and TVT setups. Additionally, modules should be clearly and simply documented so that mission making is as easy as possible.

**** 

### Current Features
| **MODULE** | **DESCRIPTION** |
|---|---|
| **[akm_tracers](https://github.com/robtherad/BC-Mod/tree/master/addons/akm_tracers)** | Fixes RHS 7.62x39 AK Tracer mag. It actually has tracers now. |
| **[areaBoundary](https://github.com/robtherad/BC-Mod/tree/master/addons/areaBoundary)** | A framework that allows mission makers to limit player movement into or from certain areas. |
| **[common](https://github.com/robtherad/BC-Mod/tree/master/addons/common)** | A module with functions that are generally useful or common between modules. |
| **[gpsMarkers](https://github.com/robtherad/BC-Mod/tree/master/addons/gpsMarkers)** | A simple framework for managing markers that follow units and or vehicles. |
| **[main](https://github.com/robtherad/BC-Mod/tree/master/addons/main)** | The root of the addon. Contains macros and other stuff used throughout the rest of the addon. |
| **[marker_tracker](https://github.com/robtherad/BC-Mod/tree/master/addons/marker_tracker)** | Shows information about marker creation/deletion during the briefing. |
| **[nametags](https://github.com/robtherad/BC-Mod/tree/master/addons/nametags)** | Allows mission maker to use BC nametags with their missions with custom color options. |
| **[spectator](https://github.com/robtherad/BC-Mod/tree/master/addons/spectator)** | F3 Spectator in addon form. |
| **[vehLock](https://github.com/robtherad/BC-Mod/tree/master/addons/vehLock)** | A framework mission makers can use to control access to vehicles in their missions. |

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
* Port ORBAT script to addon.