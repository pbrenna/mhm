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
%token EQUALSIGN
%token COMMENT
%token DTD
%token<sval> PCDATA

%token<sval> ID
%token<sval> EDITION
%token<sval> TITLE
%token<sval> CAPTION
%token<sval> PATH 
%token<sval> BOOK
%token<sval> PART
%token<sval> ITEM
%token<sval> CHAPTER
%token<sval> ACTION
%token<sval> FIGURE
%token<sval> TABLE
%token<sval> ROW
%token<sval> CELL
%token<sval> AUTHORNOTES
%token<sval> NOTE
%token<sval> DEDICATION
%token<sval> PREFACE
%token<sval> TOC
%token<sval> LOF
%token<sval> LOT
%token<sval> SECTION
%token<sval> ENCODING
%token<sval> VERSION
%token<sval> PREFACE_BEGIN

%type<sval> pcdata_str
%type<obj> id_attribute title_attribute path_attribute caption_attribute id_and_title book_attributes book_children maybe_path part_attributes figure_attributes table_attributes maybe_authornotes_element authornotes_element plus_part_element part_element plus_chapter_element chapter_element maybe_dedication_element dedication_element book_element book_children preface_element part_element part_children toc_element fine_part_children toc_element_children item_element lof_element lof_element_children lot_element lot_element_children chapter_children section_element section_children figure_element table_element table_children row_element row_children cell_element authornotes_children note_element id_ref_attribute
%%
input : XMLDECL DTD book_element { this.radice = (Nodo) $3;};

maybe_authornotes_element: authornotes_element {$$ = $1;}| {$$=null;};

plus_part_element: part_element {$$ = njoin($1);}
		| plus_part_element part_element { $$ = eladd($1, $2); };
		
plus_chapter_element: chapter_element {$$ = njoin($1);}
		| plus_chapter_element chapter_element { $$ = eladd($1, $2); };
id_attribute: ID EQUALSIGN QUOTED {this.ids.add($3); $$=attr($1,$3);};
id_ref_attribute: ID EQUALSIGN QUOTED {this.id_refs.add($3); $$=attr($1,$3);};
maybe_dedication_element: dedication_element {$$ = $1;} | {$$=null;};
title_attribute: TITLE EQUALSIGN QUOTED {$$=attr($1,$3);};
/*maybe_id_attribute: id_attribute | ;*/
/*maybe_title_attribute: title_attribute| ;*/
fine_part_children: /*vuoto*/ {$$ = njoin();}
		 | lof_element lot_element {$$ = njoin($1, $2);}
		 | lot_element {$$ = njoin($1);}
		 | lof_element {$$ = njoin($1);};
maybe_path: path_attribute {$$=$1;} | {$$=null; };
path_attribute: PATH EQUALSIGN QUOTED {$$=attr($1,$3);};
caption_attribute: CAPTION EQUALSIGN QUOTED {$$=attr($1,$3);};

id_and_title: id_attribute title_attribute {$$=ajoin($1,$2);}
		| title_attribute id_attribute {$$=ajoin($1,$2);} ;

book_element: TAGBEGIN BOOK book_attributes TAGEND book_children TAGCLOSE BOOK TAGEND
		{ $$ = nodo($2, $3, $5); };
	book_attributes: { $$=ajoin(); }
			| EDITION EQUALSIGN QUOTED {$$=ajoin(attr($1,$3));};
	book_children: maybe_dedication_element preface_element plus_part_element maybe_authornotes_element 
		{ $$ = njoin($1, $2, $3, $4); }
	;

dedication_element: TAGBEGIN DEDICATION TAGEND pcdata_str TAGCLOSE DEDICATION TAGEND
		{ $$ = nodo($2, ajoin(), da_pcdata($4)); } ;
preface_element: PREFACE_BEGIN TAGEND pcdata_str TAGCLOSE PREFACE TAGEND
		{ $$ = nodo($1, ajoin(), da_pcdata($3)); } ;

