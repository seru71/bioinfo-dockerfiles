#
# Generic NGS tools docker image
# Paweł Sztromwasser, 02/2019
#
# Usage example:
# docker build -t pawels/ngstools -f ngstools.dockerfile
# docker run -v /:/host:ro -v /home/pawels/projects/my_project:/work -ti pawels/ngstools
#

FROM ubuntu:bionic

ENV tools_dir /tools
ENV bin_dir /usr/local/bin

#
# use later to create ngs user owning stuff, instead of root
#ENV username ngs

#RUN cp /etc/apt/sources.list /etc/apt/sources.list.backup && \
#	echo deb mirror://mirrors.ubuntu.com/mirrors.txt bionic main restricted universe multiverse > /etc/apt/sources.list && \
#	echo deb mirror://mirrors.ubuntu.com/mirrors.txt bionic-updates main restricted universe multiverse >> /etc/apt/sources.list && \
#	echo deb mirror://mirrors.ubuntu.com/mirrors.txt bionic-backports main restricted universe multiverse >> /etc/apt/sources.list && \
#	echo deb mirror://mirrors.ubuntu.com/mirrors.txt bionic-security main restricted universe multiverse >> /etc/apt/sources.list && \
    
RUN apt update && \
	apt -y install curl \
			rsync \
			wget \
			unzip \
			parallel \
            git \
			vim \
			build-essential \
            cmake \
            zlib1g-dev \
            python-pip \
            virtualenv \
            openjdk-8-jre \
            tabix && \
	mkdir ${tools_dir}

# FastQC
RUN cd ${tools_dir} && \
	wget https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.7.zip && \
	unzip fastqc_v0.11.7.zip && \
	chmod a+x FastQC/fastqc && \
	ln -s ${tools_dir}/FastQC/fastqc ${bin_dir}

# MultiQC
RUN pip install multiqc

# install trimmomatic
RUN cd ${tools_dir} && \
	wget http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-0.36.zip && \
	unzip Trimmomatic-0.36.zip && \
	echo 'java -jar ${tools_dir}/Trimmomatic-0.36/trimmomatic-0.36.jar $*' > ${bin_dir}/trimmomatic && \
	chmod a+x ${bin_dir}/trimmomatic

# install bwa
RUN cd ${tools_dir} && \
	wget https://github.com/lh3/bwa/releases/download/v0.7.17/bwa-0.7.17.tar.bz2 && \
	tar -xjf bwa-0.7.17.tar.bz2 && \
	cd bwa-0.7.17 && \
	make && \
	ln -s ${tools_dir}/bwa-0.7.17/bwa ${bin_dir}

# install samtools
RUN apt -y install liblzma-dev \
		libncurses-dev \
		libbz2-dev && \
	cd ${tools_dir} && \
	wget https://github.com/samtools/samtools/releases/download/1.9/samtools-1.9.tar.bz2 && \
	tar -xjf samtools-1.9.tar.bz2 && \
	cd samtools-1.9 && \
	make && \
	ln -s ${tools_dir}/samtools-1.9/samtools ${bin_dir}

# install bowtie2
RUN apt -y install mutrace \
		libtbb-dev && \
	cd ${tools_dir} && \
	wget https://downloads.sourceforge.net/project/bowtie-bio/bowtie2/2.3.4.1/bowtie2-2.3.4.1-source.zip && \
	unzip bowtie2-2.3.4.1-source.zip && \
	cd bowtie2-2.3.4.1 && \
	make && \
	ln -s ${tools_dir}/bowtie2-2.3.4.1/bowtie2 ${bin_dir}
	
# install hisat2
RUN cd ${tools_dir} && \
	wget ftp://ftp.ccb.jhu.edu/pub/infphilo/hisat2/downloads/hisat2-2.1.0-source.zip && \
	unzip hisat2-2.1.0-source.zip && \
	cd hisat2-2.1.0 && \
	make && \
	ln -s ${tools_dir}/hisat2-2.1.0/hisat2 ${bin_dir}

# Install Picard
RUN cd ${tools_dir} && \
        mkdir picard-2.18.26 && cd picard-2.18.26 && \
        wget https://github.com/broadinstitute/picard/releases/download/2.18.26/picard.jar && \
        echo 'java -jar /tools/picard-2.18.26/picard.jar $@' > /usr/local/bin/picard && \
        chmod a+x /usr/local/bin/picard

# Subread (featureCount)
RUN cd ${tools_dir} && \
	wget https://sourceforge.net/projects/subread/files/subread-1.6.1/subread-1.6.1-source.tar.gz && \
	tar -xzf subread-1.6.1-source.tar.gz && \
	cd subread-1.6.1-source/src && \
	make -f Makefile.Linux && \
	ln -s ${tools_dir}/subread-1.6.1-source/bin/featureCounts ${bin_dir}

# STAR
RUN cd ${tools_dir} && \
    wget https://github.com/alexdobin/STAR/archive/2.7.0f.tar.gz && \
    tar -xzf 2.7.0f.tar.gz && \
    ln -s ${tools_dir}/STAR-2.7.0f/bin/Linux_x86_64/STAR ${bin_dir}

# bamtools
RUN cd ${tools_dir} && \
    wget https://github.com/pezmaster31/bamtools/archive/v2.5.1.tar.gz && \
    tar -xzf v2.5.1.tar.gz && \
    mkdir bamtools-2.5.1/build && cd bamtools-2.5.1/build && \
    cmake -DCMAKE_INSTALL_PREFIX=${tools_dir}/bamtools-2.5.1 .. && \
    make && make install && \
    ln -s ${tools_dir}/bamtools-2.5.1/bin/bamtools ${bin_dir}

# bedtools
RUN cd ${tools_dir} && \
    wget https://github.com/arq5x/bedtools2/releases/download/v2.28.0/bedtools-2.28.0.tar.gz && \
    tar -xzf bedtools-2.28.0.tar.gz && mv bedtools2 bedtools-2.28.0 && \
    cd bedtools-2.28.0 && make && \
    ln -s ${tools_dir}/bedtools-2.28.0/bin/bedtools ${bin_dir}


# Biopython and other useful bioinfo packages
RUN pip install biopython \
                pyfaidx \
                ruffus

# Pipeline
#drmaa ??





