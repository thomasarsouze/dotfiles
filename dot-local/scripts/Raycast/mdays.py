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
# @raycast.title Markdown daily list for calendar generator
# @raycast.mode fullOutput
# @raycast.packageName Markdown Daily List Calendar Generator
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


def create_daily_list(year, month, with_isoweek=False, lang="fr"):

    mdstr = ""
    dic = get_dict(lang)
    dic_m = get_dict_m(lang)

    for days in calendar.monthcalendar(year, month):
        for d in days:
            if d>0:
                full_d = datetime(year,month,d)
                mdstr += '# [📆](#0) '+dic[full_d.strftime('%A')]+' '+ \
                        str(d)+' '+dic_m[full_d.strftime('%B')]+' '+str(year)+' <a id='+str(d)+'></a>'+'\n'+ \
                        '\n'+ \
                        '- xx'+'\n'+ \
                        '- xx'+'\n'+ \
                        '\n' 

    return mdstr


def print_calendar(year, month, with_isoweek=False, lang="fr"):
    print(create_daily_list(year, month, with_isoweek, lang))


def get_dict(lang='fr'):
    dic = {}
    week_fr = ['Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi', 'Dimanche']
    week_en = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
    week_ja = ['月', '火', '水', '木', '金', '土', '日']
    if lang == 'fr':
        for d_fr,d_en in zip(week_fr,week_en):
            dic[d_en] = d_fr
    elif lang == 'en':
        for d in week_en:
            dic[d] = d
    elif lang == 'ja':
        for d_ja, d_en in zip(week_ja, week_en):
            dic[d_en] = d_ja
    else:
        for d in week_en:
            dic[d_en] = d_en
    return dic

def get_dict_m(lang='fr'):
    dic = {}
    month_fr = ['Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin', 'Juillet', 'Aout', 'Septembre', 'Octobre', 'Novembre', 'Décembre']
    month_en = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']
    if lang == 'fr':
        for m_fr,m_en in zip(month_fr,month_en):
            dic[m_en] = m_fr
    elif lang == 'en':
        for m in month_en:
            dic[m] = m
    else:
        for m in month_en:
            dic[m] = m
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
        print('Usage: python mddays.py [year] [month]')
