#!/bin/bash
# new Env('饿了么本地sign');
# 环境变量 txt 修改接口msg输出
# 会修改 /etc/hosts 文件 恢复原状请自行去除
#切换linux格式 dos2unix elmsign.sh

#pwd


_ftype=""
get_arch=`arch`
echo $get_arch
if [[ $get_arch =~ "x86_64" ]];then
	_ftype="amd64"
elif [[ $get_arch =~ "aarch64" ]];then
	_ftype="arm64"
else
	_ftype=""
fi

download_elm(){
echo "开始下载elm二进制文件到$PWD/elmsign目录"
curl -# -o $PWD/elmsign/sign-$_ftype --create-dirs https://ghproxy.com/https://github.com/pingxian/elmsign/releases/download/v1.0.0/sign-$_ftype
echo "下载完成，如需重新下载或更新请先删除该文件"
if [ -f "$PWD/elmsign/sign-$_ftype" ]; then
    echo "$PWD/elmsign/sign-$_ftype"
    eval "chmod +x ./elmsign/sign-$_ftype"
    eval "./elmsign/sign-$_ftype"
fi
}

if [ $_ftype == "" ]; then
	echo "不支持的架构$get_arch"
else
	echo "执行$_ftype"
    if [ -f "$PWD/elmsign/sign-$_ftype" ]; then
        echo "$PWD/elmsign/sign-$_ftype"
        eval "chmod +x ./elmsign/sign-$_ftype"
        eval "./elmsign/sign-$_ftype -t elm"
    elif [ -f "$PWD/sign-$_ftype" ]; then
        echo "$PWD/sign-$_ftype"
        eval "chmod +x $PWD/sign-$_ftype"
        eval "$PWD/sign-$_ftype"
    else
        echo "在$PWD/elmsign目录、$PWD目录下均未找到文件sign-$_ftype,尝试拉取远程仓库文件sign-$_ftype"
        download_elm
    fi
fi
echo "127.0.0.1 api.94wan.fun">>/etc/hosts
