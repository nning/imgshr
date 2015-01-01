module EXIF
  # http://www.sno.phy.queensu.ca/~phil/exiftool/TagNames/EXIF.html#Flash
  FLASH_MAP = {
     0x0 => 'No Flash',
     0x1 => 'Fired',
     0x5 => 'Fired, Return not detected',
     0x7 => 'Fired, Return detected',
     0x8 => 'On, Did not fire',
     0x9 => 'On, Fired',
     0xd => 'On, Return not detected',
     0xf => 'On, Return detected',
    0x10 => 'Off, Did not fire',
    0x14 => 'Off, Did not fire, Return not detected',
    0x18 => 'Auto, Did not fire',
    0x19 => 'Auto, Fired',
    0x1d => 'Auto, Fired, Return not detected',
    0x1f => 'Auto, Fired, Return detected',
    0x20 => 'No flash function',
    0x30 => 'Off, No flash function',
    0x41 => 'Fired, Red-eye reduction',
    0x45 => 'Fired, Red-eye reduction, Return not detected',
    0x47 => 'Fired, Red-eye reduction, Return detected',
    0x49 => 'On, Red-eye reduction',
    0x4d => 'On, Red-eye reduction, Return not detected',
    0x4f => 'On, Red-eye reduction, Return detected',
    0x50 => 'Off, Red-eye reduction',
    0x58 => 'Auto, Did not fire, Red-eye reduction',
    0x59 => 'Auto, Fired, Red-eye reduction',
    0x5d => 'Auto, Fired, Red-eye reduction, Return not detected',
    0x5f => 'Auto, Fired, Red-eye reduction, Return detected'
  }
end
