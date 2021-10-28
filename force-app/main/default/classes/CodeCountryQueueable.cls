public without sharing class CodeCountryQueueable implements Queueable, Database.AllowsCallouts {
    private List<Contact> contacts; 

    public CodeCountryQueueable(Set<Id> contactList) {
        this.contacts = [SELECT Id, Phone FROM Contact WHERE Id IN :contactList];
    }

    public void execute(QueueableContext context) {

        for(Contact contact : contacts) {
            if (contact.Phone != null) {
                String p ='\\+(375|48|7)';
                Pattern compPattern = Pattern.compile(p);
                Matcher matcher = compPattern.matcher(contact.Phone);
                matcher.find();
                String code = matcher.group(0).substring(1);
                HttpRequest request = new HttpRequest();
                // Set the endpoint URL.
                String endpoint = 'https://restcountries.com/v2/callingcode/' + code;
                request.setEndPoint(endpoint);
                // Set the HTTP verb to GET.
                request.setMethod('GET');
                // Send the HTTP request and get the response.
                HttpResponse response = new HTTP().send(request);
                if (response.getStatusCode() == 200) {
                    List<CallingCodeWrapper> listCountry = CallingCodeWrapper.parse(response.getBody());
                    contact.Country_from_Phone__c = listCountry[0].alpha3Code;
                }
            }
       }

       update contacts;
    }
}