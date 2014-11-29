<?php

/*
 *    This file is part of the module jxArtUp for OXID eShop Community Edition.
 *
 *    The module jxArtUp for OXID eShop Community Edition is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 3 of the License, or
 *    (at your option) any later version.
 *
 *    The module jxArtUp for OXID eShop Community Edition is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with OXID eShop Community Edition.  If not, see <http://www.gnu.org/licenses/>.
 *
 * @link      https://github.com/job963/jxArtUp
 * @license   http://www.gnu.org/licenses/gpl-3.0.html GPL v3 or later
 * @copyright (C) Joachim Barthel 2012-2014 
 *
 */
 
class jxartup extends oxAdminView
{
    protected $_sThisTemplate = "jxartup.tpl";
    
    protected $aFields = array( 'OXPRICE' => 'FLOAT', 
                                'OXTITLE' => 'CHAR', 
                                'OXACTIVE' => 'INT', 
                                'OXBPRICE' => 'FLOAT', 
                                'OXTPRICE' => 'FLOAT', 
                                'OXPRICEA' => 'FLOAT', 
                                'OXPRICEB' => 'FLOAT', 
                                'OXPRICEC' => 'FLOAT', 
                                'OXFREESHIPPING' => 'INT' );
    protected $aCalendar = array();
    protected $jxErr = "";

/*
 * 
 */    
    public function render()
    {
        parent::render();
        
        $myConfig = oxRegistry::get("oxConfig");
        $sShopPath = $myConfig->getConfigParam("sShopDir");
                
        $aUpdates = $this->_getAllUpdates();
        
        $this->aCalendar = $this->_createCalendarTable();
        $this->_fillCalendar();
        
        $oModule = oxNew('oxModule');
        $oModule->load('jxartup');
        $this->_aViewData["sModuleId"] = $oModule->getId();
        $this->_aViewData["sModuleVersion"] = $oModule->getInfo('version');
        
        $this->_aViewData["sDisplayType"] = $myConfig->getConfigParam("sJxArtUpDisplayType");
        
        $this->_aViewData["aFields"] = $this->aFields;
        $this->_aViewData["jxErr"] = $this->jxErr;
        
        $this->_aViewData["aUpdates"] = $aUpdates;
        $this->_aViewData["aDays"] = $this->aCalendar;

        return $this->_sThisTemplate;
    }
    
    
/*
 * Save changes of a job
 */
    public function jxsave ()
    {
        $myConfig = oxRegistry::get("oxConfig");
                
        $sJxId = $this->getConfig()->getRequestParameter( "jxid" );
        $sArtId = $this->getConfig()->getRequestParameter( "jxartid" );
        
        $sUpdTime = $this->getConfig()->getRequestParameter( "updatetime" );
        $sField1 = $this->getConfig()->getRequestParameter( "field1" );
        $sField2 = $this->getConfig()->getRequestParameter( "field2" );
        $sField3 = $this->getConfig()->getRequestParameter( "field3" );
        $sValue1 = $this->getConfig()->getRequestParameter( "value1" );
        $sValue2 = $this->getConfig()->getRequestParameter( "value2" );
        $sValue3 = $this->getConfig()->getRequestParameter( "value3" );
        $sInherit = $this->getConfig()->getRequestParameter( "inheritvalues" );
        
        $oDb = oxDb::getDb( oxDB::FETCH_MODE_ASSOC );
        
        $aSet = array();
        for ($i=1; $i<=3; $i++) {
            $sField = $this->getConfig()->getRequestParameter( "field{$i}" );
            if (empty($sField) === TRUE)
                $sField = 'none'; // some browsers aren't returning as value 'none'
            
            if ($sField != 'none')
                $sTmpType = $this->aFields[$sField];
            else 
                $sTmpType = '';

            $sValue = $this->getConfig()->getRequestParameter( "value{$i}" );
            if ($this->aFields[$sField] == 'FLOAT')
                $sValue = $this->_formatFloat($sValue);
            
            if ($sField == 'none')
                $sValue = '';
            if ($sValue == '')
                $sField = '';
            
            $sTmpValue = $oDb->quote($sValue);

            array_push( $aSet, "jxfield{$i} = '{$sField}', jxtype{$i} = '{$sTmpType}', jxvalue{$i} = {$sTmpValue} " );
        }
        array_push( $aSet, "jxupdatetime = '{$sUpdTime}'" );
        if ($sInherit == 'on')
            array_push( $aSet, "jxinherit = 1" );
        else
            array_push( $aSet, "jxinherit = 0" );
        
        $sSql = "UPDATE jxarticleupdates SET " . implode( ',', $aSet ) . " WHERE jxid = '{$sJxId}'";
        
        $oDb->execute($sSql);
        
        return;
    }
    
    
/*
 * Create a new job
 */
    public function jxcreate ()
    {
        $myConfig = oxRegistry::get("oxConfig");
                
        $sJxId = oxUtilsObject::getInstance()->generateUID();
        $sArtId = $this->getConfig()->getRequestParameter( "artuid" );
        
        $sUpdTime = $this->getConfig()->getRequestParameter( "updatetime" );
        $sField1 = $this->getConfig()->getRequestParameter( "field1" );
        $sField2 = $this->getConfig()->getRequestParameter( "field2" );
        $sField3 = $this->getConfig()->getRequestParameter( "field3" );
        $sValue1 = $this->getConfig()->getRequestParameter( "value1" );
        $sValue2 = $this->getConfig()->getRequestParameter( "value2" );
        $sValue3 = $this->getConfig()->getRequestParameter( "value3" );
        $sInherit = $this->getConfig()->getRequestParameter( "inheritvalues" );
        
        $oDb = oxDb::getDb( oxDB::FETCH_MODE_ASSOC );
        
        $sSql = "SELECT oxid FROM oxarticles WHERE oxid = '{$sArtId}' OR oxartnum = '{$sArtId}' ";
        $sArtUid = $oDb->getOne( $sSql, false, false );
        if ($sArtUid == "") {
            $this->jxErr = "ERR_ID_NOT_FOUND";
            return;
        }
        
        $aCol = array();
        $aVal = array();
        array_push( $aCol, "jxid, jxartid, jxupdatetime, jxdone " );
        array_push( $aVal, "'{$sJxId}', '{$sArtUid}', '{$sUpdTime}', 0 " );
        
        for ($i=1; $i<=3; $i++) {
            $sField = $this->getConfig()->getRequestParameter( "field{$i}" );
            if (empty($sField) === TRUE)
                $sField = 'none'; // some browsers aren't returning as value 'none'

            if ($sField != 'none')
                $sTmpType = $this->aFields[$sField];
            else
                $sTmpType = '';
            
            $sValue = $this->getConfig()->getRequestParameter( "value{$i}" );
            if ($this->aFields[$sField] == 'FLOAT')
                $sValue = $this->_formatFloat($sValue);
            $sTmpValue = $oDb->quote($sValue);
            
            array_push( $aCol, "jxfield{$i}, jxtype{$i}, jxvalue{$i} " );
            array_push( $aVal, "'{$sField}', '{$sTmpType}', {$sTmpValue} " );
        }
        if ($sInherit == 'on') {
            array_push( $aCol, 'jxinherit' );
            array_push( $aVal, '1' );
        }
        else {
            array_push( $aCol, 'jxinherit' );
            array_push( $aVal, '0' );
        }
        
        $sSql = "INSERT INTO jxarticleupdates (" . implode( ',', $aCol ) . ") VALUES (" . implode( ',', $aVal ) . ") ";
        
        $oDb->execute($sSql);
        
        return;
    }
    
    
/*
 * Delete an existing job
 */
    public function jxdelete ()
    {
        $myConfig = oxRegistry::get("oxConfig");
                
        $sJxId = $this->getConfig()->getRequestParameter( "jxid" );
        
        $oDb = oxDb::getDb( oxDB::FETCH_MODE_ASSOC );
        
        $sSql = "DELETE FROM jxarticleupdates WHERE jxid = '{$sJxId}' ";
        
        $oDb->execute($sSql);
        
        return;
    }
    
    
/*
 * Save the choosen display mode
 */
    public function jxsetdisplay ()
    {
        $sDispType = $this->getConfig()->getRequestParameter( "jxdisptype" );
        $sShopId = $this->getConfig()->getShopId();

        $this->getConfig()->saveShopConfVar( 'select', 'sJxArtUpDisplayType', $sDispType, $sShopId, 'module:jxartup' );
        
        return;
    }
    
    
/*
 * Retrieve all jobs from db
 */
    private function _getAllUpdates () 
    {
        $aWhere = array(
                        'last3month' => 'DATEDIFF(CURDATE(),jxupdatetime) BETWEEN 31 AND 90',
                        'lastmonth' => 'DATEDIFF(CURDATE(),jxupdatetime) BETWEEN 8 AND 30',
                        'lastweek' => 'DATEDIFF(CURDATE(),jxupdatetime) BETWEEN 2 AND 7',
                        'yesterday' => 'DATEDIFF(CURDATE(),jxupdatetime) = 1',
                        'today' => 'DATE(jxupdatetime) = CURDATE()',
                        'tomorrow' => 'DATEDIFF(jxupdatetime,CURDATE()) = 1',
                        'nextweek' => 'DATEDIFF(jxupdatetime,CURDATE()) BETWEEN 2 AND 7',
                        'nextmonth' => 'DATEDIFF(jxupdatetime,CURDATE()) BETWEEN 8 AND 30',
                        'next3month' => 'DATEDIFF(jxupdatetime,CURDATE()) BETWEEN 31 AND 90'
                    );
        
        $aUpdates = array();
        $oDb = oxDb::getDb( oxDB::FETCH_MODE_ASSOC );
        foreach($aWhere as $key => $sWhere) {
            $sSql = "SELECT '{$key}' as jxtimekey, jxid, jxartid, jxupdatetime, "
                        . "jxfield1, jxvalue1,  jxfield2, jxvalue2,  jxfield3, jxvalue3, "
                        . "a.oxartnum, "
                        . "IF(a.oxparentid='',"
                            . "a.oxtitle,"
                            . "CONCAT((SELECT p.oxtitle FROM oxarticles p WHERE p.oxid=a.oxparentid), ', ', a.oxvarselect)) "
                        . "AS oxtitle, jxinherit, jxdone, a.oxvarcount "
                    . "FROM jxarticleupdates u, oxarticles a "
                    . "WHERE a.oxid = u.jxartid AND ({$sWhere}) "
                    . "ORDER BY jxupdatetime ASC ";

            $rs = $oDb->Execute($sSql);

            if ($rs) {
                $aSubData = array();
                while (!$rs->EOF) {
                    array_push($aSubData, $rs->fields);
                    $rs->MoveNext();
                }
                $aUpdates[$key] = $aSubData;
            }
        }

        return $aUpdates;
    }
    
    
    private function _getFirstDay($sDate = '')
    {
        $sFirst = strtotime( date('Y-m-01') );
        $iWeekday = date( "N", $sFirst ) - 1;
        $sFirstWeekday = strtotime( "-$iWeekday day", $sFirst );
        
        return date( "Y-m-d", $sFirstWeekday );
    }
    
    
    private function _getLastDay($sDate = '')
    {
        if ( empty($sDate) )
            $sDate = date("Y-m-d");

        $sLast = strtotime( date($sDate) );
        $sLastDay = strtotime( "last day of next month", $sLast );
        $iWeekday = 7 - date( "N", $sLastDay );
        $sLastWeekday = strtotime( "$iWeekday day", $sLastDay );

        return date( "Y-m-d", $sLastWeekday );
    }
    
    
    private function _getFirstActiveDay($sDate = '')
    {
        $sFirstDay = strtotime( date('Y-m-01') );
        
        return date( "Y-m-d", $sFirstDay );
    }
    
    
    private function _getLastActiveDay($sDate = '')
    {
        if ( empty($sDate) )
            $sDate = date("Y-m-d");

        $sLast = strtotime( date($sDate) );
        $sLastDay = strtotime( "last day of next month", $sLast );

        return date( "Y-m-d", $sLastDay );
    }

    
    private function _createCalendarTable()
    {
        $startCalDate = new DateTime( $this->_getFirstDay() );
        $endCalDate = new DateTime( $this->_getLastDay() );
        $dateDiff = date_diff( $endCalDate, $startCalDate );
        $days = $dateDiff->format( '%a' );
        
        $startActiveDay = new DateTime( $this->_getFirstActiveDay() );
        $endActiveDay = new DateTime( $this->_getLastActiveDay() );
        
        $aCalendar = array();
        
        $tDate = $startCalDate;
        if ($tDate < $startActiveDay)
            $active = FALSE;
        else
            $active = TRUE;
        $aCalendar[$tDate->format('Y-m-d')] = array( 'day' => $tDate->format('d'), 'active' => $active, 'data' => array() );
        for ($i=1; $i<=$days; $i++) {
            $tDate = $tDate->add( new DateInterval('P1D') ); 
            if ($tDate < $startActiveDay)
                $active = FALSE;
            else
                $active = TRUE;
            $aCalendar[$tDate->format('Y-m-d')] = array( 'day' => $tDate->format('d'), 'active' => $active, 'data' => array()  );
        }

        return $aCalendar;
    }
    
    
    private function _fillCalendar()
    {
        $oDb = oxDb::getDb( oxDB::FETCH_MODE_ASSOC );
        $sSql = "SELECT jxid, jxartid, jxupdatetime, DATE(jxupdatetime) AS jxdate, "
                    . "jxfield1, jxvalue1,  jxfield2, jxvalue2,  jxfield3, jxvalue3, "
                    . "a.oxartnum, "
                    . "IF(a.oxparentid='',"
                        . "a.oxtitle,"
                        . "CONCAT((SELECT p.oxtitle FROM oxarticles p WHERE p.oxid=a.oxparentid), ', ', a.oxvarselect)) "
                    . "AS oxtitle, jxinherit, jxdone, a.oxvarcount "
                . "FROM jxarticleupdates u, oxarticles a "
                . "WHERE a.oxid = u.jxartid "
                    . "AND DATE(jxupdatetime) >= '{$this->_getFirstDay()}' "
                    . "AND DATE(jxupdatetime) <= '{$this->_getLastDay()}' "
                . "ORDER BY jxupdatetime ASC ";

        $rs = $oDb->Execute($sSql);

        if ($rs) {
            while (!$rs->EOF) {
                $maxcount = count( $this->aCalendar[$rs->fields['jxdate']]['data'] );
                $this->aCalendar[$rs->fields['jxdate']]['data'][$maxcount] = $rs->fields;
                $rs->MoveNext();
            }
        }
        return;
    }
    
    
    private function _formatFloat($sValue)
    {
        return( str_replace( ',', '.', $sValue ) );
    }



    private function _logAction($sText)
    {
        $myConfig = oxRegistry::get("oxConfig");
        $sShopPath = $myConfig->getConfigParam("sShopDir");
        $sLogPath = $sShopPath.'/log/';
        
        $fh = fopen($sLogPath.'jxmods.log',"a+");
        fputs($fh,$sText."\n");
        fclose($fh);
    }

}

?>