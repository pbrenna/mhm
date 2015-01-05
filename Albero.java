import java.util.*;
public class  Albero{
	private Nodo albero;
	private boolean outOfTree;
	public Albero(){
			albero = null;
			this.outOfTree = false;
	}
	public void addNodo(String nome){
		if(this.outOfTree)
			return;
		Nodo n = new Nodo();
		n.nome = nome;
		if(this.albero == null){
			this.albero = n;
			this.albero.parent = null;
		}
		else{
			n.parent = this.albero;
			this.albero.figli.add(n);
			this.albero = n;
		}
	}
	public void addPCDATA(String s) throws Exception {
		if(this.outOfTree)
			return;
		if(albero == null){
			throw new Exception("Hai sbagliato qualcosa di grosso");			
		}
		else{
			this.albero.figli.add(s);
		}
	}
	
	public void addAttributes(HashMap<String,String> s) {
		if(this.outOfTree)
			return;
		this.albero.attributi = s;
	}
	
	public void up(){
		if(this.albero.parent != null){
			this.albero = this.albero.parent;
		}
		else
			this.outOfTree = true;
	}
	
	public String toJSON() throws Exception{
		if(this.albero.parent != null)
			throw new Exception("XML non completo");
		return this.albero.toJSON(0);
	}
}
