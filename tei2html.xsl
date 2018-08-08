<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	version="2.0"
	xmlns:tei="http://www.tei-c.org/ns/1.0"
	xmlns:html="http://www.w3.org/1999/xhtml" 
	extension-element-prefixes="html tei" 
	exclude-result-prefixes="html tei" 
>

<xsl:output method="html" indent="yes" name="html"/>
<xsl:param name="distincttoc" />

<xsl:template match="/">
	<!-- generating TOC -->
	<xsl:result-document href="toc.html" format="html">
		<html>
		<xsl:call-template name="htmlhead" />
		<body>
			<div id="body">
				<xsl:call-template name="menu" />
				<div id="toc">
					<h3>Tartalomjegyzék</h3>
					<ul>
						<xsl:for-each select="tei:TEI[1]/tei:text[1]/tei:body[1]/tei:div1">
							<xsl:call-template name="toc">
								<xsl:with-param name="content" select="." />
							</xsl:call-template>
						</xsl:for-each>
						<li><a href="textus.html#notes">Jegyzetek</a></li>
					</ul>
				</div>
			</div>
		</body>
		</html>
	</xsl:result-document>

	<!-- generating TEXTUS -->
	<xsl:for-each select="./tei:TEI[1]/tei:text[1]/tei:body[1]/tei:div1">
		<xsl:variable name="counter" select="count(preceding-sibling::*) + 1" />
		<xsl:variable name="filename">
			<xsl:text>textus-</xsl:text>
			<xsl:if test="$counter &lt; 10">0</xsl:if>
			<xsl:value-of select="$counter" />
			<xsl:text>.html</xsl:text>
		</xsl:variable>

		<xsl:message><xsl:value-of select="$filename" /> - <xsl:value-of select="tei:head" /></xsl:message>
	
		<xsl:result-document href="{$filename}" format="html">
			<html>
			<xsl:call-template name="htmlhead" />
			<body>
				<div id="body">
					<xsl:call-template name="menu" />
		
					<div id="content">
						<xsl:apply-templates select="." />
					</div>
	
					<div id="notes">
						<h3>Jegyzetek</h3>
						<xsl:for-each select=".//tei:note | .//tei:app">
							<xsl:choose>
								<xsl:when test="name(.) = 'note'">
									<xsl:call-template name="note">
										<xsl:with-param name="content" select="." />
									</xsl:call-template>
								</xsl:when>
								<xsl:when test="name(.) = 'app'">
									<xsl:apply-templates select="." mode="node-list" />
								</xsl:when>
							</xsl:choose>
						</xsl:for-each>
					</div>
		
					<div id="floating-note">
						<div class="header">jegyzet <div class="type"></div></div>
						<div class="content"></div>
					</div>
				</div>
			</body>
			</html>
		</xsl:result-document>
	</xsl:for-each>
</xsl:template>

<xsl:template name="htmlhead">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<title>József Attila Összes tanulmánya és cikke. Szövegek, 1930–1937</title>
		<meta name="author" content="József Attila"/>
		<meta name="contributor" content="Horváth Iván, Fuchs Anna"/>
		<meta name="dc.title" content="József Attila Összes tanulmánya és cikke. Szövegek, 1930–1937"/>
		<meta name="dc.type" content="Text"/>
		<meta name="dc.format" content="text/html"/>
		<link rel="stylesheet" type="text/css" media="all" href="ja.css" />
		<script src="jquery-1.7.1.min.js"></script>
		<script src="ja.js"></script>
	</head>
</xsl:template>

<xsl:template name="menu">
	<div id="menu">
		<ul>
			<li><a href="toc.html">Szövegek, 1930–1937</a></li>
			<li><a href="index.html">Nyitólap</a></li>
			<li><a href="kiadasunkrol.html">Kiadásunkról</a></li>
			<li><a href="sugo.html">Súgó</a></li>
			<li><a href="koszonetmondas.html">Köszönetnyilvánítás</a></li>
			<li><a href="nevjegy.html">Névjegy</a></li>
			<li><a href="szerzoijogi.html">Szerzői jogi nyilatkozat</a></li>
			<li><a href="magyarazatok.html">Magyarázatok</a></li>
			<li><a href="vita.html">Vita</a></li>
			<li><a href="http://magyar-irodalom.elte.hu/ja/tartalom.htm" target="_blank">Szövegek, 1923–1930</a></li>
		</ul>
	</div>
