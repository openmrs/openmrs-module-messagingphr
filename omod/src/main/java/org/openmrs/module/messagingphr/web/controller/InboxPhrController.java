package org.openmrs.module.messagingphr.web.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class InboxPhrController {

	@RequestMapping(value = "/module/messagingphr/inbox")
	public void populateModel(HttpServletRequest request){
		
	}
}
