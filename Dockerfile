FROM joshbav/centos:latest

#### REFRESH YUM CACHE, SINCE WE OFTEN BUILD NEW TRACTOR CONTAINERS AND
# LEAVE THE BASE OS CONTAINER ALONE, AND THE BASE CAN BE OLD
RUN yum makecache fast
####

#### SETUP USERS
# Since tractor is in a container, and this is a POC project, we aren't concerned about user account rights
RUN useradd tractor
RUN usermod -a -G wheel tractor
# centos is a default user account for sub processes
RUN useradd centos
RUN usermod -a -G wheel centos
####

# Not sure if it's needed, but a makefile was used in a sanity check render jobs
RUN yum install -y make 

#### SUDO
# Doing things like mount commands can require sudo
RUN yum install -y sudo
# A slightly modified sudoers file was made for NFS mounting and such
ADD sudoers /etc/sudoers
# Adds config to avoid the first time sudo lecure when used in a script
ADD privacy /etc/sudoers.d/privacy
####

#### TRACTOR v2.2 (1715407)
ADD Tractor-2.2_1715407-linuxRHEL6_gcc44icc150.x86_64.rpm /tmp
RUN rpm -ivh /tmp/Tractor-2.2_1715407-linuxRHEL6_gcc44icc150.x86_64.rpm
RUN rm /tmp/Tractor-2.2_1715407-linuxRHEL6_gcc44icc150.x86_64.rpm
####

### RENDERMAN v21.6
ADD RenderManProServer-21.6_1803412-linuxRHEL6_gcc44icc150.x86_64.rpm /tmp
RUN rpm -ivh /tmp/RenderManProServer-21.6_1803412-linuxRHEL6_gcc44icc150.x86_64.rpm
####

### RENDERMAN v21.7
ADD RenderManProServer-21.7_1837774-linuxRHEL6_gcc44icc150.x86_64.rpm /tmp
RUN rpm -ivh /tmp/RenderManProServer-21.7_1837774-linuxRHEL6_gcc44icc150.x86_64.rpm
RUN rm /tmp/RenderManProServer-21.7_1837774-linuxRHEL6_gcc44icc150.x86_64.rpm
####

#### THE ENV VARS ARE NOT USED since the container orchestrator will inject the path and RMANTREE
# which allows the same container to be used for multiple tractor versions to demo the usefulness of containers. 
# However in production a container for each version of renderman is likely and we'd need to install the 
# previous versions of maya and katana
#ENV RMANTREE=/opt/pixar/RenderManProServer-21.7
#ENV PATH=$RMANTREE/bin:$PATH
####

#### RENDERMAN FOR MAYA 2018 v21.7
ADD RenderManForMaya-maya2018-21.7_1837774-linuxRHEL6_gcc44icc150.x86_64.rpm /tmp
RUN rpm -ivh /tmp/RenderManForMaya-maya2018-21.7_1837774-linuxRHEL6_gcc44icc150.x86_64.rpm
RUN rm /tmp/RenderManForMaya-maya2018-21.7_1837774-linuxRHEL6_gcc44icc150.x86_64.rpm
# TODO: is this installed correctly? https://rmanwiki.pixar.com/display/RFM/Installation+of+RenderMan+for+Maya
####

#### RENDERMAN FOR KATANA 3.0 v21.7
ADD RenderManForKatana-katana3.0-21.7_1837774-linuxRHEL6_gcc44icc150.x86_64.rpm /tmp
RUN rpm -ivh /tmp/RenderManForKatana-katana3.0-21.7_1837774-linuxRHEL6_gcc44icc150.x86_64.rpm
RUN rm /tmp/RenderManForKatana-katana3.0-21.7_1837774-linuxRHEL6_gcc44icc150.x86_64.rpm
####


#### TEMP, TO REMOVE
# To simplify things for the POC
##RUN chmod -R 777 /opt/pixar
####

#### MISC CLEANUP
# Clear out /tmp's rpm files
RUN rm -rf /tmp/*.rpm
# Clean up yum
# not using while developing this container: RUN yum clean all
# not using while developing this container: RUN rm -rf /var/cache/yum
####