</xsl:template>

<xsl:template name="toc">
	<xsl:param name="content" />
	
	<xsl:variable name="counter">
		<xsl:choose>
			<xsl:when test="name($content) = 'div1'">
				<xsl:value-of select="count($content/preceding-sibling::tei:div1) + 1" />
			</xsl:when>
			<xsl:when test="name($content) = 'div2'">
				<xsl:value-of select="count($content/parent::tei:div1/preceding-sibling::tei:div1) + 1" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:message><xsl:value-of select="name($content)" /></xsl:message>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="filename">
		<xsl:text>textus-</xsl:text>
		<xsl:if test="$counter &lt; 10">0</xsl:if>
		<xsl:value-of select="$counter" />
		<xsl:text>.html</xsl:text>
	</xsl:variable>

	<li>
		<a href="{$filename}#{$content/generate-id()}">
			<xsl:for-each select="$content/tei:head/child::node()">
				<xsl:variable name="type">
					<xsl:apply-templates mode="type" select="."/>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="$type = 'element'">
						
						<xsl:choose>
							<xsl:when test="name(.) = 'hi'">
								<xsl:value-of select="./text()" />
							</xsl:when>
							<xsl:when test="name(.) = 'app'">
								<xsl:value-of select="./tei:rdg[last()]/text()" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:message>IN HEAD name: '<xsl:value-of select="name(.)" />'</xsl:message>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="$type = 'text'">
						<xsl:value-of select="." />
					</xsl:when>
					<xsl:otherwise></xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</a>
		<xsl:if test="count($content/child::*[starts-with(name(), 'div') and number(substring(name(), 4)) &lt; 3]) > 0">
			<ul>
				<xsl:for-each select="$content/child::*[
						starts-with(name(), 'div')
						and number(substring(name(), 4)) &lt; 3
						]">
					<xsl:call-template name="toc">
						<xsl:with-param name="content" select="." />
					</xsl:call-template>
				</xsl:for-each>
			</ul>
		</xsl:if>
	</li>
</xsl:template>

<xsl:template match="tei:div1 | tei:div2 | tei:div3 | tei:div4 | tei:div5 | tei:div6 | tei:div7">
	
	<xsl:variable name="heading" select="concat('h', substring-after(name(.), 'div'))" />
	<xsl:element name="{$heading}">
		<xsl:attribute name="id" select="generate-id()" />
		<xsl:apply-templates select="tei:head" />
	</xsl:element>

	<xsl:for-each select="*">
		<xsl:choose>
			<xsl:when test="name(.) = 'div1' or name(.) = 'div2' or name(.) = 'div3' or name(.) = 'div4' or name(.) = 'div5' or name(.) = 'div6'">
				<xsl:apply-templates select="." />
			</xsl:when>
			<xsl:when test="name(.) = 'head'"></xsl:when>
			<xsl:when test="name(.) = 'p'">
				<xsl:apply-templates select="." />
			</xsl:when>
			<xsl:when test="name(.) = 'table'">
				<xsl:apply-templates select="." />
			</xsl:when>
			<xsl:when test="name(.) = 'list'">
				<xsl:apply-templates select="." />
			</xsl:when>
			<xsl:otherwise>
				<xsl:message>name: div/<xsl:value-of select="name(.)" /></xsl:message>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:for-each>
</xsl:template>

<xsl:template match="tei:head">
	<xsl:apply-templates />
</xsl:template>

