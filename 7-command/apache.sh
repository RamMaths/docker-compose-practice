#!/bin/bash
echo "<h1>Running <u>apache</u>...</h1>" > /var/www/html/index.html
apachectl -D FOREGROUND
