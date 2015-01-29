%%

%byaccj         /* compatibilità con byacc/j */

%{
  private Parser yyparser;

  public Yylex(java.io.Reader r, Parser yyparser) {
    this(r);
    this.yyparser = yyparser;
  }
  private String cdata_value;
%}

GA = "{"
GC = "}"
QA = "["
QC = "]"

PP = ":"
V = ","
TAG = "\"tag\"" | "'tag'"
CONTENT = "\"content\"" | "'content'"
/*Attribute Name*/
AN = "\"@" [^"\""]+ "\"" | "'@" [^"'"]+ "'"
QUOTED = "\"" [^"\""]+ "\"" | "'" [^"'"]+ "'"

SPAZIVARI = "\n" | "\t" | " " | "\r"
%%
{GA} {return Parser.GA;}
{GC} {return Parser.GC;}
{QA} {return Parser.QA;}
{QC} {return Parser.QC;}
{PP} {return Parser.PP;}
{V} {return Parser.V;}
{TAG} {return Parser.TAG;}
{CONTENT} {return Parser.CONTENT;}
{AN} {yyparser.yylval = new ParserVal(yytext()); return Parser.AN;}
{QUOTED} {yyparser.yylval = new ParserVal(yytext()); return Parser.QUOTED;}
{SPAZIVARI} {}
