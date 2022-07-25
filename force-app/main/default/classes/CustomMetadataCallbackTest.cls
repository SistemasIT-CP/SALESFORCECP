@isTest
public class CustomMetadataCallbackTest {

    @isTest
    public static void sucessDeployTest() {
        Metadata.DeployResult dr = new Metadata.DeployResult();
        dr.status = Metadata.DeployStatus.Succeeded;
        
        Test.startTest();
        CustomMetadataCallback cb = new CustomMetadataCallback();
        cb.handleResult(dr, null);
        Test.stopTest();
    }
    
    @isTest
    public static void failDeployTest() {
        Metadata.DeployResult dr = new Metadata.DeployResult();
        dr.status = Metadata.DeployStatus.Failed;
        
        Metadata.DeployMessage msje = new Metadata.DeployMessage();
        msje.fullname = 'Test';
        msje.problem = 'Test';
        
        List<Metadata.DeployMessage> msjeList = new List<Metadata.DeployMessage>();
        msjeList.add(msje);
        
        Metadata.DeployDetails dd = new Metadata.DeployDetails();
        dd.componentFailures = msjeList;
        
        dr.details = dd;
        
        Test.startTest();
        CustomMetadataCallback cb = new CustomMetadataCallback();
        cb.handleResult(dr, null);
        Test.stopTest();
    }
}