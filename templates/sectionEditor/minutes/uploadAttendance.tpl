{include file="sectionEditor/minutes/menu.tpl"}
<script type="text/javascript" src="{$baseUrl|cat:"/lib/pkp/js/lib/jquery/jquery-ui-timepicker-addon.js"}"></script>
<style type="text/css" src="{$baseUrl|cat:"/lib/pkp/styles/jquery-ui-timepicker-addon.css"}"></style>
{literal}<script type="text/javascript">
	$(document).ready(function() {
		var guestCount = 0;
		$("#adjourned").timepicker({ampm:true});

		$('.present').each( function(){
				var elemVal = $(this).attr('id').substring(19);
				var present = $(this).attr('checked');
				if(present){
					alert(elemVal);
					$("#div_reason_of_absence_"+ elemVal +" input:radio").attr('disabled',true);
					$("#div_reason_of_absence_"+ elemVal +" input:radio").attr('checked',false);
				}
			}
		);
		
		$("#addGuest").click(
				function() {
					guestCount++;
					var row="<tr>"+
			 		"<td width='5%'>Name</td>"+
	 				"<td width='15%'><input type='text' name='guestName[]' id='guestName[]' size='50' /></td>"+
					"<td width='5%'>Affiliation</td>"+
	 				"<td width='15%'><input type='text' name='guestAffiliation[]' id='guestAffiliation[]' size='50' /></td>"+
					"<td width='60%'></td>"+
	 				"</tr>";
					$("#guests tr:last").after(row);
				}
			);

		$(".absent").click( function () {
				var elemVal = $(this).attr('id').substring(18);
				$("#div_reason_of_absence_"+elemVal).show();
				$("#div_reason_of_absence_"+ elemVal +" input:radio").attr('disabled',false);
			}
		);

		$(".present").click( function () {
				var elemVal = $(this).attr('id').substring(19);	
				$("#div_reason_of_absence_"+ elemVal +" input:radio").attr('disabled',true);
				$("#div_reason_of_absence_"+ elemVal +" input:radio").attr('checked',false);
		}
 		);
 		$(".div_reason_of_absence").click( function (){
 			var elemVal = $(this).attr('id').substring(22);
			var present = $("#reviewer-ispresent-"+elemVal).attr('checked');
			if(present){
				alert("Mark the reviewer absent first.");
 	 	 	}else{
 	 	 		$("#reviewer-isabsent-"+elemVal).attr('checked',true);
 	 	 	}
 	 	 	
 		});
	});
</script>{/literal}
<h2>Announcements and Attendance for Meeting #{$meeting->getId()}</h2>
<br/>
<form method="POST" action="{url op="submitAttendance" path=$meeting->getId()}">
	
<div id="announcements">
	<h2>Details</h2>
	<table class="data" width="100%">
		<tr>
			<td class="label" width="20%">{fieldLabel name="adjourned" required="true" key="editor.minutes.adjourned"}</td>
			<td class="value" width="80%"><input type="text" class="textField" name="adjourned" id="adjourned" size="20" value="{$adjourned|date_format:"%Y-%m-%d %I:%M %p"}" /></td>
		</tr>
		<tr>
			<td class="label" width="20%">{fieldLabel name="venue" required="true" key="editor.minutes.venue"}</td>
			<td class="value" width="80%"><input type="text" class="textField" name="venue" id="venue" size="20" value="{$venue}"/></td>
		</tr>
		<tr>
		 	<td class="label" width="20%">{translate key="editor.minutes.announcements"}</td>
		 	<td class="value" width="80%">
		 		<textarea name="announcements" id="announcements" rows="7" class="textArea">{$announcements}</textarea>
		 	</td>
		 </tr>
	</table>
