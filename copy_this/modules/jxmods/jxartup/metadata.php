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
                        'de' => 'Admin-Modul für die Verwaltung von Dateien.',
                        'en' => 'Admin module for managing of files.'
                        ),
    'thumbnail'    => 'jxartup.png',
    'version'      => '0.1',
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
    'settings' => array(/*
                        array(
                                'group' => 'JXFILES_DIRECTORIES1', 
                                'name'  => 'sJxFilesDir1Path', 
                                'type'  => 'str', 
                                'value' => 'out/azure/img'
                                ),
                        array(
                                'group' => 'JXFILES_DIRECTORIES1', 
                                'name'  => 'sJxFilesDir1Title', 
                                'type'  => 'str', 
                                'value' => 'Theme-Images'
                                ),
                        array(
                                'group' => 'JXFILES_DIRECTORIES2', 
                                'name'  => 'sJxFilesDir2Path', 
                                'type'  => 'str', 
                                'value' => ''
                                ),
                        array(
                                'group' => 'JXFILES_DIRECTORIES2', 
                                'name'  => 'sJxFilesDir2Title', 
                                'type'  => 'str', 
                                'value' => ''
                                ),
                        array(
                                'group' => 'JXFILES_DIRECTORIES3', 
                                'name'  => 'sJxFilesDir3Path', 
                                'type'  => 'str', 
                                'value' => ''
                                ),
                        array(
                                'group' => 'JXFILES_DIRECTORIES3', 
                                'name'  => 'sJxFilesDir3Title', 
                                'type'  => 'str', 
                                'value' => ''
                                ),
                        array(
                                'group' => 'JXFILES_DIRECTORIES4', 
                                'name'  => 'sJxFilesDir4Path', 
                                'type'  => 'str', 
                                'value' => ''
                                ),
                        array(
                                'group' => 'JXFILES_DIRECTORIES4', 
                                'name'  => 'sJxFilesDir4Title', 
                                'type'  => 'str', 
                                'value' => ''
                                ),
                        array(
                                'group' => 'JXFILES_DIRECTORIES5', 
                                'name'  => 'sJxFilesDir5Path', 
                                'type'  => 'str', 
                                'value' => ''
                                ),
                        array(
                                'group' => 'JXFILES_DIRECTORIES5', 
                                'name'  => 'sJxFilesDir5Title', 
                                'type'  => 'str', 
                                'value' => ''
                                ),*/
                        )
    );

?>
