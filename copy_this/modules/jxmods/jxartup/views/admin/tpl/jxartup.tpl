[{include file="headitem.tpl" title="GENERAL_ADMIN_TITLE"|oxmultilangassign box=" "}]
<link href="[{$oViewConf->getModuleUrl('jxartup','out/admin/src/jxartup.css')}]" type="text/css" rel="stylesheet">

<script type="text/javascript">
  if(top)
  {
    top.sMenuItem    = "[{ oxmultilang ident="mxmanageprod" }]";
    top.sMenuSubItem = "[{ oxmultilang ident="jxartup_menu" }]";
    top.sWorkArea    = "[{$_act}]";
    top.setTitle();
  }

function editThis( sID, sClass )
{
    [{assign var="shMen" value=1}]

    [{foreach from=$menustructure item=menuholder }]
      [{if $shMen && $menuholder->nodeType == XML_ELEMENT_NODE && $menuholder->childNodes->length }]

        [{assign var="shMen" value=0}]
        [{assign var="mn" value=1}]

        [{foreach from=$menuholder->childNodes item=menuitem }]
          [{if $menuitem->nodeType == XML_ELEMENT_NODE && $menuitem->childNodes->length }]
            [{ if $menuitem->getAttribute('id') == 'mxorders' }]

              [{foreach from=$menuitem->childNodes item=submenuitem }]
                [{if $submenuitem->nodeType == XML_ELEMENT_NODE && $submenuitem->getAttribute('cl') == 'admin_order' }]

                    if ( top && top.navigation && top.navigation.adminnav ) {
                        var _sbli = top.navigation.adminnav.document.getElementById( 'nav-1-[{$mn}]-1' );
                        var _sba = _sbli.getElementsByTagName( 'a' );
                        top.navigation.adminnav._navAct( _sba[0] );
                    }

                [{/if}]
              [{/foreach}]

            [{ /if }]
            [{assign var="mn" value=$mn+1}]

          [{/if}]
        [{/foreach}]
      [{/if}]
    [{/foreach}]

    var oTransfer = document.getElementById("transfer");
    oTransfer.oxid.value=sID;
    oTransfer.cl.value=sClass; /*'article';*/
    oTransfer.submit();
}

function showEditPopup( jxid, artid, arttitle, updatetime, jxdone, field1, value1, field2, value2, field3, value3 )
{
    // stop event propagation
    if (document.getElementById('popupEditWin').style.display == 'block')
        return;
    
    document.getElementById('popupEditWin').style.display = 'block';
    document.getElementById('grayout').style.display = 'block';
    document.getElementById('jxid').value = jxid;
    document.getElementById('jxartid').value = artid;
    document.getElementById('arttitle').value = arttitle;
    document.getElementById('updatetime').value = updatetime;
    document.getElementById('field1').value = field1;
    document.getElementById('value1').value = value1;
    document.getElementById('field2').value = field2;
    document.getElementById('value2').value = value2;
    document.getElementById('field3').value = field3;
    document.getElementById('value3').value = value3;
    document.getElementById('jxsubmit').style.display = 'inline-block';
    switchFields(false);

    if (jxid == '*NEW*') {
        document.getElementById('artidline').style.display = 'table-row';
        document.getElementById('jxdelete').style.display = 'none';
        document.getElementById('jxsubmit').innerHTML = '[{ oxmultilang ident="JXARTUP_CREATE" }]';
        document.getElementById('popupWinTitle').innerHTML = '[{ oxmultilang ident="JXARTUP_CREATE_TITLE" }]';
        document.getElementById('artuid').focus();
        document.getElementById('fnc').value = 'jxcreate';
    }
    else {
        document.getElementById('artidline').style.display = 'none';
        document.getElementById('jxdelete').style.display = 'block';
        document.getElementById('jxsubmit').innerHTML = '[{ oxmultilang ident="JXARTUP_SAVE" }]';
        document.getElementById('popupWinTitle').innerHTML = '[{ oxmultilang ident="JXARTUP_EDIT_TITLE" }]';
        document.getElementById('updatetime').focus();
        document.getElementById('fnc').value = 'jxsave';
    }
    if (jxdone == 1) {
        document.getElementById('jxdelete').style.display = 'none';
        document.getElementById('jxsubmit').style.display = 'none';
        switchFields(true);
    }
    return;
}

