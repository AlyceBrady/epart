# EPART Installation Guide #

[ [Dependencies](#dependencies) | [Installation and
Configuration](#installation) |
[Installing Pre-Defined Applications](#pre-defined) ]

Epart is a program for tracking epidemic cases by date and location
and for tracking resource requests and supplies.

Epart is built on top of [Ramp] [ramp] (Record and Activity Management
Program), so the first step to take in installing EPART is to install
Ramp.  See the [Ramp README] [ramp] file or the more in-depth [Ramp
Installation Manual] [ramp_install] for more specifics on installing
Ramp.

Ramp works with tables defined in a MySQL database using PHP and the Zend
Framework.  Ramp also uses PHP Markdown and Twitter Bootstrap.
Installing and running Ramp (or Smart), therefore, first requires
installing an AMP Stack (Apache Web Server, MySQL, and PHP), the
Zend Framework, PHP Markdown, and the Twitter Bootstrap ZF library
(a version of Twitter Bootstrap that works with the Zend Framework).

Ramp also includes dependencies on HTML 5, so the browsers used to
interact with Ramp on your server must support HTML 5.

<h2 id='dependencies'> Dependencies </h2>

Epart is built on top of Ramp, which is written in PHP using the Zend
Framework.  Ramp interacts with a MySQL database.  Thus, Epart is
dependent on Ramp, PHP, Zend Framework, and MySQL.  Epart also makes use
of the Twitter Bootstrap 2 framework and Markdown.


<h2 id='installation'> Installing and Configuring Ramp/Epart </h2>

THIS DOCUMENT IS UNDER CONSTRUCTION.

It will be updated once the Ramp Installation Manual has been revised.

[readme]: /README.md
[customInstall]: /INSTALL_CUSTOM.md
[applIni]: /document/index/document/..%252F..%252Finstallation%252FApplication_Ini.md
[git]: http://git-scm.com/book/en/Getting-Started-Installing-Git
[git-setup]: https://help.github.com/articles/set-up-git#platform-all
[apache]: http://httpd.apache.org/
[mysql]:  http://www.mysql.com/
[php]:  http://www.php.net/
[mamp]: http://www.mamp.info/en/index.html
[wamp]: http://www.wampserver.com/
[xampp]: http://www.apachefriends.org/en/xampp.html
[ramp]: https://github.com/AlyceBrady/ramp

