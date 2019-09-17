#!/usr/bin/env sh

install() {
    echo "install into $os"
    echo downloading: $url
    remove $bin-$suffix
    $download $url

    extract $bin-$suffix
    remove $bin-$suffix
    move $bin /usr/local/bin/
    echo installed to /usr/local/bin/$bin
}

remove() {
    if [ -w $(dirname $1) ]; then
        rm $1
    else
        sudo rm $1
    fi
}

move() {
    if [ -w $(dirname $2) ]; then
        ln -f $1 $2 
    else
        sudo ln -f $1 $2
    fi

    remove $1
}

extract() {
    if [ ! -w $(dirname $1) ]; then
        extractor="sudo $extractor"
    fi

    $extractor $1
}

select_url() {
    if [ -z "$bin" ]; then
        bin=$(basename $repo)
    fi

    if [ -z "$ver" ]; then
        url=`$get https://api.github.com/repos/$repo/releases/latest | grep $bin-$os | grep /releases/download/ | cut -d '"' -f 4`
    else
        url="https://github.com/$repo/releases/download/$ver/$bin-$suffix"
    fi
}

select_downloader() {
    if which wget > /dev/null; then
        get="wget -O-"
        download="wget"
    else
        get="curl -L"
        download="curl -JOL"
    fi

    # if cwd is not writable prepend sudo
    if [ ! -w `pwd` ]; then
        download="sudo $download"
    fi
}

select_os() {
    case $(uname) in
    Darwin)
        os="mac"
        suffix="$os.zip"
        extractor=unzip
        ;;
    Linux)
        os="linux"
        suffix="$os.tar.gz"
        extractor="tar -xzf"
        ;;
    *)
        echo "os not supported..."
        exit 1
        ;;
    esac
}

select_downloader
select_os
select_url
install
