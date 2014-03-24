package org.openmrs.module.messagingphr.extension.html;

import org.openmrs.module.Extension;
import org.openmrs.module.messaging.util.MessagingConstants;
import org.openmrs.module.web.extension.LinkExt;

public class MessagingPhrGutterExt extends LinkExt {

	/**
	 * default constructor: set display order attribute
	 */
	public MessagingPhrGutterExt() {
		super();
	}


	@Override
	public Extension.MEDIA_TYPE getMediaType() {
		return Extension.MEDIA_TYPE.html;
	}


	@Override
	public String getUrl() {
		return "module/messagingphr/inbox.form?inTab=false";
	}

	@Override
	public String getRequiredPrivilege() {
		return MessagingConstants.PRIV_VIEW_MESSAGES;
	}


	/* (non-Jsdoc)
	 * @see org.openmrs.module.web.extension.LinkExt#getLabel()
	 */
	@Override
	public String getLabel() {
		return "My Mail";
	}


}
