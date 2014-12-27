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

TAGNAME = [a-z]+
TAGBEGIN = "<"
TAGENDANDCLOSE = "/>"
TAGEND = ">"
/*EMPTYELEMENT = TAGBEGIN TAGNAME  TAGENDANDCLOSE*/
/*TAGCLOSE = TAGBEGIN "/" TAGNAME TAGEND*/
EQUALSIGN = "="
QUOTED = "\"" [.]+ "\""
COMMENT = "<!--" [.]+ "-->"

/* riconosciamo tutti i possibili attributi */
ID = "id"
EDITION = "edition"
TITLE = "title"
CAPTION = "caption"
PATH = "path"

/* Secondo approccio che invece di utizzzare un generico TAGNAME definisce un token per ogni tag*/
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

%%

{TAGBEGIN} {return Parser.TAGBEGIN;}
{TAGNAME} { yyparser.yylval = new ParserVal(yytext());
         return Parser.TAGNAME; }

{ID} {return Parser.ID}
{EDITION} {return Parser.EDITION}
{TITLE}   {return Parser.TITLE}
{CAPTION} {return Parser.CAPTION}
{PATH} {return Parser.PATH} 

{BOOK} {return Parser.BOOK}
{PART} {return Parser.PART}
{ITEM}{return Parser.ITEM}
{CHAPTER}{return Parser.CHAPTER}
{ACTION}{return Parser.ACTION}
{FIGURE}{return Parser.FIGURE}
{TABLE}{return Parser.TABLE}
{ROW}{return Parser.ROW}
{CELL}{return Parser.CELL}
{AUTHORNOTES}{return Parser.AUTHORNOTES}
{NOTE}{return Parser.NOTE}
{DEDICATION}{return Parser.DEDICATION}
{PREFACE}{return Parser.PREFACE}
{TOC}{return Parser.TOC}
{LOF}{return Parser.LOF}
{LOT}{return Parser.LOT}
{SECTION}{return Parser.SECTION}
