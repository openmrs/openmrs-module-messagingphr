package org.openmrs.module.messagingphr.web.dwr;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openmrs.Person;
import org.openmrs.api.context.Context;
import org.openmrs.module.messaging.MessageService;
import org.openmrs.module.messaging.MessagingAddressService;
import org.openmrs.module.messaging.MessagingService;
import org.openmrs.module.messaging.domain.Message;
import org.openmrs.module.messaging.domain.MessageRecipient;
import org.openmrs.module.messaging.domain.MessagingAddress;
import org.openmrs.module.messaging.domain.gateway.Protocol;
import org.openmrs.module.messaging.omail.OMailProtocol;
import org.openmrs.module.messaging.web.domain.MessageBean;
import org.openmrs.module.messaging.web.domain.MessageBeanSet;
import org.openmrs.module.messaging.web.dwr.DWRModuleMessageService;
import org.openmrs.module.personalhr.PhrService;

public class DWRModuleMessageServiceForPhr extends DWRModuleMessageService {
	
	private static Log log = LogFactory.getLog(DWRModuleMessageServiceForPhr.class);
	
	private MessageService messageService;
	private MessagingService messagingService;
	private MessagingAddressService addressService;
	
	/**
	* The max amount of time (in milliseconds) that 2 messages
	* can be apart before they are grouped separately.
	* Currently it is 1 hour.
	*/
	private static final long MAX_TIME_DISTANCE = 3600000;
	
	public DWRModuleMessageServiceForPhr(){
		messageService = Context.getService(MessageService.class);
		messagingService = Context.getService(MessagingService.class);
		addressService = Context.getService(MessagingAddressService.class);
	}
		
	public MessageBeanSet getMessagesForAuthenticatedUserWithPageSize(Integer pageNumber, Integer pageSize, boolean to){
		return getMessagesForPerson(pageNumber,pageSize, Context.getAuthenticatedUser().getPerson().getId(),to);
	} 
	
	public MessageBeanSet getMessagesForPerson(Integer pageNumber, Integer pageSize, Integer personId, boolean to){
		List<MessageBean> beans = new ArrayList<MessageBean>();
		List<Message> messages = new ArrayList<Message>();
		Integer total=null;
		if(to){
			messages = messageService.getMessagesForPersonPaged(pageNumber, pageSize, personId, to,false,OMailProtocol.class);
			total = messageService.countMessagesForPerson(personId, to,OMailProtocol.class);
		}else{
			messages = messageService.getMessagesForPersonPaged(pageNumber, pageSize, personId, to,false,null);
			total = messageService.countMessagesForPerson(personId, to,null);
		}
		for(Message m: messages){
		    if(Context.getService(PhrService.class).hasBasicRole(m.getSender(),PhrService.PhrBasicRole.PHR_ADMINISTRATOR)) {
		       if(m.getTo() != null) {
		           m.getTo().clear(); //Hide recipients if sender is administrator
		       }
		    }
			beans.add(new MessageBean(m));
		}
		MessageBeanSet resultSet = new MessageBeanSet(beans,total,pageNumber);
		return resultSet;
	}	
}