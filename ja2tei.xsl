<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
	xmlns:ve="http://schemas.openxmlformats.org/markup-compatibility/2006" 
	xmlns:o="urn:schemas-microsoft-com:office:office" 
	xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" 
	xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" 
	xmlns:v="urn:schemas-microsoft-com:vml" 
	xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" 
	xmlns:w10="urn:schemas-microsoft-com:office:word" 
	xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" 
	xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml"
	xmlns="http://www.tei-c.org/ns/1.0"
	exclude-result-prefixes="ve o r m v wp w w10 wne "
>
<!-- exclude-result-prefixes="ve o r m v wp w" -->
<xsl:output method="xml" indent="yes" doctype-system="http://www.tei-c.org/release/xml/tei/custom/schema/dtd/tei_all.dtd" />

<xsl:param name="footnotesdoc" />
<xsl:param name="endnotesdoc" />
<xsl:param name="numberingdoc" />

<xsl:variable name="footnotes">
	<xsl:copy-of select="document($footnotesdoc)" />
</xsl:variable>

<xsl:variable name="endnotes">
	<xsl:copy-of select="document($endnotesdoc)" />
</xsl:variable>

<!-- numbering styles -->
<xsl:variable name="numbering">
	<xsl:copy-of select="document($numberingdoc)" />
</xsl:variable>

<xsl:template match="/">
	<TEI xmlns="http://www.tei-c.org/ns/1.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://www.tei-c.org/ns/1.0 http://www.tei-c.org/release/xml/tei/custom/schema/xsd/tei_all.xsd" xml:lang="en">
		<teiHeader>
			<fileDesc>
				<titleStmt>
					<title></title>
				</titleStmt>
				<publicationStmt>
					<publisher></publisher>
				</publicationStmt>
				<sourceDesc>
					<bibl></bibl>
				</sourceDesc>
			</fileDesc>
		</teiHeader>
		<text>
			<front></front>
			<body>
				<xsl:apply-templates />
			</body>
		</text>
	</TEI>
</xsl:template>

<!-- Document Body -->
<xsl:template match="/w:document/w:body">
  <!-- 'w:sectPr': Document Final Section Properties -->
	<xsl:for-each select="*[(name(.) != 'w:p') and (name(.) != 'w:tbl') and (name(.) != 'w:sectPr')]">
		<xsl:message>Unhandled element in body: <xsl:value-of select="name(.)" /></xsl:message>
	</xsl:for-each>
	<!-- we do not handle 'w:sectPr' -->
	<xsl:for-each select="*[name(.) = 'w:p' or name(.) = 'w:tbl']">
		<xsl:apply-templates select="." />
	</xsl:for-each>
</xsl:template>

