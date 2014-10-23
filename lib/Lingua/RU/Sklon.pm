#!/usr/bin/perl -w
use strict;
use warnings;
use POSIX qw(locale_h);
use locale;
setlocale(LC_CTYPE, "ru_RU.cp1251"); 

package Lingua::RU::Sklon; 




BEGIN {
    use Exporter   ();
    our ($VERSION, @ISA, @EXPORT, @EXPORT_OK, %EXPORT_TAGS);

    # set the version for version checking
    $VERSION     = 0.01;
    
    @ISA         = qw(Exporter);
    @EXPORT      = qw(&parse_n &parse_lastname &convert &initcap &sklon);
    %EXPORT_TAGS = ( );

    # your exported package globals go here,
    # as well as any optionally exported functions
    @EXPORT_OK   = qw(%pads);


}
use Carp;

our @EXPORT_OK;

our %pads;

# non-exported package globals go here
our $dos;
our $iso;
our $koi;
our $win;

# initialize package globals, first exported ones

%pads=(
  I=>1, IMEN=>1, 1=>1, #��� ����
  R=>2, ROD=>2,  2=>2, #�������� ��� ����
  D=>3, DAT=>3,  3=>3, #�������� ����
  V=>4, VIN=>4,  4=>4, #������ ����
  T=>5, TVOR=>5, 5=>5, #�������� �����
  P=>6, PRED=>6, 6=>6  #���� � ����
  );


 $dos={'�'=>160,'�'=>161,'�'=>162,'�'=>163,'�'=>164,'�'=>165,'�'=>241,'�'=>166,'�'=>167,'�'=>168,'�'=>169,'�'=>170,'�'=>171,'�'=>172,'�'=>173,'�'=>174,'�'=>175,'�'=>224,'�'=>225,'�'=>226,'�'=>227,'�'=>228,'�'=>229,'�'=>230,'�'=>231,'�'=>232,'�'=>233,'�'=>236,'�'=>235,'�'=>234,'�'=>237,'�'=>238,'�'=>239,'�'=>128,'�'=>129,'�'=>130,'�'=>131,'�'=>132,'�'=>133,'�'=>240,'�'=>134,'�'=>135,'�'=>136,'�'=>137,'�'=>138,'�'=>139,'�'=>140,'�'=>141,'�'=>142,'�'=>143,'�'=>144,'�'=>145,'�'=>146,'�'=>147,'�'=>148,'�'=>149,'�'=>150,'�'=>151,'�'=>152,'�'=>153,'�'=>156,'�'=>155,'�'=>154,'�'=>157,'�'=>158,'�'=>159};
 $iso={'�'=>208,'�'=>209,'�'=>210,'�'=>211,'�'=>212,'�'=>213,'�'=>241,'�'=>214,'�'=>215,'�'=>216,'�'=>217,'�'=>218,'�'=>219,'�'=>220,'�'=>221,'�'=>222,'�'=>223,'�'=>224,'�'=>225,'�'=>226,'�'=>227,'�'=>228,'�'=>229,'�'=>230,'�'=>231,'�'=>232,'�'=>233,'�'=>236,'�'=>235,'�'=>234,'�'=>237,'�'=>238,'�'=>239,'�'=>176,'�'=>177,'�'=>178,'�'=>179,'�'=>180,'�'=>181,'�'=>161,'�'=>182,'�'=>183,'�'=>184,'�'=>185,'�'=>186,'�'=>187,'�'=>188,'�'=>189,'�'=>190,'�'=>191,'�'=>192,'�'=>193,'�'=>194,'�'=>195,'�'=>196,'�'=>197,'�'=>198,'�'=>199,'�'=>200,'�'=>201,'�'=>204,'�'=>203,'�'=>202,'�'=>205,'�'=>206,'�'=>207};
 $koi={'�'=>193,'�'=>194,'�'=>215,'�'=>199,'�'=>196,'�'=>197,'�'=>163,'�'=>214,'�'=>218,'�'=>201,'�'=>202,'�'=>203,'�'=>204,'�'=>205,'�'=>206,'�'=>207,'�'=>208,'�'=>210,'�'=>211,'�'=>212,'�'=>213,'�'=>198,'�'=>200,'�'=>195,'�'=>222,'�'=>219,'�'=>221,'�'=>216,'�'=>217,'�'=>223,'�'=>220,'�'=>192,'�'=>209,'�'=>225,'�'=>226,'�'=>247,'�'=>231,'�'=>228,'�'=>229,'�'=>179,'�'=>246,'�'=>250,'�'=>233,'�'=>234,'�'=>235,'�'=>236,'�'=>237,'�'=>238,'�'=>239,'�'=>240,'�'=>242,'�'=>243,'�'=>244,'�'=>245,'�'=>230,'�'=>232,'�'=>227,'�'=>254,'�'=>251,'�'=>253,'�'=>248,'�'=>249,'�'=>255,'�'=>252,'�'=>224,'�'=>241};
 $win={'�'=>224,'�'=>225,'�'=>226,'�'=>227,'�'=>228,'�'=>229,'�'=>184,'�'=>230,'�'=>231,'�'=>232,'�'=>233,'�'=>234,'�'=>235,'�'=>236,'�'=>237,'�'=>238,'�'=>239,'�'=>240,'�'=>241,'�'=>242,'�'=>243,'�'=>244,'�'=>245,'�'=>246,'�'=>247,'�'=>248,'�'=>249,'�'=>252,'�'=>251,'�'=>250,'�'=>253,'�'=>254,'�'=>255,'�'=>192,'�'=>193,'�'=>194,'�'=>195,'�'=>196,'�'=>197,'�'=>168,'�'=>198,'�'=>199,'�'=>200,'�'=>201,'�'=>202,'�'=>203,'�'=>204,'�'=>205,'�'=>206,'�'=>207,'�'=>208,'�'=>209,'�'=>210,'�'=>211,'�'=>212,'�'=>213,'�'=>214,'�'=>215,'�'=>216,'�'=>217,'�'=>220,'�'=>219,'�'=>218,'�'=>221,'�'=>222,'�'=>223}; 

