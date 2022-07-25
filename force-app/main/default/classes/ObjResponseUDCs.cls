public class ObjResponseUDCs {

	public String codigo;
	public String descripction1;
	public String descripction2;
	public String nombreudc;

	
	public static List<ObjResponseUDCs> parse(String json) {
		return (List<ObjResponseUDCs>) System.JSON.deserialize(json, List<ObjResponseUDCs>.class);
	}
}