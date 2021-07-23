# 
# 生成多渠道资源
# 

# 需要的资源
image=$1
logo=$2
appName=$3
color=$4

# 创建文件夹
mkdir res
mkdir res/mipmap-mdpi
mkdir res/mipmap-hdpi
mkdir res/mipmap-xhdpi
mkdir res/mipmap-xxhdpi
mkdir res/mipmap-xxxhdpi
mkdir res/drawable-xxhdpi
mkdir res/values

# 生成不同尺寸的 launcher
magick $image -resize 48 res/mipmap-mdpi/ic_launcher.png
magick $image -resize 72 res/mipmap-hdpi/ic_launcher.png
magick $image -resize 96 res/mipmap-xhdpi/ic_launcher.png
magick $image -resize 144 res/mipmap-xxhdpi/ic_launcher.png
magick $image -resize 192 res/mipmap-xxxhdpi/ic_launcher.png

# 复制logo
cp $logo res/drawable-xxhdpi/bg_splash.png
cp $logo res/drawable-xxhdpi/ic_version.png
cp $logo res/drawable-xxhdpi/login_logo.png

# 生成 string.xml
echo "
<resources>

    <string name=\"app_name\">$appName</string>

</resources>
" \
> res/values/string.xml


# 生成color.xml
echo "
<?xml version=\"1.0\" encoding=\"utf-8\"?>
<resources>

    <color name=\"primary\">$color</color>

</resources>

" \
> res/values/colors.xml

exit 0