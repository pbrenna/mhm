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
IDENT = [a-z]+
TAGBEGIN = "<"
DOCTYPE = "<?xml"
DTD = "<!DOCTYPE" [^">"]+ ">"
DOCTYPECLOSE = "?>"
TAGENDANDCLOSE = "/>"
TAGEND = ">"
TAGCLOSE = "</"
/*EMPTYELEMENT = TAGBEGIN TAGNAME  TAGENDANDCLOSE*/
/*TAGCLOSE = TAGBEGIN "/" TAGNAME TAGEND*/
EQUALSIGN = "="
QUOTED = "\"" [^"\""]+ "\"" | "'" [^"'"]+ "'"
COMMENT = "<!--" .+ "-->"
WHITESPACE = [" " "\n" "\r\n" "\t"]+

%%

{WHITESPACE} { }
<OUT_OF_TAG> {PCDATA} { yyparser.yylval = new ParserVal(yytext()); System.out.println("ho letto: \""+ yytext()+"\""); return Parser.PCDATA; }
{IDENT} {yyparser.yylval = new ParserVal(yytext()); System.out.println("Ident: "+ yytext()); return Parser.IDENT;}
{TAGBEGIN} {System.out.println("<"); yybegin(YYINITIAL); return Parser.TAGBEGIN;}
{DOCTYPE} {return Parser.DOCTYPE; }

{QUOTED} { yyparser.yylval = new ParserVal(yytext()); return Parser.QUOTED; }
{DOCTYPECLOSE} {return Parser.DOCTYPECLOSE; }
{TAGENDANDCLOSE} {System.out.println("/>"); yybegin(OUT_OF_TAG); return Parser.TAGENDANDCLOSE; }
{TAGEND} {System.out.println(">"); yybegin(OUT_OF_TAG); return Parser.TAGEND; }
{TAGCLOSE} {System.out.println("</");yybegin(YYINITIAL); return Parser.TAGCLOSE; }
{EQUALSIGN} {return Parser.EQUALSIGN; }
{COMMENT} { }
{DTD} {yybegin(OUT_OF_TAG); /*return Parser.DTDOPEN;*/}
