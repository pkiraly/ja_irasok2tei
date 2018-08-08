# Elkészíti a hierarchiát

use strict;
use constant LN => "\n";

sub countdown($ $ $) {
	my $div   = shift;
	my $divNr = shift;
	my $last  = shift;
	
	my $text = $div;
	for(my $i=($divNr-1); $i >=0; $i--) {
		$text .= '</div'. $i .'>';
	}
	$text .= $last;
	print STDERR __LINE__, ') ', $text, LN;
	return $text;
}

open(TEI, "tei-with-notes.xml") || die "Can't open tei.xml: $!\n";
open(TEIN, ">tei-hierarchy.xml") || die "Can't open tei-with-notes.xml: $!\n";

my $text = '';
while(<TEI>) {
	$text .= $_;
}
close TEI;

my $newText;
my $oldNr = -1;
my $actualNr = -1;
my @stack = ();
print STDERR __LINE__, ') ', "empty stack: ", $#stack, LN;
while(length($text) > 0) {
	if ($text =~ s/^(.*?)(<(\/?)div(\d)>)//s) {
		$newText .= $1;
		my $tag = $2;
		my $opener = ($3) ? 0 : 1;
		my $Nr     = $4;
		print STDERR __LINE__, ') ', 'ERROR: ', $Nr, LN if $Nr !~ /^\d+$/;
		print STDERR __LINE__, ') incoming tag: ', $tag, LN;
		my $addition = '';
		if ($oldNr == -1) {
			$addition = '<div' . $Nr . '><head>';
			$actualNr = $Nr;
			push(@stack, $Nr);
			$oldNr = 0;
		}
		else {
			if ($opener) {
				$oldNr = pop(@stack);
				if ($oldNr == $Nr) {
					print STDERR __LINE__, ') ', "$oldNr == $Nr", LN;
					if($Nr != $actualNr) {
						print STDERR __LINE__, ') ', "$Nr != $actualNr", LN;
					}
					$addition = '</div' . $Nr . '>';
				}
				elsif($oldNr < $Nr) {
					print STDERR __LINE__, ') ', "$oldNr < $Nr", LN;
					$actualNr++;
					if($Nr != $actualNr) {
						print STDERR __LINE__, ') ', "$Nr != $actualNr", LN;
					}
					print STDERR __LINE__, ') Add to stack: ', $oldNr, LN;
					push(@stack, $oldNr);
					print STDERR __LINE__, ') ', ' < ', LN;
				}
				elsif ($oldNr > $Nr) {
					print STDERR __LINE__, ') ', "$oldNr > $Nr", LN;
					print STDERR __LINE__, ') in stack: ', join(', ', @stack), LN;
					my $i = $oldNr;
					print STDERR __LINE__, ') ', 'ERROR: ', $i, LN if $i !~ /^\d+$/;
					for($i = $oldNr; $i >= $Nr; ) {
						$actualNr--;
						print STDERR __LINE__, ') ', ' for: ', $i, ' > ', $Nr, ' -> ', '</div' . $i . '>', LN;
						$addition .= '</div' . $i . '>';
						if ($#stack > -1) {
							$i = pop(@stack);
						}
						else {
							last;
						}
					}
					print STDERR __LINE__, ') Add to stack: ', $i, LN;
					push(@stack, $i);
					$actualNr++;
				}
				$addition .= '<div' . $Nr . '><head>';
				print STDERR __LINE__, ') Add to stack: ', $Nr, LN;
				push(@stack, $Nr);
			}
			else {
				$addition = '</head>';
			}
			
			if($text !~ /<(\/?)div(\d)>/) {
				if($text =~ s/^(.*?)(<\/body>)/$2/s) {
					if($addition) {
						$newText .= $addition;
						$addition = '';
					}
					$newText .= $1;
					for(my $i = $Nr; $i > 0; $i--) {
						$addition .= '</div' . $i . '>';
					}
					print STDERR __LINE__, ') extra addition: ', $addition, LN;
					$addition .= $text;
					print STDERR __LINE__, ') extra addition: ', $addition, LN;
					$text = '';
				}
				else {
					print STDERR __LINE__, ') ', 'no body?', LN;
				}
			}
		}
		print STDERR __LINE__, ') inserted tags: ', ' => ', $addition, LN;
		print STDERR __LINE__, ') ', '    stack: ', join(', ', @stack), ' actualNr: ', $actualNr, LN;
		$newText .= $addition;
	}
	else {
		last;
	}
}
$text = $newText;

#$text =~ s{<(div\d)>(.*?)</\1>}{</$1><$1><head>$2</head>}g;
#$text =~ s{(</head>\s*)}{$1<!-- o-->}sg;
#$text =~ s{(</head>\s*)</(div\d)>(<\2>)}{$1$3}sg;
#$text =~ s{<body></div0>}{<body>};
#$text =~ s{(.*)<(div\d)>(.*?)</body>}{$1<$2>$3</$2></body>}s;
#$text =~ s{(</div(\d)>)(</body>)}{countdown($1, $2, $3)}e;
#$text =~ s{(<\/?div)(\d)>}{$1 . ($2+1) . '>'}eg;

$text =~ s/(<\/div1>)<\/div1>/$1/g;

print TEIN $text;
close TEIN;

#unlink "tei.xml";
#rename "tei-preprocessed.xml", "tei.xml";