part_element: TAGBEGIN PART part_attributes TAGEND part_children TAGCLOSE PART TAGEND
		{ $$ = nodo($2, $3, $5); };
	part_children: toc_element plus_chapter_element fine_part_children { $$ = njoin($1, $2, $3); };
	/*part_attributes: maybe_title_attribute maybe_id_attribute part_attributes | id_attribute;*/
	part_attributes: id_attribute {$$=ajoin($1);}
			| id_attribute title_attribute {$$=ajoin($1,$2);}
			| title_attribute id_attribute {$$=ajoin($1,$2);};

toc_element: TAGBEGIN TOC TAGEND toc_element_children TAGCLOSE TOC TAGEND
		{ $$ = nodo($2, ajoin(), $4); };
	toc_element_children: item_element { $$=njoin($1); }
				| toc_element_children item_element {$$=eladd($1, $2);};
	
lof_element: TAGBEGIN LOF TAGEND lof_element_children TAGCLOSE LOF TAGEND
		{ $$ = nodo($2, ajoin(), $4); };
	lof_element_children: item_element { $$=njoin($1); }
				| lof_element_children item_element {$$=eladd($1, $2);};
	
lot_element: TAGBEGIN LOT TAGEND lot_element_children TAGCLOSE LOT TAGEND
		{ $$ = nodo($2, ajoin(), $4); };
	lot_element_children: item_element { $$=njoin($1); }
				| lot_element_children item_element {$$=eladd($1, $2);};

item_element: TAGBEGIN ITEM id_ref_attribute TAGEND pcdata_str TAGCLOSE ITEM TAGEND 
		{ $$ = nodo($2, $3, da_pcdata($5)); };

chapter_element: TAGBEGIN CHAPTER id_and_title TAGEND chapter_children TAGCLOSE CHAPTER TAGEND
		{ $$ = nodo($2, $3, $5); };
	chapter_children: section_element {$$=njoin($1);} | chapter_children section_element {$$=eladd($1, $2);};

section_element: TAGBEGIN SECTION id_and_title TAGEND section_children TAGCLOSE SECTION TAGEND 
			{ $$ = nodo($2, $3, $5); };
	section_children: /*vuoto*/ { $$ = njoin(); }
			  | section_children pcdata_str { $$ = eladd($1, $2); }
			  | section_children section_element { $$ = eladd($1, $2); }
			  | section_children figure_element { $$ = eladd($1, $2); }
			  | section_children table_element { $$ = eladd($1, $2); };

figure_element: TAGBEGIN FIGURE figure_attributes TAGEND TAGCLOSE FIGURE TAGEND
			{ $$ = nodo($2, $3, njoin()); }
		| TAGBEGIN FIGURE figure_attributes TAGENDANDCLOSE
			{ $$ = nodo($2, $3, njoin()); };
	figure_attributes: maybe_path id_attribute maybe_path caption_attribute maybe_path
				{ if($1 == null && $3==null && $5 == null)
					$$ = ajoin($1, $2, $3, $4, attr("path", "\"placeholder.jpg\""));
				  else $$ = ajoin($1, $2, $3, $4, $5);};
			| maybe_path caption_attribute maybe_path id_attribute maybe_path
				{ if($1 == null && $3==null && $5 == null)
					$$ = ajoin($1, $2, $3, $4, attr("path", "\"placeholder.jpg\""));
				  else $$ = ajoin($1, $2, $3, $4, $5); };

table_element: TAGBEGIN TABLE table_attributes TAGEND table_children TAGCLOSE TABLE TAGEND
			{$$ = nodo($2, $3, $5);};
	table_attributes: id_attribute caption_attribute { $$ = ajoin($1, $2); }
			| caption_attribute id_attribute { $$ = ajoin($1, $2); }; 
	table_children: row_element {$$ = njoin($1); }
			| table_children row_element {$$ = eladd($1, $2);};

row_element: TAGBEGIN ROW TAGEND row_children TAGCLOSE ROW TAGEND
		{$$ = nodo($2, ajoin(), $4);};
	row_children: cell_element { $$ = njoin($1); } 
		| row_children cell_element {$$ = eladd($1, $2); };

