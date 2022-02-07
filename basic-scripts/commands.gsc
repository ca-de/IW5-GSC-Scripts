/**
*
* Usage: Type any command using a double slash. For example: "//kill Drag".
* Look in the switch cases for more specific use cases.
*
* Created by Drag
*
**/

// Entry
init() {
    level thread onPlayerConnect();
}

// Start spawned thread on connection
onPlayerConnect() {
    for(;;) {
        level waittill( "connected", player );
        player thread onPlayerSpawned();
    }
}

// Listen for commands until disconnect or game end
onPlayerSpawned() {
    self endon( "disconnect" );
    level endon("game_ended");

    for(;;) {
        // Wait until a chat is sent
        level waittill( "say", message, player );
		
		// Only allow admins to use commands. Add more in the style shown when wanted.
		if ( player.name != "ryh" && player.name != "Drag" )
            continue;

        // Reset the arguments
        level.args = [];

        // Get rid of junk character IW5 produces
        str = strTok( message, "" );

        // Parse the string past the junk character
        i = 0;
        foreach ( s in str ) {
            if ( i > 25 )
                break;
            level.args[i] = s;
            i++;
        }

        // Lets split with space as a delimiter
        str = strTok( level.args[0], " " );

        // Parse between spaces
        i = 0;
        foreach( s in str ) {
            if ( i > 25 )
                break;
            level.args[i] = s;
            i++;
        }

        // Switch cases for the commands.
        switch ( level.args[0] ) {

            // Freezes a players controls.
            // Usage: "//freeze player"
            case "/freeze":
                onePlayerArg();
                if ( level.args[1] == "" )
                    continue;
                target = findPlayerByName( level.args[1] );
                target freezeControls( true );
            break;

            // Unfreezes a players controls.
            // Usage: "//unfreeze player"
            case "/unfreeze":
                onePlayerArg();
                if ( level.args[1] == "" )
                    continue;
                target = findPlayerByName( level.args[1] );
                target freezeControls( false );
            break;

            // Kills a player.
            // Usage: "//kill player"
            case "/kill":
                onePlayerArg();
                target = findPlayerByName( level.args[1] );
                target suicide();
            break;

            // Teleports the user to a specified player.
            // Usage: "//tpto player"
            case "/tpto":
                onePlayerArg();
                if ( level.args[1] == "" )
                    continue;
                target = findPlayerByName( level.args[1] );
                player setOrigin( target getOrigin() );
            break;

            // Teleports the specified player to the user.
            // Usage: "//bring player"
            case "/bring":
                onePlayerArg();
                if ( level.args[1] == "" )
                    continue;
                target = findPlayerByName( level.args[1] );
                target setOrigin( player getOrigin() );
            break;

            // Gives a specified player a specified weapon. Weapon names are sensitive, and have funky names.
            // A list for MW3 weapons can be found here: https://www.itsmods.com/forum/Thread-Tutorial-MW3-weapons-perks-camos-attachments.html
            // Usage: "//give player weapon"
            case "/give":
                onePlayerArgPlusAnother();
                target = findPlayerByName( level.args[1] );
                target giveWeapon( level.args[2] );
                target switchToWeapon( level.args[2] );
            break;

            // Gives all players a specified weapon.
            // A list for MW3 weapons can be found here: https://www.itsmods.com/forum/Thread-Tutorial-MW3-weapons-perks-camos-attachments.html
            // Usage: "//giveall weapon"
            case "/giveall":
                foreach( p in level.players ) {
                    p giveWeapon( level.args[1] );
                    p switchToWeapon( level.args[1] );
                }
            break;

            // Takes all weapons from all players.
            // Usage: "//takeall"
            case "/takeall":
                foreach( p in level.players ) {
                    p takeAllWeapons();
                }
            break;
            
            // Takes a specified weapon from all players.
            // Usage: "//takeweapon weapon"
            case "/takeweapon":
                foreach( p in level.players ) {
                    p takeWeapon( level.args[1] );
                }
            break;

            // Gives all allies (survivors) a specified weapon.
            // A list for MW3 weapons can be found here: https://www.itsmods.com/forum/Thread-Tutorial-MW3-weapons-perks-camos-attachments.html
            // Usage: "//givesur weapon"
            case "/givesur":
                foreach ( p in level.players ) {
                    if ( p.sessionteam == "allies" ) {
                        p giveWeapon( level.args[1] );
                        p switchToWeapon( level.args[1] );
                    }
                }
            break;

            // Gives all axis (infected) a specified weapon.
            // A list for MW3 weapons can be found here: https://www.itsmods.com/forum/Thread-Tutorial-MW3-weapons-perks-camos-attachments.html
            // Usage: "//giveinf weapon"
            case "/giveinf":
                foreach ( p in level.players ) {
                    if ( p.sessionteam == "axis" ) {
                        p giveWeapon( level.args[1] );
                        p switchToWeapon( level.args[1] );
                    }
                }
            break;

            // Takes all weapons from all allies (survivors).
            // Usage: "//takesur"
            case "/takesur":
                foreach ( p in level.players ) {
                    if ( p.sessionteam == "allies" )
                        p takeAllWeapons();
                }
            break;

            // Takes all weapons from all axis (infected).
            // Usage: "//takeinf"
            case "/takeinf":
                foreach ( p in level.players ) {
                    if ( p.sessionteam == "axis" )
                        p takeAllWeapons();
                }
            break;

            // Enters the user into UFO mode, allowing them to move around the map as a spectator.
            // Type the command in again to return as a normal player.
            // Usage: "//ufo"
            case "/ufo":
                if ( player.sessionstate == "playing" ) {
                    player allowSpectateTeam( "freelook", true );
                    player.sessionstate = "spectator";
                } else {
                  player.sessionstate = "playing";
                  player allowSpectateTeam( "freelook", false );
                }
            break;

            // Teleports all players to the user.
            // Usage: "//bringall"
            case "/bringall":
                foreach ( p in level.players ) {
                    p setOrigin( player getOrigin() );
                }
            break;

            // Teleports all allies (survivors) to the user.
            // Usage: "//bringsur"
            case "/bringsur":
                foreach ( p in level.players ) {
                    if ( p.sessionteam == "allies" )
                        p setOrigin( player getOrigin() );
                }
            break;

            // Teleports all axis (infected) to the user.
            // Usage: "//bringinf"
            case "/bringinf":
                foreach ( p in level.players ) {
                    if ( p.sessionteam == "axis" )
                        p setOrigin( player getOrigin() );
                }
            break;
            
            // Gives the user super high health if on normal max health, and gives normal max health if on super high max health.
            // Usage: "//g"
            case "/g":
                if ( player.maxhealth < 9999999 ) {
                    player.maxhealth = 9999999;
                    player.health = player.maxhealth;
                } else {
                    player.maxhealth = 100;
                    player.health = player.maxhealth;
                }
            break;
            
            // Makes the user invisible. 
            // Usage: "//i"
            case "/i":
                player hide();
            break;
            
            // Makes the user appear. 
            // Usage "//ui"
            case "/ui":
                player show();
            break;

            // Teleports one specified player to the other.
            // Unique usage. In between the two player arguments, enter a '/' with no space after.
            // This is to make parsing a bit easier.
            // Usage: //tp srcplayer/destplayer
            case "/tp":
                twoPlayerArg();
                source = findPlayerByName( level.args[1] );
                dest = findPlayerByName( level.args[2] );
                source setOrigin( dest getOrigin() );
            break;
        }
    }
}

// Used for parsing when there is just one player argument after the command.
onePlayerArg() {
    for ( i = 2; i < level.args.size; i++ )
        level.args[1] = level.args[1] + " " + level.args[i];
}

// Used for parsing when there is one player argument after the command, and another arg after.
onePlayerArgPlusAnother() {
    for ( i = 2; i < level.args.size - 1; i++ )
        level.args[1] = level.args[1] + " " + level.args[i];
	level.args[2] = level.args[level.args.size - 1];
}

// Used for parsing when there is two player arguments after the command.
twoPlayerArg() {
    for ( i = 2; i < level.args.size; i++ )
        level.args[1] = level.args[1] + " " + level.args[i];

    // Lets split with space as a delimiter
    str = strTok( level.args[1], "/" );

    // Parse between spaces
    i = 1;
    foreach( s in str ) {
        break;
        level.args[i] = s;
        i++;
    }
}

// Returns the player of the name passed in, if in the game. 0 if not.
findPlayerByName( name ) {
    foreach ( player in level.players ) {
        if ( player.name == name )
            return player;
    }
    return 0;
}
