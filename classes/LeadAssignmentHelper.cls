public without sharing class LeadAssignmentHelper {
    
    public class LeadAssignmentHelperRequest {
        @InvocableVariable(required=true)
        public String actionCadenceNames;
    
        @InvocableVariable(required=false)
        public String salesRegion;

    }
    
    @InvocableMethod(label='LeadAssignmentHelper')
    public static List<Id> getTargtIdsToFilter(List<LeadAssignmentHelperRequest> lahReq){
        
        System.debug (' ***** lahReq ' +  lahReq.get(0) );
        
        List<String> allNames = lahReq.get(0).actionCadenceNames.split(';');
        System.debug (' ***** allNames ' +  allNames );
        
        String salesRegion = lahReq.get(0).salesRegion;
        salesRegion = salesRegion == null ? '' : salesRegion.trim();
        Set<Id> targetIds = New Set<Id>();
        List<ActionCadenceStepTracker> acstList =  [ SELECT Id, ActionCadenceName, ActionCadenceTracker.Id, ActionCadenceTracker.OwnerId, StepType, TargetId, IsActionTaken, ActionCadenceTrackerId 
                                                    FROM ActionCadenceStepTracker 
                                                    Where State = 'Active' 
                                                    AND StepType != 'Wait' AND StepType != 'AutoSendAnEmail'
                                                    AND ActionCadenceName in :allNames 
                                                    ];
                                                     
        System.debug (' ***** acstList size ' +  acstList.size() );
        if(acstList.size() > 0){
            for(ActionCadenceStepTracker acst : acstList){ targetIds.add(acst.TargetId); }
        }
        System.debug (' ***** targetIds size ' +  targetIds.size() );
        List<Lead> leadList;
        List<Contact> contactList;
        System.debug (' ***** salesRegion ' +  salesRegion );
        if( salesRegion.trim().equalsIgnoreCase( '' )) {
            contactList = [SELECT Id From Contact
                       Where ActionCadenceAssigneeId = :Label.SalesCadenceDefaultTargetOwnerAssignee
                       AND Id In: targetIds 
                       Order By CreatedDate DESC
                       LIMIT 1
                       ];
        }
        else if( salesRegion.trim().equalsIgnoreCase( 'Shared Lead' )) {
            leadList = [SELECT Id From Lead 
                       Where ActionCadenceAssigneeId = :Label.SalesCadenceDefaultTargetOwnerAssignee
                       AND Id In: targetIds 
                       Order By ScoreIntelligenceId DESC
                       LIMIT 1
                       ];
        }
        else {
            leadList = [SELECT Id From Lead 
                       Where ActionCadenceAssigneeId = :Label.SalesCadenceDefaultTargetOwnerAssignee
                       AND Id In: targetIds 
                       AND Sales_Region__c = :salesRegion
                       Order By ScoreIntelligenceId DESC
                       LIMIT 1
                       ];

        }                       
        //System.debug (' ***** leadList Size ' +  leadList.size() );
        List<Id> leadIds = New List<Id>();
        List<Id> contactIds = New List<Id>();
        If(leadList != Null){
        for(Lead le : leadList) { leadIds.add(le.Id); }}
        else If(contactList != Null){
            for(Contact con : contactList){contactIds.add(con.Id);}
        }
        System.debug (' ***** leadIds ' +  leadIds );
        
        return  leadIds.size() > 0 ? leadIds : contactIds;
        
    }
}