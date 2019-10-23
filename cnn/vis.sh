#!/bin/bash

FASTCNN=$HOME/git/fastcnn/bin/fastcnn
ls out.h5 out.meta.yml

# $FASTCNN predict-prob out txt/test -k 5 > /tmp/vis.tmp
paste /tmp/vis.tmp txt/test | ruby -ne '
    def id2tile(id)
        if id < 9 * 3
            suit = id < 9 ? "m" : id < 18 ? "s" : "p"
            num = 1 + id % 9
            "#{num}#{suit}"
        else
            "ESWNXYZ"[id - 9 * 3 - 4]
        end
    end
    def take_later(xs)
    ell = (xs.size - 5) / 2
        xs[-ell..-1]
    end
    pps, tps, sps = $_.split("\t")
    pred_pis = pps.split("__label__")[1..-1].map{|chunk| pi, prob, _ = chunk.split(" "); "#{id2tile(pi.to_i)} (#{prob})"}
    true_pi = id2tile(tps.split("__label__")[1].to_i)

    puts "discard: " + take_later(sps.chomp.split("").map{|c| (c.ord - 12832)}.map{|c| id2tile(c)}) * " "
    puts "- true: " + true_pi
    puts "- pred: " + pred_pis * ", "
'
