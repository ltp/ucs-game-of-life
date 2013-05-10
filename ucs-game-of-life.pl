#!/usr/bin/perl

use Game::Life;
use Cisco::UCS;

$ucs = new Cisco::UCS(    
                        cluster         =>      'ucs-1.mydomain.com',
                        port            =>      443,
                        username        =>      'username',
                        passwd          =>      'passw0rd',
                        proto           =>      'https'
                );  
$ucs->login or die "Couldn't login!: $! - $ucs->{error}\n";

# Our representation of six chassis, stacked three-by-two and
# fully-populated with half width blades. i.e.
# 
#        +-chassis 5   +-chassis 3   +-chassis 4
#        v             v             v
#       +-----+-----+ +-----+-----+ +-----+-----+
#       |  1  |  2  | |  1  |  2  | |  1  |  2  |
#       +-----+-----+ +-----+-----+ +-----+-----+
#       |  3  |  4  | |  3  |  4  | |  3  |  4  |
#       +-----+-----+ +-----+-----+ +-----+-----+
#       |  5  |  6  | |  5  |  6  | |  5  |  6  |
#       +-----+-----+ +-----+-----+ +-----+-----+
#       |  7  |  8  | |  7  |  8  | |  7  |  8  |
#       +-----+-----+ +-----+-----+ +-----+-----+
#       +-----+-----+ +-----+-----+ +-----+-----+
#       |  1  |  2  | |  1  |  2  | |  1  |  2  |
#       +-----+-----+ +-----+-----+ +-----+-----+
#       |  3  |  4  | |  3  |  4  | |  3  |  4  |
#       +-----+-----+ +-----+-----+ +-----+-----+
#       |  5  |  6  | |  5  |  6  | |  5  |  6  |
#       +-----+-----+ +-----+-----+ +-----+-----+
#       |  7  |  8  | |  7  |  8  | |  7  |  8  |
#       +-----+-----+ +-----+-----+ +-----+-----+
#        ^             ^             ^
#        +-chassis 2   +-chassis 1   +-chassis 6
#
# Notation is 'chassis id:blade id'

$u = [ 
        [ '5:1', '5:2', '3:1', '3:2', '4:1', '4:2' ],
        [ '5:3', '5:4', '3:3', '3:4', '4:3', '4:4' ],
        [ '5:5', '5:6', '3:5', '3:6', '4:1', '4:6' ],
        [ '5:7', '5:8', '3:7', '3:8', '4:7', '4:8' ],
        [ '2:1', '2:2', '1:1', '1:2', '6:1', '6:2' ],
        [ '2:3', '2:4', '1:3', '1:4', '6:3', '6:4' ],
        [ '2:5', '2:6', '1:5', '1:6', '6:5', '6:6' ],
        [ '2:7', '2:8', '1:7', '1:8', '6:7', '6:8' ]
];

my $game = Game::Life->new( [6,8] );
my $starting = [
                [ 1, 1, 1, 0, 1, 0 ],
                [ 1, 0, 0, 1, 1, 1 ],
                [ 0, 1, 0, 0, 1, 0 ],
                [ 0, 0, 1, 0, 0, 1 ],
                [ 1, 0, 1, 0, 1, 0 ],
                [ 1, 1, 0, 1, 0, 0 ],
                [ 0, 1, 1, 0, 0, 1 ],
                [ 0, 1, 1, 0, 1, 1 ] 
               ]; 

$game->place_points( 0, 0, $starting );

for (1..20) {
        my $grid = $game->get_grid();
        my $r = 0;

        foreach my $row ( @$grid ) {
                my $c = 0;

                foreach my $column ( @$row ) {
                        print ( $column ? 'X' : '.' );
                        my ( $chassis, $blade ) = split /:/, $u->[$r]->[$c];
                        $ucs->chassis($chassis)->blade($blade)->led( ( $column ? 'on' : 'off' ) );
			$c++
                }
        
		$r++;
                print "\n"
        }

        sleep 3;
        system(clear);  
        $game->process();
}   
