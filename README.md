# Tech Test

## Setup
```
rake db:create:all
rake db:migrate
rake db:migrate RAILS_ENV=test
rspec
rails s
```

## Performances
The performance observed below are around the same order of magnitude as [those results](https://blog.saeloun.com/2019/11/26/rails-6-insert-all.html) made on a much more simple example.

![Benchmark](https://github.com/gtroppee/CSVImporter/blob/master/data/benchmark.PNG)

The import process includes only 3 SQL requests, no matter how many rows the selected file includes:

1 - Get all the already existing records matching every of the file's row references
2 - Create records for each of the rows that don't have a corresponding record in the DB
3 - Update the existing records with the values found in the selected file. For attributes values that do not pass the filtering rule, they are simply replaced by the actual value, but the overall process remains the same.

Note: Almost all of the execution time is spent in the SQL transaction, very little in Ruby computation.

## Points of improvement
- Error handling (e.g. uploading a Person file into the Building field 😬)
- Removing the import from the web process and splitting large files into multiple jobs
- Improve/clarify specs
- Add requests/controllers specs
