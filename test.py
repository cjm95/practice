import boto3
import papermill as pm
from pyspark.sql import SparkSession

spark = SparkSession.builder.appName("papermill test").getOrCreate()

s3 = boto3.resource('s3')
s3.meta.client.download_file('cjm-oregon', 'papermill_input.ipynb', '/tmp/papermill_input.ipynb')
pm.execute_notebook(
    '/tmp/papermill_input.ipynb', 
    '/tmp/papermill_output.ipynb' 
)
s3.meta.client.upload_file('/tmp/papermill_output.ipynb', 'cjm-oregon', 'papermill_output.ipynb')