<!-- Paragraph -->
<xsl:template match="w:p">
	<xsl:choose>
		<xsl:when test="w:pPr/w:pStyle[@w:val = 'Heading1']">
			<xsl:text disable-output-escaping="yes">&lt;div0&gt;</xsl:text>
		</xsl:when>
		<xsl:when test="w:pPr/w:pStyle[@w:val = 'Heading2']">
			<xsl:text disable-output-escaping="yes">&lt;div1&gt;</xsl:text>
		</xsl:when>
		<xsl:when test="w:pPr/w:pStyle[@w:val = 'Heading3']">
			<xsl:text disable-output-escaping="yes">&lt;div2&gt;</xsl:text>
		</xsl:when>
		<xsl:when test="w:pPr/w:pStyle[@w:val = 'Heading4']">
			<xsl:text disable-output-escaping="yes">&lt;div3&gt;</xsl:text>
		</xsl:when>
		<xsl:when test="w:pPr/w:pStyle[@w:val = 'Heading5']">
			<xsl:text disable-output-escaping="yes">&lt;div4&gt;</xsl:text>
		</xsl:when>
		<xsl:when test="w:pPr/w:numPr">
			<xsl:if test="preceding-sibling::w:p[1] and not(preceding-sibling::w:p[1]/w:pPr/w:numPr)">
				<xsl:variable name="numId" select="w:pPr/w:numPr/w:numId/@w:val"/>
				<xsl:variable name="ilvl" select="w:pPr/w:numPr/w:ilvl/@w:val"/>
				<xsl:variable name="abstractNumId" select="$numbering/w:numbering/w:num[@w:numId=$numId]/w:abstractNumId/@w:val" />
				<xsl:variable name="listDef" select="$numbering/w:numbering/w:abstractNum[@w:abstractNumId=$abstractNumId]/w:lvl[@w:ilvl=$ilvl]" />
				<xsl:variable name="listChr" select="$listDef/w:lvlText/@w:val" />
				<xsl:variable name="listType" select="$listDef/w:numFmt/@w:val" />
				<xsl:variable name="listStyleType">
					<xsl:choose>
						<xsl:when test="string-to-codepoints($listChr) = 8211">none</xsl:when>
						<xsl:when test="string-to-codepoints($listChr) = 9679">disc</xsl:when>
						<xsl:when test="string-to-codepoints($listChr) = 61623">square</xsl:when>
						<xsl:otherwise>number</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>


				<!-- list type="type" rend="listChr" -->
				<xsl:text disable-output-escaping="yes">&lt;list type="</xsl:text>
				<xsl:value-of select="$listType" />
				<xsl:text disable-output-escaping="yes">" rend="</xsl:text>
				<xsl:value-of select="$listStyleType" />
				<xsl:text disable-output-escaping="yes">"&gt;&#xa;</xsl:text>

			</xsl:if>
			<xsl:text disable-output-escaping="yes">&lt;item&gt;&#xa;</xsl:text>
			<xsl:if test="w:pPr/w:pStyle">
				<xsl:text disable-output-escaping="yes">&lt;p rend="class:</xsl:text>
					<xsl:value-of select="w:pPr/w:pStyle/@w:val" />
				<xsl:text disable-output-escaping="yes">"&gt;</xsl:text>
			</xsl:if>
		</xsl:when>
		<xsl:when test="w:pPr/w:pStyle">
			<xsl:text disable-output-escaping="yes">&lt;p rend="class:</xsl:text>
				<xsl:value-of select="w:pPr/w:pStyle/@w:val" />
			<xsl:text disable-output-escaping="yes">"&gt;</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text disable-output-escaping="yes">&lt;p&gt;</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
		<xsl:for-each select="*">
			<xsl:choose>
				<xsl:when test="name(.) = 'w:pPr'"><xsl:apply-templates select="." /></xsl:when>
				<xsl:when test="name(.) = 'w:bookmarkStart'"></xsl:when>
				<xsl:when test="name(.) = 'w:bookmarkEnd'"></xsl:when>
				<xsl:when test="name(.) = 'w:hyperlink'"><xsl:apply-templates select="." /></xsl:when>
				<xsl:when test="name(.) = 'w:smartTag'"><xsl:apply-templates select="." /></xsl:when><!-- ezekből ki kell venni a szöveget! -->
				<xsl:when test="name(.) = 'w:r'"><xsl:apply-templates select="." /></xsl:when><!-- ez a fontos ág! -->
				<xsl:otherwise>
					<!-- xsl:copy-of select="." /-->
					<xsl:message>Unhandled element in w:p: <xsl:value-of select="name(.)" /></xsl:message>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	<xsl:choose>
		<xsl:when test="w:pPr/w:pStyle[@w:val = 'Heading1']">
			<xsl:text disable-output-escaping="yes">&lt;/div0&gt;&#xa;</xsl:text>
		</xsl:when>
		<xsl:when test="w:pPr/w:pStyle[@w:val = 'Heading2']">
			<xsl:text disable-output-escaping="yes">&lt;/div1&gt;&#xa;</xsl:text>
		</xsl:when>
		<xsl:when test="w:pPr/w:pStyle[@w:val = 'Heading3']">
			<xsl:text disable-output-escaping="yes">&lt;/div2&gt;&#xa;</xsl:text>
		</xsl:when>
		<xsl:when test="w:pPr/w:pStyle[@w:val = 'Heading4']">
			<xsl:text disable-output-escaping="yes">&lt;/div3&gt;&#xa;</xsl:text>
		</xsl:when>
		<xsl:when test="w:pPr/w:pStyle[@w:val = 'Heading5']">
			<xsl:text disable-output-escaping="yes">&lt;/div4&gt;&#xa;</xsl:text>
		</xsl:when>
		<xsl:when test="w:pPr/w:numPr">
			<xsl:text disable-output-escaping="yes">&lt;/p&gt;&#xa;</xsl:text>
			<xsl:text disable-output-escaping="yes">&lt;/item&gt;</xsl:text>
			<xsl:if test="following-sibling::w:p[1] and not(following-sibling::w:p[1]/w:pPr/w:numPr)">
				<xsl:text disable-output-escaping="yes">&lt;/list&gt;&#xa;</xsl:text>
			</xsl:if>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text disable-output-escaping="yes">&lt;/p&gt;&#xa;</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="w:pPr">
	<xsl:for-each select="*">
		<xsl:choose>
			<xsl:when test="name(.) = 'w:pStyle'"><xsl:apply-templates select="." /></xsl:when>
			<xsl:when test="name(.) = 'w:rPr'"></xsl:when>
			<xsl:when test="name(.) = 'w:spacing'"></xsl:when>
			<xsl:when test="name(.) = 'w:ind'"></xsl:when>
			<xsl:when test="name(.) = 'w:tabs'"></xsl:when>
			<xsl:when test="name(.) = 'w:jc'"></xsl:when>
			<xsl:when test="name(.) = 'w:pageBreakBefore'"></xsl:when>
			<xsl:when test="name(.) = 'w:textAlignment'"></xsl:when>
			<xsl:when test="name(.) = 'w:numPr'"></xsl:when>
			<xsl:when test="name(.) = 'w:autoSpaceDE'"></xsl:when>
			<xsl:otherwise>
				<!-- xsl:copy-of select="." /-->
				<xsl:message>Unhandled element in w:pPr: <xsl:value-of select="name(.)" /></xsl:message>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:for-each>
