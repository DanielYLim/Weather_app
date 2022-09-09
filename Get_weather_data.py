import bs4
from bs4 import BeautifulSoup
import requests
import pandas as pd
import datetime

# enter city name
#city = "Toronto"


# create url
#url = "https://www.google.com/search?q="+"weather"+city



def get_page(url):
    r = requests.get(url)
    sp = BeautifulSoup(r.text, 'html.parser')
    return sp



def parse_soup(sp):
    weather_data = []
    # get the city
    city = sp.find('span', attrs={'class': 'BNeawe tAd8D AP7Wnd'}).text 
    # get the temperature
    temp = sp.find('div', attrs={'class': 'BNeawe iBp4i AP7Wnd'}).text
    temp = temp[len(temp)-4:(len(temp)-2)]
    # this contains time and sky description
    str = sp.find('div', attrs={'class': 'BNeawe tAd8D AP7Wnd'}).text
    # format the data
    data = str.split('\n')
    d = datetime.date.today()
    date_data = d.strftime("%Y-%m-%d")
    time = "% s % s"%(date_data, data[0])
    sky = data[1]
    key_data = date_data + city
    weather_data.append((key_data, time, city, temp, sky, date_data))
    return weather_data



# cities = "toronto", "ottawa", "halifax", "St John's"
# cities are from R input

Weather_data_all = []
for city in cities:
    url = "https://www.google.com/search?q="+"weather"+city
    sp = get_page(url)
    weather_data = parse_soup(sp)
    Weather_data_all.append(weather_data[0])


print(Weather_data_all)


### Save the data in SQL

import sqlite3

### conneting to SQL file
con = sqlite3.connect('weather.db')
cur = con.cursor()

#### First execution 
cur.execute('''CREATE TABLE IF NOT EXISTS weather_table
                                (pkey text PRIMARY KEY, date_time text, city text, temperature real, sky text, Date_data DATE)''')


#### update data 
cur.executemany("INSERT OR IGNORE INTO weather_table VALUES (?,?,?,?,?,?)", Weather_data_all)
con.commit()
