#!/bin/sh
LANG="zh_CN.UTF-8"

# OLDIFS=$IFS
# IFS=$'\n'

#smali需要重打包路径
REBUILD_PATH="xxx/新建文件夹"
#重打包工具根目录
REBUILD_SMALITOOL_PATH="xxx/dex2jar-2.0"

#签名工具根目录
AUTO_SIGN_PATH="xxx/dex2jar-2.0/tools"
#待签名apk根目录
WAIT_SIGN_PATH="xxx/Final"
#签名后apk存放根目录
OUT_PUT_BASE_PATH="xxxx/自动签名"

echo 正在重打包，请稍等.....

#这里的-d 参数判断$WAIT_SIGN_PATH是否存在  
# if [ `-d "$WAIT_SIGN_PATH"` ]
# then
# 	echo "准备删除目录及文件$WAIT_SIGN_PATH"
# 	if [ `rm -rf "$WAIT_SIGN_PATH"` ]
# 　　then
# 		echo "删除目录成功" 
# 	else 
# 		echo "删除失败" 
# 		echo "请先删除目录$WAIT_SIGN_PATH"
# 		exit
# 	fi 
# fi

if [ -d "$WAIT_SIGN_PATH" ] 
then
	echo "准备删除目录及文件$WAIT_SIGN_PATH"
	if [ `rm -rf "$WAIT_SIGN_PATH"` ]
	then
		echo "删除目录成功"
	else
		if [ -d "$WAIT_SIGN_PATH" ]
		then
			echo "请先删除目录$WAIT_SIGN_PATH"
			exit
		fi
	fi
fi

for dir in $REBUILD_PATH/*
do
	#判断是否是目录，如果是目录，则输出路径
	# if [ -d $dir ] 
	# then
	# 	echo $dir
	# fi

	if [ -d "$dir" ]  
	then   
		# echo "$dir is directory"
		# path=${dir// /\\ }
		# echo $path
		apkName=${dir##*/}
		# apkName=${apkName// /\\ }
		# echo $apkName
		java -jar "$REBUILD_SMALITOOL_PATH/ShakaApktool.jar" b "$dir" -o "$WAIT_SIGN_PATH/$apkName.apk"
	# elif [ -f "$dir" ]  
	# then  
	# 	echo "$dir is file"  
	fi
done
#将IFS更改为之前的
# IFS=$OLDIFS

echo "打包完成"
echo 签名工具目录$AUTO_SIGN_PATH
echo 输出根目录$OUT_PUT_BASE_PATH
echo 正在签名，请稍等.....
# if [ -d "$OUT_PUT_BASE_PATH" ] 
# then
# 	echo "准备删除目录及文件$OUT_PUT_BASE_PATH"
# 	if [ `rm -rf "$OUT_PUT_BASE_PATH"` ]
# 	then
# 		echo "删除目录成功"
# 		echo "创建目录"
# 		if [ !`mkdir "$OUT_PUT_BASE_PATH"` ]
# 		then
# 			echo "创建目录$OUT_PUT_BASE_PATH失败"
# 			exit
# 		fi
# 	else
# 		if [ -d "$OUT_PUT_BASE_PATH" ]
# 		then
# 			echo "请先删除目录$OUT_PUT_BASE_PATH"
# 			exit
# 		fi
# 		echo "创建目录"
# 		if [ !`mkdir "$OUT_PUT_BASE_PATH"` ]
# 		then
# 			echo "创建目录$OUT_PUT_BASE_PATH失败"
# 			exit
# 		fi
# 	fi
# else
# 	echo "创建目录"
# 	if [ !`mkdir "$OUT_PUT_BASE_PATH"` ]
# 	then
# 		echo "创建目录$OUT_PUT_BASE_PATH失败"
# 		exit
# 	fi
# fi

mkdir "$OUT_PUT_BASE_PATH"

for x in $WAIT_SIGN_PATH/*.apk 
do 
	# echo 待签名文件$x 
	# echo 提取文件名${x##*/}
	# echo java -jar signapk.jar platform.x509.pem platform.pk8 $x  -o ./已签名/${x##*/}
	java -jar $AUTO_SIGN_PATH/signapk.jar "$AUTO_SIGN_PATH/platform.x509.pem" "$AUTO_SIGN_PATH/platform.pk8" "$x"  "$OUT_PUT_BASE_PATH/${x##*/}"
done
echo "签名已完成请查看【$OUT_PUT_BASE_PATH】文件夹"
echo "任务全部结束"





