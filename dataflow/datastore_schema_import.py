import argparse
import collections
import csv
import json
import os

from google.cloud import datastore


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--schema-file',
                        dest='schema_file',
                        required=True,
                        help='''
            File containing the schema of the input CSV data to be
            imported.
            Filename should be the same as the BQ table name that you
            want: "TABLENAME.csv".
            This file will be used to create a DataStore entity.
            Example:
                COLUMN_1,STRING
                COLUMN_2,FLOAT
            ''')
    args = parser.parse_args()
    client = datastore.Client()

    filename = args.schema_file
    print(('Processing file %s' % filename))
    csvfile = open(filename, 'r')
    table = os.path.splitext(os.path.basename(filename))[0]
    filetext = csv.reader(csvfile, delimiter=',')
    fields = collections.OrderedDict()
    for rows in filetext:
        fields[rows[0]] = rows[1]
    key = client.key('Table', table)
    entry = datastore.Entity(key, exclude_from_indexes=['columns'])
    entry.update({"columns": json.dumps(fields)})
    client.put(entry)
    print(('Created/Updated entry for table %s.' % table))
    print('Done.')


if __name__ == '__main__':
    main()