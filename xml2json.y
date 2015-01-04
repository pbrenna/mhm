%{
  import java.io.*;
 %}
 %token<sval> IDENT
 %token<sval> QUOTED
 %token TAGBEGIN
 %token DOCTYPE
 %token DOCTYPECLOSE
 %token TAGENDANDCLOSE
 %token TAGEND
 %token TAGCLOSE
 %token EQUALSIGN
 %token COMMENT
 %token<sval> PCDATA
%%

input: xml_declaration dtd_declaration generic_element;

attribute: IDENT EQUALSIGN QUOTED {System.out.println($3);};
attr_list:  | attribute attr_list;
xml_declaration: 
	DOCTYPE attr_list DOCTYPECLOSE;
generic_element: closed_element | element;
element: TAGBEGIN IDENT attr_list TAGEND child_list TAGCLOSE IDENT TAGEND;
closed_element: TAGBEGIN IDENT attr_list TAGENDANDCLOSE;

child_list: | generic_element child_list | pcdata2 child_list; 
dtd_declaration: ;
pcdata2 : PCDATA | PCDATA pcdata2;

%%
public static void main(String args[]) throws IOException {
	System.out.println("BYACC/Java with Xml2Json");
	Parser yyparser;
	if ( args.length > 0 ) {
		// parse a file
		FileReader r = new FileReader(args[0]);
		//System.out.println((char) r.read());
		System.out.println(Parser.DOCTYPE);
		System.out.println(Parser.PCDATA);
		yyparser = new Parser(r);
		yyparser.yydebug= true;
		yyparser.yyparse();
	} else {
		System.err.println("Errore: specificare un file.");
		return;
	}
}

private int yylex () {
	int yyl_return = -1;
	try {
		yylval = new ParserVal(0);
		yyl_return = lexer.yylex();
	}
	catch (IOException e) {
		System.err.println("IO error :"+e);
	}
	return yyl_return;
}


public void yyerror (String error) {
	System.err.println ("Error: " + error);
}

private Yylex lexer;
public Parser(Reader r) {
	lexer = new Yylex(r, this);
}
