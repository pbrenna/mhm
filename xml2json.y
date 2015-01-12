%{
	import java.io.*;
	import java.util.*;
%}
%token<sval> QUOTED
%token TAGBEGIN
%token XMLDECL
%token TAGENDANDCLOSE
%token TAGEND
%token TAGCLOSE
%token PREFACE_BEGIN
%token EQUALSIGN
%token COMMENT
%token DTD
%token<sval> PCDATA

%token ID
%token EDITION
%token TITLE
%token CAPTION
%token PATH 
%token BOOK
%token PART
%token ITEM
%token CHAPTER
%token ACTION
%token FIGURE
%token TABLE
%token ROW
%token CELL
%token AUTHORNOTES
%token NOTE
%token DEDICATION
%token PREFACE
%token TOC
%token LOF
%token LOT
%token SECTION
%token ENCODING
%token VERSION

%%
input : XMLDECL DTD book_element;

maybe_authornotes_element: authornotes_element | ;
plus_part_element: part_element | plus_part_element part_element;
plus_chapter_element: chapter_element | plus_chapter_element chapter_element;
id_attribute: ID EQUALSIGN QUOTED;
maybe_dedication_element: dedication_element| ;
title_attribute: TITLE EQUALSIGN QUOTED;
/*maybe_id_attribute: id_attribute | ;*/
/*maybe_title_attribute: title_attribute| ;*/
fine_part_children: lof_element lot_element | | lot_element | lof_element;
maybe_path: path_attribute | ;
path_attribute: PATH EQUALSIGN QUOTED;
caption_attribute: CAPTION EQUALSIGN QUOTED;

id_and_title: id_attribute title_attribute | title_attribute id_attribute;

book_element : TAGBEGIN BOOK book_attributes TAGEND book_children TAGCLOSE BOOK TAGEND;
	book_attributes : | EDITION EQUALSIGN QUOTED;
	book_children: maybe_dedication_element preface_element plus_part_element maybe_authornotes_element;


dedication_element: TAGBEGIN DEDICATION TAGEND PCDATA TAGCLOSE DEDICATION TAGEND;
preface_element: PREFACE_BEGIN TAGEND PCDATA TAGCLOSE PREFACE TAGEND;

part_element: TAGBEGIN PART part_attributes TAGEND part_children TAGCLOSE PART TAGEND;
	part_children: toc_element plus_chapter_element fine_part_children;
	/*part_attributes: maybe_title_attribute maybe_id_attribute part_attributes | id_attribute;*/
	part_attributes: id_attribute| id_attribute title_attribute | title_attribute id_attribute;

toc_element: TAGBEGIN TOC TAGEND toc_element_children TAGCLOSE TOC TAGEND;
	toc_element_children: item_element | toc_element_children item_element;
	
lof_element: TAGBEGIN LOF TAGEND lof_element_children TAGCLOSE LOF TAGEND;
	lof_element_children: item_element | lof_element_children item_element;
	
lot_element: TAGBEGIN LOT TAGEND lot_element_children TAGCLOSE LOT TAGEND;
	lot_element_children: item_element | lot_element_children item_element;

item_element: TAGBEGIN ITEM id_attribute TAGEND PCDATA TAGCLOSE ITEM TAGEND;

chapter_element: TAGBEGIN CHAPTER id_and_title TAGEND chapter_children TAGCLOSE CHAPTER TAGEND;
	chapter_children: section_element | chapter_children section_element;

section_element: TAGBEGIN SECTION id_and_title TAGEND section_children TAGCLOSE SECTION TAGEND |
		 TAGBEGIN SECTION id_and_title TAGENDANDCLOSE;
	section_children: | section_children PCDATA
			  | section_children section_element 
			  | section_children figure_element
			  | section_children table_element;

figure_element: TAGBEGIN FIGURE figure_attributes TAGEND TAGCLOSE FIGURE TAGEND |
		TAGBEGIN FIGURE figure_attributes TAGENDANDCLOSE;
	figure_attributes: maybe_path id_attribute maybe_path caption_attribute maybe_path |
				maybe_path caption_attribute maybe_path id_attribute maybe_path;

table_element: TAGBEGIN TABLE table_attributes TAGEND table_children TAGCLOSE TABLE TAGEND;
	table_attributes: id_attribute caption_attribute | caption_attribute id_attribute; 
	table_children: row_element | table_children row_element;

row_element: TAGBEGIN ROW TAGEND row_children TAGCLOSE ROW TAGEND;
	row_children: cell_element | row_children cell_element;

cell_element: TAGBEGIN CELL TAGEND PCDATA TAGCLOSE CELL TAGEND | 
		TAGBEGIN CELL TAGENDANDCLOSE;

authornotes_element: TAGBEGIN AUTHORNOTES TAGEND authornotes_children TAGCLOSE AUTHORNOTES TAGEND;
	authornotes_children: note_element | authornotes_children note_element;

note_element: TAGBEGIN NOTE TAGEND PCDATA TAGCLOSE NOTE TAGEND;


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
		yyparser.yydebug= true;
		yyparser.yyparse();
		/*if(yyparser.e != null) {
			System.err.println(yyparser.e);
		}
		PrintWriter writer = new PrintWriter(args[1], "UTF-8");
		writer.print(yyparser.radice.toJSON(0));
		writer.close();
		System.out.println("Scritto il file " + args[1]);*/
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
