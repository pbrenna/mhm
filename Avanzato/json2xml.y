%{
	import java.io.*;
	import java.util.*;
%}

%token GA
%token GC
%token QA
%token QC
%token PP
%token V
%token TAG
%token CONTENT

%token<sval> AN
%token<sval> QUOTED
%type<obj> elemento attr_cont_star content figlio p_figlio attr attr_cont figlio_star
%type<sval> tag_name
%%

input: elemento {this.radice = (Nodo)$1;};
elemento: GA tag_name attr_cont_star GC {Nodo n = new Nodo(); n.nome = $2; n.attributi = ((Cons)$3).attributi; n.figli = ((Cons) $3).figli; $$ = n;};
tag_name: TAG PP QUOTED { System.out.println($3);$$ = $3.substring(1, $3.length()-1);};
attr: AN PP QUOTED {Attr a = new Attr(); a.nome=$1.substring(2,$1.length()-1); a.valore = $3; $$ = a; }; 
attr_cont_star: V attr_cont  attr_cont_star {((Cons)$3).push($2); $$ = $3;}| {$$ = new Cons();};
attr_cont: attr {$$ = $1;};| content {$$ = $1;};
content: CONTENT PP QA p_figlio QC {$$ = $4;};
figlio: QUOTED {$$ = $1.substring(1,$1.length()-1);}| elemento {$$ = $1;};
p_figlio: figlio figlio_star{((ArrayList<Object>)$2).add($1); $$ = $2;}|{$$ = new ArrayList<Object>();};
figlio_star: V figlio figlio_star{((ArrayList<Object>)$3).add($2);  $$ = $3;}|{$$ = new ArrayList<Object>();};
%%
public static void main(String args[]) throws Exception {
	//System.out.println("BYACC/Java with Xml2Json");
	Parser yyparser;
	if ( args.length > 0 ) {
		// parse a file
		FileReader r = new FileReader(args[0]);
		yyparser = new Parser(r);
		yyparser.yydebug= true;
		yyparser.yyparse();
		if(yyparser.e != null) {
			throw yyparser.e;
		}
		System.out.print(yyparser.radice.toXML(0));
	} else {
		System.err.println("Errore: specificare un file.");
		return;
	}
}

public Exception e;
public Nodo radice;

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
	this.e = new Exception(error);
}

private Yylex lexer;
public Parser(Reader r) {
	lexer = new Yylex(r, this);
}

class Cons{
	public HashMap <String,String> attributi;
	public ArrayList<Object> figli;
	public Cons(){
		this.attributi = new HashMap<String, String>();
		this.figli = null;
	}
	public void push(Object o) {
		try{
			Attr a = (Attr) o;
			this.attributi.put(a.nome, a.valore);
		}catch(Exception ex) {
			if(this.figli == null)
				this.figli = (ArrayList<Object>) o;
			else
				yyerror("Content duplicato");
		}
	}
}
class Attr{
	public String nome;
	public String valore;
}
