#!/usr/bin/env python

import os
import emsm # pylint: disable=import-error

minecraft_dir = os.environ.get('MINECRAFT_DIR')
emsm.run(instance_dir=minecraft_dir)
