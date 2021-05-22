#!/usr/bin/sh

function add_item {

python3 - <<END




import yaml
import pprint as pp
import time
import sys



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


END

echo Enter the new item informations :
echo Enter the name : 
read var_name
echo Enter the version : 
read var_version
echo Enter the number for this version rule
read var_key_temp
echo Enter the defaultMinorVersion for this version rule
read var_value_temp
echo Wil you want to add version rule : y/n 
read check
declare -A var_value_vrules=(["$((var_key_temp))"]="$((var_value_temp))")
while [ $check = 'y' ]
do
  echo Enter the number for this version rule
  read var_key_temp
  echo Enter the defaultMinorVersion for this version rule
  read var_value_temp
  var_value_vrules+=(["$((var_key_temp))"]="$((var_value_temp))")
  echo Wil you want to add version rule : y/n 
  read check
done

echo Enter the ReadTimeout : 
read var_rdtimeout

name="$var_name" version="$var_version" rd_timeout="$var_rdtimeout" nb_values_vrules="${var_value_vrules[*]}" nb_keys_vrules="${!var_value_vrules[*]}" python3 - <<END
import os
name = str(os.environ['name'])
version = str(os.environ['version'])
rd_timeout = str(os.environ['rd_timeout'])
nb_keys_vrules = str(os.environ['nb_keys_vrules'])
nb_values_vrules = str(os.environ['nb_values_vrules'])
import yaml
import pprint as pp
import time
import sys

keys_vr = nb_keys_vrules.split()
keys_vr.reverse()
values_vr = nb_values_vrules.split()
values_vr.reverse()
nb_vrules = {}
print(keys_vr)
for i in range(len(keys_vr)):
  nb_vrules[int(keys_vr[i])] = {"defaultMinorVersion" : float(values_vr[i])}
#pp.pprint(nb_vrules)
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
  temp_dic1['defaultVersion'] = temp_dic11
  temp_vrvr = {}
  temp_vrvr['versionRules'] = vrules
  temp_dic1.update(temp_vrvr)
  temp.append(temp_dic1)
  temp.append(temp_dic2)
  temp_result[nm] = temp
  result.update(temp_result)
  return result

#nb_vrules = {}
total_dic = add_item(total_dic,name,version,nb_vrules,rd_timeout)
print(' New item added successfully ! ')

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




function update_item {

echo Enter the name of the item you want to update :
read old_name

check_update_action=1
while [ $check_update_action != 0 ]
do
  echo 1 if you want to update the item NAME 
  echo 2 if you want to update the item VERSION 
  echo 3 if you want to update the item VERSION RULES 
  echo 4 if you want to update the item READTIMEOUT 
  echo 5 if you want to quit 

  read update_action

  if [ $update_action = '1' ]
  then
    echo Enter the new name :
    read new_name
    break
  fi
  if [ $update_action = '2' ]
  then
    echo Enter the new version :
    read new_version
    break
  
  fi

  if [ $update_action = '3' ]
  then
    echo Enter the new version rules
    echo Enter the number for this version rule
    read var_key_temp
    echo Enter the defaultMinorVersion for this version rule
    read var_value_temp
    echo Wil you want to add version rule : y/n 
    read check
    declare -A var_value_vrules=(["$((var_key_temp))"]="$((var_value_temp))")
    while [ $check = 'y' ]
    do
      echo Enter the number for this version rule
      read var_key_temp
      echo Enter the defaultMinorVersion for this version rule
      read var_value_temp
      var_value_vrules+=(["$((var_key_temp))"]="$((var_value_temp))")
      echo Wil you want to add version rule : y/n 
      read check
    done
    break
  fi

  if [ $update_action = '4' ]
  then
    echo Enter the new ReadTimeout for the chosen item :
    read new_rdtimeout
    break
  fi
 
  if [ $update_action = '5' ] 
  then
    check_update_action=0
    continue
  fi
 
  if [ $update_action != '1' ] && [ $update_action != '2' ] && [ $update_action != '3' ] && [ $update_action != '5' ] && [ $update_action != '4' ]
  then
    echo Please ENTER a Valid Action !
    continue
  fi
done

nb_values_vrules="${var_value_vrules[*]}" nb_keys_vrules="${!var_value_vrules[*]}" new_version="$new_version" new_rdtimeout="$new_rdtimeout" old_name="$old_name" new_name="$new_name" update_action="$update_action" python3 - <<END
import os
action = str(os.environ['update_action'])
new_name = str(os.environ['new_name'])
old_name = str(os.environ['old_name'])
new_rd_timeout = str(os.environ['new_rdtimeout'])
new_version = str(os.environ['new_version'])
import yaml
import pprint as pp
import time
import sys


  

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



if old_name in total_dic.keys():
  if action == '1':
    total_dic[new_name] = total_dic[old_name]
    del total_dic[old_name]
    old_name = new_name
    print(' Name changed successfully ! ')
    action = None
  elif action == '2':
    total_dic[old_name][0]['defaultVersion']['defaultMajorMinorVersion'] = new_version 
    print(' Version changed successfully ! ')
    action = None
  elif action == '3':
    nb_keys_vrules = str(os.environ['nb_keys_vrules'])
    nb_values_vrules = str(os.environ['nb_values_vrules'])
    keys_vr = nb_keys_vrules.split()
    keys_vr.reverse()
    values_vr = nb_values_vrules.split()
    values_vr.reverse()
    nb_vrules = {}
    print(keys_vr)
    for i in range(len(keys_vr)):
      nb_vrules[int(keys_vr[i])] = {"defaultMinorVersion" :  float(values_vr[i])}
    del total_dic[old_name][0]['defaultVersion']['versionRules']
    total_dic[old_name][0]['defaultVersion']['versionRules'] = nb_vrules
  elif action == '4':
    total_dic[old_name][1]['ribbon']['ReadTimeout'] = new_rd_timeout
    print(' ReadTiomeout changed successfully ! ')
    action = None
else:
  print("**********!!!!!!!!!!!!!!**************")
  print(" ! There is no item with this name ! ")
  print("**********!!!!!!!!!!!!!!**************")



print(' New item updated successfully ! ')

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
pp.pprint(total_dic)

file = open("app.yaml", "w")  
yaml.dump(dicMajor, file)
file.write('\n###################\n')
file.write('#Ribbon')
file.write('\n###################\n\n')
yaml.dump(dicMinor, file)
file.close()



END
}

# Ask the user for their name
echo YAML EDITOR 

check_action=1
while [ $check_action != 0 ]
do
  echo Write ADD/UPDATE/QUIT to do an action
  read action
  if [ $action = 'ADD' ]
  then
    add_item
    continue
  fi

  if [ $action = 'UPDATE' ]
  then
    update_item
    continue
  fi
  
  if [ $action = 'QUIT' ]
  then
    check_action=0
    continue
  fi
  
  if [ $action != 'QUIT' ] && [ $action != 'UPDATE' ] && [ $action != 'ADD' ]
  then
    echo Please ENTER a Valid Action !
    continue
  fi
done

