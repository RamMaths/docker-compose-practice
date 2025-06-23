#!/bin/bash
echo "<h1>Running <u>nginx</u>...</h1>" > /var/www/html/index.html
nginx -g "daemon off;"
