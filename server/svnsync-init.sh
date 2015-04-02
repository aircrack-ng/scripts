#!/bin/sh

svnadmin create $1
echo '#!/bin/bash' > $1/hooks/pre-revprop-change
chmod +x $1/hooks/pre-revprop-change
svnsync init file://${PWD}/$1 $2
svnsync sync file://${PWD}/$1
echo DONE
