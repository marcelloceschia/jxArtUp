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

    public function render()
    {
        parent::render();
        
        $myConfig = oxRegistry::get("oxConfig");
        $sShopPath = $myConfig->getConfigParam("sShopDir");
                
        $sActPath = $this->getConfig()->getRequestParameter( "jxactdir" );
        
        $aUpdates = $this->_getAllUpdates();
        
        $oModule = oxNew('oxModule');
        $oModule->load('jxartup');
        $this->_aViewData["sModuleId"] = $oModule->getId();
        $this->_aViewData["sModuleVersion"] = $oModule->getInfo('version');
        
        $this->_aViewData["aFields"] = $this->aFields;
        
        $this->_aViewData["aUpdates"] = $aUpdates;

        return $this->_sThisTemplate;
    }
    
    
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
        
        $oDb = oxDb::getDb( oxDB::FETCH_MODE_ASSOC );
        
        $aSet = array();
        for ($i=1; $i<=3; $i++) {
            $sField = $this->getConfig()->getRequestParameter( "field{$i}" );
            if ( empty($sField) !== TRUE ) {
                $sValue = $this->getConfig()->getRequestParameter( "value{$i}" );
                if ($this->aFields[$sField] == CHAR)
                    $sTmpValue = "{$oDb->quote($sValue)}";
                else
                    $sTmpValue = "{$sValue}";
                array_push( $aSet, "jxfield{$i} = '{$sField}', jxtype{$i} = '{$this->aFields[$sField]}', jxvalue{$i} = $sTmpValue" );
            }
        }
        array_push( $aSet, "jxupdatetime = '{$sUpdTime}'" );
        
        $sSql = "UPDATE jxarticleupdates SET " . implode( ',', $aSet ) . " WHERE jxid = '{$sJxId}'";
        //echo '<hr>'.$sSql;
        
        $oDb->execute($sSql);
        
        return;
    }
    
    
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
        
        $oDb = oxDb::getDb( oxDB::FETCH_MODE_ASSOC );
        
        $aCol = array();
        $aVal = array();
        array_push( $aCol, "jxid, jxartid, jxupdatetime" );
        array_push( $aVal, "'{$sJxId}', '{$sArtId}', '{$sUpdTime}'" );
        
        for ($i=1; $i<=3; $i++) {
            $sField = $this->getConfig()->getRequestParameter( "field{$i}" );
            if ( empty($sField) !== TRUE ) {
                $sValue = $this->getConfig()->getRequestParameter( "value{$i}" );
                if ($this->aFields[$sField] == CHAR)
                    $sTmpValue = "{$oDb->quote($sValue)}";
                else
                    $sTmpValue = "{$sValue}";
                array_push( $aCol, "jxfield{$i}, jxtype{$i}, jxvalue{$i}" );
                array_push( $aVal, "'{$sField}', '{$this->aFields[$sField]}', $sTmpValue" );
            }
        }
        
        $sSql = "INSERT INTO jxarticleupdates (" . implode( ',', $aCol ) . ") VALUES (" . implode( ',', $aVal ) . ") ";
        
        $oDb->execute($sSql);
        
        return;
    }
    
    
    public function jxdelete ()
    {
        $myConfig = oxRegistry::get("oxConfig");
                
        $sJxId = $this->getConfig()->getRequestParameter( "jxid" );
        
        $oDb = oxDb::getDb( oxDB::FETCH_MODE_ASSOC );
        
        $sSql = "DELETE FROM jxarticleupdates WHERE jxid = '{$sJxId}' ";
        
        $oDb->execute($sSql);
        
        return;
    }
    
    
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
                        'next3month' => 'DATEDIFF(jxupdatetime,CURDATE()) BETWEEN 21 AND 90'
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
                        . "AS oxtitle, jxdone "
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