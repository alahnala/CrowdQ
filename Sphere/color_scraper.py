import sys
import json
import pprint
import requests
from bs4 import BeautifulSoup

EVERY_NOISE = "http://everynoise.com/engenremap.html"
res = requests.get(EVERY_NOISE)
soup = BeautifulSoup(res.content, 'html.parser')
genres = soup.findAll("div", { "class" : "genre scanme" })
color_map = {}
for g in genres:
	color = g["style"][7:14]
	color_map[g.text[:-1]] = color

with open("genres_to_colors.json", 'w') as f:
	json.dump(color_map, f)