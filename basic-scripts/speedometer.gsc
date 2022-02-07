/**
*
* Adds the speed the player is travelling on the XY plane as glowing text in the bottom
* center of the screen.
*
* Created by Drag
*
**/

#include maps\mp\gametypes\_hud_util;

// Entry
init() {
    level thread onPlayerConnect();
}

// Wait for player connection
onPlayerConnect() {
    for(;;) {
        level waittill("connected", player);
        player thread onPlayerSpawned();
    }
}

// Display speed until player disconnect or game end
onPlayerSpawned() {
    self endon("disconnect");
    level endon("game_ended"); 

    // Create the text and set the label of the text to the address of a string that
    // specifies its color
    self.speedometer = createFontString( "hudbig", 1.0 );
    self.speedometer setPoint( "CENTER", "BOTTOM", "CENTER", -50 );
    self.speedometer.label = &"^7";
    self.speedometer.glowColor = (0.13, 0.76, 0.94);
    self.speedometer.glowAlpha = 1;

    // Only use the setValue on the text to prevent overflow. Get velocity from just
    // XY plane
    for(;;) {
        vel = self getvelocity();
        self.speedometer setValue(int(sqrt( vel[0] * vel[0] + vel[1] * vel[1] )));
        wait 0.1;
    }
}
