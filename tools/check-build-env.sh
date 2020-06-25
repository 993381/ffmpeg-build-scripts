#! /usr/bin/env bash

# ======= 检查编译环境 ========= #
uname=`uname`
echo -e "check $uname build env ======="
if [[ $uname = "Darwin" ]]  && [[ ! `which brew` ]]; then
    # Mac平台检查是否安装了 brew；如果没有安装，则进行安装
    echo "check Homebrew env......"
	echo 'Homebrew not found. Trying to install...'
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" || exit 1
    echo -e "check Homebrew ok......"
fi

# curl用于下载资源的命令包
echo "check curl env......"
if [[ ! `which curl` ]]; then
    echo "curl not found begin install....."
    if [ "$(uname)" == "Darwin"];then
        # Mac平台;自带
        
    elif [ "$(uname)" == "Linux"];then
        # Linux平台
        sudo apt install curl || exit 1
    else
        # windows平台
        sudo apt-cyg install curl || exit 1
    fi
fi
echo -e "check curl ok......"

# yasm是Mac平台和PC平台的汇编器，用于windows，linux，osx系统的ffmpeg汇编部分编译；
echo "check yasm env......"
if [[ ! `which yasm` ]]; then
	echo "yasm not found begin install....."
    if [ "$(uname)" == "Darwin"];then
        # Mac平台
        brew install yasm || exit 1
    else
        # Linux平台和windows平台
        curl -O http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz || exit 1
        tar zxvf yasm-1.3.0.tar.gz || exit 1
        rm yasm-1.3.0.tar.gz
        cd yasm-1.3.0
        ./configure || exit 1
        sudo make && sudo make install || exit 1
        cd -
        rm -rf yasm-1.3.0
    fi
fi
echo -e "check yasm ok......"

if [[ $uname = "Darwin" ]]  && [[ ! `which autoconf` ]]; then
    # Mac 平台 autoconf用于基于GNU的make生成工具，有些库不支持Libtool;
    echo "check autoconf env......"
    echo "autoconf not found begin install....."
    brew install autoconf || exit 1
    echo -e "check autoconfl ok......"
fi

if [[ $uname = "Darwin" ]]  && [[ ! `which gas-preprocessor.pl` ]]; then
    # gas-preprocessor.pl是IOS平台用的汇编器，安卓则包含在ndk目录中，不需要单独再指定
    echo "check gas-preprocessor.pl env......"
	echo "gas-preprocessor.pl not found begin install....."
    git clone https://github.com/libav/gas-preprocessor
    sudo cp gas-preprocessor/gas-preprocessor.pl /usr/local/bin/gas-preprocessor.pl
    chmod +x /usr/local/bin/gas-preprocessor.pl
	rm -rf gas-preprocessor
    echo -e "check gas-preprocessor.pl ok......"
fi

echo -e "check build env over ======="