cell_element: TAGBEGIN CELL TAGEND pcdata_str TAGCLOSE CELL TAGEND
		{ $$ = nodo($2, ajoin(), da_pcdata($4));}
	 | TAGBEGIN CELL TAGENDANDCLOSE
	 	{ $$ = nodo($2, ajoin(), njoin());};

authornotes_element: TAGBEGIN AUTHORNOTES TAGEND authornotes_children TAGCLOSE AUTHORNOTES TAGEND
		{ $$ = nodo($2, ajoin(), $4);};
	authornotes_children: note_element {$$ = njoin($1);}
			| authornotes_children note_element {$$ = eladd($1, $2);};

note_element: TAGBEGIN NOTE TAGEND pcdata_str TAGCLOSE NOTE TAGEND
		{$$ = nodo($2, ajoin(), da_pcdata($4));};

pcdata_str: PCDATA {$$ = $1;} | pcdata_str PCDATA {$$= $1+$2;};

%%

public Nodo radice;
public Exception e;
public ArrayList<String> id_refs = new ArrayList<String>();
public HashSet<String> ids = new HashSet<String>();
public static void main(String args[]) throws Exception {
	//System.out.println("BYACC/Java with Xml2Json");
	Parser yyparser;
	if ( args.length > 0 ) {
		// parse a file
		FileReader r = new FileReader(args[0]);
		yyparser = new Parser(r);
		//yyparser.yydebug= true;
		yyparser.yyparse();
		if(yyparser.e != null) {
			throw yyparser.e;
		}
		yyparser.checkIdRefs();
		System.out.print(yyparser.radice.toJSON(0));
		/*
		PrintWriter writer = new PrintWriter(args[1], "UTF-8");
		writer.print(yyparser.radice.toJSON(0));
		writer.close();
		System.out.println("Scritto il file " + args[1]);*/
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
	this.e = new Exception(error);
}

private Yylex lexer;
public Parser(Reader r) {
	lexer = new Yylex(r, this);
}


/*funzioni di parsing*/
class Attr{
	public String name;
	public String value;
}
Attr attr(String name, String value){
	Attr ret = new Attr();
	ret.name = name;
	ret.value = value;
	return ret;
}
HashMap<String,String> ajoin (Object... attrs){
	HashMap<String,String> ret = new HashMap<String,String>();
	for (Object a : attrs){
		Attr attributo = (Attr) a;
		if (a != null){
			if(ret.containsKey(attributo.name)){
				yyerror("Duplicate attribute: " + attributo.name);
			} else {
				ret.put(attributo.name, attributo.value);
			}
		}
	}
	return ret;
}
Nodo nodo(String nome, Object attributi, Object figli) {
	Nodo ret = new Nodo();
	ret.nome = nome;
	try {
		ret.attributi = (HashMap<String, String>) attributi;
	} catch (Exception e) {
		HashMap<String, String> a = new HashMap<String, String>();
		a.put(((Attr) attributi).name, ((Attr)attributi).value);
		ret.attributi = a;
	}
	ret.figli = (ArrayList<Object>) figli;
	return ret;
}

ArrayList<Object> njoin (Object... figli){
	ArrayList<Object> ret = new ArrayList<Object>();
	for (Object f : figli){
		if (f != null){
			try{
				ret.addAll( (ArrayList<Object>) f);
			} catch (Exception e) {
				ret.add(f);
			}
		}
	}
	return ret;
}
ArrayList<Object> da_pcdata (String pcdata) {
	ArrayList<Object> ret = new ArrayList<Object>();
	ret.add(pcdata);
	return ret;
}
ArrayList<Object> eladd(Object lista, Object nodo){
	ArrayList<Object> l = (ArrayList<Object>) lista;
	l.add(nodo);
	return l;
}
void checkIdRefs() throws Exception {
	for(String s : this.id_refs) {
		if(!this.ids.contains(s)){
			throw new Exception("Id "+ s +" not found in document.");
		}
	}
}