</xsl:template>

<xsl:template match="w:pStyle">
	<xsl:for-each select="@*">
		<xsl:choose>
			<xsl:when test="name(.) = 'w:val'"></xsl:when>
			<xsl:otherwise>
				<!-- xsl:copy-of select="." /-->
				<xsl:message>Unhandled attribute in w:pStyle: <xsl:value-of select="name(.)" /></xsl:message>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:for-each>
	<xsl:for-each select="*">
		<xsl:choose>
			<xsl:when test="name(.) = 'dummy'"></xsl:when>
			<xsl:otherwise>
				<!-- xsl:copy-of select="." /-->
				<xsl:message>Unhandled element in w:pPr: <xsl:value-of select="name(.)" /></xsl:message>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:for-each>
</xsl:template>

<xsl:template match="w:smartTag">
	<xsl:for-each select="*">
		<xsl:choose>
			<xsl:when test="name(.) = 'w:smartTagPr'"></xsl:when>
			<xsl:when test="name(.) = 'w:r'"><xsl:apply-templates select="." /></xsl:when><!-- ez a fontos ág! -->
			<xsl:otherwise>
				<!-- xsl:copy-of select="." /-->
				<xsl:message>Unhandled element in w:smartTag: <xsl:value-of select="name(.)" /></xsl:message>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:for-each>
</xsl:template>