</div>
<div class="separator"></div>
<br/>
<div id="attendance">
	<h2>Review Committee </h2>
	<table width="100%" class="listing" name="ercMembers">
			<tr><td colspan="5" class="headseparator">&nbsp;</td></tr>
		 	<tr>
			 	<td width="5%">{translate key="editor.minutes.absent"}</td>
		 		<td width="5%">{translate key="editor.minutes.present"}</td>
		 		<td width="20%">{translate key="editor.minutes.nameOfMember"}</td>
		 		<td width="20%">{translate key="editor.minutes.affiliationOfMember"}</td>
		 		<td width="50%" class="div_reason_of_absence" id="div_title_reason_of_absence">{translate key="editor.minutes.reasonOfAbsence"}</td>
		 	</tr>
		 	<tr><td colspan="5" class="headseparator">&nbsp;</td></tr>
		 	{assign var="isPresent" value="attendance"}
		 	{assign var="reason" value="reason"}
		 	{foreach from=$reviewers  item=user}
		 	{assign var="userId" value=$user->getId()}
		 	<tr>	
					<td width="5%">	
								<input type="radio"  class="absent" name="reviewer_attendance[{$userId}][attendance]" id="reviewer-isabsent-{$userId}" 
									{if $attendance[$userId][$isPresent]} == "absent" } checked="checked" {/if} value="absent"  />
					</td>
		 			<td width="5%">
								<input type="radio" class="present" name="reviewer_attendance[{$userId}][attendance]" id="reviewer-ispresent-{$userId}" 
									{if $attendance[$userId][$isPresent] == "present" } checked="checked" {/if} value="present" />
		 			</td>
					<td width="20%">
					 		<label for="attendance[{$userId}]">{$user->getSalutation} {$user->getFirstName()} {$user->getLastName()}</label></td>
					<td width="20%">
					 		{if $user->getLocalizedWproAffiliation() == "Yes"} {translate key="editor.reviewer.wproAffiliated"} {else} {translate key="editor.reviewer.nonWpro"} {/if} /
					 		{if $user->getLocalizedHealthAffiliation() == "Yes"} {translate key="editor.reviewer.healthAffiliated"} {else} {translate key="editor.reviewer.nonHealth"} {/if}					 		
					</td>
					<td width="50%" id="div_reason_of_absence_{$userId}" class="div_reason_of_absence">
					 			<input type="radio" name="reviewer_attendance[{$userId}][reason]" id="absent-{$userId}-duty-travel" value="Duty Travel" {if  $attendance[$userId][$reason] == "Duty Travel" } checked="checked"{/if} /><label for="duty_travel_{$user->getId()}">Duty Travel</label>
						 		<input type="radio" name="reviewer_attendance[{$userId}][reason]" id="absent-{$userId}-on-leave" value="On Leave" {if $attendance[$userId][$reason] == "On Leave" } checked="checked"{/if} /><label for="on_leave_{$user->getId()}">On Leave</label>
						 		<input type="radio" name="reviewer_attendance[{$userId}][reason]" id="absent-{$userId}-other-commitment" value="Other Commitment" {if  $attendance[$userId][$reason] == "Other Commitment" } checked="checked"{/if}/><label for="others_{$user->getId()}">Other Commitment</label>
						 		<input type="radio" name="reviewer_attendance[{$userId}][reason]" id="absent-{$userId}-unexcused" value="Unexcused" {if  $attendance[$userId][$reason] == "Unexcused" } checked="checked"{/if}/><label for="unexcused_{$user->getId()}">Unexcused</label>
					</td>
					<input type="hidden" name="areviewer_attendance[{$userId}][userId]" value="{$userId}">
			</tr>
			<tr><td colspan="5" class="separator"></td></tr>	
			{/foreach}	 	
			<tr><td colspan="5" class="endseparator">&nbsp;</td></tr>	
	</table> 
	<br/>
	<br/>
	<h2>Guests&nbsp;&nbsp;<input type="button" name="addGuest" id="addGuest" class="button" value="+" /></h2>
	<table class="listing" name="guests" id="guests" width="100%">
	{foreach from=$guestNames key=guestIndex item=guest}
		<tr>
		<td width='5%'>Name</td>
	 	<td width='15%'><input type='text' name='guestName[]' id='guestName[]' size='50' value="{$guest}" /></td>
		<td width='5%'>Affiliation</td>
	 	<td width='15%'><input type='text' name='guestAffiliation[]' id='guestAffiliation[]' size='50' value="{$guestAffiliations[$guestIndex]}" /></td>
		<td width='60%'></td>
		</tr>
	{/foreach}
	<tr></tr>
	</table>
	<div class="separator"></div>
		<br/><br/>
		<input type="button" value={translate key="common.back"} class="button" onclick="document.location.href='{url op="uploadMinutes" path=$meeting->getId() }'" />
		<input type="submit" onclick="return confirm('{translate|escape:"jsparam" key="minutes.confirm.submitAttendance"}')" value="Submit"  class="button defaultButton" name="submitAttendance"/>	 
	</div>
 </form>