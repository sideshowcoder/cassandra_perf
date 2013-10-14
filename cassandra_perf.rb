require "cassandra"
require "digest"
require "benchmark"

ns = "perf_test"
server = "127.0.0.1:9160"

$client = Cassandra.new(ns, server)
$many_keys = "many_keys"

def data_hash_for_elements(start, count)
  h = {}
  rand = Digest::MD5.hexdigest Time.now.to_i.to_s
  count.times { |c| h["#{rand}/#{start + c}"] = "d" * 1024 }
  h
end

def big_row_bench
  big_row = "big_row"
  r_key = "a_row"
  Benchmark.bm(13) { |x|
    100.step(10000, 100) { |count|
      data = data_hash_for_elements(count + 1, 99)
      $client.insert big_row, r_key, data
      x.report("#{count}") {
        $client.get big_row, r_key, { count: 100000 }
      }
    }
  }
end

def many_keys_bench
  Benchmark.bm(13) { |x|
    keys = []
    100.step(10000, 100) { |count|
      100.times { |xcount|
        data = data_hash_for_elements(0, 1)
        r_key = "key_#{xcount}_#{count}"
        keys << r_key
        $client.insert $many_keys, r_key, data
      }
      x.report("#{count}") {
        $client.multi_get $many_keys, keys, { count: 100000 }
      }
    }
  }
end

def many_keys_empty_bench
  Benchmark.bm(13) { |x|
    keys = []
    100.step(10000, 100) { |count|
      keys.concat (1..100).map { |xcount| "na_key_#{xcount}_#{count}" }
      x.report("#{count}") {
        $client.multi_get $many_keys, keys, { count: 100000 }
      }
    }
  }
end

def many_tombs_bench
  r_key = "doomed_row"
  data = data_hash_for_elements(0, 100)
  $client.insert $many_keys, r_key, data
  Benchmark.bm(13) { |x|
    1.step(100, 1) { |count|
      data = data_hash_for_elements(0, 100)
      $client.insert $many_keys, r_key, data
      data.keys.each { |ck| $client.remove $many_keys, r_key, ck }
      x.report("#{100 * count}") {
        $client.get $many_keys, r_key, { count: 100000 }
      }
    }
  }
end

