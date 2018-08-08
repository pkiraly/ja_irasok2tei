# read in tei.xml, and output tei-with-notes.xml

use strict;
use warnings;
use constant LN => "\n";

our $debuggableNoteNr = 80;

sub parse_attrs($) {
	my $attrs = shift;
	my @parts = split(/ /, $attrs);
	my %attrs = ();
	for my $part (@parts) {
		my ($key, $val) = split(/=/, $part);
		$val =~ s/^['"]|['"]$//g; #"
		$attrs{$key} = $val;
	}
	return $attrs{'n'};
}

sub trim($) {
	my $string = shift;
	$string =~ s/^\s+//;
	$string =~ s/\s+$//;
	return $string;
}

sub find_reading_patterns($ $ $) {
	my $noteType = shift;
	my $noteNr = shift;
	my $reading_pattern = shift;
	
	if ($noteType eq 'qqq2' && $reading_pattern ne '[Előbb:] -- [végül: főszöveg]') {
		printf("%s %d: %s\n", $noteType, $noteNr, $reading_pattern);
	}
	elsif ($noteType eq 'qqq1' && $reading_pattern ne '[Előbb:] -- [végül: főszöveg]') {
		printf("%s %d: %s\n", $noteType, $noteNr, $reading_pattern);
	}
	elsif ($noteType eq 'qqqf' && $reading_pattern ne '[A forrásban:]') {
		printf("%s %d: %s\n", $noteType, $noteNr, $reading_pattern);
	}
	elsif ($noteType eq 'qqqb' 
	  && $reading_pattern ne '[Előbb:] -- [majd:] -- [végül: főszöveg]'
	  && $reading_pattern ne '[Előbb:] -- [majd:] -- [majd:] -- [végül: főszöveg]'
	  && $reading_pattern ne '[Előbb:] -- [majd:] -- [majd:] -- [majd:] -- [végül: főszöveg]'
	  && $reading_pattern ne '[Előbb:] -- [majd:] -- [majd:] -- [majd:] -- [majd:] -- [végül: főszöveg]'
	  && $reading_pattern ne '[Előbb:] -- [majd:] -- [javításunk:] -- [végül: főszöveg]') {
		printf("%s %d: %s\n", $noteType, $noteNr, $reading_pattern);
	}
	elsif ($noteType eq 'qqq2+2' && $reading_pattern ne '[Előbb:] -- [majd:] -- [végül: főszöveg]'
			&& $reading_pattern ne '[Előbb:] -- [végül: főszöveg]') {
		printf("%s %d: %s\n", $noteType, $noteNr, $reading_pattern);
	}
	elsif ($noteType eq 'qqq3' && $reading_pattern ne '[Előbb:] -- [végül: főszöveg]') {
		printf("%s %d: %s\n", $noteType, $noteNr, $reading_pattern);
	}
	elsif ($noteType eq 'qqq2j' && $reading_pattern ne '[Előbb:] -- [végül: főszöveg]'
			&& $reading_pattern ne '[Előbb:] -- [majd:] -- [végül: főszöveg]') {
		printf("%s %d: %s\n", $noteType, $noteNr, $reading_pattern);
	}
	elsif ($noteType eq 'qqq2k' && $reading_pattern ne '[Előbb:] -- [végül:] -- [javításunk:]'
			&& $reading_pattern ne '[Előbb:] -- [javításunk:] -- [végül:] -- [javításunk:]'
			&& $reading_pattern ne '[Előbb:] -- [javításunk:] -- [végül: főszöveg]') {
		printf("%s %d: %s\n", $noteType, $noteNr, $reading_pattern);
	}
	elsif ($noteType eq 'qqqt' && $reading_pattern ne '[A töredékes forrásban:]') {
		printf("%s %d: %s\n", $noteType, $noteNr, $reading_pattern);
	}
	# qqqm doesn't have pattern
	#elsif ($noteType eq 'qqqm') {
	#	printf("%s %d: %s\n", $noteType, $noteNr, $reading_pattern);
	#}
	elsif ($noteType eq 'qqqsz' && $reading_pattern ne '[A szerző saját jegyzete:]'
			&& $reading_pattern ne '[A szerző saját jegyzete:] -- [Előbb:] -- [végül:]') {
		printf("%s %d: %s\n", $noteType, $noteNr, $reading_pattern);
	}
	elsif ($noteType eq 'qqq1k' && $reading_pattern ne '[Előbb:] -- [végül:] -- [javításunk:]'
			&& $reading_pattern ne '[Előbb:] -- [javításunk:] -- [végül: főszöveg]') {
		printf("%s %d: %s\n", $noteType, $noteNr, $reading_pattern);
	}
	# lots of variations
	# elsif ($noteType eq 'qqqbk' && $reading_pattern ne '[Előbb:] -- [végül:] -- [javításunk:]') {
	# 	printf("%s %d: %s\n", $noteType, $noteNr, $reading_pattern);
	# }
	elsif ($noteType eq 'qqq1+1' && $reading_pattern ne '[Előbb:] -- [majd:] -- [végül: főszöveg]') {
		printf("%s %d: %s\n", $noteType, $noteNr, $reading_pattern);
	}
	elsif ($noteType eq 'qqq2+2k' && $reading_pattern ne '[Előbb:] -- [majd:] -- [végül:] -- [javításunk:]'
			&& $reading_pattern ne '[Előbb:] -- [majd:] -- [javításunk:] -- [végül: főszöveg]'
			&& $reading_pattern ne '[Előbb:] -- [majd:] -- [javításunk:]') {
		printf("%s %d: %s\n", $noteType, $noteNr, $reading_pattern);
	}
	elsif ($noteType eq 'qqqbj' && $reading_pattern ne '[Előbb:] -- [majd:] -- [végül: főszöveg]'
			&& $reading_pattern ne '[Előbb:] -- [majd:] -- [majd:] -- [végül: főszöveg]') {
		printf("%s %d: %s\n", $noteType, $noteNr, $reading_pattern);
	}
	elsif ($noteType eq 'qqq2+2j' && $reading_pattern ne '[Előbb:] -- [majd:] -- [végül: főszöveg]'
			&& $reading_pattern ne '[Előbb:] -- [majd:] -- [majd:] -- [majd:] -- [végül: főszöveg]') {
		printf("%s %d: %s\n", $noteType, $noteNr, $reading_pattern);
	}
	elsif ($noteType eq 'qqqfj' && $reading_pattern ne '[A forrásban:]') {
		printf("%s %d: %s\n", $noteType, $noteNr, $reading_pattern);
	}
	elsif ($noteType eq 'qqq2+2+2' && $reading_pattern ne '[Előbb:] -- [majd:] -- [majd:] -- [végül: főszöveg]') {
		printf("%s %d: %s\n", $noteType, $noteNr, $reading_pattern);
	}
	elsif ($noteType eq 'qqq3k' && $reading_pattern ne '[Előbb:] -- [végül:] -- [javításunk:]'
			&& $reading_pattern ne '[Előbb:] -- [végül:] -- [javításunk:] -- [végül: főszöveg]') {
		printf("%s %d: %s\n", $noteType, $noteNr, $reading_pattern);
	}
}

sub get_readings_words($ $ $) {
	my $note = shift;
	my $noteNr = shift;
	my $inNewLine = shift;

	my $note_Orig = $note;
	$note =~ s/<\/hi>|<hi rend="italics">//g;
	my @words_in_version = split(/ /, $note);
	my $firstWord = $words_in_version[0];
	my $lastWord  = $words_in_version[$#words_in_version];

	return ($firstWord, $lastWord);
}

sub get_main_words($ $ $ $ $ $ $) {
	my $main = shift;
	my $firstWordInNote = shift;
	my $lastWordInNote = shift;
	my $noteNr = shift;
	my $newLine = shift;
	my $noteType = shift;
	my $reading_type = shift;
	
	my $mainOrig = $main;
	
	while($main =~ s/(<[^<> ]+) ([^<>]+>)/$1%%%$2/g){}
	my @words = split(/ /, $main);
	my $lastWord = $words[$#words];
	$lastWord =~ s/<[^<>]+>//g;
	if (($noteType ne 'qqqb' && $noteType ne 'qqq3')
			&& $lastWordInNote ne $lastWord
		) {
		print STDERR $0, ':', __LINE__, ") ERROR in note#$noteNr LAST WORD MISMATCH ($noteType/$reading_type) $lastWordInNote != $lastWord", LN ;
	}

	my $found = -1;
	my $k = 0;
	my $j;
	for($j = $#words; $j >= 0; $j--) {
		$k++;
		my $word = $words[$j];
		$word =~ s/<[^<>]+>//g;
		if ($word eq $firstWordInNote) {
			$found = $j . ', ' . $k;
			last;
		}
	}
	
	my $tagAfterNote = '';
	my ($mainPrev, $mainVersion);
	# 144, 157, 328, 1927, 2176, 2410 -- újsor a mainben
	# 885 (átfonódik a 884 és a 885)
	if ($found eq "-1") {
		if ($noteNr == $main::debuggableNoteNr) {
			print STDERR $0, ':', __LINE__, ') NOT FOUND', LN;
			print STDERR $0, ':', __LINE__, ') newLine: ', $newLine, LN;
		}
		if(!$newLine && $mainOrig !~ /^<(p|div)[^<>]*>/) {
			print STDERR $0, ':', __LINE__, ") ERROR in note#$noteNr FIRST WORD MISMATCH ($noteType/$reading_type) '$firstWordInNote' in [[$mainOrig]]", LN;
			$mainPrev = '';
			$mainVersion = $mainOrig;
		}
		else {
			$mainOrig =~ /^<(p|div)[^<>]*>/;
			$mainPrev = $&;
			$mainVersion = $';
		}
		if ($noteNr == $main::debuggableNoteNr) {
			print STDERR $0, ':', __LINE__, ') mainVersion: ', $mainVersion, ', mainOrig: ', $mainOrig, LN;
		}
	}
	else {
		if ($noteNr == $main::debuggableNoteNr) {
			print STDERR $0, ':', __LINE__, ') @words: ', join(' -- ', @words), LN;
		}
		$mainPrev = join(' ', @words[0..$j-1]) . ' ';
		$mainVersion = join(' ', @words[$j..$#words]) . ' ';
		if ($mainVersion =~ s/^(<(p|div)[^<>]*>)// ) {
			$mainPrev .= $1;
		}
		
		if ($noteNr == $main::debuggableNoteNr) {
			print STDERR $0, ':', __LINE__, ') $mainVersion: ', $mainVersion, LN;
		}
		$mainPrev =~ s/%%%/ /g;
		$mainVersion =~ s/%%%/ /g;
		my @tags = ('hi', 'kij');
		foreach my $tag (@tags) {
			my @alltags = ($mainVersion =~ /<$tag[^<>]*>|<\/$tag>/g);
			if ($#alltags == -1 || ($#alltags+1) % 2 == 0) {
				next;
			}
			if ($noteNr == $main::debuggableNoteNr) {
				print STDERR $0, ':', __LINE__, ') @alltags: ', $#alltags, ': ', join(' -- ', @alltags), LN;
			}
			my $flag = 0;
			my @openers = ();
			for (my $t=0; $t <= $#alltags; $t++) {
				my $tag_type = ($alltags[$t] eq "</$tag>") ? -1 : 1;
				if ($tag_type == 1) {
					push(@openers, $alltags[$t]);
				}
				else {
					pop(@openers);
				}
				$flag += $tag_type;
				if ($flag < 0) {
					print STDERR $0, ':', __LINE__, ") ERROR in note#$noteNr: NO OPENER at ", $t+1, ' ', $mainVersion, LN;
				}
			}
			if ($flag > 0) {
				print STDERR $0, ':', __LINE__, ") ERROR in note#$noteNr: NO CLOSER at the end $mainVersion [", join(', ', @openers), ']', LN;
				$mainVersion .= "</$tag>" x ($#openers + 1);
				$tagAfterNote = join('', @openers);
			}
			elsif ($flag < 0) {
				@alltags = ($mainPrev =~ /<$tag[^<>]*>|<\/$tag>/g);
				$flag = 0;
				for (my $t=$#alltags; $t >= 0; $t--) {
					my $tag_type = ($alltags[$t] eq "</$tag>") ? -1 : 1;
					$flag += $tag_type;
					if ($flag == 1) {
						$mainPrev .= "</$tag>";
						$mainVersion = $alltags[$t] . $mainVersion;
						last;
					}
				}
			}
		}
	}
	
	if ($noteNr == $main::debuggableNoteNr) {
		print STDERR $0, ':', __LINE__, ') $mainPrev: ', $mainPrev, LN;
		print STDERR $0, ':', __LINE__, ') $mainVersion: ', $mainVersion, LN;
	}
	return ($mainPrev, $mainVersion, $tagAfterNote);
}

open(TEI, "tei.xml") || die "Can't open tei.xml: $!\n";
open(TEIN, ">tei-with-notes.xml") || die "Can't open tei-with-notes.xml: $!\n";

my $counter = 0;
my %statistics = ();
my $multilineHighlight = 0;
my $debug = 0;
while(<TEI>) {

	$debug = ($. == 222000);
   # delete empty tags
	s/<hi rend="(?:sub|sup|italics|bold)">( |\.)<\/hi>/$1/g;

  # TODO: külön kezelni a kétszeres kijelöléseket!
   # kijelölés eleje
	s/<note><p rend="class:Footnote(?:Text)?"><seg rend="class:footnoteRef"(?: n="\d+")?>\[(\d+)\]<\/seg> qqq(kétszeres)?kijelöléseleje<\/p><\/note>/<kij>/g;
	
	# kijelölés vége
	s/<note><p rend="class:Footnote(?:Text)?"><seg rend="class:footnoteRef"(?: n="\d+")>\[(\d+)\]<\/seg> qqq(kétszeres)?kijelölésvége<\/p><\/note>/<\/kij>/g;
	
	# egyszavas kijelölés
	s/( |>|\()([\wÉÁŰŐÚÖÜÓÍéáűőúöüóí](?:[\wÉÁŰŐÚÖÜÓÍéáűőúöüóí\-]|\[…\])*(?:\.| ?\[\?\]\.?|!+| ?\?|,|…| \xe2\x80\x95)?|\d[\d\.]+|\[olvashatatlan szó\]|\([\wÉÁŰŐÚÖÜÓÍéáűőúöüóí]+\)|\[…\][\wÉÁŰŐÚÖÜÓÍéáűőúöüóí]+\[…\])<note><p rend="class:Footnote(?:Text)?"><seg rend="class:footnoteRef"(?: n="\d+")>\[(\d+)\]<\/seg> qqq(?:kétszeres)?kijelölésegyszóra<\/p><\/note>/$1<kij>$2<\/kij>/g;
	
	print STDERR $0, ':', __LINE__, ' -- ', $_ if $debug;
	
	# egyszavas kijelölés egy jegyzet után
	s/( |>|\()([\wÉÁŰŐÚÖÜÓÍéáűőúöüóí](?:[\wÉÁŰŐÚÖÜÓÍéáűőúöüóí\-]|\[…\])*(?:\.|\[\?\]\.?|!+| ?\?|,|…)?|\d[\d\.]+|\[olvashatatlan szó\]|\([\wÉÁŰŐÚÖÜÓÍéáűőúöüóí]+\))(<note>.*?<\/note> ?)<note><p rend="class:Footnote(?:Text)?"><seg rend="class:footnoteRef"(?: n="\d+")>\[(\d+)\]<\/seg> qqq(?:kétszeres)?kijelölésegyszóra<\/p><\/note>/$1<kij>$2<\/kij>$3/g;
	s/(<(?:kij|hi rend="bold")>)(<note><p rend="class:Footnote(?:Text)?"><seg rend="class:footnoteRef"(?: n="\d+")>\[(\d+)\]<\/seg> (?:.*?)<\/p><\/note>)/$2$1/g;
	
	s/<kij> / <kij>/g;
	s/ (<\/(?:kij|hi)>)/$1 /g;
	
	# nem qqq-s jegyzet és qqq-s jegyzet cseréje
	s/(<note><p rend="class:Footnote(?:Text)?"><seg rend="class:footnoteRef"(?: n="\d+")>\[(?:\d+)\]<\/seg> [^q](?:.*?)<\/p><\/note>)(<note><p rend="class:Footnote(?:Text)?"><seg rend="class:footnoteRef"(?: n="\d+")>\[(?:\d+)\]<\/seg> qqq(?:.*?)<\/p><\/note>)/$2$1/g;
	
	s/<hi rend="(?:sub|sup|italics|bold)"><\/hi>//g;
	
	s/<hi rend="sup">,<\/hi>/,/g;
	
	if(/<note>/) {
		chomp();
		my @parts = split(/<\/?note[^<>]*?>/, $_);
		for(my $i=1; $i<=$#parts; $i+=2) {
			my $main = $parts[$i-1];
			my $note = $parts[$i];
			
			# print STDERR 'main: ', $main, "\n";
			
			my $noteNr = -1;
			my $mark   = -1;
			$note =~ s/^<p.*?>//;
			if($note =~ s/^<seg (.*?)>\[(\d+|\*)\]<\/seg> ?//) {
				$mark   = $2;
				$noteNr = parse_attrs($1);
				#$noteNr = $attrs{'n'};
				#print 'NOTE #', $noteNr, ': ', $note, LN;
			} else {
				print STDERR $0, ':', __LINE__, ' -- ', 'no <seg>[0-9]</seg> pattern in line #', $., LN;
				print STDERR $0, ':', __LINE__, ' -- ', $note, LN;
				print STDERR $0, ':', __LINE__, ' -- ', $_, LN;
			}
			
			# workaround
			$main =~ s/<hi rend="italics">minden<\/hi> <hi rend="bold"><hi rend="italics">kérdés<\/hi><\/hi><hi rend="italics"> föltételévé<\/hi>/<hi rend="italics">minden <hi rend="bold">kérdés<\/hi> föltételévé<\/hi>/;

			if ($noteNr == $debuggableNoteNr) {
				print STDERR $0, ':', __LINE__, ") $debuggableNoteNr: [main:[$main]]\n";
			}

			
			if ($note !~ /^qqq((1|1k|1\+1|1\+1\+1|1\+1\+1\+1|2|2\+2|2\+2j|2\+2k|2\+2\+2|2\+2\+2j|2j|2k|2kj|2szövegelejés|2szövegvégés|2\+2\+2\+2szövegelejés|2\+2mellékletelejés|3|3k|3j|3\+3|3\+3k|f|fj|b|bj|bk|bszövegelejés|bszövegvégés|t|m|sz) |(réteg2(eleje|vége)|kérdőjel(eleje|vége)|így \[Így!\])<\/p>)/) {
				print STDERR $., ' note ', $noteNr, ': ', $note, "\n";
			}
			
			#
			# [A szerkesztő jegyzete:]
			# [Ezután a következő szerepel a forrásban:]
			# [A költő a következő jegyzettel látta el a címet:]
			# [A lap tetejéről ehhez a ponthoz nyilazott megjegyzés:]
			# [A mondat felett a szerző kézírásával:]
			# [végül: főszöveg:]
			my @types = ($note =~ /\[[^\]]+:\]/g);
			foreach my $type (@types) {
				if ($type !~ /^\[(Előbb|javításunk|végül|majd|A forrásban|új sorban|A szerző saját jegyzete|A töredékes forrásban):\]/) {
					print STDERR $type, LN;
				}
			}

			my $content;
			my $noteType;
			if ($note =~ /^qqq((1|1k|1\+1|1\+1\+1|1\+1\+1\+1|2|2\+2|2\+2j|2\+2k|2\+2\+2|2\+2\+2j|2j|2k|2kj|2szövegelejés|2szövegvégés|2\+2\+2\+2szövegelejés|2\+2mellékletelejés|3|3k|3j|3\+3|3\+3k|f|fj|b|bj|bk|bszövegelejés|bszövegvégés|t|m|sz) |(réteg2(eleje|vége)|kérdőjel(eleje|vége)|így \[Így!\])<\/p>)/) {
				$noteType = trim($&);
				$noteType =~ s/<\/p>$//; 
				$content  = $';
			}
			$statistics{$noteType}++;
			# print $., ' ', $noteType, LN;

			my $lastWord   = '';
			my $tagAfterNote = '';
			
			if ($noteType eq 'qqq1') {
				# find last word
				if ($main =~ />$/) {
					if ($main =~ s/(<(hi|kij)[^<>]*>)([^<> ]+)(<\/\2>)$//){
						$lastWord = $&;
					}
					elsif ($main =~ s/(<hi[^<>]*>)(.*?) ([^<> ]+)(<\/hi>)$/$1$2$4 /){
						$lastWord = $1 . $3 . $4;
					}
					else {
						print STDERR $0, ':', __LINE__, " ERROR note#$noteNr NO LASTWORD [main:[$main]]", LN;
					}
				}
				else {
					if ($main =~ s/(<(?:p|div|kij)[^<>]*>| )([^<> ]+)$/$1/){
						$lastWord = $2;
					} 
					else {
						print STDERR $0, ':', __LINE__, " ERROR note#$noteNr NO LASTWORD [main:[$main]]", LN;
					}
				}
			}

			$content =~ s/<\/p>$//;
			$content =~ s/(\[(?:Előbb:|javításunk:|végül:|majd:|A forrásban:|végül: főszöveg|A töredékes forrásban:|A szerző saját jegyzete:)\])((?:<hi rend="sub">[\d,]+<\/hi>)?)/<PART>$1<SUBPART>$2<SUBPART>/g;
			$content =~ s/^<PART>//;
			my @readings = split(/<PART>/, $content);
			my @reading_types = ();
			my @teinote = ();
			my ($mainPrev, $mainVersion);
			if ($noteNr == $debuggableNoteNr) {
				print STDERR $0, ':', __LINE__, ") $debuggableNoteNr: [main:[$main]]\n";
			}
			for (my $j=0; $j <= $#readings; $j++) {
				my ($reading_type, $reading_count, $reading) = split(/<SUBPART>/, $readings[$j]);
				if ($reading_count) {
					$reading_count =~ s/(<hi rend="sub">|<\/hi>)//g;
				}
				if ($noteNr == $debuggableNoteNr) {
					print STDERR $0, ':', __LINE__, ") $debuggableNoteNr: [reading_type:[$reading_type]], [main:[$main]]\n";
				}

				if ($reading && $reading ne '') {
					$reading = trim($reading);
				}
				
				if ($noteType eq 'qqqm') {
					push(@teinote, sprintf('<note n="%s">%s</note>', $noteNr, $reading_type));
				}
				elsif ($noteType eq 'qqqsz') {
					if ($reading_type eq '[A szerző saját jegyzete:]') {
						my $t = $reading_type . $reading_count . ' ' . $reading;
						if ($#readings > 0) {
							$t .= sprintf(' <app type="%s" n="%s">', $noteType, $noteNr);
						}
						push(@teinote, $t);
					}
					else {
						push(@teinote, sprintf('<rdg varSeq="%d">%s</rdg>', ($j+1), $reading));
					}
				}
				else {
					push(@reading_types, $reading_type);
					if ($noteType eq 'qqq1' && $reading_type eq '[végül: főszöveg]') {
						if ($reading eq '') {
							$reading = $lastWord;
						}
					}
					if (   $noteType eq 'qqq2' 
							|| $noteType eq 'qqq2+2' 
							|| $noteType eq 'qqq2+2+2' 
							|| $noteType eq 'qqqf'
							|| $noteType eq 'qqqb'
							|| $noteType eq 'qqq3'
							|| $noteType eq 'qqq2j'
							|| $noteType eq 'qqq1k'
							|| $noteType eq 'qqq2k'
						) {
						if ($reading_type ne '[végül: főszöveg]') {
							my $reading_orig = $reading;
							my $inNewLine = ($reading =~ /\[új sorban:\]/) ? 1 : 0;
							if ($noteNr == $debuggableNoteNr) {
								print STDERR $0, ':', __LINE__, ") [reading:[$reading]]", LN;
							}
							# get note first, last
							my ($firstWord, $lastWord, $inBetween) = get_readings_words($reading, $noteNr, $inNewLine);
							# find pattern in main
							($mainPrev, $mainVersion, $tagAfterNote) = get_main_words($main, $firstWord, $lastWord, $noteNr, $inNewLine, $noteType, $reading_type);
							if ($noteNr == $debuggableNoteNr) {
								print STDERR $0, ':', __LINE__, ") $debuggableNoteNr: [reading:[$reading]]\n";
								print STDERR $0, ':', __LINE__, ") $debuggableNoteNr: [firstWord:[$firstWord]], [lastWord:[$lastWord]], [main:[$main]]\n";
								print STDERR $0, ':', __LINE__, ") $debuggableNoteNr: [mainPrev:[$mainPrev]], [mainVersion:[$mainVersion]]", LN;
							}
						}
						else {
							# replace main
							$main = $mainPrev;
							$reading = $mainVersion;
						}
					}
					
					if (($noteType eq 'qqq2k' || $noteType eq 'qqq1k') && $reading_type eq '[javításunk:]' && $j == $#readings) {
							# replace main
							$main = $mainPrev;
							$reading = $mainVersion;
					}

					push(@teinote, sprintf('<rdg varSeq="%d" type="%s" hand="%s">%s</rdg>', ($j+1), $reading_type, $reading_count, $reading));
					if ($noteType eq 'qqqf') {
						if ($noteNr == $debuggableNoteNr) {
							print STDERR $0, ':', __LINE__, ") $debuggableNoteNr: [mainVersion:[$mainVersion]]", LN;
						}
						$main = $mainPrev;
						$reading = $mainVersion;
						push(@teinote, sprintf('<rdg varSeq="%d">%s</rdg>', ($j+2), $mainVersion));
					}
				}
			}

			my $teinote;
			if ($noteType eq 'qqqm' || $noteType eq 'qqqsz') {
				if ($noteType eq 'qqqsz' && $#readings > 0) {
					push(@teinote, '</app>');
				}
				$teinote = sprintf('<note type="%s" n="%s">%s</note>', $noteType, $noteNr, join('', @teinote));
			}
			else {
				$teinote = sprintf('<app type="%s" n="%s">', $noteType, $noteNr) . join('', @teinote) . '</app>';
			}
			# $lastWord
			$teinote .= $tagAfterNote;

			$parts[$i-1] = $main;
			$parts[$i] = $teinote;

			my $reading_pattern = join(' -- ', @reading_types);
			find_reading_patterns($noteType, $noteNr, $reading_pattern);
			
			next;
		}
		$_ = join('', @parts) . LN;
		s/ (<\/rdg>)/$1/g;
	}
	
	my $highlightHandled = 0;
	if(/<kij>(.*?)<\/p>$/) {
		my $rest = $1;
		while($rest =~ /<kij>/) {
			$rest = $';
		}
		if($rest !~ /<\/kij>/) {
			$multilineHighlight = 1;
			$highlightHandled = 1;
			s/(<\/p>)$/<\/kij>$1/;
		}
	}
	if(/^<p(?: rend="class:Standard")?>(.*?)<\/kij>/) {
		my $rest = $1;
		if($rest !~ /<kij>/) {
			$multilineHighlight = 0;
			$highlightHandled = 1;
			s/^(<p(?: rend="class:Standard")?>)/$1<kij>/;
		}
	}

	if($multilineHighlight == 1 && $highlightHandled == 0) {
		print STDERR $0, ':', __LINE__, ' -- ', $., '.) MULTILINE...', $_, LN;
		s/^(<p rend="class:Standard">)/$1<kij>/;
		s/(<\/p>)$/<\/kij>$1/;
	}

	print STDERR $0, ':', __LINE__, ' -- ', $_ if $debug;
	
	s/<kij>/<hi rend="underline">/g;
	s/<\/kij>/<\/hi>/g;
	s/<p rend="class:Standard">/<p>/g;
	s/( )(<\/hi>)/$2$1/g;
	s/(<hi[^<>]*>)( )/$2$1/g;

	print STDERR $0, ':', __LINE__, ' -- ', $_ if $debug;
	
	print TEIN $_;
}
close TEI;
close TEIN;

open(STAT, '>ja-notes-stat.txt');
for my $type (sort { $statistics{$b} <=> $statistics{$a} } keys %statistics) {
	print STAT $type, ': ', $statistics{$type}, LN;
}
close STAT;

my $fulltext = '';
open(TEI, "<tei-with-notes.xml") || die "Can't open tei-with-notes.xml: $!\n";
while(<TEI>) {
	$fulltext .= $_;
}
close TEI;

while ($fulltext =~ /<hi(?:[^<>]*)>([^\n]+?)<\/hi>/s) {
	my $found = $&;
	my $content = $1;
	#print $content, LN;
	if ($content !~ /<\/hi[^<>]*>/) {
		my $change = $found;
		$change =~ s/^<hi([^<>]*)>([^\n]+?)<\/hi>$/<hey$1>$2<\/hey>/;
		$fulltext =~ s/\Q$found\E/$change/;
	}
}

while ($fulltext =~ /<hi([^<>]*)>(.+?)<\/hi>/s) {
	my $found = $&;
	print STDERR '.';
	my $attribs = $1;
	my $change = my $content = $2;
	$change =~ s/(<\/p>\n)(\s*<p[^<>]*>)/<\/hey>$1$2<hey$attribs>/gs;
	$change = '<hey' . $attribs . '>' . $change . '</hey>';
	$fulltext =~ s/\Q$found\E/$change/;
}

$fulltext =~ s/<hey([^<>]*)>/<hi$1>/g;
$fulltext =~ s/<\/hey>/<\/hi>/g;

open(TEI, ">tei-with-notes.xml") || die "Can't open tei-with-notes.xml: $!\n";
print TEI $fulltext;
close TEI;