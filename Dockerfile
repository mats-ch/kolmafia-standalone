# Kolmafia inside a vncserver inside docker

FROM ubuntu:20.04

ARG VNCPASSWD=kolmafia
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
	apt-get install \
	openjdk-17-jre curl tightvncserver xterm icewm git nodejs jq python sudo python-numpy snapd python3-numpy -y

COPY .vnc /home/kolmafia/.vnc
COPY kolmafia.sh /home/kolmafia/kolmafia.sh
RUN chmod +x /home/kolmafia/kolmafia.sh

RUN mkdir -p /home/kolmafia
RUN useradd kolmafia -d /home/kolmafia
RUN chown -R kolmafia:kolmafia /home/kolmafia

RUN echo "kolmafia ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER kolmafia

ENV USER kolmafia
ENV HOME /home/kolmafia

RUN curl $(curl -s https://api.github.com/repos/kolmafia/kolmafia/releases/latest | jq '.assets[] | select(.name | endswith("jar")).browser_download_url') -o /home/kolmafia/kolmafia.jar

RUN git clone https://github.com/novnc/noVNC.git /home/kolmafia/novnc

RUN echo $VNCPASSWD | vncpasswd -f > /home/kolmafia/.vnc/passwd
RUN chmod 0600 /home/kolmafia/.vnc/passwd
RUN chmod +x /home/kolmafia/.vnc/xstartup

ENTRYPOINT ["/home/kolmafia/kolmafia.sh"]
