#
# miRNA tools docker image
# Paweł Sztromwasser, 03/2018
#
# Usage example:
# docker build -t pawels/mirtools -f mirna-tools.dockerfile
# docker run -v /:/gen:ro -v /home/pawels/projects/mirseq_pipeline/out:/out -ti pawels/mirtools
#

FROM pawels/ngstools:latest

ENV tools_dir /tools
ENV bin_dir /usr/local/bin

#
# use later to create mirna user owning stuff, instead of root
#ENV username mirna

# install trimming script
RUN apt -y install libtre-dev && \
	pip install tre && \
	wget -O ${bin_dir}/trim_UMI.py https://pastebin.com/raw/UuYuzwQD && \
	chmod a+x ${bin_dir}/trim_UMI.py

ENV TZ=Europe/Warsaw

# install tDRmapper
RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && \
    echo ${TZ} > /etc/timezone && \
    apt -y install r-base && \
	cd ${tools_dir} && \
	wget http://github.com/sararselitsky/tDRmapper/archive/c5079bf9d07906869d76fcf5564cecc300d68b7e.zip && \
	unzip c5079bf9d07906869d76fcf5564cecc300d68b7e.zip && \
	echo '${tools_dir}/tDRmapper-c5079bf9d07906869d76fcf5564cecc300d68b7e/Scripts/TdrMappingScripts.pl $*' > ${bin_dir}/tdrmapper && \
	chmod a+x ${bin_dir}/tdrmapper

# install mirdeep2
RUN cd ${tools_dir} && \
	wget https://github.com/rajewsky-lab/mirdeep2/archive/562963670200e6e63ff7d55c8e99acf4d6184c5b.zip && \
	unzip 562963670200e6e63ff7d55c8e99acf4d6184c5b.zip && \
	cd mirdeep2-562963670200e6e63ff7d55c8e99acf4d6184c5b && \
	perl install.pl && \
	/bin/bash -c 'source ~/.bash_profile' && \
	perl install.pl

# UMI-tools
RUN pip install -U setuptools && \
    pip install umi_tools