function showDeletePopup( filename )
{
    document.getElementById('popupDeleteWin').style.display = 'block';
    document.getElementById('grayout').style.display = 'block';
    document.getElementById('jxfile').value = filename;
    return;
}

function fillDateTime( elemId, timeValue )
{
    document.getElementById(elemId).value = timeValue;
    return;
}

function clearUrl()
{
    document.getElementById('artuid').value = document.getElementById('artuid').value.match(/'([^']+)'/)[1];
    return;
}

function switchFields( bVal )
{
    document.getElementById('arttitle').disabled = bVal;
    document.getElementById('updatetime').disabled = bVal;
    document.getElementById('field1').disabled = bVal;
    document.getElementById('value1').disabled = bVal;
    document.getElementById('field2').disabled = bVal;
    document.getElementById('value2').disabled = bVal;
    document.getElementById('field3').disabled = bVal;
    document.getElementById('value3').disabled = bVal;
    return;
}

</script>

    [{assign var="iconPath" value=$oViewConf->getModuleUrl('jxartup','out/admin/src/bg') }]

    <h1>[{ oxmultilang ident="JXARTUP_TITLE" }]</h1>
    <div style="position:absolute;top:4px;right:8px;color:gray;font-size:0.9em;border:1px solid gray;border-radius:3px;">&nbsp;[{$sModuleId}]&nbsp;[{$sModuleVersion}]&nbsp;</div>
    <br clear="all" />

    
    <div id="popupEditWin" class="jxpopupwin jxpopupfixed" style="top:20%;width:600px;display:none;">
        <div style="background:#3960ab;color:#fff;padding:4px;">
            <span id="popupWinTitle" style="font-weight:bold;">[{ oxmultilang ident="JXARTUP_EDIT_TITLE" }]</span>
        </div>
        <div class="jxpopupclose" onclick="document.getElementById('popupEditWin').style.display='none';document.getElementById('grayout').style.display='none';">
            <div style="height:3px;"></div>
            <span>X</span>
        </div>
        <div class="jxpopupcontent">
            <form name="jxedit" id="jxedit" action="[{ $oViewConf->selflink }]" method="post">
                [{ $oViewConf->hiddensid }]
                <input type="hidden" name="cl" value="jxartup">
                <input type="hidden" name="fnc" id="fnc" value="jxsave">
                [{*<input type="hidden" name="jxid" id="jxid" value="">*}]
                <input type="hidden" name="jxid" id="jxid" value="">
                <input type="hidden" name="jxartid" id="jxartid" value="">

                <br />
                <table>
                    <tr id="artidline" style="display:none;">
                        <td><label for="artuid">[{ oxmultilang ident="JXARTUP_PRODUCTID" }]</label></td>
                        <td><input type="text" name="artuid" id="artuid" size="40" value="" onchange="clearUrl();" onkeyup="clearUrl();" /></td>
                    </tr>
                    <tr>
                        <td><label for="arttitle">[{ oxmultilang ident="JXARTUP_PRODUCT" }]</label></td>
                        <td><input type="text" name="arttitle" id="arttitle" size="40" value="nofilename" disabled="disabled" /></td>
                    </tr>
                    <tr>
                        <td><label for="updatetime">[{ oxmultilang ident="JXARTUP_DATETIME" }]</label></td>
                        <td>
                            <input type="text" name="updatetime" id="updatetime" size="20" />&nbsp;
                            <a href="#" onclick="fillDateTime('updatetime','[{$smarty.now|date_format:"%Y-%m-%d"|cat:" 00:00:00"}]');" title="[{ oxmultilang ident="JXARTUP_TODAY_TITLE" }]" style="text-decoration:underline;">[{ oxmultilang ident="JXARTUP_TODAY_ABBR" }]</a>&nbsp;
                            <a href="#" onclick="fillDateTime('updatetime','[{"tomorrow"|date_format:"%Y-%m-%d"|cat:" 00:00:00"}]');" title="[{ oxmultilang ident="JXARTUP_TOMORROW_TITLE" }]" style="text-decoration:underline;">[{ oxmultilang ident="JXARTUP_TOMORROW_ABBR" }]</a>&nbsp;
                            <a href="#" onclick="fillDateTime('updatetime','[{"+2 days"|date_format:"%Y-%m-%d"|cat:" 00:00:00"}]');" title="[{ oxmultilang ident="JXARTUP_2DAYS_TITLE" }]" style="text-decoration:underline;">[{ oxmultilang ident="JXARTUP_2DAYS_ABBR" }]</a>&nbsp;
                            <a href="#" onclick="fillDateTime('updatetime','[{"next saturday"|date_format:"%Y-%m-%d"|cat:" 00:00:00"}]');" title="[{ oxmultilang ident="JXARTUP_NXTSAT_TITLE" }]" style="text-decoration:underline;">[{ oxmultilang ident="JXARTUP_NXTSAT_ABBR" }]</a>&nbsp;
                            <a href="#" onclick="fillDateTime('updatetime','[{"next monday"|date_format:"%Y-%m-%d"|cat:" 00:00:00"}]');" title="[{ oxmultilang ident="JXARTUP_NXTMON_TITLE" }]" style="text-decoration:underline;">[{ oxmultilang ident="JXARTUP_NXTMON_ABBR" }]</a>&nbsp;
                            <a href="#" onclick="fillDateTime('updatetime','[{"first day of next month"|date_format:"%Y-%m-%d"|cat:" 00:00:00"}]');" title="[{ oxmultilang ident="JXARTUP_FIRSTDAY_TITLE" }]" style="text-decoration:underline;">[{ oxmultilang ident="JXARTUP_FIRSTDAY_ABBR" }]</a>&nbsp;
                            <a href="#" onclick="fillDateTime('updatetime','[{"last day of next month"|date_format:"%Y-%m-%d"|cat:" 23:59:59"}]');" title="[{ oxmultilang ident="JXARTUP_LASTDAY_TITLE" }]" style="text-decoration:underline;">[{ oxmultilang ident="JXARTUP_LASTDAY_ABBR" }]</a>&nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td><label for="field1">[{ oxmultilang ident="JXARTUP_FIELDS" }]</label></td>
                        <td>
                            <select name="field1" id="field1">
                                <option value="none"></option>
                                [{foreach key=sField name=selbox item=sType from=$aFields}]
                                    [{assign var="sOptText" value="JXARTUP_"|cat:$sField}]
                                    <option value="[{$sField}]">[{ oxmultilang ident=$sOptText }]</option>
                                [{/foreach}]
                            </select>
                            &nbsp;&equals;&gt;&nbsp;
                            <input type="text" name="value1" id="value1" size="40" value="" />
                        </td>
                    </tr>
                    <tr>
                        <td> </td>
                        <td>
                            <select name="field2" id="field2">
                                <option value="none"></option>
                                [{foreach key=sField name=selbox item=sType from=$aFields}]
                                    [{assign var="sOptText" value="JXARTUP_"|cat:$sField}]
                                    <option value="[{$sField}]">[{ oxmultilang ident=$sOptText }]</option>
                                [{/foreach}]
                            </select>
                            &nbsp;&equals;&gt;&nbsp;
                            <input type="text" name="value2" id="value2" size="40" value="" />
                        </td>
                    </tr>
                    <tr>
                        <td> </td>
                        <td>
                            <select name="field3" id="field3">
                                <option value="none"></option>
                                [{foreach key=sField name=selbox item=sType from=$aFields}]
                                    [{assign var="sOptText" value="JXARTUP_"|cat:$sField}]
                                    <option value="[{$sField}]">[{ oxmultilang ident=$sOptText }]</option>
                                [{/foreach}]
                            </select>
                            &nbsp;&equals;&gt;&nbsp;
                            <input type="text" name="value3" id="value3" size="40" value="" />
                        </td>
                    </tr>
                    <tr>
                        <td><label>[{ oxmultilang ident="JXARTUP_OPTIONS" }]</label></td>
                        <td>
                            <input type="checkbox" name="inheritprices" id="inheritprices" size="20" />
                            <label for="inheritprices">[{ oxmultilang ident="JXARTUP_INHERITPRICES" }]</label>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" align="right"> </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="redbtn"><button type="button" id="jxdelete" onclick="document.getElementById('fnc').value='jxdelete';document.getElementById('jxedit').submit();">[{ oxmultilang ident="JXARTUP_DELETE" }]</button></div>
                        </td>
                        <td align="right">
                            <button type="submit" id="jxsubmit" onclick="">[{ oxmultilang ident="JXARTUP_SAVE" }]</button>
                            &nbsp;
                            <button type="reset" id="jxreset" onclick="document.getElementById('popupEditWin').style.display='none';document.getElementById('grayout').style.display='none';">[{ oxmultilang ident="JXARTUP_CANCEL" }]</button>
                        </td>
                    </tr>
                </table>
            </form>
        </div>
    </div>
    

    <div id="grayout" class="jxgrayout" style="display:none;"> </div>
    
    
    <form name="transfer" id="transfer" action="[{ $shop->selflink }]" method="post">
        [{ $shop->hiddensid }]
        <input type="hidden" name="oxid" value="[{ $oxid }]">
        <input type="hidden" name="cl" value="article" size="40">
        <input type="hidden" name="updatelist" value="1">
    </form>
        
        
