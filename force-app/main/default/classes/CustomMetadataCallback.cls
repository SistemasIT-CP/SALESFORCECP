public class CustomMetadataCallback implements Metadata.DeployCallback {
    public void handleResult(Metadata.DeployResult result,
                             Metadata.DeployCallbackContext context) {
        if (result.status == Metadata.DeployStatus.Succeeded) {
            System.debug('Todo ha salido bien!');
        } else {
            for(Metadata.DeployMessage msje : result.details.componentFailures) {
            	System.debug('Error sobre mtd:' + msje.fullName + ', problema: ' + msje.problem);    
            }
        }
    }
}