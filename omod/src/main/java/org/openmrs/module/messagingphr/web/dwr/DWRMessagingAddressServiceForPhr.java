package org.openmrs.module.messagingphr.web.dwr;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openmrs.Person;
import org.openmrs.api.context.Context;
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
				
		MessagingAddressService addressService = Context.getService(MessagingAddressService.class);
		for(Person p: people){
		    log.debug("Finding email for person: " + p);
			List<MessagingAddress> mAddresses = addressService.getMessagingAddressesForPerson(p);
			for(MessagingAddress ma: mAddresses){
				AddressAutocompleteBean addressBean = new AddressAutocompleteBean(ma);
	            log.debug("Found address: " + addressBean.getLabel() + "->" + addressBean.getValue());
				if(!addressBeans.contains(addressBean)){
					addressBeans.add(addressBean);
				}
			}
		}
		List<MessagingAddress> mAddresses2 = addressService.findMessagingAddresses(query, false);
		for(MessagingAddress ma2: mAddresses2){
			AddressAutocompleteBean addressBean2 = new AddressAutocompleteBean(ma2);
			if(!addressBeans.contains(addressBean2)){
				addressBeans.add(addressBean2);
			}
		}
		return addressBeans;
	}
}
