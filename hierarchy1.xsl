<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
	xmlns="http://www.tei-c.org/ns/1.0"
	xmlns:tei="http://www.tei-c.org/ns/1.0"
	exclude-result-prefixes="tei"
>

<xsl:output method="text"/>

<xsl:template match="/">
	<xsl:apply-templates select="//tei:div1 | //tei:div2 | //tei:div3 | //tei:div4 | //tei:div5 | //tei:div6 | //tei:div7 | //tei:div8 | //tei:div9" />
</xsl:template>

<xsl:template match="tei:div1 | tei:div2 | tei:div3 | tei:div4 | tei:div5 | tei:div6 | tei:div7 | tei:div8 | tei:div9">
	<xsl:variable name="indentNr">
		<xsl:value-of select="number(substring-after(name(.), 'div'))-1" />
	</xsl:variable>
	<xsl:variable name="indent">
		<xsl:sequence select="string-join(for $i in 1 to $indentNr return '  ','')"/>
	</xsl:variable>

	<xsl:variable name="text">
		<xsl:for-each select="*|text()">
			<xsl:if test="self::text()">
				<xsl:value-of select="." />
			</xsl:if>
		</xsl:for-each>
	</xsl:variable>
	<xsl:message><xsl:value-of select="concat($indent, name(.), '=', $text)" /></xsl:message>
</xsl:template>

</xsl:stylesheet>