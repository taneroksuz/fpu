#!/usr/bin/env python

import binascii
import sys
import subprocess
import os
from os.path import basename


if __name__ == '__main__':

    if len(sys.argv) < 4:
        print('Expected usage: {0} <type> <folder> <testfloat path>'.format(sys.argv[0]))
        sys.exit(1)

    operation = sys.argv[1]
    folder = sys.argv[2]
    testfloat = sys.argv[3]
    
    list_operation = [ \
        ('f32_mulAdd',"0","0","0","001"), \
        ('f32_add',"0","0","0","002"), \
        ('f32_sub',"0","0","0","004"), \
        ('f32_mul',"0","0","0","008"), \
        ('f32_div',"0","0","0","010"), \
        ('f32_sqrt',"0","0","0","020"), \
        ('f64_mulAdd',"1","0","0","001"), \
        ('f64_add',"1","0","0","002"), \
        ('f64_sub',"1","0","0","004"), \
        ('f64_mul',"1","0","0","008"), \
        ('f64_div',"1","0","0","010"), \
        ('f64_sqrt',"1","0","0","020"), \
        ('f32_le',"0","0","0","040"), \
        ('f32_lt',"0","1","0","040"), \
        ('f32_eq',"0","2","0","040"), \
        ('f64_le',"1","0","0","040"), \
        ('f64_lt',"1","1","0","040"), \
        ('f64_eq',"1","2","0","040"), \
        ('f32_to_f64',"1","0","0","080"), \
        ('f64_to_f32',"0","0","1","080"), \
        ('i32_to_f32',"0","0","0","100"), \
        ('ui32_to_f32',"0","0","1","100"), \
        ('i64_to_f32',"0","0","2","100"), \
        ('ui64_to_f32',"0","0","3","100"), \
        ('i32_to_f64',"1","0","0","100"), \
        ('ui32_to_f64',"1","0","1","100"), \
        ('i64_to_f64',"1","0","2","100"), \
        ('ui64_to_f64',"1","0","3","100"), \
        ('f32_to_i32',"0","0","0","200"), \
        ('f32_to_ui32',"0","0","1","200"), \
        ('f32_to_i64',"0","0","2","200"), \
        ('f32_to_ui64',"0","0","3","200"), \
        ('f64_to_i32',"1","0","0","200"), \
        ('f64_to_ui32',"1","0","1","200"), \
        ('f64_to_i64',"1","0","2","200"), \
        ('f64_to_ui64',"1","0","3","200")]
    
    extend_32   = "00000000"
    
    find = False
    for i in range(len(list_operation)):
        if operation == list_operation[i][0]:
            get_operation = list_operation[i]
            find = True
            break

    if not find:
        sys.exit(1)
    
    if int(get_operation[4],16) == 1:
        empty_word = ""
    elif int(get_operation[4],16) > 1 and int(get_operation[4],16) < 32:
        empty_word = "0000000000000000"
    elif int(get_operation[4],16) == 64:
        empty_word = "0000000000000000"
    else:
        empty_word = "00000000000000000000000000000000"

    command = 'chmod +x {0}/testfloat_gen'.format(testfloat)
    subprocess.call(command,shell=True)

    command = '{0}/testfloat_gen {1} > {2}{1}.hex'.format(testfloat,operation,folder)
    subprocess.call(command,shell=True)

    filename = folder + operation+".hex"
    h = open(filename,"r")

    filename = folder + operation+".dat"
    f = open(filename,"w+")

    wort = ""
    line = ""
    index_res = 0
    i = 0

    output = h.readline()
    while(output):
        if output[i] == '\n':
            line = line + wort
            length = len(line)
            if len(empty_word) == 32:
                line = line[0:16] + empty_word + line[16:length]
            elif len(empty_word) == 16:
                line = line[0:32] + empty_word + line[32:length]
            for k in range(1,len(get_operation)):
                line = line + get_operation[k]
            line = line + '\n'
            f.writelines(line)
            line = ""
            wort = ""
            index_res = 0
            i = 0
            output = h.readline()
        elif output[i] == ' ':
            if len(wort) == 8:
                wort = extend_32 + wort
            if index_res == 2 and int(get_operation[4],16) == 64:
                wort =  extend_32 + "0000000" + wort
            line = line + wort
            wort = ""
            index_res = index_res + 1
            i = i+1
        else:
            wort = wort + output[i]
            i = i+1

    h.close()
    f.close()
