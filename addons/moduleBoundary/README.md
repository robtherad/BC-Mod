## moduleBoundary.pbo

#### How it works
For now, the boundary only effects players. 

**1.** Place a "Player Mission Boundary" found in the editor under Multiplayer Modules (`Systems (F5) >> Modules >> Multiplayer >> Player Mission Boundary`).
 
**2.** Place a trigger and sync the trigger and module together. You can also place three or more Area Logics (`Systems (F5) >> Logic Entities >> Locations >> Area`) and sync them together to form a complex shape for your mission area. Sync one area logic to the module and then sync that area logic to the next point in the chain. Keep going until you come back around to the first area logic. In the end, your chain of logics should look something like the image below.
<p align="center">
  <img src="http://i.imgur.com/EGMSiCn.jpg" width="143">
</p>

You can add as many logics as you want and create complex shapes with them, as shown below, however adding more logics and making very complex shapes will make the module less performant.
<p align="center">
  <img src="http://i.imgur.com/gziXcwI.jpg" width="382">
</p>

**3.** Configure the module's settings. For help understanding a setting you can hover over the setting ingame and get a brief description of it.

**4.** Test it ingame! Make sure everything works. If something seems off, check your Arma 3 RPT file for error messages.


