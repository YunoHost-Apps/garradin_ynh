## Problem
- *Upgrade of the application to v0.9.8.1 resolves some issues*
- *Adding links in the public page made issues due to the nginx.conf*
- *Protect somes links vilnerables for security*

## Solution
- *I do the necessary to upgrade the application to the new sources*
- *@ericg found the solution to add in the nginx.conf*
- *Redirections to 403 on the nginx.conf for sensibles urls*

## PR Status
- [x] Code finished.
- [x] Tested with Package_check.
- [x] Fix or enhancement tested.
- [x] Upgrade from last version tested.
- [x] Can be reviewed and tested.

## Package_check results
---
*If you have access to [App Continuous Integration for packagers](https://yunohost.org/#/packaging_apps_ci) you can provide a link to the package_check results like below, replacing '-NUM-' in this link by the PR number and USERNAME by your username on the ci-apps-dev. Or you provide a screenshot or a pastebin of the results*

[![Build Status](https://ci-apps-dev.yunohost.org/jenkins/job/garradin_ynh%20PR-NUM-%20(USERNAME)/badge/icon)](https://ci-apps-dev.yunohost.org/jenkins/job/garradin_ynh%20PR-NUM-%20(USERNAME)/)  
