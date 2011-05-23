<%@ include file="/WEB-INF/template/include.jsp" %>
<div id="followup-div"  >
		<div class="tooltipPhr">
		<spring:message code="messagingphr.tooltip.messaging"/>
		</div>
		<iframe src ="${pageContext.request.contextPath}/module/messagingphr/inbox.form" width="100%" height="1000">
		Loading Messaging Inbox...
		</iframe>
</div>