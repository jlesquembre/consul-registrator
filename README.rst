====================
 Consul-Registrator
====================

Systemd service to run two docker_ containers with consul_ and registrator_.

It is based on these blog entries:

http://progrium.com/blog/2014/09/10/automatic-docker-service-announcement-with-registrator/

http://progrium.com/blog/2014/08/20/consul-service-discovery-with-docker/

Install
-------

To work properly requires you to install openresolv_ and docker_.

.. code:: bash

    make install

Or create a package if you are running Archlinux:

.. code:: bash

    make pkgbuild
    sudo pacman -U _build/consul-registrator-$version-any.pkg.tar.xz

Usage
-----

Start the service:

.. code:: bash

    systemctl start consul-registrator@net0

You can replace `net0` with any other network interface.

Once the service is running, try to open this url to see if everything is working:

http://consul:8500/

Now you can add an environment variable called `SERVICE_NAME` to every docker
service you are running. If you service has a web interface now is possible to
access it via http://SERVICE_NAME:PORT


Behind the scenes
-----------------

Apart of running two containers with consul_ and registrator_, the service
modifies you /etc/resolv.conf file. For this, openresolv_ is used.


.. _Docker: https://www.docker.com/

.. _Consul: https://www.consul.io/

.. _Registrator: https://github.com/progrium/registrator/

.. _openresolv: http://roy.marples.name/projects/openresolv/index
