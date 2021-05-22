function current_datetime {
python3 - <<END





#!/usr/bin/python3
# -*- coding: utf-8 -*-
"""yamlEditor.ipynb

Automatically generated by Colaboratory.

Original file is located at
    https://colab.research.google.com/drive/1PRI_kv2VtC6Ibkh_-LgLWMJOsS5cyaCH
"""

#pip install -U PyYAML

#yaml.__version__

import yaml
import pprint as pp
import time

# with open('app.yaml') as file:
#     # The FullLoader parameter handles the conversion from YAML
#     # scalar values to Python the dictionary format
#     dic = yaml.load(file, Loader=yaml.FullLoader)

#     pp.pprint(dic)
check_lood = 0
temp = 0.0
while check_lood == 0:
  try:
    stream = open("app.yaml", 'r')
    dictionary = yaml.load_all(stream)
    dic = {}
    for doc in dictionary:
        print("\n * YAML File Loaded * \n")
        dic = dict(doc)
    check_lood = 1
  except:
    message = " ! ! ! YOU NEED TO PUT THE YAML FILE IN THE SAME DIRECTORY ! ! ! "
    if temp != 0:
      message += '\t * Time spent : '+str(temp)+'s *'
    print(message)
    time.sleep(8)
    temp += 8.0

# Yaml file preprocessing
total_dic = {}
for key, value in dic.items():
  temp = list(value.keys())
  temp_list = []
  if temp[0] != 'defaultVersion':
    continue
  temp_list.append(value)
  v = list(list(value.values())[0].values())[0]
  name_v = key+'-'+str(v)
  if name_v in dic.keys() : 
    temp_list.append(dic[name_v])
    #print(name_v)
  #print(key)
  total_dic[key] = temp_list

pp.pprint(total_dic)

def nb_input(question,explication):
  nb_v = None
  while nb_v == None:
    try:
      nb_v = int(input(question))
    except:
      print(explication)
      nb_v = None
  return nb_v

def add_item( result, nm, vr, vrules, tmout):
  temp_result = {}
  temp = []
  temp_dic1 = {}
  temp_dic11= {}
  temp_dic2 = {}
  temp_dic21 = {}
  temp_dic21['ReadTiomeout'] = tmout
  temp_dic2['ribbon'] = temp_dic21
  temp_dic11['defaultMajorMinorVersion'] = vr
  temp_dic11.update(vrules)
  temp_dic1['defaultVersion'] = temp_dic11
  temp.append(temp_dic1)
  temp.append(temp_dic2)
  temp_result[nm] = temp
  result.update(temp_result)
  return result

#def update_item():

print('**************  Yaml Editor  ************** ')
s = None
action = None
while s == None: 
  s = input(" * Write (ADD/UPDATE/QUIT) to do an action * ")
  if s.upper() == 'ADD':
    name = input(" * Enter the name : ")
    version = input(" * Enter the version : ")
    nb_v = nb_input(" * How many version rules :"," Please ENTER a Valid number for the version rules ! ")
    nb_vrules = {}
    for i in range(1,nb_v+1):
      print(" Enter the "+str(i)+" version informations : ")
      temp_vr = nb_input(" * Enter the number for "+str(i)+" version rule : ","  Please ENTER a Valid number ! ")
      temp_vr_minor = nb_input(" * Enter the defaultMinorVersion for "+str(i)+" version rule : ","  Please ENTER a Valid number ! ")
      nb_vrules[temp_vr] = {"defaultMinorVersion" : temp_vr_minor}
    rd_timeout = nb_input(" * Enter the ReadTimeout : ", "  Please ENTER a Valid number ! ")
    total_dic = add_item(total_dic,name,version,nb_vrules,rd_timeout)
    print(' New item added successfully ! ')
  elif s.upper() == 'UPDATE':
    name = input(" * Enter the name of the item you want to update : ")
    if name in total_dic.keys():
      while action == None:

        print(" * 1 if you want to update the item's NAME * ")
        print(" * 2 if you want to update the item's VERSION * ")
        print(" * 3 if you want to update the item's VERSION RULES * ")
        print(" * 4 if you want to update the item's READTIMEOUT * ")
        print(" * 5 if you want to quit * ")
        print(" "+name+" : ")
        pp.pprint(total_dic[name])
        action = nb_input(" Enter a number based on you action : "," Please ENTER a valid number for your action ! ")

        if action < 0 or action > 5:
          action = None
        elif action == 1:
          new_name = input(" * Enter the new name for the chosen item : ")
          total_dic[new_name] = total_dic[name]
          del total_dic[name]
          name = new_name
          print(' Name changed successfully ! ')
          action = None
        elif action == 2:
          new_version = input(" * Enter the new version for the chosen item : ")
          total_dic[name][0]['defaultVersion']['defaultMajorMinorVersion'] = new_version 
          print(' Version changed successfully ! ')
          action = None
        elif action == 3:      
          new_vrules = dict(total_dic[name][0]['defaultVersion']['versionRules'])
          pp.pprint(new_vrules)
          for k, v in new_vrules.items():
            print(" * Current version rule * "+str(k)+ " : " + str(v) + " } ")
            check = None
            while check == None:
              check = input(" * You want to update this version rule ? (Yes/No) ")
              if check.upper() == 'YES':
                new_vrule = nb_input(" * Enter the new number for "+str(k)+" version rule : ","  Please ENTER a Valid number ! ")
                total_dic[name][0]['defaultVersion']['versionRules'][new_vrule] = total_dic[name][0]['defaultVersion']['versionRules'][k]
                del total_dic[name][0]['defaultVersion']['versionRules'][k]
                check_minor = None
                while check_minor == None:
                  check_minor = input(" * You want also to update the defaultMinorVersion for this version rule ? (Yes/No) ")
                  if check_minor.upper() == 'YES':
                    new_vr_minor = nb_input(" * Enter the new defaultMinorVersion for the new "+str(new_vrule)+" version rule : ","  Please ENTER a Valid number ! ")
                    total_dic[name][0]['defaultVersion']['versionRules'][new_vrule]['defaultMinorVersion'] = new_vr_minor
                  elif check_minor.upper() == 'NO':
                    continue
                  else:
                    print(" Please ENTER a Valid Choice ! ")
              elif check.upper() == 'NO':
                continue
              else:
                print(" Please ENTER a Valid Choice ! ")
                check = None   
          print(' VersionRules changed successfully ! ')   
          action = None    
        elif action == 4:
          new_rd_timeout = input(" * Enter the new ReadTimeout for the chosen item : ")
          total_dic[name][1]['ribbon']['ReadTimeout'] = new_rd_timeout
          action = None
          print(' ReadTiomeout changed successfully ! ')
        elif action == 5:
          s = None
          action = 0
  elif s.upper() == 'QUIT':
    break
  else:
    print(" Please ENTER a Valid Action ! ")
    s = None

total_dic
dic_final = {}
dicMajor = {}
dicMinor = {} 
for k,v in total_dic.items():
  dicMajor[k] = total_dic[k][0]
  _v = total_dic[k][0]['defaultVersion']['defaultMajorMinorVersion']
  dicMinor[k+'-'+str(_v)] = total_dic[k][1]
#dicMajor.update(dicMinor)
# dic_final['#'] = dicMajor
# dic_final['#Ribbon'] = dicMinor
# dic_final

file = open("app.yaml", "w")  
yaml.dump(dicMajor, file)
file.write('\n###################\n')
file.write('#Ribbon')
file.write('\n###################\n\n')
yaml.dump(dicMinor, file)
file.close()






END
}

# Call it
current_datetime