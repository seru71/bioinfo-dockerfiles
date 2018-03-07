#
# miRNA tools docker image
# Paweł Sztromwasser, 03/2018
#
# Usage example:
# docker build -t pawels/mirtools mirna-tools.dockerfile
# docker run -v /:/gen:ro -v /home/pawels/projects/mirseq_pipeline/out:/out -ti pawels/mirtools
#

FROM ubuntu:trusty

ENV tools_dir /tools
ENV bin_dir /usr/local/bin

#
# use later to create mirna user owning stuff, instead of root
#ENV username mirna

RUN cp /etc/apt/sources.list /etc/apt/sources.list.backup && \
	echo deb mirror://mirrors.ubuntu.com/mirrors.txt trusty main restricted universe multiverse > /etc/apt/sources.list && \
	echo deb mirror://mirrors.ubuntu.com/mirrors.txt trusty-updates main restricted universe multiverse >> /etc/apt/sources.list && \
	echo deb mirror://mirrors.ubuntu.com/mirrors.txt trusty-backports main restricted universe multiverse >> /etc/apt/sources.list && \
	echo deb mirror://mirrors.ubuntu.com/mirrors.txt trusty-security main restricted universe multiverse >> /etc/apt/sources.list && \
	apt update && \
	apt -y install curl \
			rsync \
			wget \
			unzip \
			parallel \
			vim \
			build-essential && \
	mkdir ${tools_dir}

# FastQC
RUN cd ${tools_dir} && \
	wget https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.7.zip && \
	unzip fastqc_v0.11.7.zip && \
	chmod u+x FastQC/fastqc && \
	ln -s ${tools_dir}/FastQC/fastqc ${bin_dir}

# MultiQC
RUN apt -y install python-setuptools \
			python-dev && \
	easy_install pip && \
	pip install multiqc


# install trimmomatic
RUN apt -y install openjdk-7-jre && \
	cd ${tools_dir} && \
	wget http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-0.36.zip && \
	unzip Trimmomatic-0.36.zip && \
	echo 'java -jar ${tools_dir}/Trimmomatic-0.36/trimmomatic-0.36.jar $*' > ${bin_dir}/trimmomatic && \
	chmod u+x ${bin_dir}/trimmomatic

# install bwa
RUN apt -y install zlib1g-dev && \
	cd ${tools_dir} && \
	wget https://sourceforge.net/projects/bio-bwa/files/bwa-0.7.17.tar.bz2 && \
	tar -xjf bwa-0.7.17.tar.bz2 && \
	cd bwa-0.7.17 && \
	make && \
	ln -s ${tools_dir}/bwa-0.7.17/bwa ${bin_dir}

# install bowtie2
RUN apt -y install zlib1g-dev \
		mutrace \
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

# install tDRmapper
RUN apt -y install r-base && \
	cd ${tools_dir} && \
	wget http://github.com/sararselitsky/tDRmapper/archive/c5079bf9d07906869d76fcf5564cecc300d68b7e.zip && \
	unzip c5079bf9d07906869d76fcf5564cecc300d68b7e.zip && \
	echo '${tools_dir}/tDRmapper-c5079bf9d07906869d76fcf5564cecc300d68b7e/Scripts/TdrMappingScripts.pl $*' > ${bin_dir}/tdrmapper && \
	chmod u+x ${bin_dir}/tdrmapper

# install mirdeep2
RUN cd ${tools_dir} && \
	wget https://github.com/rajewsky-lab/mirdeep2/archive/562963670200e6e63ff7d55c8e99acf4d6184c5b.zip && \
	unzip 562963670200e6e63ff7d55c8e99acf4d6184c5b.zip && \
	cd mirdeep2-562963670200e6e63ff7d55c8e99acf4d6184c5b && \
	perl install.pl && \
	/bin/bash -c 'source ~/.bash_profile' && \
	perl install.pl

# install samtools
#
# TODO: use version 1.4 from github!!
#
RUN apt -y install liblzma-dev &&
	cd ${tools_dir} && \
	wget https://github.com/samtools/samtools/releases/download/1.7/samtools-1.7.tar.bz2 && \
	tar -xjf samtools-1.7.tar.bz2 && \
	cd samtools-1.7 && \
	make && \
	ln -s ${tools_dir}/samtools-1.7/bin/samtools ${bin_dir}


