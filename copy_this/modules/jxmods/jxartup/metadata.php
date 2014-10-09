<?php

/**
 * Metadata version
 */
$sMetadataVersion = '1.1';
 
/**
 * Module information
 */
$aModule = array(
    'id'           => 'jxartup',
    'title'        => 'jxArtUp - Product Updater and Scheduler',
    'description'  => array(
                        'de' => 'Admin-Modul für die Planung von Artikel-Updates',
                        'en' => 'Admin Module for Scheduling Product Updates'
                        ),
    'thumbnail'    => 'jxartup.png',
    'version'      => '0.2',
    'author'       => 'Joachim Barthel',
    'url'          => 'https://github.com/job963/jxArtUp',
    'email'        => 'jobarthel@gmail.com',
    'extend'       => array(
                        ),
    'files'        => array(
                        'jxartup' => 'jxmods/jxartup/application/controllers/admin/jxartup.php'
                        ),
    'templates'    => array(
                        'jxartup.tpl' => 'jxmods/jxartup/views/admin/tpl/jxartup.tpl'
                        ),
    'events'       => array(
        'onActivate'   => 'jxartup_install::onActivate', 
        'onDeactivate' => 'jxartup_install::onDeactivate'
                        ),
    'settings' => array(
                        )
    );

?>