<!-- Text Run -->
<xsl:template match="w:r">
	<xsl:for-each select="@*">
		<xsl:choose>
		  <!-- Revision Identifier for Run Properties -->
			<xsl:when test="name(.) = 'w:rsidRPr'"></xsl:when>

			<!-- Revision Identifier for Run -->
			<xsl:when test="name(.) = 'w:rsidR'"></xsl:when>

			<!-- Revision Identifier for Run Deletion -->
			<xsl:when test="name(.) = 'w:rsidDel'"></xsl:when>
			
			<!-- Unhandled attributes -->
			<xsl:otherwise>
				<!-- xsl:copy-of select="." /-->
				<xsl:message>Unhandled attribute in w:r: <xsl:value-of select="name(.)" /></xsl:message>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:for-each>

	<!-- <seg/> -->
	<xsl:if test="w:rPr/w:rStyle and w:rPr/w:rStyle/@w:val != 'FootnoteReference'">
		<xsl:text disable-output-escaping="yes">&lt;seg type="</xsl:text>
			<xsl:value-of select="w:rPr/w:rStyle/@w:val" />
		<xsl:text disable-output-escaping="yes">"&gt;</xsl:text>
	</xsl:if>

	<xsl:if test="w:rPr/w:u">
		<xsl:text disable-output-escaping="yes">&lt;hi rend="underline"&gt;</xsl:text>
	</xsl:if>

	<xsl:if test="w:rPr/w:b">
		<xsl:text disable-output-escaping="yes">&lt;hi rend="bold"&gt;</xsl:text>
	</xsl:if>

	<xsl:if test="w:t and w:rPr/w:i">
		<xsl:text disable-output-escaping="yes">&lt;hi rend="italics"&gt;</xsl:text>
	</xsl:if>

	<xsl:if test="w:t and w:rPr/w:vertAlign[@w:val = 'superscript']">
		<xsl:text disable-output-escaping="yes">&lt;hi rend="sup"&gt;</xsl:text>
	</xsl:if>

	<xsl:if test="w:t and w:rPr/w:vertAlign[@w:val = 'subscript']">
		<xsl:text disable-output-escaping="yes">&lt;hi rend="sub"&gt;</xsl:text>
	</xsl:if>

	<xsl:for-each select="*">
		<xsl:choose>
			<xsl:when test="name(.) = 'w:rPr'"><xsl:apply-templates select="." /></xsl:when>
			<xsl:when test="name(.) = 'w:tab'"></xsl:when>
			<xsl:when test="name(.) = 'w:br'"></xsl:when>
			<xsl:when test="name(.) = 'w:softHyphen'"></xsl:when>
			<xsl:when test="name(.) = 'w:fldChar'"></xsl:when>
			<xsl:when test="name(.) = 'w:instrText'"></xsl:when>
			<xsl:when test="name(.) = 'w:lastRenderedPageBreak'"></xsl:when>
			<xsl:when test="name(.) = 'w:footnoteReference'"><xsl:apply-templates select="." /></xsl:when>
			<xsl:when test="name(.) = 'w:footnoteRef'"><seg rend="class:footnoteRef" n="{../../parent::w:footnote/@w:id}">[<xsl:value-of select="../../parent::w:footnote/@w:id" />]</seg></xsl:when>
			<xsl:when test="name(.) = 'w:t'">
				<xsl:choose>
					<xsl:when test="name(preceding-sibling::*[1]) = 'w:rPr' and preceding-sibling::w:rPr/w:rStyle/@w:val ='FootnoteReference'">
						<seg rend="class:footnoteRef" n="{../../parent::w:footnote/@w:id}">[<xsl:apply-templates select="." />]</seg>
					</xsl:when>
					<xsl:otherwise>	
						<xsl:apply-templates select="." />
					</xsl:otherwise>	
				</xsl:choose>
			</xsl:when><!-- ez a fontos ág! -->
			<xsl:otherwise>
				<!-- xsl:copy-of select="." /-->
				<xsl:message>Unhandled element in w:r: <xsl:value-of select="name(.)" /></xsl:message>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:for-each>
	<xsl:if test="w:t and w:rPr/w:vertAlign[@w:val = 'subscript']">
		<xsl:text disable-output-escaping="yes">&lt;/hi&gt;</xsl:text>
	</xsl:if>
	<xsl:if test="w:t and w:rPr/w:vertAlign[@w:val = 'superscript']">
		<xsl:text disable-output-escaping="yes">&lt;/hi&gt;</xsl:text>
	</xsl:if>
	<xsl:if test="w:t and w:rPr/w:i">
		<xsl:text disable-output-escaping="yes">&lt;/hi&gt;</xsl:text>
	</xsl:if>
	<xsl:if test="w:rPr/w:b">
		<xsl:text disable-output-escaping="yes">&lt;/hi&gt;</xsl:text>
	</xsl:if>
	<xsl:if test="w:rPr/w:u">
		<xsl:text disable-output-escaping="yes">&lt;/hi&gt;</xsl:text>
	</xsl:if>
	<xsl:if test="w:rPr/w:rStyle and w:rPr/w:rStyle/@w:val != 'FootnoteReference'">
		<xsl:text disable-output-escaping="yes">&lt;/seg&gt;</xsl:text>
	</xsl:if>
</xsl:template>