END { }       # module clean-up code here (global destructor)




sub convert {
  my $src=lc shift;
  my $tgt=lc shift;
  my ($src_cp, $tgt_cp);
  if      ($src eq 'dos') {  $src_cp=$dos;
  } elsif ($src eq 'win') {  $src_cp=$win;
  } elsif ($src eq 'iso') {  $src_cp=$iso;
  } elsif ($src eq 'koi') {  $src_cp=$koi;
  } else {
    croak "Wrong Source encoding: $src"; 
    return "! Wrong Source encoding: $src"; 
  }
  
  if      ($tgt eq 'dos') {  $tgt_cp=$dos;
  } elsif ($tgt eq 'win') {  $tgt_cp=$win;
  } elsif ($tgt eq 'iso') {  $tgt_cp=$iso;
  } elsif ($tgt eq 'koi') {  $tgt_cp=$koi; 
  } else {
    croak "Wrong tgt encoding: $tgt"; 
    return "! Wrong tgt encoding: $tgt";
  }
  
  my %src_cp = reverse %{$src_cp};
  my $out;
  my @out;
  foreach (@_) {
    my @a=split //;
    $out='';
    foreach (@a) {
      my $r=chr($tgt_cp->{$src_cp{ord($_)}});
      $out.= $r?$r:$_;
    }
    push @out,$out;
  }
  if (wantarray) {
    return @out;
  } else {
    return join ('',@out);
  }
}


