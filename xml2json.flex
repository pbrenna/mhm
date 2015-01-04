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
DOCTYPE = "<?xml"
DOCTYPECLOSE = "?>"
TAGENDANDCLOSE = "/>"
TAGEND = ">"
TAGCLOSE = "</"
/*EMPTYELEMENT = TAGBEGIN TAGNAME  TAGENDANDCLOSE*/
/*TAGCLOSE = TAGBEGIN "/" TAGNAME TAGEND*/
EQUALSIGN = "="
QUOTED = "\"" [^"\""]+ "\""
COMMENT = "<!--" .+ "-->"
WHITESPACE = " " | "\n" | "\r\n" | "\t"
PCDATA = [^<]
/* riconosciamo tutti i possibili attributi 
ID = "id"
EDITION = "edition"
TITLE = "title"
CAPTION = "caption"
PATH = "path"

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

{IDENT} {System.out.println("2");  yyparser.yylval = new ParserVal(yytext()); return Parser.IDENT;}
{TAGBEGIN} {System.out.println("sdifpdsifds"); return Parser.TAGBEGIN;}
{DOCTYPE} {return Parser.DOCTYPE; }

{QUOTED} { yyparser.yylval = new ParserVal(yytext()); return Parser.QUOTED; }
{DOCTYPECLOSE} {return Parser.DOCTYPECLOSE; }
{TAGENDANDCLOSE} {return Parser.TAGENDANDCLOSE; }
{TAGEND} {return Parser.TAGEND; }
{TAGCLOSE} {return Parser.TAGCLOSE; }
{EQUALSIGN} {return Parser.EQUALSIGN; }
/*{COMMENT} { return Parser.COMMENT; }*/
{WHITESPACE} { }
{PCDATA} { yyparser.yylval = new ParserVal(yytext()); return Parser.PCDATA; }
