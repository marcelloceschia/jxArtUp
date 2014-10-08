<?php

/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

        //--require_once '../../../../config.inc.php';

        /*
        //setup connection to database
        $db_connection = @mysql_connect($this->dbHost, $this->dbUser, $this->dbPwd);
        @mysql_select_db($this->dbName, $db_connection);
        
        if($this->iUtfMode == 1)
        {
            mysql_query("SET NAMES 'utf8'");
        }*/
            /*$dbConn = 'mysql:host='.$this->dbHost.';dbname='.$this->dbName;
            $dbUser = $this->dbUser;
            $dbPass = $this->dbPwd;*/
            $dbConn = 'localhost';
            $dbName = 'oxid_ce_479';
            $dbUser = 'root';
            $dbPass = 'root';

            $db = @mysql_connect($dbConn, $dbUser, $dbPass);
            @mysql_select_db($dbName, $db);
            //$db->exec('set names "utf8"');
            mysql_query("SET NAMES 'utf8'");
        
            $sSql = "SELECT jxid, jxartid, jxfield1, jxtype1, jxvalue1, jxfield2, jxtype2, jxvalue2, jxfield3, jxtype3, jxvalue3  FROM jxarticleupdates WHERE jxupdatetime <= NOW() AND jxdone = 0";
            $aTasks = jxfetchall($sSql);
            //$stmt = $db->prepare($sSql);
            //$stmt->execute();
            
            //$aTasks = $stmt->fetchAll(PDO::FETCH_ASSOC);
        /*echo '<pre>';
        print_r($aTasks);
        echo '</pre>';*/

        /*$rs = mysql_query($query);
        $aTasks = array();
        if ($rs)
        {
            while($row = mysql_fetch_array($rs))
            {
                array_push( $aTasks, $row );
            }	
        }*/
        
        echo '<h1>Tasks</h1>';
        foreach ($aTasks as $key => $aTask) {
            $aSet = array();
            for ($i=1; $i<=3; $i++) {
                //echo "jxvalue{$i}".'-->'.empty($aTask["jxvalue{$i}"]).$aTask["jxvalue{$i}"];
                if ( empty($aTask["jxvalue{$i}"]) !== TRUE ) {
                    //echo $i.'<br>';
                    if ($aTask["jxtype{$i}"] == 'FLOAT')
                        array_push ($aSet, "{$aTask["jxfield{$i}"]} = {$aTask["jxvalue{$i}"]}");
                    elseif  ($aTask["jxtype{$i}"] == 'CHAR')
                        array_push ($aSet, "{$aTask["jxfield{$i}"]} = '{$aTask["jxvalue{$i}"]}'");
                }
            }
            
        /*echo '<pre>';
        print_r($aSet);
        echo '</pre>';*/
            $sSql = "UPDATE oxarticles SET " . implode( ',', $aSet ) . " WHERE oxid = '{$aTask['jxartid']}'";
            echo $sSql . '<hr>';
            mysql_query($sSql);
            /*$stmt = $db->prepare($sSql);
            $stmt->execute();
            echo '<pre>';
            print_r($db->errorInfo());
            echo '</pre>';*/
            
            $sSql = "UPDATE jxarticleupdates SET jxdone = 1 WHERE jxid = '{$aTask['jxid']}'";
            echo $sSql . '<hr>';
            mysql_query($sSql);
            /*$stmt = $db->prepare($sSql);
            $stmt->execute();
            echo '<pre>';
            print_r($db->errorInfo());
            echo '</pre>';*/
        }
        
        $db = NULL;
    
//}
function jxfetchall ($query)
{
    $rs = mysql_query($query);
        if ($rs)
        {
            $aLines = array();
            while($row = mysql_fetch_array($rs)) {
                // caching query
                array_push($aLines, $row);
                //--$this->tempMainCategoryId[$oxid] = $row['oxcatnid'];
                //--return $row['oxcatnid'];
            }	
        }
    return $aLines;
} 