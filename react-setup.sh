#/bin/bash

msg() {
    echo $'\e[32m[react-setup]\e[0m' "$@"
}

if ! type git > /dev/null 2>&1; then
    msg "git が入ってないので入れてから戻ってきて下さい。"
    msg "ここだけは GUI が避けられない模様。"
    open "https://www.google.co.jp/search?q=git+mac+%E3%82%A4%E3%83%B3%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AB"
    exit 1
fi

NODE_VERSION=$1
DIRECTORY=$2

if [ ! "$NODE_VERSION" ]; then
    msg "使用する node のバーションを一つ目の引数で指定して下さい。"
    open "https://nodejs.org/ja/download/releases/"
    ERROR=1
elif [ ! $(echo $NODE_VERSION | grep -e "^\d\+\.\d\+\.\d\+$") ]; then
    msg "node のバージョンのフォーマットが不正です。"
    ERROR=1
fi

if [ ! "$DIRECTORY" ]; then
    msg "作成するディレクトリを二つ目の引数で指定して下さい。"
    ERROR=1
fi

if [ $3 ]; then
    msg "三つ目以降の引数は無効です。"
    ERROR=1
fi

if [ "$ERROR" ]; then
    msg "例えば以下のようにします。"
    msg "$0 6.11.1 my-react-app"
    exit 1
fi

if [ -d $DIRECTORY ]; then
    msg "ディレクトリ $DIRECTORY はすでに存在します。"
    msg "新しいディレクトリを指定して下さい。"
    ERROR=1
fi

if [ "$ERROR" ]; then
    exit 1
fi

if [ ! -d ~/.nodenv ]; then
    msg "nodenv を ~/.nodenv 以下にインストールします。"
    git clone git://github.com/nodenv/nodenv.git ~/.nodenv
    if [ ! -f ~/.bash_profile ]; then
        msg "~/.bash_profile が無いので作成します。"
        touch ~/.bash_profile
    fi
    msg "~/.bash_profile に nodeenv のパスを追加して読み込みます。"
    echo 'export PATH="$HOME/.nodenv/bin:$PATH"' >> ~/.bash_profile
    echo 'eval "$(nodenv init -)"' >> ~/.bash_profile
    source ~/.bash_profile
fi

if [ ! -d ~/.nodenv/plugins/node-build ]; then
    msg "nodenv に node-build プラグインを追加します。"
    git clone https://github.com/nodenv/node-build.git ~/.nodenv/plugins/node-build
    source ~/.bash_profile
fi

if [ ! -d ~/.nodenv/plugins/nodenv-update ]; then
    msg "nodenv に nodenv-update プラグインを追加します。"
    git clone https://github.com/nodenv/nodenv-update.git ~/.nodenv/plugins/nodenv-update
    source ~/.bash_profile
fi

msg "nodenv を最新バージョンにアップデートします。"
nodenv update

if [ ! $(nodenv versions --bare | grep -e "^$NODE_VERSION$") ]; then
    msg "node v$NODE_VERSION を ~/.nodenv/versions 以下にインストールします。"
    nodenv install $NODE_VERSION
fi

msg "デフォルトの node のバージョンを v$NODE_VERSION にします。"
nodenv global $NODE_VERSION

if [ ! $(npm ls -g --parseable create-react-app) ]; then
    msg "create-react-app をインストールします。"
    npm install -g create-react-app
fi

msg "$DIRECTORY 以下に React アプリを作成します。"
msg "必要なパッケージをインストールするため、数分間程度の時間がかかる場合があります。"
~/.nodenv/versions/$NODE_VERSION/bin/create-react-app $DIRECTORY

msg "新しい React アプリが $DIRECTORY に作成されました。"
msg ""
msg "この新しいディレクトリ以下で、いくつかのコマンドを実行することが出来ます。"
msg "  npm start -> 開発用サーバの起動"
msg "  npm run build -> 本番サーバ向けに静的ファイルをバンドル"
msg "  npm test -> テスト実行サーバの起動"
msg "  npm run eject -> create-react-app で管理されている依存関係や設定ファイルをコピーします。これにより Webpack や Babel の設定が編集可能になりますが、後から元に戻すことは出来ません。"
msg ""
msg "下記のコマンドで開発用サーバを起動すると、http://localhost:3000/ で作成したアプリが確認出来ます。"
msg "その後 $DIRECTORY/src/App.js を編集して保存すると、ブラウザが自動的にリロードし、変更が反映されます。"
msg "  cd $DIRECTORY"
msg "  npm start"
msg "ハッピーハッキング！"

exit

== what will be instealled? ==

git
nodenv
node (under nodenv)
create-react-app


== special thanks ==

checkcmd
http://qiita.com/kawaz/items/1b61ee2dd4d1acc7cc94

#parse bash options
#http://qiita.com/b4b4r07/items/dcd6be0bb9c9185475bb

colored echo
http://qiita.com/k_ui/items/9a194634af9f522bfad6

noeenv
http://qiita.com/1000ch/items/41ea7caffe8c42c5211c

create-react-app ?
http://qiita.com/chibicode/items/8533dd72f1ebaeb4b614

#https://hackernoon.com/simple-react-development-in-2017-113bd563691f

#webpack
#http://qiita.com/nosoosso/items/a9ef0b26ccff47133870

#react-redux starter ?
#http://qiita.com/ossan-engineer/items/25babf2025bfe1968b9b
