public with sharing class FillCountryPhoneContactTriggerHandler extends TriggerHandler {
    public override void afterInsert() {
        if (TriggerContextUtility.isFirstRun()) {
            TriggerContextUtility.setFirstRunFalse();
            System.enqueueJob(new CodeCountryQueueable(Trigger.newMap.keySet()));
        }
    }
}