%{
  import java.io.*;
%}
%%
%%
public static void main(String args[]) throws IOException {
	System.out.println("BYACC/Java with Xml2Json");
	Parser yyparser;
	if ( args.length > 0 ) {
		// parse a file
		yyparser = new Parser(new FileReader(args[0]));
	} else {
		System.out.error("Errore");
		return;
	}
}

private Yylex lexer;
public Parser(Reader r) {
	lexer = new Yylex(r, this);
}
