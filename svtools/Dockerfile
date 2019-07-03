#
# SV calling tools docker image
# Paweł Sztromwasser, 03/2018
#
# Usage example:
# docker build -t pawels/svtools -f svtools.dockerfile
# docker run -v /home/ngs:/gen:ro -v /home/ngs/projects/RCAD_WGS/SV_docker:/work:rw -ti pawels/svtools
#

FROM pawels/ngstools

ENV tools_dir /tools
ENV bin_dir /usr/local/bin


RUN	apt update && \
	apt -y install gawk

# install SV2
RUN apt -y install python-numpy \
			       cython && \
	pip install sv2


# install Manta
RUN cd ${tools_dir} && \
	wget https://github.com/Illumina/manta/releases/download/v1.5.0/manta-1.5.0.centos6_x86_64.tar.bz2 && \
	tar -xjf manta-1.5.0.centos6_x86_64.tar.bz2 && \
	echo "cd /tools/manta-1.5.0.centos6_x86_6/bin && ./configManta.py $*" > ${bin_dir}/manta && \
    chmod u+x ${bin_dir}/manta


# install CNVnator
RUN apt -y install libcurl4-openssl-dev && \
    cd ${tools_dir} && \
	wget https://root.cern/download/root_v6.16.00.Linux-ubuntu18-x86_64-gcc7.3.tar.gz && \
    tar -xzf root_v6.16.00.Linux-ubuntu18-x86_64-gcc7.3.tar.gz && mv root root_v6.16.00 && \
    echo "export ROOTSYS=/tools/root_v6.16.00" >> ~/.bashrc && \
    echo "source /tools/root_v6.16.00/bin/thisroot.sh" >> ~/.bashrc && \
	wget https://github.com/abyzovlab/CNVnator/releases/download/v0.4/CNVnator_v0.4.zip && \
	unzip CNVnator_v0.4.zip && cd CNVnator_v0.4/src/ && \
    ln -s ../../samtools-1.9 samtools && \
    /bin/bash -c "export ROOTSYS=/tools/root_v6.16.00 && source /tools/root_v6.16.00/bin/thisroot.sh && make" && \
	ln -s ${tools_dir}/CNVnator_v0.4/src/cnvnator ${bin_dir}

# install speedseq
RUN apt -y install python-scipy && \
	cd ${tools_dir} && \
	git clone --recursive https://github.com/cc2qe/speedseq.git && \
	cd speedseq && export CXXFLAGS="-std=c++98" && make && \
	ln -s ${tools_dir}/speedseq/bin/speedseq ${bin_dir} && \
    cp ${tools_dir}/speedseq/bin/speedseq.config ${bin_dir}


# install MetaSV and its dependencies
RUN cd ${tools_dir} && \
	wget http://cab.spbu.ru/files/release3.11.1/SPAdes-3.11.1-Linux.tar.gz && \
	tar -xzf SPAdes-3.11.1-Linux.tar.gz && \
	ln -s ${tools_dir}/SPAdes-3.11.1-Linux/bin/spades.py ${bin_dir} && \
	wget https://github.com/abyzovlab/AGE/archive/master.zip && \
	unzip master.zip && cd AGE-master && make OMP=no && \
	ln -s ${tools_dir}/AGE-master/age_align ${bin_dir} && \
	pip install https://github.com/bioinform/metasv/archive/0.5.2.tar.gz

# SVTyper (latest, independently of SpeedSeq)
RUN pip install git+https://github.com/hall-lab/svtyper.git
























