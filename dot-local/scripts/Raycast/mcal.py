#!/usr/bin/env python3

# Raycast Script Command Agenda generator
#
# Dependency: This script requires Python 3
# Install Python 3: https://www.python.org/downloads/release
#
# Duplicate this file and remove ".template." from the filename to get started.
# See full documentation here: https://github.com/raycast/script-commands
#
# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Markdown calendar generator
# @raycast.mode fullOutput
# @raycast.packageName Markdown Calendar Generator
#
# Optional parameters:
# @raycast.icon 🎯
# @raycast.currentDirectoryPath ~
# @raycast.needsConfirmation false
#
# Documentation:
# @raycast.description Write a nice and descriptive summary about your script command here 
# @raycast.author pn11
# @raycast.authorURL https://github.com/pn11/mdcal/blob/master/mdcal.py

"""Markdown Calendar Generator"""
import calendar
from datetime import datetime
import sys


def create_calendar(year, month, with_isoweek=False, lang="fr"):

    mdstr = ""
    dic = get_dict(lang)

    colnames = ['Lu', 'Ma', 'Me', 'Je', 'Ve', 'Sa', 'Di']
    if with_isoweek:
        colnames.insert(0, "Week")
    colnames = [dic[col] for col in colnames]

    mdstr += '|' + '|'.join(colnames) + '|' + '\n'
    mdstr += '|' + '|'.join([':-:' for _ in range(len(colnames))]) + '|' + '\n'

    for days in calendar.monthcalendar(year, month):
        if with_isoweek:
            isoweek = days[0].isocalendar()[1]
            mdstr += '|' + str(isoweek) + '|' + \
                '|'.join(["["+str(d.day)+"](#"+str(d.day)+")" for d in days]) + '|' + '\n'
        else:
            mdstr += '|' + '|'.join(["["+str(d)+"](#"+str(d)+")"  if d >0 else " " for d in days]) + '|' + '\n'

    return mdstr


def print_calendar(year, month, with_isoweek=False, lang="fr"):
    print('{}/{}\n'.format(year, month))
    print(create_calendar(year, month, with_isoweek, lang))


def get_dict(lang='fr'):
    dic = {}
    colnames = ['Sem', 'Lu', 'Ma', 'Me', 'Je', 'Ve', 'Sa', 'Di']
    colnames_en = ['Week', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
    colnames_ja = ['週', '月', '火', '水', '木', '金', '土', '日']
    if lang == 'fr':
        for col in colnames:
            dic[col] = col
    elif lang == 'en':
        for col, colen in zip(colnames, colnames_en):
            dic[col] = colen
    elif lang == 'ja':
        for col, colja in zip(colnames, colnames_ja):
            dic[col] = colja
    else:
        for col in colnames:
            dic[col] = col
    return dic


if __name__ == "__main__":
    argv = sys.argv
    if len(argv) == 1:
        today = datetime.now()
        print_calendar(today.year, today.month)
    elif len(argv) == 2:
        year = int(argv[1])
        for month in range(1, 13):
            print_calendar(year, month, with_isoweek=True)
    elif len(argv) == 3:
        year, month = [int(a) for a in argv[1:3]]
        print_calendar(year, month)
    else:
        print('Usage: python mdcal.py [year] [month]')