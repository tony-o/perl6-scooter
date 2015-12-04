use Chaos::Doer;

role A does Chaos::Doer {
  method cause-chaos(Str $cmd, :$probability, :$interval) {
    my $val = qqx{$cmd.substr(4)};
    my $pstr = $probability.Int ~ '%';
    my $istr = $interval.Int ~ ' secs';

    $pstr = (' ' x 3 - $pstr.chars) ~ $pstr;
    $istr = (' ' x 7 - $istr.chars) ~ $istr;
    "\{$pstr, $istr\}\t{$val.trim}".say;
    CATCH { default { .say; } }
  }

  method handles(Str $cmd) {
    return True if $cmd ~~ /^ 'run ' /;
    return False;
  }
}
