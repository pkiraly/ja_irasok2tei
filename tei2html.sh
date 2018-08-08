#!/bin/bash

SAXON=~/.m2/repository/net/sf/saxon/Saxon-HE/9.8.0-7/Saxon-HE-9.8.0-7.jar
java -jar $SAXON -o:index.html tei-hierarchy.xml tei2html.xsl splitLevel=3