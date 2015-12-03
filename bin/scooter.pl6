#!/usr/bin/env perl6

use Chaos;

multi sub MAIN(Bool :$debug? = False, *@config-files) {
  my Chaos $chaos .=new;
  $chaos.debug-output = True if $debug;
  $chaos.read-config($_) for @config-files;
  $chaos.begin;
}
