#!/bin/bash

XMLDIR=wordxml
SAXON=~/.m2/repository/net/sf/saxon/Saxon-HE/9.8.0-7/Saxon-HE-9.8.0-7.jar

echo "*** STARTED"
echo "-------------------"
echo "--- creating simple TEI (tei-raw.xml...)"
echo "-------------------"
java -jar $SAXON $XMLDIR/word/document.xml ja2tei.xsl footnotesdoc=$XMLDIR/word/footnotes.xml numberingdoc=$XMLDIR/word/numbering.xml > tei-raw.xml

echo "-------------------"
echo "--- do some preprocess (tei.xml...)"
echo "-------------------"
perl -w preprocess-tei-xml.pl

echo "-------------------"
echo "--- validating raw well formedness (validated.xml...)"
echo "-------------------"
java -jar $SAXON tei.xml validate.xsl > validated.xml

echo "-------------------"
echo "--- handling notes (qqq replacements) (tei-with-notes.xml..., see ja-notes.err)"
echo "-------------------"
perl -w ja-notes3.pl > ja-notes.txt 2>ja-notes.err

echo "-------------------"
echo "--- validating notes well formedness"
echo "-------------------"
java -jar $SAXON tei-with-notes.xml validate.xsl > validated.xml

echo "-------------------"
echo "--- creating a hierarchy draft view (tei-hierarchy.xml...)"
echo "-------------------"
java -jar $SAXON tei-with-notes.xml hierarchy1.xsl > tei-hierarchy.xml 2>hierarchy1.messages.txt

echo "-------------------"
echo "--- setting up hierarchy"
echo "-------------------"
perl -w hierarchy.pl > hierarchy-notes.txt 2>hierarchy.err

echo "-------------------"
echo "--- validating hierarchy well formedness"
echo "-------------------"
java -jar $SAXON tei-hierarchy.xml validate.xsl > validated.xml

echo "-------------------"
echo "--- validating hierarchy" 
echo "-------------------"
java -jar $SAXON -dtd tei-hierarchy.xml validate.xsl > validated.xml

# echo setting up hierarchy
# java -jar $SAXON tei-with-notes.xml hierarchy5.xsl > tei-hierarchy.xml 2>hierarchy5.messages.txt

echo "*** FINISHED"
