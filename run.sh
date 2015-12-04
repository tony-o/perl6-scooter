#!/bin/bash

INCLUDE='-I../archive/perl6-module-does/lib -Itest/lib -Ilib'
PLUGINS='-MA'
CONFIG='test/test.yaml'
echo perl6 $INCLUDE bin/scooter.pl6 --debug $PLUGINS $CONFIG
perl6 $INCLUDE $PLUGINS bin/scooter.pl6 $CONFIG