sub parse_lastname {
  my $txt=lc shift;
  my $wrap=shift;
  my $last_letter=substr($txt,-2);
  
  #print $last_letter;
  if ($last_letter eq '��') {
    my $h={1=>'��',
           2=>'���',
           3=>'���',
           4=>'���',
           5=>'��',
           6=>'��'
           };
    return substr($txt,0,-2).($h->{$wrap}||return "!$txt");
  } elsif ($last_letter eq '��') {
    my $h={1=>'��',
           2=>'���',
           3=>'���',
           4=>'���',
           5=>'��',
           6=>'��'
           };
    return substr($txt,0,-2).($h->{$wrap}||return "!$txt");
  } elsif ($last_letter eq '��') {
    return $txt;
  } elsif ($last_letter eq '��') {
    my $h={1=>'��',
           2=>'��',
           3=>'��',
           4=>'��',
           5=>'��',
           6=>'��'
           };
    return substr($txt,0,-2).($h->{$wrap}||return "!$txt");
  } elsif ($last_letter eq '��') {
    my $h={1=>'��',
           2=>'��',
           3=>'��',
           4=>'��',
           5=>'��',
           6=>'��'
           };
    return substr($txt,0,-2).($h->{$wrap}||return "!$txt");
  } elsif ($last_letter eq '��') {
  
    my $h={1=>'��',  #��� ����
           2=>'��',  #�������� ��� ����
           3=>'��',  #�������� ����
           4=>'��',  #������ ����
           5=>'���', #�������� �����
           6=>'��'   #���� � ����
           };
    return substr($txt,0,-2).$h->{$wrap};
  }
  
  $_=substr($txt,-1);
  
  if ($_ eq '�') {
  
  my $h={1=>'�',
           2=>'�',
           3=>'�',
           4=>'�',
           5=>'��',
           6=>'�'
           };
    return substr($txt,0,-1).($h->{$wrap}||return "!$txt");
  }
  if ($_ eq '�') {
    my $h={1=>'�',  #��� ����
           2=>'��',  #�������� ��� ����
           3=>'�',  #������ ����
           4=>'��',  #�������� ����
           5=>'��', #�������� �����
           6=>'��'   #���� � ����
           };
    return substr($txt,0,-1).($h->{$wrap}||return "!$txt");
  }
  if ($_ eq '�') {
    my $h={1=>'�',  #��� ����
           2=>'�',  #�������� ��� ����
           3=>'�',  #������ ����
           4=>'�',  #�������� ����
           5=>'��', #�������� �����
           6=>'�'   #���� � ����
           };
    return substr($txt,0,-1).($h->{$wrap}||return "!$txt");
  }
  if ($_ eq '�') {
    my $h={1=>'�',  #��� ����
           2=>'�',  #�������� ��� ����
           3=>'�',  #������ ����
           4=>'�',  #�������� ����
           5=>'��', #�������� �����
           6=>'�'   #���� � ����
           };
    return substr($txt,0,-1).($h->{$wrap}||return "!$txt");
  }
  if (/[����������������������]/) {
    return $txt;
  }
  if (/�/) {
    my $h={1=>'',  #��� ����
           2=>'�',  #�������� ��� ����
           3=>'e',  #�������� ����
           4=>'�',  #������ ����
           5=>'��', #�������� �����
           6=>'�'   #���� � ����
           };
    return $txt.$h->{$wrap};
  }
  
  if (/[�������������������������������]/) {
    my $h={1=>'',  #��� ����
           2=>'�',  #�������� ��� ����
           3=>'�',  #������ ����
           4=>'e',  #�������� ����
           5=>'��', #�������� �����
           6=>'��'   #���� � ����
           };
    return $txt.$h->{$wrap};
  }
  carp ("Unalbe to sklon: $txt");
  return "$txt";
  
}

sub parse_n {
  my $txt=lc shift;
  my $wrap=shift;
  my $last_letter=substr($txt,-2);
  
  #print $last_letter;
  if ($last_letter eq '��') {
    my $h={1=>'��',  #��� ����
           2=>'��',  #�������� ��� ����
           3=>'��',  #������ ����
           4=>'��',  #�������� ����
           5=>'���', #�������� �����
           6=>'��'   #���� � ����
           };
    return substr($txt,0,-2).$h->{$wrap};
  } elsif ($last_letter eq '��') {
    my $h={1=>'��',  #��� ����
           2=>'��',  #�������� ��� ����
           3=>'��',  #������ ����
           4=>'��',  #�������� ����
           5=>'���', #�������� �����
           6=>'��'   #���� � ����
           };
    return substr($txt,0,-2).$h->{$wrap};
  } elsif ($last_letter eq '��') {
    my $h={1=>'��',  #��� ����
           2=>'���',  #�������� ��� ����
           3=>'���',  #������ ����
           4=>'���',  #�������� ����
           5=>'����', #�������� �����
           6=>'���'   #���� � ����
           };
    return substr($txt,0,-2).$h->{$wrap};
  }
  
  $_=substr($txt,-1);
  
  if ($_ eq '�') {
    my $h={1=>'�',
           2=>'�',
           3=>'�',
           4=>'�',
           5=>'��',
           6=>'�'
           };
    return substr($txt,0,-1).($h->{$wrap}||return "!$txt");
  }
  if ($_ eq '�') {
    my $h={1=>'�',  #��� ����
           2=>'�',  #�������� ��� ����
           3=>'�',  #�������� ����
           4=>'�',  #������ ����
           5=>'��', #�������� �����
           6=>'�'   #���� � ����
           };
    return substr($txt,0,-1).($h->{$wrap}||return "!$txt");
  }
  if ($_ eq '�') {
    my $h={1=>'�',  #��� ����
           2=>'�',  #�������� ��� ����
           3=>'�',  #�������� ����
           4=>'�',  #������ ����
           5=>'��', #�������� �����
           6=>'�'   #���� � ����
           };
    return substr($txt,0,-1).($h->{$wrap}||return "!$txt");
  }
  if ($_ eq '�') {
    my $h={1=>'�',  #��� ����
           2=>'�',  #�������� ��� ����
           3=>'�',  #�������� ����
           4=>'�',  #������ ����
           5=>'��', #�������� �����
           6=>'�'   #���� � ����
           };
    return substr($txt,0,-1).($h->{$wrap}||return "!$txt");
  }
  if (/[������]/) {
    return $txt;
  }
  if (/[����������������]/) {
    my $h={1=>'',  #��� ����
           2=>'�',  #�������� ��� ����
           3=>'�',  #�������� ����
           4=>'�',  #������ ����
           5=>'��', #�������� �����
           6=>'�'   #���� � ����
           };
    return $txt.$h->{$wrap};
  }
  
  if (/[�����]/) {
    my $h={1=>'',  #��� ����
           2=>'�',  #�������� ��� ����
           3=>'�',  #�������� ����
           4=>'�',  #������ ����
           5=>'��', #�������� �����
           6=>'�'   #���� � ����
           };
    return $txt.$h->{$wrap};
  }
  carp ("Unalbe to sklon: $txt");
  return "$txt";
  
}

