require "fileutils"
require_relative "./cassandra_perf"

schema_path = "./schema.txt"
reset_path = "./reset.txt"

task :default => :setup

desc "reset the database and seed initial table config"
task :setup => ["db:reset", "db:seed"]

namespace :benchmark do
  desc "benchmark query row with many keys: each iteration queries a longer row"
  task :big_row => :setup do
    big_row_bench
  end

  desc "query many rows with one column: each iteration queries more rows"
  task :many_rows => :setup do
    many_keys_bench
  end

  desc "query many empty rows: query random keys which don't exist, each iteration queries more keys"
  task :empty_keys => :setup do
    many_keys_empty_bench
  end

  desc "query with many tombs in row: row has 100 columns each iteration creates more tombstones"
  task :many_tombs => :setup do
    many_tombs_bench
  end
end

namespace :db do
  task :seed do
    puts "seeding cassandra..."
    begin
      `cassandra-cli --host 127.0.0.1 --batch < #{schema_path}`
    rescue
      puts "carry on, nothing to seed here!"
    end
  end

  task :reset do
    begin
      `cassandra-cli --host 127.0.0.1 --batch < #{reset_path}`
    rescue
      puts "not seeded!"
    end
  end
end

