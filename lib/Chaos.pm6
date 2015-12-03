use Module::Does;
use Chaos::Grammar;


class Chaos does Module::Does[<Chaos::Doer>] {
  has Bool    $.debug-output is rw = False;
  has Promise $!kill .=new;
  has @!config;
  has @!proms;

  method read-config(Str $file) {
    my @keys = qw<min-period max-period period probability action>;
    my $max  = max @keys.map({ .chars });
    for $file.IO.lines -> $l {
      my $d = Chaos::Grammar.parse: $l;
      my %d = 
        min-period  => $d<period><min>.Str,
        max-period  => $d<period><max>.Str,
        period      => $d<period><measurement><base>.Str,
        probability => $d<chance><odds>
                         ??   100 * $d<chance><odds><xin>.subst(',','').Int
                            / $d<chance><odds><xout>.subst(',','').Int
                         !! $d<chance><percentage>.Str.subst('%',''),
        action      => $d<action>.Str,
      ;
      %d<handlers> = %!base-types<Chaos::Doer>.map({ try .handles(%d<action>) }).grep(*.so);
      @!config.push: %d;
      print "$l\n{
        @keys.map({
          "\t$_" ~ (' ' x ($max - $_.chars)) ~ 
          ': ' ~ %d{$_} ~ ($_ eq 'probability' ?? '%' !! '') ~ "\n"
        }) 
      }" if $.debug-output;
      "\thandlers{' ' x ($max - 'handlers'.chars)}: {%d<handlers>.cache.elems}\n".say if $.debug-output;
      @!proms.push(False);
    }
  }

  method begin {
    for ^@!config -> $c {
      $.requeue($c);
    }
    await $!kill;    
  }

  method stop {
    $!kill.keep;
  }

  method requeue(Int $index) {
    "[MSG $index] Queuing for processing".say if $.debug-output; 
    my $c = @!config[$index];
    @!proms[$index] = start {
      my $x = ($c<min-period>..$c<max-period>).pick * do given $c<period> {
        when 'minute' { 60       }
        when 'hour'   { 60*60    }
        when 'day'    { 60*60*24 }
        default       { 1        }
      };
      "[MSG $index] Promise scheduled in $x".say if $.debug-output;
      await Promise.in($x);
      $.process($index);
      $.requeue($index);
    };
  }

  method process(Int $index) {
    "[MSG $index] Processing..".say if $.debug-output;
    my $c = @!config[$index];
    if rand < $c<probability> {
      $c<handlers>.cache.perl.say;
      $_.cause-chaos($c<action>) for $c<handlers>.cache;
    }
    CATCH { default { .say; } }
  }
}
