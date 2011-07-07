#!/bin/sh

# baseLibApp Build
# Lubosz Sarnecki 2011

CPU_CORES=`getconf _NPROCESSORS_ONLN`
GCC_THREADS=`expr $CPU_CORES + 1`

if uname -a | grep Ubuntu; then
  sudo apt-get install build-essential git subversion cvs qt4-qmake cmake libunicap-dev libucil-dev libcv-dev liblapack-dev gfortran libf2c2-dev libftgl-dev libcvaux-dev libhighgui-dev
fi

mkdir external
cd external/

svn co https://svn.uni-koblenz.de/agas/projects/IntegVelodyne/30_prog/external/coreDataStructs/lib coreDataStructs

#svn co https://svn.uni-koblenz.de/agas/projects/IntegVelodyne/30_prog/external/imageGrabber/lib imageGrabber
#cd imageGrabber
#qmake
#make -j$GCC_THREADS
#cd ..

svn co https://svn.uni-koblenz.de/agas/projects/IntegVelodyne/30_prog/external/imageOperations/lib imageOperations
cd imageOperations
patch -p0 < ../../patches/imageOperationsPaths.diff
qmake
make -j$GCC_THREADS
cd ..

svn co https://svn.uni-koblenz.de/agas/projects/IntegVelodyne/30_prog/external/tinyxml
cd tinyxml
qmake
make -j$GCC_THREADS
cd ..

git clone git://github.com/mariusmuja/flann.git
cd flann
git checkout 94d28f2d2868709adac1c944472dda71f5b8c289
cmake . -DBUILD_MATLAB_BINDINGS=0 -DBUILD_PYTHON_BINDINGS=0 -DLATEX_OUTPUT_PATH=.
make -j$GCC_THREADS
cd ..

svn co https://lapackpp.svn.sourceforge.net/svnroot/lapackpp/lapackpp/trunk/ lapackpp
cd lapackpp
./autogen.sh
./configure
make -j$GCC_THREADS
ln -s include lapackpp
cd ..

cvs -z3 -d:pserver:anoncvs@cvs.savannah.nongnu.org:/cvsroot/toon co TooN
#cd TooN
#./configure
#cd ..

cvs -z3 -d:pserver:anoncvs@cvs.savannah.nongnu.org:/cvsroot/toon co tag
cd tag
chmod +x configure
./configure --with-TooN=..
#patch wrong header case
sed -i 's/svd.h/SVD.h/g' tag/absorient.h 
make -j$GCC_THREADS
cd ..

svn co https://artoolkit.svn.sourceforge.net/svnroot/artoolkit/trunk/artoolkit/
cd artoolkit
./Configure
make -j$GCC_THREADS
cd ..

wget http://freefr.dl.sourceforge.net/project/opencvlibrary/opencv-unix/2.3/OpenCV-2.3.0.tar.bz2
tar -xvjf OpenCV-2.3.0.tar.bz2
rm OpenCV-2.3.0.tar.bz2
cd OpenCV-2.3.0
cmake .
make -j$GCC_THREADS
cd ..

wget http://www.ics.forth.gr/~lourakis/sba/sba-1.6.tgz
tar xvfz sba-1.6.tgz
rm sba-1.6.tgz
mv sba-1.6 sba
cd sba
cmake . -Wno-dev
make -j$GCC_THREADS
cd ../..

svn co https://svn.uni-koblenz.de/agas/projects/IntegVelodyne/30_prog/baselib
cd baselib
patch -p0 < ../patches/baselibBuild.diff
cmake . -DRELEASE=1
make -j$GCC_THREADS
cd ..

svn co https://svn.uni-koblenz.de/decker/baselibApp
cd baselibApp
cmake . -DRELEASE=1
make -j$GCC_THREADS
echo "Done"


#wget http://www.ics.forth.gr/~lourakis/homest/homest-1.3.tgz
#tar xvfz homest-1.3.tgz
#rm homest-1.3.tgz
#mv homest-1.3 homest

#wget http://www.ics.forth.gr/~lourakis/levmar/levmar-2.5.tgz
#tar xvfz levmar-2.5.tgz
#rm levmar-2.5.tgz

#bzr branch lp:unicap

