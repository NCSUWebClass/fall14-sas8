<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="action.mainAction"%>
<%@page import="bean.DocBean"%>
<%@page import="bean.CampaignBean"%>
<%@page import="java.util.List"%>
<%@include file="/global.jsp"%>
<%
	mainAction action = new mainAction();
	List<CampaignBean> campaignList = action.getCampaigns();
	List<DocBean> docList = action.getDocs(campaignList.get(0).getId()); 

if(request.getUserPrincipal() != null) {
	userName = authDAO.getName(request.getUserPrincipal().getName());
	avatar = authDAO.getAvatar(request.getUserPrincipal().getName());
}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<%@include file="/header.jsp"%>
<body>
	<input type="hidden" id="userName" value="<%= userName %>" />
	<div class="header">
		<!-- <button class="menu_btn"></button> -->
		<button class="header_btn" id="group"></button>
		<a class="header_btn" id="user" href="/SASTeam08/logout.jsp"></a>
		<button class="header_btn" id="help"></button>
		<button class="header_btn" id="alert"></button>
		<button class="header_btn" id="search"></button>
	</div>
	<!--<div class="navBar" id="campaign1">
	<img class="back_arrow"  src="images/back_arrowBlack.png"/>
	<div class="navBarText">2014 Christmas - Canned Food Drive</div>
</div>-->

	<!-- side bar on the left side of screen -->
	<div class="dashboard" id="dashboard">
		<img class="logo" src="/SASTeam08/images/Icon-01.png" /> <img
			class="hbar" src="/SASTeam08/images/horizontal_bar.png" />
		<div class="dashboard_link">Dashboard</div>
		<div class="dashboard_link">
			Campaign <br /> Builder
		</div>
		<br />
		<div class="dashboard_link">Analytics</div>
		<div class="dashboard_link">
			Media <br /> Manager
		</div>
		<br />
		<div class="dashboard_link">Calendar</div>
		<div class="dashboard_link">Email</div>
		<img class="sas_db_logo" src="/SASTeam08/images/sas_db_logo.png">
	</div>
	<div class="activeItem" id="activeItem">
		<div class="accordion-toggle" id="<%=campaignList.get(0).getId()%>">
			<div class="accordion-header">
				<img class="back_arrow" src="/SASTeam08/images/back_arrowBlack.png" />
				<%
					String title = "";
								   	  if (campaignList != null) {
								   	  	title = campaignList.get(0).getTitle();
								   	  }
				%>
				<div><%=title%></div>
			</div>
		</div>
	</div>

	<div class="accordion" id="dock">
		<%
			for (int i = 1; i < campaignList.size(); i++) {
		%>
		<div class="accordion-toggle" id="<%=campaignList.get(i).getId()%>">
			<div class="accordion-header">
				<img class="back_arrow" src="/SASTeam08/images/back_arrowBlack.png" />
				<div><%=campaignList.get(i).getTitle()%></div>
			</div>
		</div>
		<%
			}
		%>
	</div>

	<div class="documentDisplay">
		<div id="editor">
			<div class="selectedEdit" id="selectedEdit"></div>
			<div class="editIconBar">
				<img src="/SASTeam08/images/user.png"
					style="width: 50px; height: 50px" id="userBtn" /> <img
					src="/SASTeam08/images/highlightedUser.png"
					style="width: 50px; height: 50px" id="huserBtn" /> <img
					src="/SASTeam08/images/add.png" style="width: 50px; height: 50px"
					id="addBtn" /> <img src="/SASTeam08/images/highlight.png"
					style="width: 50px; height: 50px" id="highlightBtn" /> <img
					src="/SASTeam08/images/vibrate.png"
					style="width: 50px; height: 50px" id="vibrateBtn" /> <img
					src="/SASTeam08/images/archive.png"
					style="width: 50px; height: 50px" id="archiveBtn" />
			</div>
			<div class="docEditor" id="docEditor"></div>
		</div>
		<div class="documentDisplayTable"></div>
	</div>

	<div class="chat">
		<div class="chatsReceived" id="chatsReceived">
			<div class="chatItem">
				<img class="chatBubbleAvatar" src="/SASTeam08/images/chatAvatar.png">
				<div class="chatBubble">This is a chat bubble</div>
			</div>
		</div>
		<textarea class="chatInput"></textarea>	
	</div>

	<div class="imageComments" id="imageComments">
		<div class="imageCommentsDisplay" id="imageCommentsDisplay"></div>
	</div>
	<div class="viewImageCommentsBtn" id="viewImageCommentsBtn"><i class="glyphicon glyphicon-comment"></i></div>
	<div class="imageModal" onclick="hideImageModal()">
		<span class="imageModalImageHelper"></span> <img id="imageModalImage"
			src="" />
	</div>

	<div class="uploadModal">
		<span class="uploadActionHelper"></span>
		<div class="uploadActionBox">
			<input type="file" id="fileInput" />

			<div class="uploadTextInput">
				<p>
					<span> Name: <input class="form-control" type="text"
						id="creatorInput" />
					</span>
					<input type="hidden" id="username" value="<%= userName %>" />
				</p>
				<p>
					<span> Document Title: <input class="form-control"
						type="text" id="docTitleInput" />
					</span>
				</p>
				<p>
				<div id="fileToUpload"></div>
				</p>
			</div>
			<div class="uploadUI">
				<button class="btn btn-default browse_btn" id="browse_btn">Browse</button>
				<button class="btn btn-primary submit_btn" id="submit_btn">Upload</button>
				<button class="btn btn-warning close_btn" id="close_btn">Close</button>
			</div>
		</div>
	</div>

	<div class="chatBar" id="chatBar"></div>
