use strict;
use warnings;

#open my $pi, 'sparc64-linux-gnu-objdump --endian=big -D -m sparc:v9m8 -b binary tokenize.exe |';

my $dict = shift @ARGV // 'tokenize.exe';
open my $pi, "sparc64-linux-gnu-objdump --endian=big -D -m sparc -b binary $dict |";

my @m;
while (<$pi>) {
	# s/\t/[t]/g;
	# |||        0:[t]30 80 00 08 [t]b,a   0x20
	# |||        0:   30 80 00 08     b,a   0x20
	chomp;
	/^\s*([0-9a-f]+):\s+(..) (..) (..) (..)\s+(.*)$/ or next;
	die "$2$3$4$5 | $_" if hex ($1) & 3;
	$m[hex ($1) >> 2] = { word => hex "$2$3$4$5", disasm => $6 };
}

my $magic = $m[0]{word};
die unless $magic == 0x30800008;

my $hlen = ($magic & 0xffff) << 2;
my $tlen = $m[1]{word};
my $dlen = $m[2]{word};

warn sprintf "hlen=0x%x\n", $hlen;
warn sprintf "tlen=0x%x\n", $tlen;
warn sprintf "dlen=0x%x\n", $dlen;

sub dict
{
	my $adr = shift;
	return undef unless $adr < $tlen;
	$adr += $hlen;
	return undef if $adr & 3;
	$m[$adr >> 2] //= { word => 0, disasm => "" };
	$m[$adr >> 2];
}

sub dicthdr
{
	my $adr = shift;
	die if $adr & 3;
	$adr -= 4;
	my $link = dict($adr)->{word};
	my $word = dict($adr-4)->{word};
	my $len = $word & 0x1f;
	my $flags = $word & 0xe0;
	$adr--;

	my $name = "";
	while ($len--) {
		$word = dict($adr-4)->{word}
			unless $adr & 3;
		my $shift = 8*(3-(($adr-1) & 3));
		$name = chr(($word >> $shift) & 0xff).$name;
		$adr--;
	}

	#printf "flags=%02x adr=%08x link=%08x name=%s\n",
	#	$flags, $adr, $link, $name;

	$adr &= ~3;

	return $name, $flags, $adr, $link;
}

sub dictread
{
	my $link = shift;
	while ($link) {
		(
			dict($link)->{name},
			dict($link)->{flags},
			dict($link)->{hdr},
			dict($link)->{lnk}
		) = dicthdr($link);
		dict(dict($link)->{hdr})->{body} = $link + $hlen;

		$link = dict($link)->{lnk};
	}
}


dict(0x44 - $hlen)->{name} = '<INTERPRET>';
dict(0x58 - $hlen)->{name} = '<NULLSUB>';
dict(0x6c - $hlen)->{name} = '<VARIABLE>';
dict(0x80 - $hlen)->{name} = '<USER>';
dict(0x98 - $hlen)->{name} = '<VALUE>';
dict(0xb0 - $hlen)->{name} = '<DEFER>';
dict(0xbc - $hlen)->{name} = '<CONSTANT>';

dict(0x30 - $hlen)->{name} = '<?>';
dict(0xd0 - $hlen)->{name} = '<?>';
dict(0xf0 - $hlen)->{name} = '<?>';

dict(0xf0)->{name} = '{LITERAL}';
dict(0x150)->{name} = '{IF}';

$m[0x0/4]->{name} = '[HEADER]';
$m[0x20/4]->{name} = '[ENTRY]';
if ($dict eq 'tokenize.exe') {
	$m[0xc980/4]->{name} = '[UNIX-MAIN]';

	dictread ($tlen-8);
	dictread (0x00028074);
	dictread (0x000241d4);
	dictread (0x00023c4c);
	dictread (0x00023798);
	dictread (0x0001d400);
	dictread (0x00017704);
	dictread (0x0001682c);
	dictread (0x0000f704);
	dictread (0x0000f3cc);
	dictread (0x00008e08);

	dictread (0x0001d2e8);
	dictread (0x00019ec4);
	dictread (0x0000ebec);
} else {
	$m[0xc8f8/4]->{name} = '[UNIX-MAIN]';

	#dictread(0x0000e8c8-0x20);
printf "%x\n", $tlen-0xc0;
	dictread ($tlen-0x80-0x40);
	#dict($tlen/4)->{name} = '[END]';
	#dictread ($tlen-0xac-0x20);
}



my $w = 0;
while (my $this = dict($w)) {
	if ($this->{disasm} eq 'call  0x6c') {
		my $ptr = dict($w + 8);
		if ($ptr) {
			$ptr->{disasm} = sprintf "VARIABLE 0x%x", $ptr->{word};
			#warn sprintf "%x: %s = %x\n", $w, $this->{name}, $ptr->{word}
			dict($ptr->{word})->{name} = "PTR $this->{name}"
				#if $this->{name} =~ /ptr/;
				if $this->{name} and $this->{name} =~ /ptr/;
		}
	} elsif ($this->{disasm} eq 'call  0xb0') {
		my $ptr = dict($w + 8);
		$ptr->{disasm} = sprintf "DEFER 0x%x", $ptr->{word}
			if $ptr;
	} elsif ($this->{disasm} eq 'call  0xbc') {
		my $ptr = dict($w + 8);
		$ptr->{disasm} = sprintf "CONSTANT 0x%x", $ptr->{word}
			if $ptr;
	} elsif ($this->{disasm} eq 'call  0x80') {
		my $ptr = dict($w + 8);
		$ptr->{disasm} = sprintf "USER 0x%x", $ptr->{word}
			if $ptr;
	} elsif ($this->{disasm} eq 'call  0x98') {
		my $ptr = dict($w + 8);
		$ptr->{disasm} = sprintf "VALUE 0x%x", $ptr->{word}
			if $ptr;
	}
	$w = $w + 4;
}

# flags=80 name=token-tables-ptr
#  00024edc: 7fff6c5c                       call  0x6c
#  00024ee0: 8e21e004                       sub  %g7, 4, %g7
#  00024ee4: 00026800                       illtrap  0x26800

use Data::Dumper;
#warn Dumper \@m;
#warn Dumper $m[0];
#warn Dumper dict(0);
#die;


#my
#while (my $this = dict($w)) {
$w = 0;
while ($w <= $#m) {
	my $this = $m[$w];
	my $adr = $w * 4;
	$w++;
	next unless defined $this;
#print Dumper [ $w, $this ];
	#print "===== {$w} =====\n";

	if (exists $this->{body}) {
		# Skip name
		$w = $this->{body}/4;
		next;
	}

	if (exists $this->{name}) {
		printf "\nname=%s", $this->{name};
		printf " flags=%02x", $this->{flags} if exists $this->{flags};
		printf "\n";
	}

	printf "  %08x: %08x ", $adr, $this->{word};
	my $linked = dict($this->{word});
	printf "%-20s  ", $linked->{name} // "";
	printf "%s\n", $this->{disasm};
	#$w = $w + 4;
}

__END__
	#   1085 flags=80 
	#     81 flags=c0 " h# d#
	#     20 flags=a0 %up %tos
	#      2 flags=e0 (s to
	#	warn sprintf "link=0x%08x adr=0x%08x flags=0x%02x name=%s\n",
	#	$link, $adr, $flags, $name;
