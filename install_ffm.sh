#!/bin/bash

if [ ! -e /data/src/flvtool/ ];
then
        mkdir /data/src/flvtool
fi 

cd /data/src/flvtool
#rm * -fr

#Install any necessary packages:
yum -y install gcc gmake make libcpp libgcc libstdc++ gcc4 gcc4-c++ gcc4-gfortran subversion ruby ncurses-devel -y
yum -y install libogg libogg-devel libvorbis zlib-devel libtool
yum -y install libjpeg*

#rpm -ivh http://rpm.livna.org/livna-release.rpm
rpm -ivh http://m.yx.renren.com/soft/flvtools/livna-release.rpm

#get mplayer ffmpeg src from svn
svn checkout svn://svn.mplayerhq.hu/ffmpeg/trunk ffmpeg
svn checkout svn://svn.mplayerhq.hu/mplayer/trunk mplayer
cd mplayer
svn update

#install openjpeg
cd /data/src/flvtool
#wget http://m.yx.renren.com/soft/flvtools/openjpeg_v1_3.tar.gz
tar zxvf openjpeg_v1_3.tar.gz
cd OpenJPEG_v1_3
make && make install
ldconfig


#Copy codecs for mplayer:
#Make a directory to store all the codecs:
cd /data/src/flvtool
#wget http://m.yx.renren.com/soft/flvtools/essential-20061022.tar.bz2
tar jxvf essential-20061022.tar.bz2
mkdir /usr/local/lib/codecs/
mv essential-20061022/* /usr/local/lib/codecs/
chmod -R 755 /usr/local/lib/codecs/

#Installing Lame:
cd /data/src/flvtool
#wget http://m.yx.renren.com/soft/flvtools/lame-3.97.tar.gz
tar zxvf lame-3.97.tar.gz
cd lame-3.97
./configure
make && make install

#Installing Libogg:
cd /data/src/flvtool
#wget http://m.yx.renren.com/soft/flvtools/libogg-1.1.3.tar.gz
tar zxvf libogg-1.1.3.tar.gz
cd libogg-1.1.3
./configure --enable-shared
make && make install
PKG_CONFIG_PATH=/usr/local/lib/pkgconfig
export PKG_CONFIG_PATH

#Installing libvorbis:
cd /data/src/flvtool
#wget http://m.yx.renren.com/soft/flvtools/libvorbis-1.1.2.tar.gz
tar zxvf libvorbis-1.1.2.tar.gz
cd libvorbis-1.1.2
./configure 
make && make install

#install xvidcore
cd /data/src/flvtool
#wget http://m.yx.renren.com/soft/flvtools/xvidcore-1.2.1.tar.gz
tar zxvf xvidcore-1.1.2.tar.gz
cd xvidcore
cd build/generic
./configure --enable-shared
make && make install


#Installing flvtool2:
cd /data/src/flvtool
#wget http://m.yx.renren.com/soft/flvtools/flvtool2_1.0.5_rc6.tgz
tar zxvf flvtool2_1.0.5_rc6.tgz
cd flvtool2_1.0.5_rc6
ruby setup.rb config
ruby setup.rb setup
ruby setup.rb install


#Install libtheora (for ogg video encoding) 
cd /data/src/flvtool
#wget http://m.yx.renren.com/soft/flvtools/libtheora-1.0beta3.tar.gz
tar zxvf libtheora-1.0beta3.tar.gz
cd libtheora-1.0beta3
./configure --enable-shared
make && make install

#intall libdts
cd /data/src/flvtool
#wget http://m.yx.renren.com/soft/flvtools/libdts-0.0.2.tar.gz
tar zxvf libdts-0.0.2.tar.gz
cd libdts-0.0.2
./configure --enable-shared
make && make install


#install faad2
cd /data/src/flvtool
#wget http://m.yx.renren.com/soft/flvtools/faad2-2.7.tar.bz2
tar jxvf faad2-2.7.tar.bz2
cd faad2-2.7
./autoreconf -vif
./configure --with-mp4v2 --enable-shared
make && make install
ldconfig

#install faac
cd /data/src/flvtool
#wget http://m.yx.renren.com/soft/flvtools/faac-1.28.tar.bz2
tar jxvf faac-1.28.tar.bz2
cd faac-1.28
sed -i 's/\r//' bootstrap
sed -i 's/\r//' configure.in
./bootstrap
./configure  --with-mp4v2 --enable-shared
make && make install
ldconfig

#install a52
#cd /data/src/flvtool
#tar zxvf a52dec-0.7.4.tar.gz
#cd a52dec-0.7.4
#./configure 
#make
#make install


# install amrnb
cd /data/src/flvtool
tar jxvf amrnb-6.1.0.4.tar.bz2
cd amrnb-6.1.0.4
./configure 
make 
make install

#install x264
cd /data/src/flvtool
tar jxvf x264-snapshot-20070913-2245.tar.bz2
cd x264-snapshot-20070913-2245
./configur --enable-sharede 
make 
make install




#
#Installing mplayer
cd /data/src/flvtool/mplayer
./configure && make && make install

#Installing ffmpeg:
cd /data/src/flvtool/ffmpeg/
./configure --enable-gpl --disable-mmx  --enable-shared  --enable-pthreads --enable-libx264 --enable-libamr-nb --enable-avfilter --enable-avfilter-lavf  --enable-libmp3lame  --enable-libvorbis  --enable-libfaac --enable-libfaad --enable-libfaadbin   --enable-libtheora --enable-libopenjpeg --enable-libxvid    --enable-nonfree --enable-memalign-hack      	       
make && make install
export LD_LIBRARY_PATH=/usr/local/lib/

ln -s /usr/local/lib/libavdevice.so.52 /usr/lib/libavdevice.so.52
ln -s /usr/local/lib/libavformat.so.52 /usr/lib/libavformat.so.52
ln -s /usr/local/lib/libavcodec.so.52 /usr/lib/libavcodec.so.52
ln -s /usr/local/lib/libavutil.so.50 /usr/lib/libavutil.so.50
ln -s /usr/local/lib/libmp3lame.so.0 /usr/lib/libmp3lame.so.0
ln -s /usr/local/lib/libswscale.so.0 /usr/lib/libswscale.so.0
ln -s /usr/local/lib/libfaac.so.0 /usr/lib/libfaac.so.0
ln -s /usr/local/lib/libtheoradec.so.1 /usr/lib/libtheoradec.so.1


echo "ffmpeg is OK"


#Installing ffmpeg-php:
#cd /data/src/
#wget http://nchc.dl.sourceforge.net/sourceforge/ffmpeg-php/ffmpeg-php-0.6.0.tbz2
#tar jxvf ffmpeg-php-0.6.0.tbz2
#mv ffmpeg-php-0.6.0 /data/server/php5.4.3/include/php/ext/ffmpeg
#cd /data/server/php5.4.3/include/php/ext/ffmpeg
#/data/server/php5.4.3/bin/phpize 
#./configure --with-php-config=/data/server/php5.4.3/bin/php-config
#make clean && make && make install


#echo 'extension=/data/server/php5.4.3/lib/php/extensions/no-debug-non-zts-20090626/ffmpeg.so' >> /data/server/php5.4.3/etc/php.ini

#mv /data/server/php5.4.3/include/php/ext/ffmpeg/ffmpeg_frame.loT /data/server/php5.4.3/include/php/ext/ffmpeg/ffmpeg_frame.lo
#make
#make test
#make install