<form name="jxdisplay" id="jxdisplay" action="[{ $oViewConf->selflink }]" method="post">
    [{ $oViewConf->hiddensid }]
    <input type="hidden" name="cl" value="jxartup">
    <input type="hidden" name="fnc" id="dspfnc" value="">
    <input type="hidden" name="jxdisptype" id="jxdisptype" value="">

    <div class="greenbtn" style="display:inline-block;">
        <button type="button" 
                onclick="showEditPopup('*NEW*','','','','','','','','','','');">
            <span type="font-weight:bold;">&#10010;</span> <b>[{ oxmultilang ident="JXARTUP_CREATE" }]</b>
        </button>
    </div>
    
    &nbsp;&nbsp;&nbsp;&nbsp;

    <div class="litegraybtn" style="display:inline-block;">
        <a href="[{$oViewConf->getModuleUrl('jxartup','core/jxartup_cron.php')}]" target="_blank">
            <button type="button" style="font-weight:bold;color:#444;" >
                Update now
            </button>
        </a>
    </div>
    
    &nbsp;&nbsp;&nbsp;&nbsp;

    <div class="litegraybtn" style="display:inline-block;">
        <button type="submit" 
                onclick="document.getElementById('dspfnc').value='jxsetdisplay';
                            document.getElementById('jxdisptype').value='list';
                            document.getElementById('jxdisplay').submit();">
            <img src="[{$iconPath}]/liste.png" style="position:relative;left:0px;top:2px;">
        </button>
    </div>

    <div class="litegraybtn" style="display:inline-block;">
        <button type="submit" 
                onclick="document.getElementById('dspfnc').value='jxsetdisplay';
                            document.getElementById('jxdisptype').value='calendar';
                            document.getElementById('jxdisplay').submit();">
            <img src="[{$iconPath}]/calendar.png" style="position:relative;left:0px;top:2px;">
        </button>
    </div>
