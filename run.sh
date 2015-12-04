#!/bin/bash

INCLUDE='-I../archive/perl6-module-does/lib -Itest/lib -Ilib'
PLUGINS='-MA'
CONFIG='test/test.yaml'
# cannot test passing --plugins=XYZ because precomp is dumb.
perl6 $INCLUDE $PLUGINS bin/scooter.pl6 $CONFIG
