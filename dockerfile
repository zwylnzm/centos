FROM centos:latest

MAINTAINER zwylnzm

RUN yum update
RUN yum install -y git
