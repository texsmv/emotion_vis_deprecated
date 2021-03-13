from utils.utils import time_serie_from_json, time_serie_from_eml_string


# with open('datasets/CASE_dataset/sub_1.json', 'r') as file:
#     data = file.read()
#     for i in range(100):
#         mtserie = time_serie_from_json(data)
#         print(mtserie.variables)

with open('datasets/CASE_dataset/sub_1.xml', 'r') as file:
    data = file.read()
    for i in range(100):
        mtserie = time_serie_from_eml_string(data)
        print(mtserie.variables)