#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'Project::Dragn' );
}

diag( "Testing Project::Dragn $Project::Dragn::VERSION, Perl $], $^X" );
