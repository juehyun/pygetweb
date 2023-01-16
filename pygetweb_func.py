#!C:\Python382\bin\python
#*********************************************************************
# COPYRIGHT (C) 2017 Joohyun Lee (juehyun@etri.re.kr)
# 
# MIT License
# 
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
# 
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#********************************************************************/
#
#-- python script for downloading & synchronizing redmine issues
#--    * attachment files
#--    * issue page (.url shortcut & .html)
#
#-- Created by Joohyun Lee (juehyun@etri.re.kr)
#
#----------------------------------------------------------------------
#--Revision History Here
#----------------------------------------------------------------------
#--Rev              Date              Comments
#                   20200529          juehyun: add color to "saved to:"
#
#**********************************************************************

#----------------------------------------------------------------------
# import
#----------------------------------------------------------------------
import grequests
from selenium import webdriver
from selenium.webdriver.common.desired_capabilities import DesiredCapabilities
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options
from bs4 import BeautifulSoup
import requests
import os
import wget
import urllib.request
import re
import validators
import getpass
import pathlib
import time
import shutil
import timeit
import datetime
import sys
import unicodedata

#----------------------------------------------------------------------
# Functions
#----------------------------------------------------------------------
def printErr(f_str):
    print(f'[31mERROR: {f_str}[0m')

def printMsg(f_str):
    print(f'[32minfo : {f_str}[0m')

def printMhl(f_str):
    print(f'[35minfo : {f_str}[0m')

def create_browser(path_chrome_drive, headless_mode):
    #--------------------------------------------------------------------------------
    # option setting : Chrome w/o GUI (headless mode)
    #--------------------------------------------------------------------------------
    options = webdriver.ChromeOptions()
    if(headless_mode):
        options.add_argument('headless')
    #options.add_argument('window-size=1920x1080')
    #options.add_argument("disable-gpu")
    #options.add_argument("--start-maximized")
    options.add_experimental_option("prefs", { "download.default_directory": os.getcwd() })
    #options.add_experimental_option("prefs", { "download.default_directory": def_dir_sav })

    #--------------------------------------------------------------------------------
    # option setting : Chrome not to wait until full page loading
    #--------------------------------------------------------------------------------
    caps = DesiredCapabilities().CHROME
    #caps["pageLoadStrategy"] = "normal"  # complete
    caps["pageLoadStrategy"] = "eager"   # interactive
    #caps["pageLoadStrategy"] = "none"     # you need "chrome.implicitly_wait(3)" statement (some site's full loading time is so long)

    #--------------------------------------------------------------------------------
    # Launch Chrome Driver
    #--------------------------------------------------------------------------------
    ch = webdriver.Chrome(path_chrome_drive, desired_capabilities=caps, options=options) # non-def-pageLoadStrategy, Headless(no-GUI)
    #ch = webdriver.Chrome(path_chrome_drive, desired_capabilities=caps)
    #ch = webdriver.Chrome(path_chrome_drive, options=options)
    #ch = webdriver.Chrome(path_chrome_drive)
    #ch.implicitly_wait(3) # An implicit wait tells WebDriver to poll the DOM for a certain amount of time when trying to find any element (or elements) not immediately available. The default setting is 0. Once set, the implicit wait is set for the life of the WebDriver object.

    return(ch)

def download_files(list_urls, list_filenames):
    # get files using Asyncronous HTTP
    rs = requests.Session()
    reqs = ( grequests.get(u, session=rs) for u in list_urls )
    resps = grequests.map(reqs)

    # write to disk
    for i, p in enumerate(resps):
        # if file not exist -> download
        if (not os.path.exists(list_filenames[i])):
            with open(list_filenames[i], 'wb') as f:
                f.write(p.content)
                f.close()
            print(f'\t[{i:03}] download : {list_filenames[i]}')
        else:
            print(f'\tskip existing file : {list_filenames[i]}')
            # os.remove(list_fnm[i])

def is_download_finished(folder):
    """
    check previous chrome downloading is completed
    only necessary if you use CHROME selenium webdriver for downloading files (not needed for requests, grequests)
    """
    firefox_temp_file = sorted(pathlib.Path(folder).glob('*.part'))
    chrome_temp_file = sorted(pathlib.Path(folder).glob('*.crdownload'))
    downloaded_files = sorted(pathlib.Path(folder).glob('*.*'))
    if (len(firefox_temp_file) == 0) and \
       (len(chrome_temp_file) == 0) and \
       (len(downloaded_files) >= 1):
        return True
    else:
        return False

def strip_html(raw_html):
    #cleanr = re.compile('<.*?>')
    cleanr = re.compile('<.*?>|&([a-z0-9]+|#[0-9]{1,6}|#x[0-9a-f]{1,6});')
    cleantext = re.sub(cleanr, '', raw_html)
    return cleantext

def clear_html(raw_html):
    cleantext = BeautifulSoup(raw_html, "lxml").text
    return cleantext

