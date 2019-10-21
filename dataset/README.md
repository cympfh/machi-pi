## 牌譜データセット

天鳳が公開している牌譜から、和了した人の捨て牌と和了牌のデータセットを作ります

### コマンド

```bash
make all
```

### 出力形式

`txt/all` 及びそれを分割した `txt/train` `txt/valid` `txt/test` が出来ます

各ファイルの形式は以下のような一行１インスタンスです

```
__label__(和了牌ID)	(捨て牌ID) (捨て牌ID) ... (捨て牌ID)
```

捨て牌は左から捨てた順

## 参考

1. 天鳳が公開しているログについては [tenhou.net/sc/raw/](https://tenhou.net/sc/raw/) に記述があります
2. けど結局XMLファイルの場所については [note.mu/meaningless777/n/n951d795ff55e](https://note.mu/meaningless777/n/n951d795ff55e0) を読まないと分からなかった
3. 牌譜XMLファイルの読み方については [blog.kobalab.net/entry/20170225/1488036549](https://blog.kobalab.net/entry/20170225/1488036549) を参考にしました
