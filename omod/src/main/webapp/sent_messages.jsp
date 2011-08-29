<%@ include file="/WEB-INF/view/module/personalhr/template/include.jsp" %>

<personalhr:require privilege="View Messages" otherwise="/phr/login.htm" redirect="/module/messagingphr/sent_messages.form" />

<openmrs:globalProperty var="phrStarted" key="personalhr.started" defaultValue="false"/>
<c:if test="${phrStarted}">
	<%@ page import="org.openmrs.web.WebConstants" %>
	<%
		 session.setAttribute(WebConstants.OPENMRS_HEADER_USE_MINIMAL, "true");
	%>
</c:if>

<%@ include file="/WEB-INF/template/header.jsp"%>
<openmrs:htmlInclude file="/dwr/engine.js" />	

<link rel="stylesheet" href="<openmrs:contextPath/>/moduleResources/messagingphr/css/sent_messages.css" type="text/css"/>
<table id="index">
<tr>
	<td id="link-cell">
		<div id="link-panel">
			<a id="inbox-link" class="panel-link" href="<openmrs:contextPath/>/module/messagingphr/inbox.form">Mail Inbox</a>
			<a id="compose-message-link" class="panel-link" href="<openmrs:contextPath/>/module/messagingphr/compose_message.form">Compose New Message</a>
			<a id="sent-messages-link" class="panel-link" href="<openmrs:contextPath/>/module/messagingphr/sent_messages.form">Sent Messages</a>
			<a id="settings-link" class="panel-link" href="<openmrs:contextPath/>/module/messagingphr/settings.form">Settings</a>
		</div>
	</td>
	<td id="sent-messages">
		<div id="search-bar-container">
			<form method="post" action="<openmrs:contextPath/>/module/messagingphr/search.form">
				<input id="sent-messages-search" name="searchString" type="text" style="display:inline;"/>
				<input id="search-button" type="submit" value="Search"/>
				<input type="hidden" name="searchingInbox" value="${false}"/>
				<input type="hidden" name="searchingSent" value="${true}"/>
			</form>
		</div><br/>
		<div id="message-table-container">
			<table id="messages-table" class="message-table">
				<thead>
					<tr>
						<th class="message-row-to">To</th>
						<th class="message-row-subject">Message</th>
						<th class="message-row-date">Date</th>
					</tr>
				</thead>
				<tbody id="messages-table-body">		
				</tbody>
			</table>
			<div id="paging-controls-container">
				<span id="paging-controls">
					<span id="paging-info">
						<span id="paging-start"></span>&nbsp;to 
						<span id ="paging-end"></span>&nbsp;of 
						<span id="paging-total"></span>
					</span>
					<a href="#" id="previous-page" onclick="pageToPreviousPage()">&lt;</a>
					<span id="current-page">1</span>
					<a href="#" id="next-page" onclick="pageToNextPage()">&gt;</a>
				</span>
			</div>
		</div>
		<div id="message-panel">
		<div id="message-info-panel" class="boxHeader">
			<table id="message-header-table">
				<tr><td class="header-label">To: </td><td class="header-info" id="header-to"></td></tr>
				<tr><td class="header-label">Subject: </td><td class="header-info" id="header-subject"></td></tr>
				<tr><td class="header-label">Date: </td><td class="header-info" id="header-date"></td></tr>
			</table>
			<div style="clear:both;"></div>
		</div>
		<div id="message-text-panel">
		</div>
		</div>
	</td>
	</tr>
</table>

<%@ include file="/WEB-INF/template/footer.jsp" %>

<script src="<openmrs:contextPath/>/moduleResources/messaging/jquery/jquery-1.4.4.min.js"></script>
<script src="<openmrs:contextPath/>/moduleResources/messaging/jquery/jquery.watermark.min.js"></script>
<openmrs:htmlInclude file="/dwr/engine.js"/>
<openmrs:htmlInclude file="/dwr/util.js"/>
<script src="<openmrs:contextPath/>/dwr/interface/DWRModuleMessageService.js"></script>

<script type="text/javascript">
	window.onload = init;
	
	var messageCache = { };

	var pageNum=0;
	var pageSize=10;
	
	function init() {
		//$j("#sent-messages-search").watermark("search sent messages");
		$j("#messages-table-body *").live("click",rowClicked);
		$j("#message-info-panel").hide();		
		fillMessageTable();
	}
	
	function rowClicked(e){
		var who = e.target||e.srcElement;
		var id =who.id.substring(12);
		var message = messageCache[id];
		$j("#message-info-panel").show();
		$j("#header-subject").html(message.subject);
		$j("#header-date").html(message.date);
		$j("#header-to").html(message.recipients);
		$j("#message-text-panel").html(message.content);
		$j("#messages-table-body").children().removeClass("highlight-row");
		$j("#pattern"+id).addClass("highlight-row");	
		$j(".header-label").css("visibility","visible");
	}
	
	function fillMessageTable(){
		DWRModuleMessageService.getMessagesForAuthenticatedUserWithPageSize(pageNum,pageSize,false,function(messageSet){
			dwr.util.removeAllRows("messages-table-body", { filter:function(tr) {return (tr.id != "pattern");}});
			var message, id;
			var messages = messageSet.messages;
			// iterate through the messages, cloning the pattern row
			// and placing each message value into that row
			for (var i = 0; i < messages.length; i++) {
				message = messages[i];
			    $j(createMessageRow(message.id)).appendTo("#messages-table-body");
			    $j("#message-dest" + message.id).html(message.recipients);
			    $j("#message-subj" + message.id).html(message.subject);
			    $j("#message-date" + message.id).html(message.time+ " " + message.date);
			    messageCache[message.id] = message;
			}
			pageNum = messageSet.pageNumber;
			pageSize = messageSet.pageSize;
			setPagingControls(messageSet);
		});
	}

	function setPagingControls(messageSet){
		$j("#paging-start").html((messageSet.pageNumber * messageSet.pageSize) + 1);
		$j("#paging-end").html((messageSet.pageNumber * messageSet.pageSize)  + messageSet.messages.length);
		$j("#paging-total").html(messageSet.total);
		$j("#current-page").html(messageSet.pageNumber+1);
		//enable or disable the paging controls properly
		if(messageSet.pageNumber === 0){
			$j('#previous-page').attr('class','disabled');
		}else{
			$j('#previous-page').attr('class','');
		}

		if(messageSet.pageSize > messageSet.messages.length){
			$j('#next-page').attr('class','disabled');
		}else{
			$j('#next-page').attr('class','');
		}
	}

	function pageToPreviousPage(){
		if($j('#previous-page').hasClass('disabled')){
			return false;
		}else{
			pageNum--;
			fillMessageTable();
		}
	}

	function pageToNextPage(){
		if($j('#next-page').hasClass('disabled')){
			return false;
		}else{
			pageNum++;
			fillMessageTable();
		}
	}
	function createMessageRow(mesgId){
		msgString = "<tr class=\"message-row\" id=\"pattern#\"><td class=\"message-row-to\" id=\"message-dest#\"></td><td class=\"message-row-subject\" id=\"msg-subj-con#\"><div class=\"subj-con\" id=\"subject-cont#\"><span class=\"msg-subj\" id=\"message-subj#\"></span><span class=\"msg-msg\" id=\"message-mesg#\"></span></div></td><td class=\"message-row-date\" id=\"message-date#\"></td></tr>";
		return msgString.replace(new RegExp("#",'g'),mesgId);
	}
</script>