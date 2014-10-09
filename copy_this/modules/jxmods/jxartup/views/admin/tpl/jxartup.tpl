[{*debug*}]
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

function showEditPopup( jxid, artid, arttitle, updatetime, field1, value1, field2, value2, field3, value3 )
{
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
    //alert(jxid == '*NEW*');
    if (jxid == '*NEW*') {
        document.getElementById('artidline').style.display = 'table-row';
        document.getElementById('jxdelete').style.display = 'none';
        document.getElementById('jxsubmit').innerHTML = '[{ oxmultilang ident="JXARTUP_CREATE" }]';
        document.getElementById('popupWinTitle').innerHTML = '[{ oxmultilang ident="JXARTUP_CREATE_TITLE" }]';
        document.getElementById('fnc').value = 'jxcreate';
    }
    else {
        document.getElementById('artidline').style.display = 'none';
        document.getElementById('jxdelete').style.display = 'block';
        document.getElementById('jxsubmit').innerHTML = '[{ oxmultilang ident="JXARTUP_SAVE" }]';
        document.getElementById('popupWinTitle').innerHTML = '[{ oxmultilang ident="JXARTUP_EDIT_TITLE" }]';
        document.getElementById('fnc').value = 'jxsave';
    }
}

function showDeletePopup( filename )
{
    document.getElementById('popupDeleteWin').style.display = 'block';
    document.getElementById('grayout').style.display = 'block';
    document.getElementById('jxfile').value = filename;
}

function fillDateTime( elemId, timeValue )
{
    document.getElementById(elemId).value = timeValue;
}

function clearUrl()
{
    document.getElementById('artuid').value = document.getElementById('artuid').value.match(/'([^']+)'/)[1];
}

</script>

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
                        <td><label for="artuid">[{ oxmultilang ident="JXARTUP_PRODUCT" }]-UID</label></td>
                        <td><input type="text" name="artuid" id="artuid" size="40" value="" onchange="clearUrl();" onkeyup="clearUrl();" /></td>
                    </tr>
                    <tr>
                        <td><label for="arttitle">[{ oxmultilang ident="JXARTUP_PRODUCT" }]</label></td>
                        <td><input type="text" name="arttitle" id="arttitle" size="40" value="nofilename" disabled="disabled" /></td>
                    </tr>
                    <tr>
                        <td><label for="updatetime">[{ oxmultilang ident="JXARTUP_DATETIME" }]</label></td>
                        <td>
                            <input type="text" name="updatetime" id="updatetime" size="20" autofocus />&nbsp;
                            <a href="#" onclick="fillDateTime('updatetime','[{"yesterday"|date_format:"%Y-%m-%d"|cat:" 23:59:59"}]');" title="[{ oxmultilang ident="JXARTUP_TODAYMIDNIGHT_TITLE" }]" style="text-decoration:underline;">[{ oxmultilang ident="JXARTUP_TODAYMIDNIGHT_ABBR" }]</a>&nbsp;
                            <a href="#" onclick="fillDateTime('updatetime','[{$smarty.now|date_format:"%Y-%m-%d"|cat:" 23:59:59"}]');" title="[{ oxmultilang ident="JXARTUP_TOMORROWMIDNIGHT_TITLE" }]" style="text-decoration:underline;">[{ oxmultilang ident="JXARTUP_TOMORROWMIDNIGHT_ABBR" }]</a>&nbsp;
                            <a href="#" onclick="fillDateTime('updatetime','[{"tomorrow"|date_format:"%Y-%m-%d"|cat:" 23:59:59"}]');" title="[{ oxmultilang ident="JXARTUP_2DAYSMIDNIGHT_TITLE" }]" style="text-decoration:underline;">[{ oxmultilang ident="JXARTUP_2DAYSMIDNIGHT_ABBR" }]</a>&nbsp;
                            <a href="#" onclick="fillDateTime('updatetime','[{"next friday"|date_format:"%Y-%m-%d"|cat:" 23:59:59"}]');" title="[{ oxmultilang ident="JXARTUP_NXTFRIMIDNIGHT_TITLE" }]" style="text-decoration:underline;">[{ oxmultilang ident="JXARTUP_NXTFRIMIDNIGHT_ABBR" }]</a>&nbsp;
                            <a href="#" onclick="fillDateTime('updatetime','[{"next sunday"|date_format:"%Y-%m-%d"|cat:" 23:59:59"}]');" title="[{ oxmultilang ident="JXARTUP_NXTSUNMIDNIGHT_TITLE" }]" style="text-decoration:underline;">[{ oxmultilang ident="JXARTUP_NXTSUNMIDNIGHT_ABBR" }]</a>&nbsp;
                            <a href="#" onclick="fillDateTime('updatetime','[{"last day of this month"|date_format:"%Y-%m-%d"|cat:" 23:59:59"}]');" title="[{ oxmultilang ident="JXARTUP_FIRSTMIDNIGHT_TITLE" }]" style="text-decoration:underline;">[{ oxmultilang ident="JXARTUP_FIRSTMIDNIGHT_ABBR" }]</a>&nbsp;
                            <a href="#" onclick="fillDateTime('updatetime','[{"last day of next month"|date_format:"%Y-%m-%d"|cat:" 23:59:59"}]');" title="[{ oxmultilang ident="JXARTUP_LASTMIDNIGHT_TITLE" }]" style="text-decoration:underline;">[{ oxmultilang ident="JXARTUP_LASTMIDNIGHT_ABBR" }]</a>&nbsp;
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
                            <input type="checkbox" name="inheritprices" id="inheritprices" size="20" autofocus />
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
        
        
    <div class="greenbtn">
        <button type="button" 
                onclick="showEditPopup('*NEW*','','','','','','','','','');">
            <span type="font-weight:bold;">&#10010;</span> <b>[{ oxmultilang ident="JXARTUP_CREATE" }]</b>
        </button>
    </div>
    