</body>
<script>
	var showingDashboard = true;
	$('.accordion-toggle').click(
			function(evt) {
				if (!$(this).hasClass("navBar")) { //when an item is clicked and is not top item
					var goingActive = $(this);
					var lastActive = $('#activeItem > .accordion-toggle');
					var id = $(this).attr("id");
					goingActive.animate({
						marginLeft : "200%"
					}, 300);
					getDocs(id);
					$('#activeItem').animate(
							{
								top : "-20px"
							},
							300,
							function() {
								$('.accordion-toggle').not(goingActive).css({
									backgroundColor : "#12ada9"
								}); //change all other bgs to dark green
								$(goingActive).addClass("navBar", true);
								$('#activeItem').css({
									top : "45px"
								});
								lastActive.css({
									borderBottom : "1px solid white",
									marginLeft : "200%"
								});
								lastActive.appendTo("#dock"); // prepend activeItem to dock
								lastActive.animate({
									marginLeft : "0"
								}, 300);
								goingActive.prependTo('#activeItem');
								goingActive.animate({
									marginLeft : "0"
								}, 300);
								$('.accordion-toggle').not(goingActive)
										.removeClass("navBar"); // remove navBar class from all other items
								$(goingActive).animate({
									backgroundColor : "#C8D758"
								}, 300); //change bg to light green
								$(goingActive).css({
									borderBottom : "0px"
								});
							});
				} else { //when an item is clicked and is top item
					//clicking on a campaign header should hide the dashboard
					if (showingDashboard === true) {
						$('.dashboard').animate({
							left : -175
						}, 300); //hide the dashboard
						$(this).find('.accordion-header').animate({
							marginLeft : "15px"
						}, 300); //move text left
						$(this).find('.accordion-header > .back_arrow')
								.animate({
									opacity : 1
								}, 1000); // show back arrow
						var allOtherAccordionToggles = $(".accordion-toggle")
								.not($(this));
						allOtherAccordionToggles.animate({
							opacity : 0
						}, function() {
							allOtherAccordionToggles.hide();
						}); //hide all other accordion-toggle classes
						$(".documentDisplay").animate({
							left : "40px",
							bottom : "5px",
							right : "220px"
						}, 300);
						$(".chatsReceived").empty();
						$(".chat").animate({
							right : "20px"
						});
						$("#editor").stop(true, true).fadeIn({
							duration : 300,
							queue : false
						}).css('display', 'none').slideDown(300); //show editor
						$(".documentDisplay").css({
							zIndex : "102"
						});
						evt.preventDefault();
						connectToChatserver();

						showingDashboard = false;
						//clicking again should show the dashboard
					} else {
						$('.dashboard').animate({
							left : 0
						}, 300);
						$(this).find('.accordion-header').animate({
							marginLeft : "200px"
						}, 300);
						$(this).find('.accordion-header > .back_arrow')
								.animate({
									opacity : 0
								}, 300);
						$(".accordion-toggle").not($(this)).show();
						$(".accordion-toggle").not($(this)).animate({
							opacity : 1
						}, 300);
						$(".documentDisplay").animate({
							left : "180px",
							bottom : "138px",
							right : "180px"
						}, 300);
						$(".chat").animate({
							right : "-200px"
						});
						$("#editor").stop(true, true).fadeOut({
							duration : 300,
							queue : false
						}).slideUp(300); //hide editor
						$(".documentDisplay").css({
							zIndex : "10"
						});
						showingDashboard = true;
						leaveRoom();
					}
				}
			});

	// handle chat functionality
