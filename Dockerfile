# version 1 - IBM Installation Manager(I.M) silent install on a docker centos6 linux image. You might do this using an official supported Red Hat or Suze
# See the complete list of supported O.S looking at the official IBM documentation.
# IBM Installation Manager 1.8 Documentation - http://www-01.ibm.com/support/knowledgecenter/SSDV2W_1.8.0/com.ibm.cic.agent.ui.doc/helpindex_imic.html?cp=SSDV2W_1.8.0%2F0
# by mmaia - mpais@br.ibm.com, maia.marcos@gmail.com
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
# +------------------------------------------------------------------------+
# | Licensed Materials - Property of IBM                                   |
# | (C) Copyright IBM Corp. 2010, 2011.  All Rights Reserved.              |
# |                                                                        |
# | US Government Users Restricted Rights - Use, duplication or disclosure |
# | restricted by GSA ADP Schedule Contract with IBM Corp.                 |
# +------------------------------------------------------------------------+

FROM centos:centos6
MAINTAINER Marcos Maia "mpais@br.ibm.com / maia.marcos@gmail.com"

# make sure centos is up to date and install unzip support to decompress I.M file later
RUN yum update && yum install -y unzip

#create user and group to use with websphere and Installation Manager
RUN groupadd -r wasadmin && useradd -r -g wasadmin wasadmin

#copy I.M to image
COPY agent.installer.linux.gtk.x86_64_1.8.0.20140902_1503.zip tmp/agent.installer.linux.gtk.x86_64_1.8.0.20140902_1503.zip

# unzip I.M install it and delete all files. The installation log is written to /opt/im_install.log
RUN cd tmp && unzip agent.installer.linux.gtk.x86_64_1.8.0.20140902_1503.zip && ./installc -log /opt/im_install.log -acceptLicense && rm -rf *

#change the user owner for IBM folder and subfolders to be wasadmin:wasadmin . I use this for WebSphere based products.
RUN cd /opt && chown -R wasadmin:wasadmin IBM