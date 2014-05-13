Readme
======

What
----

This dinky little script implements
[Conway's Game of Life](http://en.wikipedia.org/wiki/Conway%27s_Game_of_Life) 
using the locator LEDs of blades in a 
[Cisco UCS cluster](http://en.wikipedia.org/wiki/Cisco_Unified_Computing_System).

Why
---

This script was inspired by the concept of [Blinkenlights](http://en.wikipedia.org/wiki/Blinkenlights),
particularly by the implementation of Conway's Game of Life on 
[Connection Machines](http://en.wikipedia.org/wiki/Connection_Machine).

How
---

To use this script you must have at least version 0.031 of the
[Cisco::UCS](https://metacpan.org/release/Cisco-UCS) module installed in addition to 
at least version 0.05 of the [Game::Life](https://metacpan.org/release/Game-Life) module.

You will also need to edit the script so as to specify your UCS cluster 
information (hostname, username and password) and you will also likely
need to modify the script to specify you physical chassis arrangement.

For example - to configure the script for your cluster of four chassis
arranged in a two-by-two arrangement like so:

    +-chassis 1   +-chassis 3
    v             v          
    +-----+-----+ +-----+-----+
    |  1  |  2  | |  1  |  2  |
    +-----+-----+ +-----+-----+
    |  3  |  4  | |  3  |  4  |
    +-----+-----+ +-----+-----+
    |  5  |  6  | |  5  |  6  |
    +-----+-----+ +-----+-----+
    |  7  |  8  | |  7  |  8  |
    +-----+-----+ +-----+-----+
    +-----+-----+ +-----+-----+
    |  1  |  2  | |  1  |  2  |
    +-----+-----+ +-----+-----+
    |  3  |  4  | |  3  |  4  |
    +-----+-----+ +-----+-----+
    |  5  |  6  | |  5  |  6  |
    +-----+-----+ +-----+-----+
    |  7  |  8  | |  7  |  8  |
    +-----+-----+ +-----+-----+
    ^             ^
    +-chassis 2   +- chassis 4

You would modify the script like so:

    $u = [ 
           [ '1:1', '1:2', '3:1', '3:2' ],
           [ '1:3', '1:4', '3:3', '3:4' ],
           [ '1:5', '1:6', '3:5', '3:6' ],
           [ '1:7', '1:8', '3:7', '3:8' ],
           [ '2:1', '2:2', '4:1', '4:2' ],
           [ '2:3', '2:4', '4:3', '4:4' ],
           [ '2:5', '2:6', '4:5', '4:6' ],
           [ '2:7', '2:8', '4:7', '4:8' ]
         ];

See the script comments for further details.

Note that this script will work best (only?) if your chassis are fully-populated 
and arranged as a square or rectangular shape.

When you have configured the script for your environment, the script will 
run for 20 generations with a three second gap between each generation.

Note that there may be some delay between all lights updating for each generation
due to the delay of UCSM actioning the led action.

In addition to blinking lights on your UCS cluster, the script will also output
a simple textual representation of the current game board.
