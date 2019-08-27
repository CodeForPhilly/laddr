#!/bin/bash

git holo project emergence-skeleton \
    --fetch \
    --ref=origin/releases/v3 \
    --commit-to=emergence/skeleton/v3

git holo project emergence-vfs-site \
    --fetch \
    --ref=origin/releases/v3 \
    --commit-to=emergence/vfs-site/v3
