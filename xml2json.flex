%%

%byaccj         /* compatibilità con byacc/j */

%{
  private Parser yyparser;

  public Yylex(java.io.Reader r, Parser yyparser) {
    this(r);
    this.yyparser = yyparser;
  }
%}
/* ??????????????? */

IDENT = [a-z]+
TAGBEGIN = "<"
DOCTYPE = TAGBEGIN "?xml"
DOCTYPECLOSE = "?" TAGEND
TAGENDANDCLOSE = "/>"
TAGEND = ">"
TAGCLOSE = "</"
/*EMPTYELEMENT = TAGBEGIN TAGNAME  TAGENDANDCLOSE*/
/*TAGCLOSE = TAGBEGIN "/" TAGNAME TAGEND*/
EQUALSIGN = "="
QUOTED = "\"" [.]+ "\""
COMMENT = "<!--" [.]+ "-->"
PCDATA = [^TAGBEGIN]+
/* riconosciamo tutti i possibili attributi 
ID = "id"
EDITION = "edition"
TITLE = "title"
CAPTION = "caption"
PATH = "path"
WHITESPACE = " " | "\n" | "\r\n" | "\t";

/* Secondo approccio che invece di utizzzare un generico TAGNAME definisce un token per ogni tag
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
SECTION = "section"*/*/

%%

{TAGBEGIN} {System.out.println("sdifpdsifds"); return Parser.TAGBEGIN;}

{IDENT} {System.out.println("2");  yyparser.yylval = new ParserVal(yytext()); return Parser.IDENT;}
{DOCTYPE} {return Parser.DOCTYPE; }
{DOCTYPECLOSE} {return Parser.DOCTYPECLOSE; }
{TAGENDANDCLOSE} {return Parser.TAGENDANDCLOSE; }
{TAGEND} {return Parser.TAGEND; }
{TAGCLOSE} {return Parser.TAGCLOSE; }
{EQUALSIGN} {return Parser.EQUALSIGN; }
{QUOTED} { yyparser.yylval = new ParserVal(yytext()); return Parser.QUOTED; }
/*{COMMENT} { return Parser.COMMENT; }*/
{PCDATA} { yyparser.yylval = new ParserVal(yytext()); return Parser.PCDATA; }
