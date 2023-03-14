@isTest
private class LeadAssignmentHelperTest {
    
    @isTest
    static void testGetTargtIdsToFilter1(){
        LeadAssignmentHelper.LeadAssignmentHelperRequest lahr = new LeadAssignmentHelper.LeadAssignmentHelperRequest();
        String actionCadenceNames = 'Rehash Team Journey';
        lahr.actionCadenceNames = actionCadenceNames;
        lahr.salesRegion = '';
        
        Test.startTest();
        LeadAssignmentHelper.getTargtIdsToFilter(new List<LeadAssignmentHelper.LeadAssignmentHelperRequest>{lahr});
        Test.stopTest();
    }
    
    @isTest
    static void testGetTargtIdsToFilter2(){
        LeadAssignmentHelper.LeadAssignmentHelperRequest lahr = new LeadAssignmentHelper.LeadAssignmentHelperRequest();
        String actionCadenceNames = 'Field Marketing Journey;Paid List Journey A';
        lahr.actionCadenceNames = actionCadenceNames;
        lahr.salesRegion = 'Shared Lead';
        
        Test.startTest();
        LeadAssignmentHelper.getTargtIdsToFilter(new List<LeadAssignmentHelper.LeadAssignmentHelperRequest>{lahr});
        Test.stopTest();
    }
    
    @isTest
    static void testGetTargtIdsToFilter3(){
        LeadAssignmentHelper.LeadAssignmentHelperRequest lahr = new LeadAssignmentHelper.LeadAssignmentHelperRequest();
        String actionCadenceNames = 'Field Marketing Journey;Paid List Journey A';
        lahr.actionCadenceNames = actionCadenceNames;
        lahr.salesRegion = 'Connecticut';
        
        Test.startTest();
        LeadAssignmentHelper.getTargtIdsToFilter(new List<LeadAssignmentHelper.LeadAssignmentHelperRequest>{lahr});
        Test.stopTest();
    }
}