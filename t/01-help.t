#!env perl

use strict;
use warnings;
use Test::More;

$ENV{NO_COLOR} = 1;

my @txt = qx{$^X ./speedtest --help};
ok ($#txt > 40, "--help gives enough output");
like ("@txt", qr{--help}, "Help has --help");

@txt = qx{$^X ./speedtest --version};
is (scalar @txt, 1, "--version gives exactly 1 line");
like ($txt[0], qr{^speedtest\s+\[[0-9.]+\]}, "--version shows command + version");

@txt = qx{$^X ./speedtest --man};
ok (300 < scalar @txt, "--man gives the manual");
if ($txt[0] =~ m/^NAME\b/) { # No nroff available, fallback to Text
    like ($txt[1], qr{^\s+App::SpeedTest\s}i, "Pod was correctly parsed");
    }
else {
    like ($txt[0], qr{^SPEEDTEST\s*\(1\)}i, "It starts with a standard manual header");
    }

chomp (@txt = qx{$^X ./speedtest --info});
ok (300 < scalar @txt, "--info gives the manual as simple text");
is ($txt[0], "NAME", "The manual starts with section NAME");

done_testing ();
