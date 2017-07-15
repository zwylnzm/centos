FROM centos:7

MAINTAINER zwylnzm

ENV DISPLAY :1
ENV VNC_PORT 5901
EXPOSE $VNC_PORT
ENV VNC_COL_DEPTH 24
ENV VNC_RESOLUTION 1280x1024
ENV VNC_PW vncpassword


ENV HOME /home/kknd
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
RUN yum --enablerepo=epel -y -x gnome-keyring --skip-broken groups install "Xfce" 
RUN yum -y groups install "Fonts"
RUN yum erase -y *power* *screensaver*
RUN rm /etc/xdg/autostart/xfce-polkit*
RUN /bin/dbus-uuidgen > /etc/machine-id
RUN yum -y install tigervnc-server
RUN yum -y install lyx
RUN yum -y install firefox
RUN yum -y install nss_wrapper gettext
RUN yum clean all


### configuration
RUN mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
ADD ./config/CentOS-Base.repo /etc/yum.repos.d/
ADD ./config/xfce/ $HOME/
RUN echo 'source $STARTUPDIR/generate_container_user' >> $HOME/.bashrc
ADD ./dockerboot $STARTUPDIR
RUN $INST_SCRIPTS/set_user_permission.sh $STARTUPDIR $HOME

USER 1984

ENTRYPOINT ["/dockerstartup/vnc_startup.sh"]
CMD ["--tail-log"]