<xsl:template match="w:rPr">
	<xsl:for-each select="*">
		<xsl:choose>
			<xsl:when test="name(.) = 'w:b'"><xsl:apply-templates select="." /></xsl:when>
			<xsl:when test="name(.) = 'w:bCs'"><xsl:apply-templates select="." /></xsl:when>
			<xsl:when test="name(.) = 'w:i'"><xsl:apply-templates select="." /></xsl:when>
			<xsl:when test="name(.) = 'w:iCs'"><xsl:apply-templates select="." /></xsl:when>
			<xsl:when test="name(.) = 'w:rFonts'"></xsl:when>
			<xsl:when test="name(.) = 'w:rStyle'"><xsl:apply-templates select="." /></xsl:when>
			<xsl:when test="name(.) = 'w:spacing'"></xsl:when>
			<xsl:when test="name(.) = 'w:sz'"></xsl:when>
			<xsl:when test="name(.) = 'w:szCs'"></xsl:when>
			<xsl:when test="name(.) = 'w:u'"><xsl:apply-templates select="." /></xsl:when>
			<xsl:when test="name(.) = 'w:vertAlign'"><xsl:apply-templates select="." /></xsl:when>
			<xsl:when test="name(.) = 'w:lang'"></xsl:when>
			<xsl:when test="name(.) = 'w:color'"></xsl:when>
			<xsl:when test="name(.) = 'dummy'"></xsl:when>
			<xsl:otherwise>
				<!-- xsl:copy-of select="." /-->
				<xsl:message>Unhandled element in w:rPr: <xsl:value-of select="name(.)" /></xsl:message>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:for-each>
</xsl:template>

<xsl:template match="w:b | w:bCs | w:i | w:iCs | w:u">
	<xsl:variable name="element" select="name(.)" />
	<xsl:for-each select="@*">
		<xsl:choose>
			<xsl:when test="name(.) = 'w:val'"></xsl:when>
			<xsl:otherwise>
				<!-- xsl:copy-of select="." /-->
				<xsl:message>Unhandled attribute in <xsl:value-of select="$element" />: <xsl:value-of select="name(.)" /></xsl:message>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:for-each>
	<xsl:for-each select="*">
		<xsl:message>Unhandled element in <xsl:value-of select="$element" />: <xsl:value-of select="name(.)" /></xsl:message>
	</xsl:for-each>
</xsl:template>

<xsl:template match="w:footnoteReference">
	<xsl:variable name="id">
		<xsl:value-of select="@w:id" />
	</xsl:variable>
	
	<xsl:variable name="mark">
		<xsl:choose>
			<xsl:when test="@w:customMarkFollows">
				<xsl:value-of select="following-sibling::w:t" />
			</xsl:when>
			<xsl:otherwise><xsl:value-of select="$id" /></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:for-each select="@*">
		<xsl:choose>
			<xsl:when test="name(.) = 'w:id'"></xsl:when>
			<xsl:when test="name(.) = 'w:customMarkFollows'"></xsl:when>
			<xsl:otherwise>
				<!-- xsl:copy-of select="." /-->
				<xsl:message>Unhandled attribute in w:footnoteReference: <xsl:value-of select="name(.)" /></xsl:message>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:for-each>

	<!-- note n="{$id}" mark="{$mark}" -->
	<note>
		<xsl:apply-templates select="$footnotes/w:footnotes[1]/w:footnote[@w:id = $id]/w:p" />
	</note>

	<!-- if there are more elements, that a fault -->
	<xsl:for-each select="*">
		<xsl:message>Unhandled element in w:footnoteReference: <xsl:value-of select="name(.)" /></xsl:message>
	</xsl:for-each>
</xsl:template>

<xsl:template match="w:t">
	<xsl:for-each select="@*">
		<xsl:choose>
			<xsl:when test="name(.) = 'xml:space'"></xsl:when>
			<xsl:otherwise>
				<!-- xsl:copy-of select="." /-->
				<xsl:message>Unhandled attribute in w:t: <xsl:value-of select="name(.)" /> '<xsl:value-of select="." />'</xsl:message>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:for-each>
	<xsl:value-of select="." />
	<xsl:for-each select="*">
		<xsl:message>Unhandled element in w:t: <xsl:value-of select="name(.)" /></xsl:message>
	</xsl:for-each>
