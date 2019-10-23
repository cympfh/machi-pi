#!/bin/bash

mkdir -p txt
FASTCNN=$HOME/git/fastcnn/bin/fastcnn

id2chr() {
    grep -v ' $' |
        grep '^三' |
        ruby -ne '
            _, label,ps=$_.split("\t");
            label = "__label__" + (label.split("__label__")[1].to_i / 4).to_s;
            ps = ps.split(" ").map{|c| c.to_i / 4};
            ps = ps.reverse + [36] * 5 + ps;
            puts label+"\t"+ps.map{|c|(c+12832).chr Encoding::UTF_8}*""
        '
}

report() {
    $FASTCNN test out txt/test | grep Acc@
    $FASTCNN test out txt/test -k 5 | grep Acc@
    $FASTCNN test out txt/test -k 10 | grep Acc@
}

cat ../dataset/txt/train | id2chr >txt/train
cat ../dataset/txt/valid | id2chr >txt/valid
cat ../dataset/txt/test | id2chr >txt/test
$FASTCNN supervised txt/train --validate txt/valid --verbose --stat -e 50 --lr 0.3 --kernel-size 5

report | tee out.report.log
cat out.report.log | tw -
