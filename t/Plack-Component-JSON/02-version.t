use strict;
use warnings;

use Plack::Component::JSON;
use Test::More 'tests' => 2;
use Test::NoWarnings;

# Test.
is($Plack::Component::JSON::VERSION, 0.01, 'Version.');
