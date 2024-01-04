#!/bin/bash
SERVER="username@server-ip"
KEY="path/to/your/ssh/key"
LOCAL_DIR="path/to/local/directory"
REMOTE_DIR="path/to/remote/directory"

# sincron
rsync -avz -e "ssh -i $KEY" $LOCAL_DIR $SERVER:$REMOTE_DIR

ssh -i $KEY $SERVER << 'ENDSSH'
cd /path/to/your/project
git pull origin main

ENDSSH
