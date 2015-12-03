#!/usr/bin/env perl6

use lib 'lib';
use Chaos;
use Chaos::Doer;


class A does Chaos::Doer {
  method cause-chaos(Str $cmd) {
    "cause-chaos: $cmd".say;
  }
  method handles(Str $cmd) {
    "checking: $cmd".say;
    return True if $cmd ~~ /^ 'run ' /;
    return False;
  }
};

'valus:'.say;
GLOBAL::.values.say;
'/valus:'.say;
die 'dead';



my Chaos $c .=new;
$c.debug-output = True;
$c.read-config('test.yaml');
