# Importing the required libraries
import subprocess
from IPython.display import clear_output
import os
from pathlib import Path
import pandas as pd
from google.cloud import storage
from google.cloud import vision

# 'presample' function
#subprocess.run(['./presample.sh'], capture_output = True)

# 'collecturls' function
#subprocess.run(['./getimagesurls.sh'], capture_output = True)

# 'grabimages' function
#subprocess.run(['./grabimages.sh'], capture_output = True)

# 'removedupes' function
#subprocess.run(['./removedupes.sh'], capture_output = True)

# 'uploadtobucket' function
#def upload_directory_to_bucket(bucket_name, source_directory, destination_blob_name):
#    storage_client = storage.Client()
#    bucket = storage_client.bucket(bucket_name)
#
#    for root, dirs, files in os.walk(source_directory):
#        for file in files:
#            local_path = os.path.join(root, file)
#            blob_path = os.path.join(destination_blob_name, os.path.relpath(local_path, source_directory)).replace('\\', '/')
#            blob = bucket.blob(blob_path)
#            blob.upload_from_filename(local_path)
#
#    print(f'Directory {source_directory} uploaded to {bucket_name}/{destination_blob_name} successfully!')
#
#end = False
#while end == False:
#    my_bucket = str(input('Enter your bucket name: '))
#    if my_bucket != '':
#        bucket_name = my_bucket
#        end = True
#        clear_output()
#
#source_directory = r'.\images\images'
#destination_blob_name = 'images'
#upload_directory_to_bucket(bucket_name, source_directory, destination_blob_name)

# 'googlelabels' function
#def detect_labels(image_uri):
#    """Detects labels in the image URL using the Google Cloud Vision API."""
#    client = vision.ImageAnnotatorClient()
#    image = vision.Image()
#    image.source.image_uri = image_uri
#    response = client.label_detection(image = image, max_results = 150)
#    if response.error.message:
#        raise Exception(f'Error: {response.error.message}')
#    return response.label_annotations
#
#with open('folders', 'r', encoding='utf8') as f:
#    for folder in f:
#        folder = folder.strip()
#        os.makedirs(f'images/google_cloud/labels/{folder}', exist_ok = True)
#        # os.system(f'rm -f images/google_cloud/labels/{folder}/*')
#
#last = subprocess.run(['tail', '-1', 'images/images_index.txt'], capture_output = True, text = True).stdout.strip().split('|')[1][2:]
#last = int(last)
#
#for i in range(1, last + 1):
#    try:
#        with open('images/images_index.txt', 'r', encoding='utf8') as f:
#            line = next(line for j, line in enumerate(f, start = 1) if j == i)
#            folder = line.split('|')[0][3:]
#            n = line.split('|')[1][2:]
#            id = line.split('|')[2][3:]
#            file = line.split('|')[5][2:]
#            ext = line.split('|')[6][2:5]
#
#        print(f"---- detect-labels {i} / {last} ----")
#
#        image_uri = f'gs://{bucket_name}/images/{folder}/{n}.{ext}'
#        labels = detect_labels(image_uri)
#        with open(f'images/google_cloud/labels/{folder}/{n}.txt', 'w', encoding='utf8') as f:
#            for label in labels:
#                f.write('description: ' + f'{label.description}\n')
#                f.write('mid: ' + f'{label.mid}\n')
#                f.write('score: ' + f'{label.score}\n')
#                f.write('topicality: ' + f'{label.topicality}\n\n')
#    except StopIteration:
#        print('The iteration was stopped because there were empty files that have been removed.')

# 'labeltypes' function
#subprocess.run(['./labeltypes.sh'], capture_output = True)

# 'toplabels' function
#subprocess.run(['./toplabels.sh'], capture_output = True)

# 'sas' function
#subprocess.run(['./sas.sh'], capture_output = True)

# 'datamatrix' function
#subprocess.run(['./datamatrix.sh'], capture_output = True)

# 'correlationmatrix' function
#dataframe = pd.read_csv('images/data.csv')
#matrix = dataframe.corr()
#with pd.option_context('display.max_rows', None,
#                       'display.max_columns', None,
#                       'display.precision', 8,
#                       'display.width', 20000,
#                       ):
#    with open('images/correlation', 'w', encoding = 'utf8') as correlation:
#        correlation.write(str(matrix))
