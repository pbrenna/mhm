import java.util.*;

public class Nodo{
	public String nome;
	public HashMap<String, String> attributi;
	public ArrayList<Object> figli;
	public Nodo(){
		this.attributi = new HashMap<String, String>();
		this.figli = new ArrayList<Object>();
	}
	public String toXML(int indentazione){
		String XML = "";
		if(indentazione == 0){
			XML = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<!DOCTYPE book SYSTEM \"book.dtd\">\n";
		}
		XML = XML + Nodo.retTab(indentazione) + "<" + this.nome;
		for(String s: this.attributi.keySet()){
			XML = XML + " " + s + "=" + this.attributi.get(s);
		}
		XML = XML + ">\n";
		for(Object n: this.figli){
			try{
				String s = (String) n;
				XML = XML + Nodo.retTab(indentazione + 1) + Nodo.sistemaAcapi(s, Nodo.retTab(indentazione + 1)) + "\n";
			}catch(Exception e){
				XML = XML + ((Nodo)n).toXML(indentazione + 1)+ "\n";
			}
		}
		XML = XML + Nodo.retTab(indentazione) + "</" + this.nome + ">";
		return XML;		
	}
	private static String retTab(int n){
		String ret = "";
		for(int i = 0; i< n; i++)
			ret = ret + "\t";
		return ret;
	}
	
	public static String sistemaAcapi(String s, String tabulazz){
		return s.replaceAll("\t","")
			.replaceAll("\\\\\n", "\n")
			.replaceAll("\n", "\n"+tabulazz)
			.replaceAll("\r","")
			.replaceAll("<", "&lt;")
			.replaceAll(">", "&gt;");
	}
	
	public static void main(String args[]){
		Nodo n = new Nodo();
		Nodo g = new Nodo();
		n.nome = "book";
		n.attributi.put("id", "ciao");
		n.figli.add("Ciao questa è una prova");
		n.figli.add(g);
		g.nome = "bho";
		g.figli.add("roba sotto");
		System.out.print(n.toXML(0));
	}
}
