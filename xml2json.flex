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
COMMENT = "<!--" [^"-->"]* "-->"
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
PREFACE_BEGIN = "<preface"
PREFACE = "preface"
TOC = "toc"
LOF = "lof"
LOT = "lot"
SECTION = "section"
ENCODING = "encoding"
VERSION = "version"

%%

{WHITESPACE} { }
<OUT_OF_TAG> {PCDATA} { yyparser.yylval = new ParserVal(yytext()); return Parser.PCDATA; }
/*{IDENT} {yyparser.yylval = new ParserVal(yytext());  return Parser.IDENT;}*/
{TAGBEGIN} { yybegin(YYINITIAL);return Parser.TAGBEGIN;}

{QUOTED} { yyparser.yylval = new ParserVal(yytext()); return Parser.QUOTED; }
{TAGENDANDCLOSE} { yybegin(OUT_OF_TAG); return Parser.TAGENDANDCLOSE; }
{TAGEND} { yybegin(OUT_OF_TAG); return Parser.TAGEND; }
{TAGCLOSE} {yybegin(YYINITIAL); return Parser.TAGCLOSE; }
{EQUALSIGN} {return Parser.EQUALSIGN; }
{COMMENT} {  }
{DTD} {yybegin(OUT_OF_TAG); return Parser.DTD;}




{ID} {yyparser.yylval = new ParserVal(yytext()); return Parser.ID;}
{EDITION} {yyparser.yylval = new ParserVal(yytext()); return Parser.EDITION;}
{TITLE} {yyparser.yylval = new ParserVal(yytext()); return Parser.TITLE;}
{CAPTION} {yyparser.yylval = new ParserVal(yytext()); return Parser.CAPTION;}
{PATH} {yyparser.yylval = new ParserVal(yytext()); return Parser.PATH;}
{BOOK} {yyparser.yylval = new ParserVal(yytext()); return Parser.BOOK;}
{PART} {yyparser.yylval = new ParserVal(yytext()); return Parser.PART;}
{ITEM} {yyparser.yylval = new ParserVal(yytext()); return Parser.ITEM;}
{CHAPTER} {yyparser.yylval = new ParserVal(yytext()); return Parser.CHAPTER;}
{ACTION} {yyparser.yylval = new ParserVal(yytext()); return Parser.ACTION;}
{FIGURE} {yyparser.yylval = new ParserVal(yytext()); return Parser.FIGURE;}
{TABLE} {yyparser.yylval = new ParserVal(yytext()); return Parser.TABLE;}
{ROW} {yyparser.yylval = new ParserVal(yytext()); return Parser.ROW;}
{CELL} {yyparser.yylval = new ParserVal(yytext()); return Parser.CELL;}
{AUTHORNOTES} {yyparser.yylval = new ParserVal(yytext()); return Parser.AUTHORNOTES;}
{NOTE} {yyparser.yylval = new ParserVal(yytext()); return Parser.NOTE;}
{DEDICATION} {yyparser.yylval = new ParserVal(yytext()); return Parser.DEDICATION;}
{PREFACE} {yyparser.yylval = new ParserVal(yytext());  return Parser.PREFACE;}
{TOC} {yyparser.yylval = new ParserVal(yytext()); return Parser.TOC;}
{LOF} {yyparser.yylval = new ParserVal(yytext()); return Parser.LOF;}
{LOT} {yyparser.yylval = new ParserVal(yytext()); return Parser.LOT;}
{SECTION} {yyparser.yylval = new ParserVal(yytext()); return Parser.SECTION;}
{ENCODING} {yyparser.yylval = new ParserVal(yytext()); return Parser.ENCODING;}
{VERSION} {yyparser.yylval = new ParserVal(yytext()); return Parser.VERSION;}
{PREFACE_BEGIN} {yyparser.yylval = new ParserVal("preface"); yybegin(YYINITIAL); return Parser.PREFACE_BEGIN;}
{XMLDECL} {yyparser.yylval = new ParserVal(yytext());  return Parser.XMLDECL;}