<xsl:template match="tei:p">
	<xsl:variable name="locus">
		<xsl:choose>
			<xsl:when test="parent::tei:div3[tei:head/text() = 'Kosztolányi Dezső Beszélgetőlapjai (forráskiadás)']">
				<xsl:text>1</xsl:text>
			</xsl:when>
			<xsl:when test="parent::tei:div4[tei:head/text() = 'Tárgyi és szómagyarázó jegyzetek']">
				<xsl:text>2</xsl:text>
			</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="collection">
		<xsl:choose>
			<xsl:when test="tei:hi[@rend = 'bold'] and 
			  (tei:hi/text() = 'MTAK' or tei:hi/text() = 'PIM' or tei:hi/text() = 'OSZK')">
				<xsl:text>1</xsl:text>
			</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="jelzet">
		<xsl:choose>
			<xsl:when test="tei:hi[@rend = 'bold'] and 
			  (preceding-sibling::*[1][self::tei:p]/tei:hi/text() = 'MTAK' 
			   or preceding-sibling::*[1][self::tei:p]/tei:hi/text() = 'PIM' 
			   or preceding-sibling::*[1][self::tei:p]/tei:hi/text() = 'OSZK')">
				<xsl:text>1</xsl:text>
			</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="verzo">
		<xsl:choose>
			<xsl:when test="$locus = 1 and tei:hi[@rend = 'bold'] and tei:hi/text() = '[verzó]'">
				<xsl:text>1</xsl:text>
			</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="image">
		<xsl:choose>
			<xsl:when test="$locus = 1 and tei:ref[@rend ='img']">
				<xsl:text>1</xsl:text>
			</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:if test="$collection = 1 and $locus = 1 and preceding-sibling::*[1][self::tei:p]">
		<xsl:text disable-output-escaping="yes">&lt;/td&gt;&lt;/tr&gt;&lt;/table&gt;</xsl:text>
	</xsl:if>

	<xsl:if test="$verzo = 1">
		<xsl:text disable-output-escaping="yes">&lt;/td&gt;&lt;/tr&gt;&lt;tr valign="top"&gt;&lt;td colspan="2"&gt;</xsl:text>
	</xsl:if>

	<xsl:if test="$image = 1">
		<xsl:text disable-output-escaping="yes">&lt;td&gt;</xsl:text>
	</xsl:if>

	<p>
		<xsl:for-each select="./@*">
			<xsl:choose>
				<xsl:when test="name(.) = 'rend' and substring(., 1, 6) = 'class:'">
					<xsl:attribute name="class">
						<xsl:value-of select="substring(., 7)" />
					</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:message>name: p@<xsl:value-of select="name(.)" /> - <xsl:value-of select="substring(., 1, 6)" /></xsl:message>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>

		<xsl:if test="$locus = 1 and $collection = 1">
			<xsl:attribute name="class">
				<xsl:value-of select="'foszoveg'" />
			</xsl:attribute>
		</xsl:if>
		
		<xsl:choose>
			<!-- jelzet! -->
			<xsl:when test="preceding-sibling::*[1][self::tei:p]/tei:hi/text() = 'MTAK' 
			               or preceding-sibling::*[1][self::tei:p]/tei:hi/text() = 'PIM' 
			               or preceding-sibling::*[1][self::tei:p]/tei:hi/text() = 'OSZK'">
				<xsl:variable name="linkPart" select="replace(replace(replace(./tei:hi/text(), ' ', '_'), '/', '_'), '\.', '_')" />

				<xsl:if test="parent::tei:div4[tei:head/text() = 'Tárgyi és szómagyarázó jegyzetek']">
					<xsl:attribute name="id">
						<xsl:value-of select="concat('targyijegyzet-', $linkPart)" />
					</xsl:attribute>
				</xsl:if>
				<xsl:if test="parent::tei:div3[tei:head/text() = 'Kosztolányi Dezső Beszélgetőlapjai (forráskiadás)']">
					<xsl:attribute name="id">
						<xsl:value-of select="concat('foszoveg-', $linkPart)" />
					</xsl:attribute>
				</xsl:if>
				
				<xsl:variable name="link">
					<xsl:if test="parent::tei:div3[tei:head/text() = 'Kosztolányi Dezső Beszélgetőlapjai (forráskiadás)']">
						<xsl:value-of select="concat('#targyijegyzet-', $linkPart)"/>
					</xsl:if>
					<xsl:if test="parent::tei:div4[tei:head/text() = 'Tárgyi és szómagyarázó jegyzetek']">
						<xsl:value-of select="concat('#foszoveg-', $linkPart)"/>
					</xsl:if>
				</xsl:variable>

				<a href="{$link}">
					<xsl:apply-templates />
				</a>
				
			</xsl:when>
			
			<!-- a beszélgetőlap és a verzójánál legyen egy clear:both -->
			<xsl:when test="(tei:hi/text() = 'MTAK' or tei:hi/text() = 'PIM' or tei:hi/text() = 'OSZK' 
			                 or tei:hi/text() = '[verzó]') 
			                 and parent::tei:div3[tei:head/text() = 
			                 		'Kosztolányi Dezső Beszélgetőlapjai (forráskiadás)']">
				<xsl:attribute name="style">
					<xsl:text>clear:both;</xsl:text>
				</xsl:attribute>
				<xsl:apply-templates />
			</xsl:when>

			<xsl:otherwise>
				<xsl:if test="count(*|text()) = 0">
					<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
				</xsl:if>
				<xsl:apply-templates />
			</xsl:otherwise>
		</xsl:choose>
	</p>
	
	<xsl:if test="$locus = 1 and $jelzet = 1">
		<xsl:text disable-output-escaping="yes">&lt;table&gt;&lt;tr valign="top"&gt;</xsl:text>
	</xsl:if>

	<xsl:if test="$verzo = 1">
		<xsl:text disable-output-escaping="yes">&lt;/td&gt;&lt;/tr&gt;&lt;tr valign="top"&gt;</xsl:text>
	</xsl:if>
	
	<xsl:if test="$image = 1">
		<xsl:text disable-output-escaping="yes">&lt;/td&gt;&lt;td&gt;</xsl:text>
	</xsl:if>

