package org.openmrs.module.messagingphr.web.domain;

import org.openmrs.api.context.Context;
import org.openmrs.module.messaging.MessagingService;
import org.openmrs.module.messaging.domain.MessagingAddress;
import org.openmrs.module.messaging.omail.OMailProtocol;
import org.openmrs.module.messaging.web.domain.AddressAutocompleteBean; 

public class AddressAutocompleteBeanPhr extends  AddressAutocompleteBean {
	
	public AddressAutocompleteBeanPhr(MessagingAddress address){
	    super(address);
	    
		String value="";
		String label = "";
		if(address.getPerson() != null){
			value += "\""+address.getPerson().getPersonName().toString()+"\" ";
	        label = value;
		}
		//String protocolAbbreviation = Context.getService(MessagingService.class).getProtocolByClass(address.getProtocol()).getProtocolAbbreviation();		
		//value+="<"+protocolAbbreviation+":"+address.getAddress()+">";
		
		setValue(value);
		setLabel(label);
	}
}
