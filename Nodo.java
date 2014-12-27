import java.util.*;

public class Nodo{
	public String nome;
	public HashMap<String, String> attributi;
	public ArrayList<Object> figli;
	public Nodo parent;
	public Nodo(){
		this.attributi = new HashMap<String, String>();
		this.figli = new ArrayList<Object>();
	}
	public String toJSON(int indentazione){
		String JSON = "";
		String tabg = Nodo.retTab(indentazione);
		String tab = Nodo.retTab(indentazione + 1);
		JSON = tabg + "{\n";
		JSON = JSON + tab + "\"tag\": \"" + this.nome + "\",\n";
		for(String key : this.attributi.keySet()){
			JSON = JSON + tab + "\"@" + key + "\": " + this.attributi.get(key) + "\",\n";
		}
		if(this.figli.size() != 0){
			JSON = JSON + tab + "\"content\": [\n";
			for(Object n: this.figli){
				boolean isNode = false;
				String stringa = "";
				try{
					stringa = (String)n;
				}catch(Exception e){
					isNode = true;
				}
				if(isNode){
					JSON = JSON + ((Nodo)n).toJSON(indentazione + 1) + "\n";
				}
				else{
					JSON = JSON + tab + "\t \"" + stringa + "\"\n";
				}
			}
			JSON = JSON + tab + "]\n";
		}
		JSON = JSON + tabg + "}";
		return JSON;
	}
	private static String retTab(int n){
		String ret = "";
		for(int i = 0; i< n; i++)
			ret = ret + "\t";
		return ret;
	}
	
	public static void mainProva(String args[]){
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
}