</xsl:template>

<xsl:template match="tei:note">
	<a>
		<xsl:attribute name="class" select="'note'" />
		<xsl:attribute name="name" select="concat('text', @n)" />
		<xsl:attribute name="href" select="concat('#note', @n)" />
		<xsl:text>[</xsl:text>
		<xsl:value-of select="@n" />
		<xsl:text>]</xsl:text>
	</a>
</xsl:template>

<xsl:template name="note">
	<xsl:param name="content" />

	<div class="note"><p>
		<xsl:attribute name="id" select="concat('note', @n)" />
		<a>
			<xsl:attribute name="class" select="'note'" />
			<xsl:attribute name="name" select="concat('note', @n)" />
			<xsl:attribute name="href" select="concat('#text', @n)" />
			<xsl:text>[</xsl:text>
			<xsl:value-of select="@n" />
			<xsl:text>]</xsl:text>
		</a>
		<xsl:text> </xsl:text>
		<xsl:apply-templates select="$content/node()" />
	</p></div>
</xsl:template>

<xsl:template match="tei:hi">
	<xsl:variable name="elementName">
		<xsl:choose>
			<xsl:when test="@rend and @rend = 'bold'">strong</xsl:when>
			<xsl:when test="@rend and @rend = 'italics'">em</xsl:when>
			<xsl:when test="@rend and @rend = 'underline'">u</xsl:when>
			<xsl:when test="@rend and @rend = 'sub'">sub</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="./@*">
					<xsl:message>name: hi@<xsl:value-of select="name(.)" /> - <xsl:value-of select="concat(., ' .. ', ../text())" /></xsl:message>
				</xsl:for-each>
				<xsl:value-of select="name(.)" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:element name="{$elementName}">
		<xsl:apply-templates />
	</xsl:element>
</xsl:template>

<xsl:template match="tei:ref">
	<xsl:choose>
		<xsl:when test="@rend and @rend = 'img'">
			<a>
				<xsl:attribute name="class" select="'external'" />
				<xsl:attribute name="href" select="concat(@target, '.png')" />
				<xsl:if test="not(starts-with(@target, 'http://'))">
					<xsl:attribute name="style" select="'display: block; text-align: center; margin: 10px auto;'" />
					<xsl:attribute name="align" select="'center'" />
				</xsl:if>
				<img>
					<xsl:if test="starts-with(@target, 'http://')">
						<xsl:attribute name="align" select="'left'" />
						<xsl:attribute name="style" select="'border: 5px solid #ccc;'" />
					</xsl:if>
					<xsl:attribute name="border" select="'0'" />
					<xsl:for-each select="tokenize(@target, '/')">
						<xsl:if test="position() = last()">
							<xsl:attribute name="src" select="concat('img/small/', ., '.png')" />
						</xsl:if>
					</xsl:for-each>
				</img>
			</a>
		</xsl:when>
		<xsl:otherwise>
			<a>
				<xsl:attribute name="class" select="external" />
				<xsl:attribute name="href" select="@target" />
				<xsl:apply-templates />
			</a>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="tei:app">
	<xsl:element name="span">
		<xsl:attribute name="class" select="concat('app', ' ', @type)" />
		<xsl:attribute name="id" select="concat('note-ref-', @n)" />
		<xsl:attribute name="onclick" select="concat('display_note(', @n, ');')" />
		<xsl:choose>
			<xsl:when test="count(tei:rdg[position() = last()]/node()) = 0">
				<xsl:text>[</xsl:text>
				<xsl:value-of select="@n" />
				<xsl:text>]</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="tei:rdg[position() = last()]">
					<xsl:apply-templates />
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:element>
</xsl:template>

