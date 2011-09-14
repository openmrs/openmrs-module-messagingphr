package org.openmrs.module.messagingphr.web.dwr;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openmrs.Person;
import org.openmrs.api.context.Context;
import org.openmrs.module.messagingphr.web.domain.AddressAutocompleteBeanPhr;
import org.openmrs.module.messaging.web.domain.AddressAutocompleteBean;
import org.openmrs.module.messaging.web.dwr.DWRMessagingAddressService;
import org.openmrs.module.messaging.MessagingAddressService;
import org.openmrs.module.messaging.domain.MessagingAddress;
import org.openmrs.module.personalhr.PhrService;

public class DWRMessagingAddressServiceForPhr extends DWRMessagingAddressService{

	Log log = LogFactory.getLog(getClass());
	
	public List<AddressAutocompleteBean> autocompleteSearch(String query){
	    log.debug("DWRMessagingAddressServiceForPhr:autocompleteSearch is called: " + query);
        if(!Context.isAuthenticated()) {
            return null;
        }
        
		List<AddressAutocompleteBean> addressBeans = new ArrayList<AddressAutocompleteBean>();
		
	    List<Person> people = Context.getService(PhrService.class).getRelatedPersons(Context.getAuthenticatedUser().getPerson());
	    people.add(Context.getAuthenticatedUser().getPerson());
				
		MessagingAddressService addressService = Context.getService(MessagingAddressService.class);
		for(Person p: people){
		    log.debug("Finding email for person: " + p);
			List<MessagingAddress> mAddresses = addressService.getMessagingAddressesForPerson(p);
			for(MessagingAddress ma: mAddresses){
				AddressAutocompleteBean addressBean = new AddressAutocompleteBeanPhr(ma);
	            log.debug("Found address: " + addressBean.getLabel() + "->" + addressBean.getValue());
				if(!addressBeans.contains(addressBean)){
					addressBeans.add(addressBean);
				}
			}
		}
		return addressBeans;
	}
	
    public String findOmailAddress(String personNames){
        log.debug("DWRMessagingAddressServiceForPhr:findOmailAddress is called: " + personNames);
        if(!Context.isAuthenticated()) {
            return null;
        } else if(personNames == null) {
            return "";
        }
        
        String[] perNames = personNames.split(",");
        List<AddressAutocompleteBean> addressBeans = new ArrayList<AddressAutocompleteBean>();
        
        List<Person> people = Context.getService(PhrService.class).getRelatedPersons(Context.getAuthenticatedUser().getPerson());
        people.add(Context.getAuthenticatedUser().getPerson());
                
        MessagingAddressService addressService = Context.getService(MessagingAddressService.class);
        String addrList = "";
        for(Person p: people){
            log.debug("Finding email for person: " + p);
            if(isPersonSelected(p,perNames)) {                        
                List<MessagingAddress> mAddresses = addressService.getMessagingAddressesForPerson(p);
                for(MessagingAddress ma: mAddresses){
                    AddressAutocompleteBean addressBean = new AddressAutocompleteBean(ma);
                    log.debug("Found address: " + addressBean.getLabel() + "->" + addressBean.getValue());
                    if(!addressBeans.contains(addressBean) && addressBean.getValue().toLowerCase().contains("omail:")){
                        addressBeans.add(addressBean);
                        if(addrList.isEmpty()) {
                            addrList += addressBean.getValue();
                        } else {
                            addrList += "," + addressBean.getValue();
                        }
                    }
                }
            } 
        }
        
        return addrList;
    }

    /**
     * Auto generated method comment
     * 
     * @param p
     * @param personNames
     * @return
     */
    private boolean isPersonSelected(Person p, String[] perNames) {
        // TODO Auto-generated method stub
        for(String perName : perNames) {
            if(perName.trim().replace("\"", "").equals(p.getPersonName().toString().trim())) {
                return true;
            }
        }
        return false;
    }	
}