</form>

<br clear="all" />
        
    [{if $jxErr != ""}]
        <div style="margin-left:10px; border:1px #dd0000 solid; border-radius:3px; padding:6px; background-color:#ffdddd; display:inline-block;">
            <span style="color:#dd0000; font-size:1.1em;"><b>[{ oxmultilang ident="JXARTUP_ERR" }]:</b> [{ oxmultilang ident="JXARTUP_"|cat:$jxErr }]</span>
        </div>
    [{/if}]
    
    
    <div id="liste" style="[{if $sDisplayType!="calendar"}]display:block;[{else}]display:none;[{/if}]">
        <table cellspacing="0" cellpadding="0" border="0" width="99%">
        <tr>
            [{ assign var="headStyle" value="border-bottom:1px solid #C8C8C8; font-weight:bold;" }]
            <td class="listfilter first" style="[{$headStyle}]">
                <div class="r1"><div class="b1">
                    [{ oxmultilang ident="JXARTUP_STATUS" }]
                </div></div>
            </td>
            <td class="listfilter" style="[{$headStyle}]">
                <div class="r1"><div class="b1">
                    [{ oxmultilang ident="JXARTUP_ARTNUM" }]
                </div></div>
            </td>
            <td class="listfilter" style="[{$headStyle}]">
                <div class="r1"><div class="b1">
                    [{ oxmultilang ident="JXARTUP_ARTTITLE" }]
                </div></div>
            </td>
            <td class="listfilter" style="[{$headStyle}]">
                <div class="r1"><div class="b1">
                    [{ oxmultilang ident="JXARTUP_DATE" }]
                </div></div>
            </td>
            <td class="listfilter" style="[{$headStyle}]">
                <div class="r1"><div class="b1">
                    [{ oxmultilang ident="JXARTUP_CHANGES" }]
                </div></div>
            </td>
        </tr>

        [{foreach key=phase name=timephase item=aPhase from=$aUpdates}]
            [{if $aPhase|@count > 0}]
                [{assign var="phasetitle" value="JXARTUP_"|cat:$phase}]
                <tr><td colspan="4" style="font-size:1.3em;font-weight:bold;padding-top:12px;padding-bottom:4px;">[{ oxmultilang ident=$phasetitle }]</td></tr>
            [{/if}]
            [{foreach name=inner item=sUpdate from=$aPhase}]
            <tr>
                [{ cycle values="listitem,listitem2" assign="listclass" }]
                <td class="[{$listclass}]">
                    [{if $sUpdate.jxdone == 1}]
                        [{assign var="iconFile" value="done"}]
                    [{else}]
                        [{assign var="iconFile" value="planned"}]
                    [{/if}]
                    <img src="[{$iconPath}]/[{$iconFile}].png" style="position:relative;left:2px;top:3px;">&nbsp;
                </td>
                <td class="[{$listclass}]">
                    <a href="#" 
                       onclick="showEditPopup('[{$sUpdate.jxid}]', '[{$sUpdate.jxartid}]',
                                   '[{$sUpdate.oxtitle|escape:"quotes"}]','[{$sUpdate.jxupdatetime}]','[{$sUpdate.jxdone}]',
                                   '[{$sUpdate.jxfield1}]','[{$sUpdate.jxvalue1|escape:"quotes"}]',
                                   '[{$sUpdate.jxfield2}]','[{$sUpdate.jxvalue2|escape:"quotes"}]',
                                   '[{$sUpdate.jxfield3}]','[{$sUpdate.jxvalue3|escape:"quotes"}]');">
                        [{$sUpdate.oxartnum}]
                    </a>
                </td>
                <td class="[{$listclass}]">
                    <a href="#" 
                       onclick="showEditPopup('[{$sUpdate.jxid}]', '[{$sUpdate.jxartid}]',
                                   '[{$sUpdate.oxtitle|escape:"quotes"}]','[{$sUpdate.jxupdatetime}]','[{$sUpdate.jxdone}]',
                                   '[{$sUpdate.jxfield1}]','[{$sUpdate.jxvalue1|escape:"quotes"}]',
                                   '[{$sUpdate.jxfield2}]','[{$sUpdate.jxvalue2|escape:"quotes"}]',
                                   '[{$sUpdate.jxfield3}]','[{$sUpdate.jxvalue3|escape:"quotes"}]');">
                        [{$sUpdate.oxtitle}]
                    </a>
                </td>
                <td class="[{$listclass}]">
                    &nbsp;
                    <a href="#" 
                       onclick="showEditPopup('[{$sUpdate.jxid}]', '[{$sUpdate.jxartid}]',
                                   '[{$sUpdate.oxtitle|escape:"quotes"}]','[{$sUpdate.jxupdatetime}]','[{$sUpdate.jxdone}]',
                                   '[{$sUpdate.jxfield1}]','[{$sUpdate.jxvalue1|escape:"quotes"}]',
                                   '[{$sUpdate.jxfield2}]','[{$sUpdate.jxvalue2|escape:"quotes"}]',
                                   '[{$sUpdate.jxfield3}]','[{$sUpdate.jxvalue3|escape:"quotes"}]');">
                        [{$sUpdate.jxupdatetime}]
                    </a>
                </td>
                <td class="[{$listclass}]">
                    <a href="#" 
                       onclick="showEditPopup('[{$sUpdate.jxid}]', '[{$sUpdate.jxartid}]',
                                   '[{$sUpdate.oxtitle|escape:"quotes"}]','[{$sUpdate.jxupdatetime}]','[{$sUpdate.jxdone}]',
                                   '[{$sUpdate.jxfield1}]','[{$sUpdate.jxvalue1|escape:"quotes"}]',
                                   '[{$sUpdate.jxfield2}]','[{$sUpdate.jxvalue2|escape:"quotes"}]',
                                   '[{$sUpdate.jxfield3}]','[{$sUpdate.jxvalue3|escape:"quotes"}]');">
                        <b>[{if $sUpdate.jxfield1 != "none"}][{ oxmultilang ident="JXARTUP_"|cat:$sUpdate.jxfield1}]</b> =&gt; [{$sUpdate.jxvalue1}][{/if}]
                        <b>[{if $sUpdate.jxfield2 != "none"}]<br>[{ oxmultilang ident="JXARTUP_"|cat:$sUpdate.jxfield2}]</b> =&gt; [{$sUpdate.jxvalue2}][{/if}]
                        <b>[{if $sUpdate.jxfield3 != "none"}]<br>[{ oxmultilang ident="JXARTUP_"|cat:$sUpdate.jxfield3}]</b> =&gt; [{$sUpdate.jxvalue3}][{/if}]
                    </a>
                </td>
            </tr>
        [{/foreach}]
        [{/foreach}]
        [{*</tbody>*}]

        </table>
    </div>
        