def clean_filename(in_filename):
    out_filename = re.sub(r'[\\/:*?"<>|]+','',in_filename)
    return out_filename

def parse_http_code(code):
    if   (code==100): 
        return ('Continue')
    elif (code==101): 
        return ('Switching Protocols')
    elif (code==102): 
        return ('Processing')
    elif (code==103): 
        return ('Early Hints')
    elif (104<code and code<199): 
        return ('Unassigned')
    elif (code==200): 
        return ('OK')
    elif (code==201): 
        return ('Created')
    elif (code==202): 
        return ('Accepted')
    elif (code==203): 
        return ('Non-Authoritative Information')
    elif (code==204): 
        return ('No Content')
    elif (code==205): 
        return ('Reset Content')
    elif (code==206): 
        return ('Partial Content')
    elif (code==207): 
        return ('Multi-Status')
    elif (code==208): 
        return ('Already Reported')
    elif (209<code and code<225): 
        return ('Unassigned')
    elif (code==226): 
        return ('IM Used')
    elif (code==227<code and code<299): 
        return ('Unassigned')
    elif (code==300): 
        return ('Multiple Choices')
    elif (code==301): 
        return ('Moved Permanently')
    elif (code==302): 
        return ('Found')
    elif (code==303): 
        return ('See Other')
    elif (code==304): 
        return ('Not Modified')
    elif (code==305): 
        return ('Use Proxy')
    elif (code==306): 
        return ('(Unused)')
    elif (code==307): 
        return ('Temporary Redirect')
    elif (code==308): 
        return ('Permanent Redirect')
    elif (309<code and code<399): 
        return ('Unassigned')
    elif (code==400): 
        return ('Bad Request')
    elif (code==401): 
        return ('Unauthorized')
    elif (code==402): 
        return ('Payment Required')
    elif (code==403): 
        return ('Forbidden')
    elif (code==404): 
        return ('Not Found')
    elif (code==405): 
        return ('Method Not Allowed')
    elif (code==406): 
        return ('Not Acceptable')
    elif (code==407): 
        return ('Proxy Authentication Required')
    elif (code==408): 
        return ('Request Timeout')
    elif (code==409): 
        return ('Conflict')
    elif (code==410): 
        return ('Gone')
    elif (code==411): 
        return ('Length Required')
    elif (code==412): 
        return ('Precondition Failed')
    elif (code==413): 
        return ('Payload Too Large')
    elif (code==414): 
        return ('URI Too Long')
    elif (code==415): 
        return ('Unsupported Media Type')
    elif (code==416): 
        return ('Range Not Satisfiable')
    elif (code==417): 
        return ('Expectation Failed')
    elif (418<code and code<420): 
        return ('Unassigned')
    elif (code==421): 
        return ('Misdirected Request')
    elif (code==422): 
        return ('Unprocessable Entity')
    elif (code==423): 
        return ('Locked')
    elif (code==424): 
        return ('Failed Dependency')
    elif (code==425): 
        return ('Too Early')
    elif (code==426): 
        return ('Upgrade Required')
    elif (code==427): 
        return ('Unassigned')
    elif (code==428): 
        return ('Precondition Required')
    elif (code==429): 
        return ('Too Many Requests')
    elif (code==430): 
        return ('Unassigned')
    elif (code==431): 
        return ('Request Header Fields Too Large')
    elif (432<code and code<450): 
        return ('Unassigned')
    elif (code==451): 
        return ('Unavailable For Legal Reasons')
    elif (452<code and code<499): 
        return ('Unassigned')
    elif (code==500): 
        return ('Internal Server Error')
    elif (code==501): 
        return ('Not Implemented')
    elif (code==502): 
        return ('Bad Gateway')
    elif (code==503): 
        return ('Service Unavailable')
    elif (code==504): 
        return ('Gateway Timeout')
    elif (code==505): 
        return ('HTTP Version Not Supported')
    elif (code==506): 
        return ('Variant Also Negotiates')
    elif (code==507): 
        return ('Insufficient Storage')
    elif (code==508): 
        return ('Loop Detected')
    elif (code==509): 
        return ('Unassigned')
    elif (code==510): 
        return ('Not Extended')
    elif (code==511): 
        return ('Network Authentication Required')
    elif (512<code and code<599): 
        return ('Unassigned')
    else            : 
        return ('Unrecognized code')

def cd_projfolder(projdir):
    if not os.path.exists(projdir):
        printMhl(f'downloading folder (create new dir)    : {projdir}')
        os.makedirs(projdir)
    else:
        printMhl(f'downloading folder (use existing dir)  : {projdir}')

    os.chdir(projdir)

def close_all(chrome):
    printMsg(f'Terminate web driver ... ')
    chrome.quit()
    quit()

def del_repeated_str(in_str):
    out_str = re.sub(r'(.+?)\1+(.*)$',r'\1\2', in_str)
    return(out_str)