// 	$(".chatInput")
// 			.on("keyup", function(e) {
// 					var code = (e.keycode) ? e.keycode : e.which;
// 					if (code === 13) {
// 						var chatItem = "<div class=\"chatItem\">";
<%-- 						var img = "<img class=\"chatBubbleAvatar\" src=\"/SASTeam08/images/chatAvatar.png\" title=\"" + '<%=userName%>' + "\"/>"; --%>
// 						var submit = "<div class=\"chatBubble\">"
// 								+ $('.chatInput').val() + "</div></div>";
// 						$(chatItem + img + submit).appendTo(
// 								$('.chatsReceived'));
// 						updateChatScroller();
// 						$('.chatInput').val("");
// 					}
// 				});
	var wsocket;
	var userName;
	var serviceLocation = "ws:localhost:8080/SASTeam08/chat/";
	var $message;
	var $chatWindow;
	var room = '';
	var avatar;

	$('.chatInput').on("keyup", function(evt) {
		var code = (evt.keycode) ? evt.keycode : evt.which;
		if (code === 13) {
			$message.val($message.val().replace(/(\r\n|\n|\r)/gm,""));
			evt.preventDefault();
			sendMessage();
		}
	});

	function onMessageReceived(evt) {
		//var msg = eval('(' + evt.data + ')');
		var msg = JSON.parse(evt.data); // native API
		var chatItem = "<div class=\"chatItem\">";
		var img = "<img class=\"chatBubbleAvatar\" src=\""+ msg.avatar +"\" title=\"" + msg.sender + "\"/>";
		var submit = "<div class=\"chatBubble\">"
				+ msg.message + "</div></div>";
		$(chatItem + img + submit).appendTo(
				$('.chatsReceived'));
		updateChatScroller();
		$('.chatInput').val("");
// 		var $messageLine = $('<tr><td class="received">' + msg.received
// 				+ '</td><td class="user label label-info">' + msg.sender
// 				+ '</td><td class="message badge">' + msg.message
// 				+ '</td></tr>');
// 		$chatWindow.append($messageLine);
	}
	function sendMessage() {
		var msg = '{"message":"' + $message.val() + '", "sender":"'
				+ userName + '", "received":"", "avatar":"' + avatar +'"}';
		wsocket.send(msg);
	}
 
	function connectToChatserver() {
			room = $(".activeItem > .accordion-toggle").attr("id");
			wsocket = new WebSocket(serviceLocation + room);
			console.log(wsocket.readyState);
			wsocket.onmessage = onMessageReceived;
	}
 
	function leaveRoom() {
		if (wsocket.readyState < 2) {
			wsocket.close();
		}
	}

	$(document).ready(function($) {
		$("#editor").hide();
		$(".activeItem > .accordion-toggle").css({
			backgroundColor : "#C8D758",
			borderBottom : 0
		});
		$(".activeItem > .accordion-toggle").addClass("navBar");
		var activeId = $(".activeItem > .accordion-toggle").attr("id");
		getDocs(activeId);
		
		userName = "<%=userName%>";
		avatar = "<%=avatar%>";
		$message = $('.chatInput');
		$chatWindow = $('.chatsReceived');
		$('#user').click(function(){
			leaveRoom();
		});
		window.onbeforeunload = function() {
		    websocket.onclose = function () {}; // disable onclose handler first
		    leaveRoom();
		};
		/*$('#dock').find('.accordion-toggle').click(function(){
			
			    //Expand or collapse this panel
			$(this).next().slideToggle('fast');
			
			    //Hide the other panels
			$('.accordion-content').not($(this).next()).slideUp('fast');
		});*/
	});

	function updateChatScroller() {
		var element = document.getElementById("chatsReceived");
		element.scrollTop = element.scrollHeight;
	}

	function getDocs(id) {
		$('.documentDisplay')
			.fadeOut(
				function() {
					$.get("/SASTeam08/DBGetter?id=" + id, function(data) {
							$(".documentDisplayTable").empty();
							var numImages = $(".documentDisplay").width() / 300;
					for (var i = 0; i < data.length; i++) {
						var content;
						if (i % numImages === 0) {
							content = "<div class=\"documentRow\">"
									+ "<div class=\"documentBox\" onclick=\"showImageModal('"
									+ data[i].href + "', " + data[i].id
									+ ")\">"
									+ "<div class=\"documentImage\"></div>"
									+ "<div class=\"deleteBtn\" id=\"" + data[i].id + "\"><i class=\"glyphicon glyphicon-trash\" /></div>"
									+ "<input type=\"hidden\" class=\"docHref\" value=\""+ data[i].href +"\">"
									+ "<input type=\"hidden\" class=\"docId\" value=\""+ data[i].id +"\">"
									+ data[i].text
									+ " - "
									+ data[i].creator
									+ "</div></div>";
							$(content).appendTo($(".documentDisplayTable"));
						} else {
							content = "<div class=\"documentBox\" onclick=\"showImageModal('"
									+ data[i].href + "', " + data[i].id
									+ ")\">"
									+ "<div class=\"documentImage\"></div>"
									+ "<div class=\"deleteBtn\" id=\"" + data[i].id + "\"><i class=\"glyphicon glyphicon-trash\" /></div>"
									+ "<input type=\"hidden\" class=\"docHref\" value=\""+ data[i].href +"\">"
									+ "<input type=\"hidden\" class=\"docId\" value=\""+ data[i].id +"\">"
									+ data[i].text
									+ " - "
									+ data[i].creator
									+ "</div></div>";
							$(content).appendTo($(".documentDisplayTable")
													.children()
													.last());
						}
						console.log(data[i].ext);
						if (data[i].ext === "png" || data[i].ext === "gif" || data[i].ext === "jpg") { //show image or show the doc type
							$(".documentDisplayTable")
								.children()
								.last()
								.children()
								.last()
								.children()
								.first()
								.css('background-image','url('
												+ data[i].href
												+ ')');
						} else {
							$(".documentDisplayTable")
								.children()
								.last()
								.children()
								.last()
								.children()
								.first()
								.css('background-image','url(\'/SASTeam08/images/file.png\')');
							$(".documentDisplayTable")
								.children()
								.last()
								.children()
								.last()
								.children()
								.first()
								.html(data[i].ext);
							$(".documentDisplayTable")
								.children()
								.last()
								.children()
								.last()
								.children()
								.first()
								.css(
										{
											fontSize : "20px",
											verticalAlign : "middle"
										});
							$(".documentDisplayTable")
								.children()
								.last()
								.children()
								.last()
								.attr("onclick", "downloadFile(\""+ data[i].href + "\")");
						}
						$(".documentDisplayTable")
							.children()
							.last()
							.children()
							.last()
							.hover(function() {
								$(this).find(".deleteBtn").show();
								var thisBox = $(this);
								$(this).find(".deleteBtn").on("click", function() {
									clickedDelete = true;
									handleDeleteFile($(this).attr("id"),
											$("#activeItem > .accordion-toggle").attr("id"),
											thisBox.find(".docHref").val());
								});
						},
						function() {
							$(this).find(".deleteBtn").hide();
						});
		
					}
					$(".documentDisplay").fadeIn();
			});
		});
	}
	function showImageModal(url, docId) {
		if (!clickedDelete) {
			$('#imageModalImage').attr("src", url);
			$('#viewImageCommentsBtn').css({'display': 'block'});
			$('.imageModal').css({
				display : "inline-block"
			});
			$('.imageModal').animate({
				opacity : 1
			}, 300);
		}
		
		$('#viewImageCommentsBtn').on('click', function () {
			var bg = $('#viewImageCommentsBtn').css('backgroundColor');
			if (bg === 'rgb(136, 136, 136)') {
				clickedImageCommentsBtn = true; 
				$('#viewImageCommentsBtn').css({'backgroundColor' : '#0000FF'});
				$('#imageComments').css({'display' : 'block'});
				runCommentEditor(docId);
			} else {
				hideComments();
			}
		});
	}
	var clickedImageCommentsBtn = false;
	function hideImageModal() {
		if (!clickedImageCommentsBtn) {
			$('.imageModal').animate({
				opacity : 0
			}, 300, function() {
				$('.imageModal').css({
					display : "none"
				});
			});
			$('#viewImageCommentsBtn').off('click');
			$('#viewImageCommentsBtn').css({'display': 'none'});
		}
	}
	
	function hideComments() {
		$('#viewImageCommentsBtn').css({'backgroundColor' : '#888888'});
		$('#imageComments').css({'display' : 'none'});
		$('.commentInput').remove();
		$("#imageComments > .circle").remove();
		clickedImageCommentsBtn = false; 
		stopCommentEditor();
	}
	
	var clickedDelete = false;
	// Use the function below to add a scroll bar to a div
	// 	$(function() {
	// 		$('.dashboard').jScrollPane();
	// 	});
</script>
</html>