<div class="jxcal" id="calendar" style="[{if $sDisplayType=="calendar"}]display:block;[{else}]display:none;[{/if}]">        
[{assign var="i" value=1}]
[{assign var="thisMonth" value=$smarty.now|date_format:"%m"}]
<table>
    <tr>
    [{foreach key=day name=alldays item=aDay from=$aDays}]
        <td [{if $aDay.active}][{if $day==$smarty.now|date_format:"%Y-%m-%d"}]class="jxcaltoday"[{elseif $thisMonth!=$day|date_format:"%m"}]class="jxcalnxtmon"[{else}]class="jxcalact"[{/if}][{else}]class="jxcalgray"[{/if}]
                onclick="showEditPopup('*NEW*', '', '','[{$day}] 00:00:00', '0', '','', '','', '','');">
            <div [{if $aDay.active}]class="jxcaldaynum"[{else}]class="jxcaldaynumgray"[{/if}]>[{$aDay.day}]</div>
            [{if $aDay.data|@count > 0}]
                [{foreach name=job item=aJob from=$aDay.data}]
                <div>
                    [{if $aJob.jxdone == 1}]
                        [{assign var="iconFile" value="done"}]
                    [{else}]
                        [{assign var="iconFile" value="planned"}]
                    [{/if}]
                    <img src="[{$iconPath}]/[{$iconFile}].png" style="position:relative;left:2px;top:3px;">&nbsp;
                    <a href="#" 
                       onclick="showEditPopup('[{$aJob.jxid}]', '[{$aJob.jxartid}]',
                                   '[{$aJob.oxtitle|escape:"quotes"}]','[{$aJob.jxupdatetime}]','[{$aJob.jxdone}]',
                                   '[{$aJob.jxfield1}]','[{$aJob.jxvalue1|escape:"quotes"}]',
                                   '[{$aJob.jxfield2}]','[{$aJob.jxvalue2|escape:"quotes"}]',
                                   '[{$aJob.jxfield3}]','[{$aJob.jxvalue3|escape:"quotes"}]');"
                        title="[{$aJob.jxupdatetime|date_format:"%H:%M:%S"}]
[{if $aJob.jxfield1 != "none"}][{ oxmultilang ident="JXARTUP_"|cat:$aJob.jxfield1}] =&gt; [{$aJob.jxvalue1}][{/if}]
[{if $aJob.jxfield2 != "none"}][{ oxmultilang ident="JXARTUP_"|cat:$aJob.jxfield2}] =&gt; [{$aJob.jxvalue2}][{/if}]
[{if $aJob.jxfield3 != "none"}][{ oxmultilang ident="JXARTUP_"|cat:$aJob.jxfield3}] =&gt; [{$aJob.jxvalue3}][{/if}]
">
                    [{$aJob.oxtitle}]
                    </a>
                </div>
                    [{/foreach}]
            [{/if}]
        </td>
        [{if $i == 7}]
            [{assign var="i" value=0}]
            </tr>
            <tr>
        [{/if}]
        [{assign var="i" value=$i+1}]
    [{/foreach}]
    </tr>
</table>
</div>