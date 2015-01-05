%{
	import java.io.*;
	import java.util.*;
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
%token DTD
%token<sval> PCDATA

%type<obj> generic_element input closed_element element attr_list child_list
%%

input: xml_declaration generic_element { this.radice = (Nodo) $2; };


attr_list: /*vuoto*/ { $$ = new HashMap<String,String>(); }
	| IDENT EQUALSIGN QUOTED attr_list {
	 	 	((HashMap<String,String>) $4).put($1,$3); $$= $4;
		};

xml_declaration: 
	DOCTYPE attr_list DOCTYPECLOSE;

generic_element: 
	  closed_element 	{ $$ = $1; }
	| element 		{ $$ = $1; };

element: TAGBEGIN IDENT attr_list TAGEND child_list TAGCLOSE IDENT TAGEND {
		if(! $2.equals($7) ) {
			this.e = new Exception("Aperto tag "+ $2+", chiuso "+ $7);
			break;
		}
		Nodo n = new Nodo();
		n.nome = $2;
		n.attributi = (HashMap<String,String>) $3;
		n.figli = (ArrayList<Object>) $5;
		n.parent = null;
		$$ = n;
	};

closed_element: TAGBEGIN IDENT attr_list TAGENDANDCLOSE {
		Nodo n = new Nodo();
		n.nome = $2;
		n.attributi = (HashMap<String,String>) $3;
		n.parent= null;
		$$ = n;
	};

child_list: /*vuoto*/ 			{ $$ = new ArrayList<Object>(); }
	| generic_element child_list 	{ ((ArrayList<Object>) $2).add($1); $$=$2; }
	| PCDATA child_list 		{ ((ArrayList<Object>) $2).add($1); $$=$2; };

%%

public Nodo radice;
public Exception e;
public static void main(String args[]) throws IOException {
	//System.out.println("BYACC/Java with Xml2Json");
	Parser yyparser;
	if ( args.length > 1 ) {
		// parse a file
		FileReader r = new FileReader(args[0]);
		yyparser = new Parser(r);
		//yyparser.yydebug= true;
		yyparser.yyparse();
		if(yyparser.e != null) {
			System.err.println(yyparser.e);
		}
		PrintWriter writer = new PrintWriter(args[1], "UTF-8");
		writer.print(yyparser.radice.toJSON(0));
		writer.close();
		System.out.println("Scritto il file " + args[1]);
	} else {
		System.err.println("Errore: specificare due file.");
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
public Nodo n;
public Parser(Reader r) {
	lexer = new Yylex(r, this);
}
