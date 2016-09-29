### Imports

import pickle
import csv
from time import sleep
from selenium import webdriver
from getCompanies import xPaths

### File connections

def get_inc_5000_list():
    chrome_path = '/Users/luisagroher/Desktop/learning/poems/chromedriver'
    browser = webdriver.Chrome(executable_path = chrome_path)
    base_url = 'http://www.inc.com/inc5000/list/2016/'
    ##connect with chrome
    browser.get(base_url)
    sleep(22)
    browser.find_element_by_xpath(xPaths.view_per_page_input).click()
    #pages = browser.find_element_by_xpath(xPaths.scroll_down)
    sleep(2)
    browser.find_element_by_xpath(xPaths.two_hundred_per_page).click()
    #keys = ['rank', 'company', '3-yr growth', 'revenue', 'industry', 'state', 'metro', 'years']
    companies = {}
    for x in range(1, 27):
        try:
            companies['rank'].extend([row.text for row in browser.find_elements_by_class_name('c1')])
            companies['company'].extend([row.text for row in browser.find_elements_by_class_name('c2')])
            companies['3-yr growth'].extend([row.text for row in browser.find_elements_by_class_name('c3')])
            companies['revenue'].extend([row.text for row in browser.find_elements_by_class_name('c4')])
            companies['industry'].extend([row.text for row in browser.find_elements_by_class_name('c5')])
            browser.find_element_by_xpath(xPaths.more_columns).click()
            ##state
            companies['state'].extend([row.text for row in browser.find_elements_by_class_name('c6')])
            browser.find_element_by_xpath(xPaths.more_columns).click()
            ##metro
            companies['metro'].extend([row.text for row in browser.find_elements_by_class_name('c7')])
            browser.find_element_by_xpath(xPaths.more_columns).click()
            ##years
            companies['years'].extend([row.text for row in browser.find_elements_by_class_name('c9')])
            browser.find_element_by_xpath(xPaths.more_columns).click()
            ##get next page
            browser.find_element_by_xpath(xPaths.next_page).click()
        except:
            companies['rank'] = [row.text for row in browser.find_elements_by_class_name('c1')]
            companies['company'] = [row.text for row in browser.find_elements_by_class_name('c2')]
            companies['3-yr growth'] = [row.text for row in browser.find_elements_by_class_name('c3')]
            companies['revenue'] = [row.text for row in browser.find_elements_by_class_name('c4')]
            companies['industry'] = [row.text for row in browser.find_elements_by_class_name('c5')]
            browser.find_element_by_xpath(xPaths.more_columns).click()
            ##state
            companies['state'] = [row.text for row in browser.find_elements_by_class_name('c6')]
            browser.find_element_by_xpath(xPaths.more_columns).click()
            ##metro
            companies['metro'] = [row.text for row in browser.find_elements_by_class_name('c7')]
            browser.find_element_by_xpath(xPaths.more_columns).click()
            ##years
            companies['years'] = [row.text for row in browser.find_elements_by_class_name('c9')]
            browser.find_element_by_xpath(xPaths.more_columns).click()
            ##get next page
            browser.find_element_by_xpath(xPaths.next_page).click()
            ## dict to csv
            ## in some cases the column headers were picked up as values...this removes those column headers
            remove_vals = ['INDUSTRY', '3-YR GROWTH', 'RANK', 'REVENUE', 'COMPANY']
    for key in companies.keys():
        companies[key] = [x for x in companies[key] if x != [v for v in remove_vals]]
    with open('inc_5000_list_2016.csv', 'wb') as f:
        #fieldnames = companies.keys()
        writer = csv.writer(f)
        writer.writerow(companies.keys())
        writer.writerows(zip(*companies.values()))
        pickle.dump(companies, open('inc_5000_list_2016.p', 'wb'))
    
if __name__ == '__main__':
    get_inc_5000_list()