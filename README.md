# József Attila Összes tanulmánya és cikke. Szövegek, 1930–1937.

Közzéteszi: Horváth Iván (főszerkesztő), Fuchs Anna (szerkesztő), Bognár Péter, Buda Borbála Sára, Devescovi Balázs, Golden Dániel (sajtó alá rendezők), Király Péter (programozó).

1.0. kiadás, 2012.

## Bevezető

Jelen project egy "qqq-kódolással" készült MS Word (.docx) állományból Perl és XSLT segitségével TEI XML és HTML állományokat készit.

## Követelmények

* Java futtató környezet
* Perl futtató környezet
* SAXON9 XSLT könyvtár (Saxon-HE-9.*.jar)

A program alapértelmezésben a Maven könyvtárában keresi a Saxon-t, de ezt a bash szkriptekben át lehet irni.

## Futtatás

Word -> TEI konverzió:

```
./ja2tei.sh
```

TEI XML -> HTML konverzió:

```
./tei2html.sh
```

