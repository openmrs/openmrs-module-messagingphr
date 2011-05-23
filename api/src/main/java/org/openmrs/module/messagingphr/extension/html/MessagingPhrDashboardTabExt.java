package org.openmrs.module.messagingphr.extension.html;

import org.openmrs.module.Extension;
import org.openmrs.module.messaging.util.MessagingConstants;
import org.openmrs.module.web.extension.PatientDashboardTabExt;

public class MessagingPhrDashboardTabExt extends PatientDashboardTabExt {

	public Extension.MEDIA_TYPE getMediaType(){
		return Extension.MEDIA_TYPE.html;
	}
	
	@Override
	public String getPortletUrl() {
		return "messagingPhrDashboardTab";
	}
		
	@Override
	public String getRequiredPrivilege() {
		return MessagingConstants.PRIV_VIEW_MESSAGES;
	}

	@Override
	public String getTabId() {
		return "messaging";
	}

	@Override
	public String getTabName() {
		return "My Mail";
	}

}
