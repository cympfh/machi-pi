#!/bin/bash

mkdir -p txt
FASTCNN=$HOME/git/fastcnn/bin/fastcnn

id2chr() {
    ruby -ne 'label,ps=$_.split("\t"); puts label+"\t"+ps.split(" ").map{|c| (c.to_i + 12832).chr Encoding::UTF_8}*""'
}

# cat ../dataset/txt/train | id2chr >txt/train
# cat ../dataset/txt/valid | id2chr >txt/valid
cat ../dataset/txt/test | id2chr >txt/test
# $FASTCNN supervised txt/train --validate txt/valid --verbose --stat -e 100 --lr 0.3
$FASTCNN test out txt/test
