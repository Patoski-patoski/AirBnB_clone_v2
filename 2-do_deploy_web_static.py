#!/usr/bin/python3
"""  1-pack_web_static.py: a Fabric script that generates a .tgz archive from
     the contents of the web_static folder of your AirBnB Clone repo
"""

from fabric.api import local, env, put, run
from datetime import datetime
from os.path import exists

env.hosts = ["35.175.128.192", "54.88.205.156"]


def do_pack():
    """ do_pack: Generates a .tgz archive from the contents of the web_static

        Args: None

        Return:  the archive path if the archive has been correctly generated.
        otherwise, None
    """

    get_time = datetime.now().strftime("%Y%m%d%H%M%S")

    # Creates the versions directory
    local("mkdir -p versions")

    # Create the archived file
    tgz_file = f"versions/web_static_{get_time}.tgz"

    # archiving process
    archived = local(f"tar -cvzf {tgz_file} web_static")

    if not archived.failed:
        return archived
    return None


def do_deploy(archive_path):
    """distributes an archive to your web servers
    """
    if exists(archive_path) is False:
        return False
    try:
        put(archive_path, "/tmp/")
        file_name = archive_path.split("/")[-1]
        path = "/data/web_static/releases/{}".format(file_name.split('.')[0])
        run("mkdir -p {}".format(path))
        run("tar -xzf /tmp/{} -C {}/".format(file_name, path))
        run("rm /tmp/{}".format(file_name))
        run("mv {}/web_static/* {}/".format(path, path))
        run("rm -rf {}/web_static".format(path))
        run("rm -rf /data/web_static/current")
        run("ln -s {}/ /data/web_static/current".format(path))
        print("New version deployed!")
        return True
    except Exception:
        return False
