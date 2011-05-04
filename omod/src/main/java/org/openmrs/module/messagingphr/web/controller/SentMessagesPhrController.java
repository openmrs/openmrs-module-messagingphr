package org.openmrs.module.messagingphr.web.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class SentMessagesPhrController {

	@RequestMapping(value = "/module/messagingphr/sent_messages")
	public void populateModel(HttpServletRequest request){
		
	}
}
