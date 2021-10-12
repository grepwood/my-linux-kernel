#!/usr/bin/env python3

import requests
from bs4 import BeautifulSoup

def get_lts_kernels():
	url = 'https://www.kernel.org'
	page = requests.get(url).text
	soup = BeautifulSoup(page, "html.parser").findAll('td')
	array = []
	counter = 0
	while counter < len(soup):
		if soup[counter].text == 'longterm:':
			tmp_array = soup[counter+1].text.split('.')[0:2]
			tmp_result = tmp_array[0] + '.' + tmp_array[1]
			array.append(tmp_result)
			counter += 1
		counter += 1
	return array

for kernel in get_lts_kernels():
	print(kernel)
