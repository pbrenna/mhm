%%

%byaccj         /* compatibilità con byacc/j */

%{
  private Parser yyparser;

  public Yylex(java.io.Reader r, Parser yyparser) {
    this(r);
    this.yyparser = yyparser;
  }
%}

%s OUT_OF_TAG

PCDATA = [^<]+
/*IDENT = [a-z]+*/
TAGBEGIN = "<"
XMLDECL = "<?xml" [^"?>"]+ "?>"
DTD = "<!DOCTYPE" [^">"]+ ">"
TAGENDANDCLOSE = "/>"
TAGEND = ">"
TAGCLOSE = "</"
/*EMPTYELEMENT = TAGBEGIN TAGNAME  TAGENDANDCLOSE*/
/*TAGCLOSE = TAGBEGIN "/" TAGNAME TAGEND*/
EQUALSIGN = "="
QUOTED = "\"" [^"\""]+ "\"" | "'" [^"'"]+ "'"
COMMENT = "<!--" .+ "-->"
WHITESPACE = [" " "\n" "\r\n" "\t"]+

/*token hard coded :) */
/* Secondo approccio che invece di utizzzare un generico TAGNAME definisce un token per ogni tag*/
ID = "id"
EDITION = "edition"
TITLE = "title"
CAPTION = "caption"
PATH = "path"
BOOK = "book"
PART = "part"
ITEM = "item"
CHAPTER = "chapter"
ACTION = "action"
FIGURE = "figure"
TABLE = "table"
ROW = "row"
CELL = "cell"
AUTHORNOTES = "authornotes"
NOTE = "note"
DEDICATION = "dedication"
PREFACE = "preface"
TOC = "toc"
LOF = "lof"
LOT = "lot"
SECTION = "section"
ENCODING = "encoding"
VERSION = "version"

%%

{WHITESPACE} { }
<OUT_OF_TAG> {PCDATA} { yyparser.yylval = new ParserVal(yytext()); System.out.println("Pcdata: "+yytext()); return Parser.PCDATA; }
/*{IDENT} {yyparser.yylval = new ParserVal(yytext());  return Parser.IDENT;}*/
{TAGBEGIN} { yybegin(YYINITIAL);System.out.println(yytext()); return Parser.TAGBEGIN;}

{QUOTED} { yyparser.yylval = new ParserVal(yytext()); return Parser.QUOTED; }
{TAGENDANDCLOSE} { yybegin(OUT_OF_TAG); return Parser.TAGENDANDCLOSE; }
{TAGEND} { System.out.println("trovato tagend"); yybegin(OUT_OF_TAG); return Parser.TAGEND; }
{TAGCLOSE} {yybegin(YYINITIAL); return Parser.TAGCLOSE; }
{EQUALSIGN} {return Parser.EQUALSIGN; }
{COMMENT} { System.out.println("Commento: --"+yytext()+"--"); }
{DTD} {yybegin(OUT_OF_TAG); System.out.println("DTD: --"+yytext()+"--"); return Parser.DTD;}


{ID} {return Parser.ID;}
{EDITION} {return Parser.EDITION;}
{TITLE} {return Parser.TITLE;}
{CAPTION} {return Parser.CAPTION;}
{PATH} {return Parser.PATH;}
{BOOK} {return Parser.BOOK;}
{PART} {return Parser.PART;}
{ITEM} {return Parser.ITEM;}
{CHAPTER} {return Parser.CHAPTER;}
{ACTION} {return Parser.ACTION;}
{FIGURE} {return Parser.FIGURE;}
{TABLE} {return Parser.TABLE;}
{ROW} {return Parser.ROW;}
{CELL} {return Parser.CELL;}
{AUTHORNOTES} {return Parser.AUTHORNOTES;}
{NOTE} {return Parser.NOTE;}
{DEDICATION} {return Parser.DEDICATION;}
{PREFACE} {System.out.println(yytext()); return Parser.PREFACE;}
{TOC} {return Parser.TOC;}
{LOF} {return Parser.LOF;}
{LOT} {return Parser.LOT;}
{SECTION} {return Parser.SECTION;}
{ENCODING} {return Parser.ENCODING;}
{VERSION} {return Parser.VERSION;}
{XMLDECL} { return Parser.XMLDECL;}