<form name="jxartup" id="jxartup" action="[{ $oViewConf->selflink }]" method="post">
    <p>
        [{ $oViewConf->hiddensid }]
        <input type="hidden" name="cl" value="jxartup">
        <input type="hidden" name="fnc" value="">
        <input type="hidden" name="oxid" value="[{ $oxid }]">
        <input type="hidden" name="jxactdir" value="[{$sActPath}]">
        <input type="hidden" name="jxsectiondir" value="[{$sSectionPath}]">
        <input type="hidden" name="jxsortby" value="[{$sSortBy}]">
        <input type="hidden" name="jxsubdir" value="">
    </p>
    
    <div id="liste">
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

        [{assign var="iconPath" value=$oViewConf->getModuleUrl('jxartup','out/admin/src/bg') }]
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
                                   '[{$sUpdate.oxtitle|escape:"quotes"}]','[{$sUpdate.jxupdatetime}]',
                                   '[{$sUpdate.jxfield1}]','[{$sUpdate.jxvalue1|escape:"quotes"}]',
                                   '[{$sUpdate.jxfield2}]','[{$sUpdate.jxvalue2|escape:"quotes"}]',
                                   '[{$sUpdate.jxfield3}]','[{$sUpdate.jxvalue3|escape:"quotes"}]');">
                        [{$sUpdate.oxartnum}]
                    </a>
                </td>
                <td class="[{$listclass}]">
                    <a href="#" 
                       onclick="showEditPopup('[{$sUpdate.jxid}]', '[{$sUpdate.jxartid}]',
                                   '[{$sUpdate.oxtitle|escape:"quotes"}]','[{$sUpdate.jxupdatetime}]',
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
                                   '[{$sUpdate.oxtitle|escape:"quotes"}]','[{$sUpdate.jxupdatetime}]',
                                   '[{$sUpdate.jxfield1}]','[{$sUpdate.jxvalue1|escape:"quotes"}]',
                                   '[{$sUpdate.jxfield2}]','[{$sUpdate.jxvalue2|escape:"quotes"}]',
                                   '[{$sUpdate.jxfield3}]','[{$sUpdate.jxvalue3|escape:"quotes"}]');">
                        [{$sUpdate.jxupdatetime}]
                    </a>
                </td>
                <td class="[{$listclass}]">
                    <a href="#" 
                       onclick="showEditPopup('[{$sUpdate.jxid}]', '[{$sUpdate.jxartid}]',
                                   '[{$sUpdate.oxtitle|escape:"quotes"}]','[{$sUpdate.jxupdatetime}]',
                                   '[{$sUpdate.jxfield1}]','[{$sUpdate.jxvalue1|escape:"quotes"}]',
                                   '[{$sUpdate.jxfield2}]','[{$sUpdate.jxvalue2|escape:"quotes"}]',
                                   '[{$sUpdate.jxfield3}]','[{$sUpdate.jxvalue3|escape:"quotes"}]');">
                        <b>[{ oxmultilang ident="JXARTUP_"|cat:$sUpdate.jxfield1}]</b> =&gt; [{$sUpdate.jxvalue1}]
                        <b>[{if $sUpdate.jxfield2}]<br>[{ oxmultilang ident="JXARTUP_"|cat:$sUpdate.jxfield2}]</b> =&gt; [{$sUpdate.jxvalue2}][{/if}]
                        <b>[{if $sUpdate.jxfield3}]<br>[{ oxmultilang ident="JXARTUP_"|cat:$sUpdate.jxfield3}]</b> =&gt; [{$sUpdate.jxvalue3}][{/if}]
                    </a>
                </td>
            </tr>
        [{/foreach}]
        [{/foreach}]
        [{*</tbody>*}]

        </table>
    </div>
</form>
