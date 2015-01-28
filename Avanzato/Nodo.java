import java.util.*;

public class Nodo{
	public String nome;
	public HashMap<String, String> attributi;
	public ArrayList<Object> figli;
	public Nodo(){
		this.attributi = new HashMap<String, String>();
		this.figli = new ArrayList<Object>();
	}
	public String toJSON(int indentazione){
		String JSON = "";
		String tabg = Nodo.retTab(indentazione);
		String tab = Nodo.retTab(indentazione + 1);
		String tab2 = Nodo.retTab(indentazione + 2);
		JSON = tabg + "{\n";
		JSON = JSON + tab + "\"tag\": \"" + this.nome + "\",\n";
		for(String key : this.attributi.keySet()){
			JSON = JSON + tab + "\"@" + key + "\": " + sistemaAcapi(this.attributi.get(key), tab) + ",\n";
		}
		if(this.figli.size() != 0){
			JSON = JSON + tab + "\"content\": [\n";
			boolean primo = true;
			for(Object n: this.figli){
				boolean isNode = false;
				String stringa = "";
				if(!primo){
					JSON = JSON +",\n";
				}
				primo = false;
				try{
					stringa = (String)n;
				}catch(Exception e){
					isNode = true;
				}
				if(isNode){
					JSON = JSON + ((Nodo)n).toJSON(indentazione + 2);
				}
				else{
					JSON = JSON + tab2 + "\"" + sistemaAcapi(stringa, tab2)+"\"";
				}
			}
			JSON = JSON + "\n" + tab + "]\n";
		}
		JSON = JSON + tabg + "}";
		if(indentazione == 0){
			JSON = JSON + "\n";
		}
		return JSON;
	}
	private static String retTab(int n){
		String ret = "";
		for(int i = 0; i< n; i++)
			ret = ret + "\t";
		return ret;
	}
	
	public static void main(String args[]){
		Nodo n = new Nodo();
		Nodo g = new Nodo();
		n.nome = "book";
		n.attributi.put("id", "ciao");
		n.parent = null;
		n.figli.add("Ciao questa è una prova");
		n.figli.add(g);
		g.nome = "bho";
		g.figli.add("roba sotto");
		g.parent = n;
		System.out.print(n.toJSON(0));
	}
	public static String sistemaAcapi(String s, String tabulazz){
		return s.replaceAll("\t","").replaceAll("\n", "\\\\\n"+tabulazz).replaceAll("\r","");
	}
}
