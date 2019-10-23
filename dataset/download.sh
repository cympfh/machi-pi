#!/bin/bash

# 数字部分を抜き出す
get-number() {
    if [ $# -eq 0 ]; then
        grep -o '[0-9][0-9]*'
    else
        echo "$1" | get-number
    fi
}

# ゲームID ("2019101911gm-00b9-0000-da5012af") から和了牌とその人の捨て牌を抜き出す
dataset-from-game-id() {
    # curl -s "http://e.mjv.jp/0/log/plainfiles.cgi?$1"
    curl -sL "https://tenhou.net/0/log?$1" |
        sed 's/></>\n</g' |
        while read LINE; do
            case "$LINE" in
                "<INIT"* )
                    HAI0=
                    HAI1=
                    HAI2=
                    HAI3=
                    ;;
                "<DORA"* | "<N"* )
                    ;;
                "<D"* )
                    HAI0="$HAI0 $(get-number $LINE)"
                    ;;
                "<E"* )
                    HAI1="$HAI1 $(get-number $LINE)"
                    ;;
                "<F"* )
                    HAI2="$HAI2 $(get-number $LINE)"
                    ;;
                "<G"* )
                    HAI3="$HAI3 $(get-number $LINE)"
                    ;;
                "<AGARI"* )
                    machi=$( echo "$LINE" | grep -o 'machi=[^ ]*' | get-number )
                    who=$( echo "$LINE" | grep -o 'who=[^ ]*' | get-number )
                    case "$who" in
                        0 )
                            echo "__label__${machi} ${HAI0}"
                            ;;
                        1 )
                            echo "__label__${machi} ${HAI1}"
                            ;;
                        2 )
                            echo "__label__${machi} ${HAI2}"
                            ;;
                        3 )
                            echo "__label__${machi} ${HAI3}"
                            ;;
                    esac
                    ;;
            esac
        done
    }

curl -sL https://tenhou.net/sc/raw/list.cgi | grep -o 'scc.*.html.gz' |
    while read f; do
        echo $f >&2
        echo "# $f"
        curl -sL https://tenhou.net/sc/raw/dat/$f | gunzip -d |
            sed 's/ | /\n/g' | awk 'NR%5 == 3 || NR%5 == 4' |
            while read GAME_TYPE; do
                read URL
                GID=$( echo $URL | grep -o '201[0-9a-z\-]*' | head -1 )
                echo $GID >&2
                echo "## $GID"
                dataset-from-game-id $GID | sed 's/  /\t/g' | sed "s/^/$GAME_TYPE	/g"
            done
    done
