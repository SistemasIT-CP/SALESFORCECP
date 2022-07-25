public class CheckRecursividad {
    
    private static boolean run = true;
    
    public static boolean runOnce(){
        System.debug(run);
        if(run){
            run=false;
            return true;
        }else{
            return run;
        }
    }
    
}