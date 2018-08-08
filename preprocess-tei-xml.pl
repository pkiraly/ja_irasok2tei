# Az első, wordből előállított XML-en hajt végre néhány olyan változtatást, amivel
# javít a későbbi programok hatékonyságán
# 1. </note>\p<note> (több változat is előfordulhat
# 2. <link> összefűzése

use strict;
use constant LN => "\n";

open(TEI, "tei-raw.xml") || die "Can't open tei.xml: $!\n";
open(TEIN, ">tei.xml") || die "Can't open tei-with-notes.xml: $!\n";

my $text = '';
while(<TEI>) {
	$text .= $_;
}
close TEI;

# processes goes here
$text =~ s{</p>\n</note>}{</p></note>}g;
$text =~ s{<link>qqq@</link><link>(http)</link><link>(://textus.)}{<link rend="img">$1$2}g;
$text =~ s{(kosztolanyi_korhazi)</link></p>\n<p rend="class:Standard"><link>(\d+\.tiff</link>)}{$1  $2}g;
$text =~ s{(kosztolanyi_korhazi)</link></p>\n<p rend="class:Standard">(\d+\.tiff)}{$1  $2</link>}g;
$text =~ s{(</p>)\n(<p rend="class:Footnote">)}{$1$2}g;
$text =~ s{<link(.*?)>(.*?)</link>}{<ref$1 target="$2">$2</ref>}g;
$text =~ s{<p>Tartalomjegyzék</p>\n}{}g;
$text =~ s{<p rend="class:Contents\d">.*?</p>\n}{}g;
$text =~ s{<p[^<>]*>qqq@(.*?)</p>}{<p rend="class:Standard"><ref rend="img" target="img/$1">$1</ref></p>}g;

print TEIN $text;
close TEIN;

#unlink "tei.xml";
#rename "tei-preprocessed.xml", "tei.xml";