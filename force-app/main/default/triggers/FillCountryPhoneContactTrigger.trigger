trigger FillCountryPhoneContactTrigger on Contact (after insert) {
    new FillCountryPhoneContactTriggerHandler().run();
}