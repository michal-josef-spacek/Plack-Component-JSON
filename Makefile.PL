use lib '.';
use strict;
use warnings;

use inc::Module::Install;

# Definition.
abstract 'Plack component for JSON output.';
author 'Michal Josef Spacek <skim@cpan.org>';
author_requires 'English' => 0;
author_requires 'File::Object' => 0.05;
author_requires 'Test::More' => 0;
author_requires 'Test::NoWarnings' => 0;
author_requires 'Test::Pod' => 0;
author_requires 'Test::Pod::Coverage' => 0;
license 'bsd';
name 'Plack-Component-JSON';
perl_version 5.008;
readme_from 'JSON.pm';
recursive_author_tests('xt');
requires 'Encode' => 0;
requires 'Plack::Component' => 0;
requires 'Plack::Util::Accessor' => 0;
resources 'bugtracker' => 'https://github.com/michal-josef-spacek/Plack-Component-JSON/issues';
resources 'homepage' => 'https://github.com/michal-josef-spacek/Plack-Component-JSON';
resources 'repository' => 'git://github.com/michal-josef-spacek/Plack-Component-JSON';
test_requires 'Test::More' => 0;
test_requires 'Test::NoWarnings' => 0;
tests_recursive;
version '0.01';

# Run.
WriteAll();
