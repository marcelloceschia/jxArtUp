<?php
/*
 *    This file is part of the module jxInventory for OXID eShop Community Edition.
 *
 *    OXID eShop Community Edition is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 3 of the License, or
 *    (at your option) any later version.
 *
 *    OXID eShop Community Edition is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with OXID eShop Community Edition.  If not, see <http://www.gnu.org/licenses/>.
 *
 * @link      https://github.com/job963/jxInventory
 * @license   http://www.gnu.org/licenses/gpl-3.0.html GPL v3 or later
 * @copyright (C) Joachim Barthel 2012-2013
 * 
 */

class jxArtUpdater_Install
{ 
    public static function onActivate() 
    { 

        $myConfig = oxRegistry::get("oxConfig");
        //$bConfig_DropOnDeactivate = $myConfig->getConfigParam("bJxInventoryDropOnDeactivate");
        $oDb = oxDb::getDb(); 

        $isUtf = oxRegistry::getConfig()->isUtf(); 
        $sCollate = ($isUtf ? "COLLATE 'utf8_general_ci'" : "");
        
        /*$sSql = "CREATE TABLE IF NOT EXISTS `jxinvarticles` ( "
            . "`jxartid` CHAR(32) NOT NULL COLLATE 'latin1_general_ci', "
            . "`jxinvsite` VARCHAR(255) NULL DEFAULT NULL $sCollate, "
            . "`jxinvstore` VARCHAR(255) NULL DEFAULT NULL $sCollate, "
            . "`jxinvrack` VARCHAR(255) NULL DEFAULT NULL $sCollate, "
            . "`jxinvlevel` VARCHAR(255) NULL DEFAULT NULL $sCollate, "
            . "`jxinvstock` DOUBLE NULL DEFAULT '0', "
            . "`jxtimestamp` TIMESTAMP NOT NULL DEFAULT current_timestamp ON UPDATE current_timestamp, "
            . "PRIMARY KEY (`jxartid`), "
            . "INDEX `invsite` (`jxinvsite`), "
            . "INDEX `invstore` (`jxinvstore`) "
            . ")"
            . "ENGINE=MyISAM " . ($isUtf ? 'DEFAULT CHARSET=utf8' : ''); 
                
        $oRs = $oDb->execute($sSql); */
        
        return true; 
    } 

    public static function onDeactivate() 
    { 
        /*$myConfig = oxRegistry::get("oxConfig");
        $bConfig_DropOnDeactivate = $myConfig->getConfigParam("bJxInventoryDropOnDeactivate");

        if ($bConfig_DropOnDeactivate) {
            $oDb = oxDb::getDb(); 

            $sSql = "DROP TABLE IF EXISTS `jxinvarticles`"; 
            $oRs = $oDb->execute($sSql); 
             
            $sSql = "DROP TABLE IF EXISTS `jxinvshipping`"; 
            $oRs = $oDb->execute($sSql); 
        }*/
        
        return true; 
    }  
}

?>