use inc::Module::Install;

name     'Project-Dragn';
all_from 'lib/Project/Dragn.pm';
author   'Robert Krimen <rkrimen@cpan.org>';
license  'perl';

{
    require ExtUtils::MakeMaker;
    use strict;
    no strict 'refs';

    my $libscan = \&{"ExtUtils::MM_Any::libscan"};
    *{"ExtUtils::MM_Any::libscan"} = sub {
        return '' unless $libscan->(@_);
        return '' if $_[1] =~ /\.sw[p-z]$/;
        return $_[1];
    };
}

{
    map { my ($pk, $vr) = split m/\s/; build_requires $pk => $vr || 0 } grep { ! /^\s*#/ } split m/\n/, <<_END_;
Test::Most
_END_

    map { my ($pk, $vr) = split m/\s/; requires $pk => $vr || 0 } grep { ! /^\s*#/ } split m/\n/, <<_END_;
Catalyst::Runtime 5.8000
Catalyst::Controller::REST
Catalyst::View::TT
File::Assets
KiokuDB
KiokuDB::Backend::BDB
Moose
Path::Class
Path::Mapper
URI::PathAbstract
_END_
}

if (-e 'inc/.author') {
    my $all_from = join '/', 'lib', split m/-/, name . '.pm';
    `perldoc -tF $all_from > README` if ! -e 'README' || (stat $all_from)[9] > (stat 'README')[9];
}


auto_install;

WriteAll;

