# jxArtUp - OXID Admin for Scheduled Updates of Products

*Module for backend / admin of OXID eShops for scheduled updates of product attributes*

## Installation and Setup
1. Copy all folders and files under **copy\_this** to the root folder of your shop.
2. Open your browser and login into the OXID admin.
3. Goto **Settings** - **Modules**, select the module _jxArtUp_ and and activate it.
4. Create a CRON job which runs the file /modules/jxmods/jxartup/core/jxartup_cron.php periodically (eg. each 5 minutes).

## Screenshot

Start Screen:  
![Active column](https://github.com/job963/jxFiles/raw/master/docs/img/screenshot.png)

## Changelog

* **0.1 Initial Release**
  * Create, edit and remove update jobs
  * Update job for CRON
  