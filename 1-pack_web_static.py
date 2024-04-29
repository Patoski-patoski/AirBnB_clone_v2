#!/usr/bin/python3
"""  1-pack_web_static.py: a Fabric script that generates a .tgz archive from the contents of the 
    web_static folder of your AirBnB Clone repo
"""

from fabric.api import local
from datetime import datetime


def do_pack():
    """ do_pack: Generates a .tgz archive from the contents of the web_static

        Args: None

        Return:  the archive path if the archive has been correctly generated.
        otherwise, None
    """

    get_time = datetime.now().strftime("%Y%m%d%H%M%S")

    # Creates the versions directory
    local("mkdir -p versions")

    #Create the archived file
    tgz_file = f"versions/web_static_{get_time}.tgz"

    # archiving process
    archived = local(f"tar -cvzf {tgz_file} web_static")

    if not archived.failed:
        return archived
    return None
