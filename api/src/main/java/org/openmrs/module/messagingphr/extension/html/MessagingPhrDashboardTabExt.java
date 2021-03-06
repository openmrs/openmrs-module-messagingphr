package org.openmrs.module.messagingphr.extension.html;

import org.openmrs.api.context.Context;
import org.openmrs.module.Extension;
import org.openmrs.module.messaging.util.MessagingConstants;
import org.openmrs.module.web.extension.PatientDashboardTabExt;

public class MessagingPhrDashboardTabExt extends PatientDashboardTabExt {

    /**
     * default constructor: set display order attribute
     */
    public MessagingPhrDashboardTabExt() {
        super();
    }

    
	public Extension.MEDIA_TYPE getMediaType(){
		return Extension.MEDIA_TYPE.html;
	}
	
	@Override
	public String getPortletUrl() {
		return "messagingPhrDashboardTab";
	}
	
    public String getUrl() {
        return "module/messagingphr/inbox.form";
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
	    if(Context.hasPrivilege("PHR Single Patient Access")){
	        return "My Mail";
	    } else {
            return "Mail";	        
	    }
	}

}