sub sklon {
  $_=shift;
  print "$_\n";
  /(\w+)\s(\w+)\s(.+)/;
  my $pad=shift;
  my $decl=$pads{$pad};

  croak "Unknown pad attempting to be set : $pad" unless $decl;
  return initcap(parse_lastname($1,$decl)." ".parse_n($2,$decl)." ".parse_n($3,$decl));
  
}
sub initcap {
  $_=shift;
  my $out;
  while (/(\w)(\w*)(\W*)/g) {
    $out.=uc ($1).$2.$3;
  }
  return $out;
}

1;

__END__

=head1 NAME

Lingua::RU::Sklon - helps declensing russian word

=head1 SYNOPSIS

  use Lingua::RU::Sklon;
  
  print sklon("�������� ������� ����������"=>'VIN');
  print sklon(convert('koi'=>'win', '�������� ������� ����������' )=>'VIN');
  # gives ��������� ������� �����������
  
=head1 DESCRIPTION

  Lingua::RU::Sklon - specially made to helps declense russian names in any acts
  or docs you've come through. This, sadly, doesn't help yet at some more
  complex names such as ����������-������ ��������-��������� ��������� ����.
  But, in 99.9% cases this module fits.
  
  default encoding for this module is win-1251. be sure you install this locale.
  If not, then please send all names initcapped, this should do the trick either.

=over 4

=item convert (FROM=>TO, WHAT)

usage
my $win_text=convert ('koi'=>'win', $koi_text);
This lil' helper converts russian text from/to different encodings.
available charsets koi, win, iso, dos
see L<Lingua::RU::Charset> for more flexible version.

=item sklon (WHAT=>PAD)
 
 This function gets full name of client, and transforms it into desired
 declense. Available list of declesnes is:
 
 C<
  I=>1, IMEN=>1, 1=>1, #������������
  R=>2, ROD=>2,  2=>2, #������������
  D=>3, DAT=>3,  3=>3, #���������
  V=>4, VIN=>4,  4=>4, #�����������
  T=>5, TVOR=>5, 5=>5, #������������
  P=>6, PRED=>6, 6=>6  #� ����������
 >
 
=item %pads

 Yes, it's the hash from above.

=item initcap (NAME)

Make First Letters of the Every Word Capital.

=item parse_n

parses noun (name or second name) of client.

=item parse_lastname

parses last name of client.
  
  
=back

=head1 AUTHOR

Alexey Usanov <alexey_usa@mail.ru>

=head1 SEE ALSO

L<Lingua::RU::Charset>, L<perllocale>

=head1 COPYRIGHT

Copyright (c) 2007, Alexey Usanov. All Rights Reserved.
This module is free software. It may be used, redistributed
and/or modified under the same terms as Perl itself.

=cut