<xsl:template match="tei:app" mode="node-list">
	<div class="app">
		<xsl:attribute name="class" select="concat('app', ' ', @type)" />
		<xsl:attribute name="id" select="concat('note-', @n)" />
		<p>
			<a>
				<xsl:attribute name="href" select="concat('#note-ref-', @n)" />
				<xsl:attribute name="class" select="'backref'" />
				<xsl:text>[</xsl:text>
				<xsl:value-of select="@n" />
				<xsl:text>]</xsl:text>
			</a>
			<span class="type">
				<xsl:value-of select="@type" />
			</span>
		</p>
		<div class="content">
			<xsl:for-each select="tei:rdg">
				<xsl:choose>
					<!-- or ../@type = 'qqq2' -->
					<xsl:when test="(../@type = 'qqq1'
					              or ../@type = 'qqqf') 
					             and (position() = last())">
					</xsl:when>
					<xsl:otherwise>
						<p>
							<xsl:if test="@type">
								<xsl:value-of select="@type" />
							</xsl:if>
							<xsl:if test="@hand and @hand != ''">
								<sub><xsl:value-of select="@hand" /></sub>
							</xsl:if>
							<xsl:text> </xsl:text>
							<xsl:apply-templates />
						</p>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</div><!-- /content -->
	</div>
</xsl:template>

<xsl:template match="tei:seg">
	<span class="{@type}">
		<xsl:apply-templates />
	</span>
</xsl:template>

<xsl:template match="tei:table">
	<table>
		<xsl:for-each select="*">
			<xsl:choose>
				<xsl:when test="name(.) = 'row'"><xsl:apply-templates select="." /></xsl:when>
				<xsl:otherwise>
					<xsl:message>name: table/<xsl:value-of select="name(.)" /></xsl:message>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</table>
</xsl:template>

<xsl:template match="tei:row">
	<tr valign="top">
		<xsl:for-each select="*">
			<xsl:choose>
				<xsl:when test="name(.) = 'cell'"><xsl:apply-templates select="." /></xsl:when>
				<xsl:otherwise>
					<xsl:message>name: row/<xsl:value-of select="name(.)" /></xsl:message>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</tr>
</xsl:template>

<xsl:template match="tei:cell">
	<td width="50%">
		<xsl:apply-templates select="*|text()" />
	</td>
</xsl:template>

<xsl:template match="tei:list">
	<xsl:variable name="el">
		<xsl:choose>
			<xsl:when test="@type = 'decimal'">ol</xsl:when>
			<xsl:otherwise>ul</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:element name="{$el}">
		<xsl:if test="$el = 'ul'">
			<xsl:attribute name="style">
				<xsl:text>list-style-type:</xsl:text>
				<xsl:value-of select="@rend" />
			</xsl:attribute>
		</xsl:if>

		<xsl:for-each select="*">
			<xsl:choose>
				<xsl:when test="name(.) = 'item'"><xsl:apply-templates select="." /></xsl:when>
				<xsl:otherwise>
					<xsl:message>name: list/<xsl:value-of select="name(.)" /></xsl:message>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:element>
</xsl:template>

<xsl:template match="tei:item">
	<li>
		<xsl:apply-templates select="*|text()" />
	</li>
</xsl:template>

<xsl:template match="*">
	<xsl:message>Unhandled name: *<xsl:value-of select="name(.)" /></xsl:message>
	<xsl:apply-templates />
</xsl:template>

<xsl:template match="*" mode="type">
	<xsl:text>element</xsl:text>
</xsl:template>

<xsl:template match="text()" mode="type">
	<xsl:text>text</xsl:text>
</xsl:template>

<xsl:template match="comment()" mode="type">
	<xsl:text>comment</xsl:text>
</xsl:template>

<xsl:template match="processing-instruction()" mode="type">
	<xsl:text>pi</xsl:text>
</xsl:template>
<!--

-->
</xsl:stylesheet>