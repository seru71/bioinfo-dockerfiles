#
# WGS analysis tools docker image
# Paweł Sztromwasser, 02/2019
#
# Usage example:
# docker build -t pawels/wgs-tools -f wgstools.dockerfile
# docker run -v /home/ngs/reference:/reference:ro -v /home/ngs/projects/my_project:/work:rw -ti pawels/wgstools
#

FROM pawels/svtools

ENV tools_dir /tools
ENV bin_dir /usr/local/bin


# GATK
RUN cd ${tools_dir} && \
    wget https://github.com/broadinstitute/gatk/releases/download/4.1.0.0/gatk-4.1.0.0.zip && \
    unzip gatk-4.1.0.0.zip && \
    ln -s ${tools_dir}/gatk-4.1.0.0/gatk ${bin_dir}/gatk
        
# VT
RUN apt -y install libcurl4-openssl-dev libssl-dev && \
    cd ${tools_dir} && \
    wget https://github.com/atks/vt/archive/0.57721.tar.gz && \
    tar -xzf 0.57721.tar.gz && \
    cd vt-0.57721 && make && ln -s ${tools_dir}/vt-0.57721/vt ${bin_dir}/vt

# SnpEff
RUN cd ${tools_dir} && \
    wget http://sourceforge.net/projects/snpeff/files/snpEff_latest_core.zip && \
    unzip snpEff_latest_core.zip && \
    echo 'java -jar ${tools_dir}/snpEff/snpEff.jar $*' > ${bin_dir}/snpeff && \
    echo 'java -jar ${tools_dir}/snpEff/SnpSift.jar$*' > ${bin_dir}/snpsift && \
    chmod a+x ${bin_dir}/snpeff && chmod a+x ${bin_dir}/snpsift && \
    snpeff download GRCh38.86
    

# VEP
RUN apt install -y cpanminus libmysqlclient-dev && \
    cpanm Archive::Zip DBD::mysql DBI && \
    cd ${tools_dir} && \
    git clone https://github.com/Ensembl/ensembl-vep.git && \
    cd ensembl-vep && \
    perl INSTALL.pl --AUTO ap --PLUGINS all && \
    ln -s ${tools_dir}/ensembl-vep/vep ${bin_dir}/vep && \
    ln -s ${tools_dir}/ensembl-vep/filter_vep ${bin_dir}/filter_vep

# bcftools
RUN cd ${tools_dir} && \
    wget https://github.com/samtools/bcftools/releases/download/1.9/bcftools-1.9.tar.bz2 && \
    tar -xjf bcftools-1.9.tar.bz2 && \
    cd bcftools-1.9 && make && \
    ln -s ${tools_dir}/bcftools-1.9/bcftools  ${bin_dir}  
    
