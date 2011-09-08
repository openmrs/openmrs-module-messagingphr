<%@ include file="/WEB-INF/view/module/personalhr/template/include.jsp" %>

<personalhr:require privilege="View Messages" otherwise="/phr/login.htm" redirect="/module/messagingphr/compose_message.form" />

<link rel="stylesheet" href="<openmrs:contextPath/>/moduleResources/messagingphr/css/compose_message.css" type="text/css"/>

<!-- YUI Text Editor includes -->
<link rel="stylesheet" type="text/css" href="<openmrs:contextPath/>/moduleResources/messaging/yui-text-editor/skin.css">
<script type="text/javascript" src="<openmrs:contextPath/>/moduleResources/messaging/yui-text-editor/yahoo-dom-event.js"></script>
<script type="text/javascript" src="<openmrs:contextPath/>/moduleResources/messaging/yui-text-editor/element-min.js"></script>
<script type="text/javascript" src="<openmrs:contextPath/>/moduleResources/messaging/yui-text-editor/container_core-min.js"></script>
<script type="text/javascript" src="<openmrs:contextPath/>/moduleResources/messaging/yui-text-editor/menu-min.js"></script>
<script type="text/javascript" src="<openmrs:contextPath/>/moduleResources/messaging/yui-text-editor/button-min.js"></script>
<script type="text/javascript" src="<openmrs:contextPath/>/moduleResources/messaging/yui-text-editor/editor-min.js"></script>
<script type="text/javascript">	
	var myEditor = new YAHOO.widget.SimpleEditor('writing-area', {
	    height: '20em',
		width: ''
	});
	myEditor.render();
</script>

<openmrs:globalProperty var="phrStarted" key="personalhr.started" defaultValue="false"/>
<c:if test="${phrStarted}">
	<%@ page import="org.openmrs.web.WebConstants" %>
	<%
		 session.setAttribute(WebConstants.OPENMRS_HEADER_USE_MINIMAL, "true");
	%>
</c:if>

<%@ include file="/WEB-INF/template/header.jsp"%>
<openmrs:htmlInclude file="/dwr/engine.js" />	

<div id="index" class="home">
	<table id="compose-message-table">
	<tr>
	<td id="link-cell">
		<div id="link-panel">
			<a id="inbox-link" class="panel-link" href="<openmrs:contextPath/>/module/messagingphr/inbox.form">Mail Inbox</a>
			<a id="compose-message-link" class="panel-link" href="<openmrs:contextPath/>/module/messagingphr/compose_message.form">Compose New Message</a>
			<a id="sent-messages-link" class="panel-link" href="<openmrs:contextPath/>/module/messagingphr/sent_messages.form">Sent Messages</a>
			<a id="settings-link" class="panel-link" href="<openmrs:contextPath/>/module/messagingphr/settings.form">Settings</a>
		</div>
	</td>
	<td id="compose-message-cell">
		<div id="header-panel" class="boxHeader">
			<table id="header-table">
				<tr>
					<td><span id="subject-label">Disclaimer:</span></td>
					<td class="header-left-column">Please do not use this messaging system if you need immediate help.  If you are experiencing a medical emergency, please call 911 or go to your nearest emergency room.</td>
				</tr>
				<tr>
					<td><span id="to-label">To:</span></td>
					<td class="header-left-column"><textarea id="to-addresses" rows="2">${toAddresses}</textarea></td>
				</tr>
				<tr>
					<td><span id="subject-label">Subject:</span></td>
					<td class="header-left-column"><input id="subject" type="text" value="${subject}"/></td>
				</tr>
			</table>
		</div>
		<div id="writing-area-container" class="yui-skin-sam">
			<textarea id="writing-area" name="writing-area"/>${messageText}</textarea>
		</div>
		<div id="buttons-container" class="boxHeader">
			<input type="button" value="Send" id="send-button" onclick="sendMessage()"></input>
			<input type="button" value="Discard" id="discard-button" onclick="clearFields()"></input>
			<span id="sent-message-result" style="margin-left:10px;"></span>
		</div>
	</td>
	</tr>
	</table>
</div>
<%@ include file="/WEB-INF/template/footer.jsp" %>

<!--  jQuery includes -->
<style>
	.ui-autocomplete-loading { background: white url('<openmrs:contextPath/>/moduleResources/messaging/images/ajax-loader-circle.gif') right center no-repeat; }
</style>

<script src="<openmrs:contextPath/>/dwr/interface/DWRMessagingAddressServiceForPhr.js"></script>
<script src="<openmrs:contextPath/>/dwr/interface/DWRModuleMessageService.js"></script>
<script type="text/javascript">
$j(function() {
	function split( val ) {
		return val.split( /,\s*/ );
	}
	function extractLast( term ) {
		return split( term ).pop();
	}

	$j( "#to-addresses" )
		// don't navigate away from the field on tab when selecting an item
		.bind( "keydown", function( event ) {
			if ( event.keyCode === $j.ui.keyCode.TAB &&
					$j( this ).data( "autocomplete" ).menu.active ) {
				event.preventDefault();
			}
		})
		.autocomplete({
			source: function( request, response ) {
				DWRMessagingAddressServiceForPhr.autocompleteSearch(extractLast(request.term), response);
			},
			search: function() {
				// custom minLength
				var term = extractLast( this.value );
				//if ( term.length < 2 ) {
				//	return false;
				//}
			},
			focus: function() {
				// prevent value inserted on focus
				return false;
			},
			select: function( event, ui ) {
				var terms = split( this.value );
				// remove the current input
				terms.pop();
				// add the selected item
				terms.push( ui.item.value );
				// add placeholder to get the comma-and-space at the end
				terms.push( "" );
				this.value = terms.join( ", " );
				return false;
			}
		});
});

	function sendMessage(){
		$j("#send-button").attr("disabled","disabled");
		$j("#discard-button").attr("disabled","disabled");
		$j("#sent-message-result").html("Sending...");
		myEditor.saveHTML();
	    //The var html will now have the contents of the textarea
	    var html = myEditor.get('element').value, match;
		match = html.match(/<body[^>]*>([\s\S]*?)<\/body>/i);
	    html = match ? match[1] : html;
	    
	    DWRMessagingAddressServiceForPhr.findOmailAddress(document.getElementById('to-addresses').value, function(response){
		    DWRModuleMessageService.sendMessage(html, response,document.getElementById('subject').value,true,function(response){
				$j("#send-button").attr("disabled","");
				$j("#discard-button").attr("disabled","");
				if(!response){
					response = "Message Sent!";
				}
				$j("#sent-message-result").html(response);
				var t = setTimeout("clearMessage()",3000);
				clearFields();
		    });
	    });
	}
	function clearMessage(){
		$j("#sent-message-result").html("");
	}
	function clearFields(){
		myEditor.clearEditorDoc();
	    $j('#to-addresses').val("");
	    $j('#subject').val("");
	}
</script>