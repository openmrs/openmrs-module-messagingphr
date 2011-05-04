package org.openmrs.module.messagingphr.web.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class ExternalConversationsPhrController {

	@RequestMapping(value = "/module/messagingphr/external_conversations")
	public void populateModel(HttpServletRequest request){
		
	}
	
}
