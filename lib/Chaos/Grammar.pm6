grammar Chaos::Grammar {
  rule TOP {
    ^
      <period>
      <chance>
      <action>
    $
  }

  rule period {
    'every'?
    $<min>=<number>
    [
      || '..'
      || 'to'
    ]
    $<max>=<number>
    $<measurement>=<time>
  }

  regex chance {
    <phrasing>
    [
      || <odds>
      || <percentage>
    ]
    <endchance>
  }

  regex endchance {
    \s* 
    [
      | 'chance to'
      | 'to'
      | 'chance'
      | 'chance to do'
      | 'do'
      | 'to do'
    ] ** 0..1
    \s*
  }

  rule action {
    .+
  }

  regex phrasing {
    \s*
    [ 
      'there should be a' 
    ] ** 0..1
    \s*
  }

  rule odds {
    $<xin>=<number>
    'in'
    $<xout>=<number>
  }

  regex percentage {
    \s*
    $<fval>=[
      '.' ** 0..1
      \d+
    ]
    \s*
    '%'
  }

  regex time {
    $<base>=[
      || 'minute' 
      || 'second'
      || 'hour'
      || 'day'
    ]
    's'?
  }

  regex number {
    [
      || \d
      || ','
    ]+
  }
}