</xsl:template>

<xsl:template match="w:rStyle">
	<xsl:for-each select="@*">
		<xsl:choose>
			<xsl:when test="name(.) = 'w:val' and . = 'FootnoteReference'"></xsl:when>
			<xsl:when test="name(.) = 'w:val' and . = 'abstractpagetext1'"></xsl:when>
			<xsl:when test="name(.) = 'w:val' and . = 'nv-teljes'"></xsl:when>
			<xsl:otherwise>
				<!-- xsl:copy-of select="." /-->
				<xsl:message>Unhandled attribute in w:rStyle: <xsl:value-of select="name(.)" />="<xsl:value-of select="." />"</xsl:message>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:for-each>
	<xsl:for-each select="*">
		<xsl:message>Unhandled element in w:rStyle: <xsl:value-of select="name(.)" /></xsl:message>
	</xsl:for-each>
</xsl:template>

<xsl:template match="w:vertAlign">
	<xsl:for-each select="@*">
		<xsl:choose>
			<xsl:when test="name(.) = 'w:val' and . = 'superscript'"></xsl:when>
			<xsl:when test="name(.) = 'w:val' and . = 'subscript'"></xsl:when>
			<xsl:otherwise>
				<!-- xsl:copy-of select="." /-->
				<xsl:message>Unhandled attribute in w:vertAlign: <xsl:value-of select="name(.)" />="<xsl:value-of select="." />"</xsl:message>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:for-each>
	<xsl:for-each select="*">
		<xsl:message>Unhandled element in w:vertAlign: <xsl:value-of select="name(.)" /></xsl:message>
	</xsl:for-each>
</xsl:template>

<!-- Optional Hyphen Character -->
<xsl:template match="w:softHyphen">
	<xsl:text>¬</xsl:text>
</xsl:template>

<!-- Hyperlink -->
<xsl:template match="w:hyperlink">
  <!-- w:r/w:t: Text Run/Text -->
	<link><xsl:value-of select="w:r/w:t" /></link>
</xsl:template>

<!-- Table -->
<xsl:template match="w:tbl">
	<table>
	<xsl:for-each select="*">
		<xsl:choose>
			<!-- handle rows -->
			<xsl:when test="name(.) = 'w:tr'"><xsl:apply-templates select="." /></xsl:when>
			<!-- we do not handle these currently -->
			<xsl:when test="name(.) = 'w:tblPr'"></xsl:when>
			<xsl:when test="name(.) = 'w:tblGrid'"></xsl:when>
			<xsl:otherwise>
				<!-- xsl:copy-of select="." /-->
				<xsl:message>Unhandled child in w:tbl: <xsl:value-of select="name(.)" /></xsl:message>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:for-each>
	</table>
</xsl:template>

<xsl:template match="w:tr">
	<row>
	<xsl:for-each select="*">
		<xsl:choose>
			<!-- handle rows -->
			<xsl:when test="name(.) = 'w:tc'"><xsl:apply-templates select="." /></xsl:when>
			<!-- we do not handle these currently -->
			<xsl:when test="name(.) = 'w:tblPrEx'"></xsl:when>
			<xsl:otherwise>
				<xsl:message>Unhandled child in w:tr: <xsl:value-of select="name(.)" /></xsl:message>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:for-each>
	</row>
</xsl:template>

<xsl:template match="w:tc">
	<cell>
	<xsl:for-each select="*">
		<xsl:choose>
			<!-- handle rows -->
			<xsl:when test="name(.) = 'w:p'">
				<xsl:for-each select="./*">
				 <xsl:apply-templates select="." />
				</xsl:for-each>
			</xsl:when>
			<!-- we do not handle these currently -->
			<xsl:when test="name(.) = 'w:tcPr'"></xsl:when>
			<xsl:otherwise>
				<xsl:message>Unhandled child in w:tc: <xsl:value-of select="name(.)" /></xsl:message>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:for-each>
	</cell>
</xsl:template>

<!-- **********************************************************************
 Swallow unmatched elements
     ********************************************************************** -->
<!--xsl:template match="@*|node()"/>
	<xsl:apply-templates select="kml/Placemark/description" /-->
</xsl:stylesheet>

