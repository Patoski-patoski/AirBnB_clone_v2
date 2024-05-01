#!/usr/bin/python3
""" 100-clean_web_static"""

from fabric.api import local, run, env
env.hosts = ["35.175.128.192", "54.88.205.156"]


def do_clean(number=0):
    """do_clean: deletes out-of-date archives
       Args:
            number(int): The number to remain
    """
    number = int(number)
    if number == 0 or number == 1:
        number = 1

    remote_path = "/data/web_static/releases/"
    local(f"cd versions ; ls -rt | head -n {-number} | xargs rm -rf --")
    run(f"cd {remote_path} ; ls -rt | head -n {-number} | xargs rm -rf --")
