#
# SV calling tools docker image
# Paweł Sztromwasser, 03/2018
#
# Usage example:
# docker build -t pawels/svtools svtools.dockerfile
# docker run -v /home/ngs:/gen:ro -v /home/ngs/projects/RCAD_WGS/SV_docker:/work:rw -ti pawels/svtools
#

FROM ubuntu:xenial

ENV tools_dir /tools
ENV bin_dir /usr/local/bin

#
# use later to create mirna user owning stuff, instead of root
#ENV username mirna

RUN cp /etc/apt/sources.list /etc/apt/sources.list.backup && \
	echo deb mirror://mirrors.ubuntu.com/mirrors.txt xenial main restricted universe multiverse > /etc/apt/sources.list && \
	echo deb mirror://mirrors.ubuntu.com/mirrors.txt xenial-updates main restricted universe multiverse >> /etc/apt/sources.list && \
	echo deb mirror://mirrors.ubuntu.com/mirrors.txt xenial-backports main restricted universe multiverse >> /etc/apt/sources.list && \
	echo deb mirror://mirrors.ubuntu.com/mirrors.txt xenial-security main restricted universe multiverse >> /etc/apt/sources.list && \
	apt update && \
	apt -y install curl \
			git \
			rsync \
			wget \
			unzip \
			parallel \
			vim \
			gawk \
			build-essential \
			cmake \
			zlib1g-dev \
			liblzma-dev \
			libncurses-dev \
			libbz2-dev && \
	mkdir ${tools_dir}


# install samtools
RUN cd ${tools_dir} && \
	wget https://github.com/samtools/samtools/releases/download/1.7/samtools-1.7.tar.bz2 && \
	tar -xjf samtools-1.7.tar.bz2 && \
	cd samtools-1.7 && \
	make && \
	ln -s ${tools_dir}/samtools-1.7/samtools ${bin_dir}


# install bwa
RUN cd ${tools_dir} && \
	wget https://sourceforge.net/projects/bio-bwa/files/bwa-0.7.17.tar.bz2 && \
	tar -xjf bwa-0.7.17.tar.bz2 && \
	cd bwa-0.7.17 && \
	make && \
	ln -s ${tools_dir}/bwa-0.7.17/bwa ${bin_dir}


# install SV2
RUN apt -y install python-setuptools \
			python-dev \
			python-numpy \
			cython \
			bedtools && \
	easy_install pip && \
	pip install sv2


# install Manta
RUN cd ${tools_dir} && \
	wget https://github.com/Illumina/manta/releases/download/v1.3.2/manta-1.3.2.release_src.tar.bz2 && \
	tar -xjf manta-1.3.2.release_src.tar.bz2 && \
	mkdir manta-build && cd manta-build && \
 	../manta-1.3.2.release_src/configure --jobs=8 --prefix=${tools_dir}/manta-1.3.2 && \
	make -j8 install && \
	ln -s ${tools_dir}/manta-1.3.2/bin/configManta.py ${bin_dir}/manta
#
# the ${bin_dir}/manta link does not work
#

# install CNVnator
RUN export DEBIAN_FRONTEND=noninteractive && \
	apt -y install root-system && \
	echo "export ROOTSYS=/usr" >> ~/.bashrc && export ROOTSYS=/usr && \
	cd ${tools_dir} && \
	wget https://github.com/abyzovlab/CNVnator/releases/download/v0.3.3/CNVnator_v0.3.3.zip && \
	unzip CNVnator_v0.3.3.zip && \
	cd CNVnator_v0.3.3/src/samtools && make && \
	cd .. && make && \
	ln -s ${tools_dir}/CNVnator_v0.3.3/src/cnvnator ${bin_dir}
	


# install speedseq
RUN apt -y install python-scipy && \
	cd ${tools_dir} && \
	git clone --recursive https://github.com/cc2qe/speedseq.git && \
	cd speedseq && make && \
	ln -s ${tools_dir}/speedseq/bin/speedseq ${bin_dir}


































