#!/bin/sh

# baseLibApp Build
# Lubosz Sarnecki 2011

CPU_CORES=`getconf _NPROCESSORS_ONLN`
GCC_THREADS=`expr $CPU_CORES + 1`

function error {
  echo "ERROR $1 could not be build"
  exit
}

if uname -a | grep Ubuntu; then
  sudo apt-get install build-essential git subversion cvs qt4-qmake cmake libunicap-dev libucil-dev liblapack-dev gfortran libf2c2-dev libftgl-dev libhighgui-dev
fi

if [ ! -d external ]; then
  mkdir external
fi
  
cd external/

#
# coreDataStructs
#
if [ ! -d coreDataStructs ]; then
  svn co https://svn.uni-koblenz.de/agas/projects/IntegVelodyne/30_prog/external/coreDataStructs/lib coreDataStructs
else
  svn up coreDataStructs
fi

#
# imageGrabber
#
#svn co https://svn.uni-koblenz.de/agas/projects/IntegVelodyne/30_prog/external/imageGrabber/lib imageGrabber
#cd imageGrabber
#qmake
#make -j$GCC_THREADS
#cd ..

#
# imageOperations
#
if [ ! -d imageOperations ]; then
  svn co https://svn.uni-koblenz.de/agas/projects/IntegVelodyne/30_prog/external/imageOperations/lib imageOperations
else
  svn up imageOperations
fi

if [ ! -f imageOperations/libimageOperations.a ]; then
  cd imageOperations
  patch -p0 < ../../patches/imageOperationsPaths.diff
  qmake
  make -j$GCC_THREADS || error "imageOperations"
  cd ..
fi

#
# tinyxml
#
if [ ! -d tinyxml ]; then
  svn co https://svn.uni-koblenz.de/agas/projects/IntegVelodyne/30_prog/external/tinyxml
else
  svn up tinyxml
fi

if [ ! -f tinyxml/libtinyxml.a ]; then
  cd tinyxml
  qmake
  make -j$GCC_THREADS || error "tinyxml"
  cd ..
fi

#
# flann
#
if [ ! -d flann ]; then
  git clone git://github.com/mariusmuja/flann.git
fi

if [ ! -f flann/lib/libflann.so ]; then
  cd flann
  git checkout 94d28f2d2868709adac1c944472dda71f5b8c289
  cmake . -DBUILD_MATLAB_BINDINGS=0 -DBUILD_PYTHON_BINDINGS=0 -DLATEX_OUTPUT_PATH=.
  make -j$GCC_THREADS || error "flann"
  cd ..
fi

#
# lapackpp
#
if [ ! -d lapackpp ]; then
  svn co https://lapackpp.svn.sourceforge.net/svnroot/lapackpp/lapackpp/trunk/ lapackpp
fi

if [ ! -f lapackpp/src/.libs/liblapackpp.so ]; then
  cd lapackpp
  ./autogen.sh
  ./configure
  make -j$GCC_THREADS || error "lapackpp"
  ln -s include lapackpp
  cd ..
fi

#
# TooN
#
if [ ! -d TooN ]; then
  cvs -z3 -d:pserver:anoncvs@cvs.savannah.nongnu.org:/cvsroot/toon co TooN
fi
#cd TooN
#./configure
#cd ..

#
# tag
#
if [ ! -d tag ]; then
  cvs -z3 -d:pserver:anoncvs@cvs.savannah.nongnu.org:/cvsroot/toon co tag
fi

if [ ! -f tag/.libs/libtoontag.a ]; then
  cd tag
  chmod +x configure
  ./configure --with-TooN=..
  #patch wrong header case
  sed -i 's/svd.h/SVD.h/g' tag/absorient.h 
  make -j$GCC_THREADS || error "tag"
  cd ..
fi

#
# artoolkit
#
#svn co https://artoolkit.svn.sourceforge.net/svnroot/artoolkit/trunk/artoolkit/
#cd artoolkit
#./Configure
#make -j$GCC_THREADS
#cd ..

#
# opencv
#

#Look for installed opencv 2.3
if [ ! -f /usr/lib/libopencv_imgproc.so.2.3 ]; then
  if [ ! -d OpenCV-2.3.0 ]; then
    wget http://freefr.dl.sourceforge.net/project/opencvlibrary/opencv-unix/2.3/OpenCV-2.3.0.tar.bz2
    tar -xvjf OpenCV-2.3.0.tar.bz2
    rm OpenCV-2.3.0.tar.bz2
  fi

  if [ ! -f OpenCV-2.3.0/lib/libopencv_imgproc.so ]; then
    cd OpenCV-2.3.0
    cmake .
    make -j$GCC_THREADS || error "OpenCV"
    cd ..
  fi
fi

#
# sba
#
if [ ! -d sba ]; then
  wget http://www.ics.forth.gr/~lourakis/sba/sba-1.6.tgz
  tar xvfz sba-1.6.tgz
  rm sba-1.6.tgz
  mv sba-1.6 sba
fi

if [ ! -f sba/libsba.a ]; then
  cd sba
  cmake . -Wno-dev
  make -j$GCC_THREADS || error "sba"
  cd ..
fi

cd ..

#
# baselib
#
if [ ! -d baselib ]; then
  svn co https://svn.uni-koblenz.de/agas/projects/IntegVelodyne/30_prog/baselib
else
  svn up baselib
fi

if [ ! -f baselib/libbaselib.a ]; then
  cd baselib
  patch -p0 < ../patches/baselibBuild.diff
  cmake . -DRELEASE=1
  make -j$GCC_THREADS || error "baselib"
  cd ..
fi

#
# baselibApp
#
if [ ! -d baselibApp ]; then
  svn co https://svn.uni-koblenz.de/decker/baselibApp
else
  svn up baselibApp
fi

cd baselibApp
#make clean
#rm CMakeCache.txt
cmake . -DRELEASE=1
make -j$GCC_THREADS || error "baselibApp"
echo "Done"


#wget http://www.ics.forth.gr/~lourakis/homest/homest-1.3.tgz
#tar xvfz homest-1.3.tgz
#rm homest-1.3.tgz
#mv homest-1.3 homest

#wget http://www.ics.forth.gr/~lourakis/levmar/levmar-2.5.tgz
#tar xvfz levmar-2.5.tgz
#rm levmar-2.5.tgz

#bzr branch lp:unicap

