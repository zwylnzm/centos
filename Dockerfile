FROM centos:7

MAINTAINER zwylnzm

ENV DISPLAY :1
ENV VNC_PORT 5901
EXPOSE $VNC_PORT
ENV VNC_COL_DEPTH 24
ENV VNC_RESOLUTION 1280x720
ENV VNC_PW vncpassword

RUN useradd -m -G wheel docker && echo "docker:docker" | chpasswd
ENV HOME /home/docker
ENV STARTUPDIR /dockerstartup
WORKDIR $HOME
ENV INST_SCRIPTS $HOME/install
ADD ./install_script/ $INST_SCRIPTS/
RUN find $INST_SCRIPTS -name '*.sh' -exec chmod a+x {} +

RUN yum -y update
RUN yum -y install epel-release 
RUN yum -y update
RUN yum -y install sudo
RUN yum -y install vim 
RUN yum -y install wget 
RUN yum -y install which 
RUN yum -y install net-tools 
RUN yum -y install bash-completion 
RUN yum -y install nano
RUN yum -y install emacs
RUN yum -y install git
RUN yum -y groupinstall xfce
RUN yum -y install mousepad
RUN yum -y install gtk2-engines
RUN yum -y install xfwm4-themes
RUN yum -y groups install "Fonts"
RUN yum erase -y *power* *screensaver*
RUN rm /etc/xdg/autostart/xfce-polkit*
RUN /bin/dbus-uuidgen > /etc/machine-id
RUN yum -y install tigervnc-server
RUN yum -y install lyx
RUN yum -y install texlive-xetex*
RUN yum -y install texlive-euenc
RUN yum -y install evince
RUN yum -y install firefox
RUN yum -y install libreoffice
RUN yum -y install xarchiver
RUN yum -y install nss_wrapper gettext
RUN yum -y install R
RUN yum -y install gstreamer gstreamer-plugins-base
RUN $INST_SCRIPTS/rstudio.sh
RUN yum -y install ibus-libpinyin
RUN yum -y install im-chooser
RUN yum clean all


### configuration
#RUN mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
#ADD ./config/CentOS-Base.repo /etc/yum.repos.d/
ADD ./config/config/ $HOME/.config
ADD ./config/emacs.d/ $HOME/.emacs.d
ADD ./config/pip $HOME/.pip
RUN echo 'source $STARTUPDIR/generate_container_user' >> $HOME/.bashrc
RUN echo 'export PS1="\[\033[38;5;11m\]\u\[$(tput sgr0)\]\[\033[38;5;15m\]@\h:\[$(tput sgr0)\]\[\033[38;5;6m\][\w]\[$(tput sgr0)\]\[\033[38;5;9m\]\\$\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]"' >> $HOME/.bashrc
ADD ./dockerboot $STARTUPDIR
RUN $INST_SCRIPTS/set_user_permission.sh $STARTUPDIR $HOME

USER docker

ENTRYPOINT ["/dockerstartup/vnc_startup.sh"]
CMD ["--tail-log"]