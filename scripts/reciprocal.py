#!/usr/bin/env python

from __future__ import division
import binascii
import sys
import subprocess
import os
import struct
import numpy as np

def reciprocal_div():
    filename = "reciprocal_div.vhd"
    file = open(filename,"w+")

    data    = 1.0
    tsize   = 2**7
    plength = 8

    for i in range(tsize):
        div = int((1.0 / data) * 2**plength)
        if i == 0:
            div = 0
        str = '\"' + np.binary_repr(div, width=plength) + '\"'
        if i < tsize - 1:
            str = str  + ','
        if i%8 == 7:
            str = str  + '\n'
        file.writelines(str)
        data = data + 1.0 / tsize

    file.close()

def reciprocal_root():
    filename = "reciprocal_root.vhd"
    file = open(filename,"w+")

    data    = 0.5
    tsize   = 2**6
    plength = 8

    for i in range(int(tsize/2)):
        root = int((1.0 / (data**0.5)) * 2**(plength-1))
        str = '\"' + np.binary_repr(root, width=plength) + '\"'
        if i < tsize - 1:
            str = str  + ','
        if i%8 == 7:
            str = str  + '\n'
        file.writelines(str)
        data = data + 1.0 / tsize

    data    = 1.0
    tsize   = 2**7
    plength = 8

    for i in range(int(tsize/2),tsize):
        root = int((1.0 / (data**0.5)) * 2**(plength-1))
        str = '\"' + np.binary_repr(root, width=plength) + '\"'
        if i < tsize - 1:
            str = str  + ','
        if i%8 == 7:
            str = str  + '\n'
        file.writelines(str)
        data = data + 2.0 / tsize

    file.close()

if __name__ == '__main__':

    reciprocal_div()
    reciprocal_root()
