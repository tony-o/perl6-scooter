#!/usr/bin/env perl6

use Chaos;

multi sub MAIN(Bool :$debug? = False, :$plugins = [], *@config-files) {
  for $plugins.split(',').Slip -> $p {
    try require $p;
  }
  my Chaos $chaos .=new;
  $chaos.debug-output = True if $debug;
  $chaos.read-config($_) for @config-files;
  $chaos.begin;
}
