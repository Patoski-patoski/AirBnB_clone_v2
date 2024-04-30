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
    """ do_deploy: distributes an archive to your web servers
        Args:
            archive_path(str): param 1

        Return True if args, False otherwise
    """
    if exists(archive_path) is False:
        return False
    try:
        put(archive_path, "/tmp/")

        first_split = archive_path.split('/')[-1]
        second_split = first_split.split('.')[0]

        path = f"/data/web_static/releases/{second_split}"
        run(f"mkdir -p {path}/")
        run(f"tar -xzf /tmp/{first_split} -C {path}")
        # Delete the archive from the web server
        run(f"rm -fr /tmp/{first_split}")
        run(f"rm -rf {path}/web_static")
        # Delete the symbolic link /data/web_static/current from the web server
        run(f"rm -rf /data/web_static/current")
        run(f"ln -sf {path}/ /data/web_static/current")
        local(f"ln -sf {path}/ /data/web_static/current")

        print("New version deployed!")
        return True
    except Exception:
        return False
