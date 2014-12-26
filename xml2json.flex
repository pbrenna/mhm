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
ID = ^[i][d][=].+[a]+$

%%

{TAGBEGIN} {return Parser.TAGBEGIN;}
{TAGNAME} { yyparser.yylval = new ParserVal(yytext());
         return Parser.TAGNAME; }
{
