FROM centos:7

MAINTAINER zwylnzm

ENV DISPLAY :1
ENV VNC_PORT 5901
EXPOSE $VNC_PORT
ENV VNC_COL_DEPTH 24
ENV VNC_RESOLUTION 1024x768
ENV VNC_PW vncpassword

ENV HOME /root
ENV STARTUPDIR /root
WORKDIR $HOME
ENV INST_SCRIPTS $HOME/install
ADD . $INST_SCRIPTS/

RUN find $INST_SCRIPTS -name '*.sh' -exec chmod a+x {} +
RUN $INST_SCRIPTS/tools.sh

ENTRYPOINT ["/root/install/vnc_startup.sh"]
CMD ["--tail-log"]