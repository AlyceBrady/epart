<?php

// Define the application environment
defined('APPLICATION_ENV')
    || define('APPLICATION_ENV',
        (getenv('APPLICATION_ENV') ? getenv('APPLICATION_ENV') : 'njala_prototype'));

// Define path to the application environment directory
defined('APP_ENV_PATH')
    || define('APP_ENV_PATH',
        realpath(dirname(__FILE__) . '/..'));

// Define path to RAMP repository
defined('RAMP_PATH')
    || define('RAMP_PATH', APP_ENV_PATH . '/../ramp');

// Define path to RAMP "application" directory
defined('APPLICATION_PATH')
    || define('APPLICATION_PATH', RAMP_PATH . '/application');

// Define path to RAMP "docs" directory
defined('RAMP_DOCS_PATH')
    || define('RAMP_DOCS_PATH', APPLICATION_PATH . '/docs');

// Define path to RAMP "adminSettings" directory
defined('RAMP_ADMIN_SETTINGS_PATH')
    || define('RAMP_ADMIN_SETTINGS_PATH',
        APPLICATION_PATH . '/adminSettings');

// Ensure library is on include_path
set_include_path(implode(PATH_SEPARATOR, array(
    realpath(RAMP_PATH . '/library'),
    get_include_path(),
)));

/** Zend_Application (in library, which is now on include_path) */
require_once 'Zend/Application.php';

// Create application, bootstrap, and run
$application = new Zend_Application(
    APPLICATION_ENV,
    APP_ENV_PATH . '/configs/application.ini'
);
$application->bootstrap()
            ->run();
